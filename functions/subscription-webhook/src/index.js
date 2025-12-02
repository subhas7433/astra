const sdk = require("node-appwrite");

/*
  'req' variable has:
    'headers' - object with request headers
    'payload' - request body data as a string
    'variables' - object with function variables

  'res' variable has:
    'send(text, status)' - function to return text response. Status code defaults to 200
    'json(obj, status)' - function to return JSON response. Status code defaults to 200

  If an error is thrown, a response with code 500 will be returned.
*/

module.exports = async function (req, res) {
    const client = new sdk.Client();
    const databases = new sdk.Databases(client);

    if (
        !req.variables['APPWRITE_FUNCTION_ENDPOINT'] ||
        !req.variables['APPWRITE_FUNCTION_API_KEY']
    ) {
        console.warn("Environment variables are not set. Function cannot use Appwrite SDK.");
    } else {
        client
            .setEndpoint(req.variables['APPWRITE_FUNCTION_ENDPOINT'])
            .setProject(req.variables['APPWRITE_FUNCTION_PROJECT_ID'])
            .setKey(req.variables['APPWRITE_FUNCTION_API_KEY'])
            .setSelfSigned(true);
    }

    const payload = JSON.parse(req.payload);
    const event = payload.event; // RevenueCat event

    console.log(`Received event: ${event.type}`);

    try {
        // Sync subscription status to user document
        if (event.app_user_id) {
            const userId = event.app_user_id;

            // Map RevenueCat event to our subscription status
            let status = 'free';
            let tier = 'free';

            // This logic depends on how RevenueCat sends data
            // For simplicity, we assume we get the entitlement info
            if (event.type === 'INITIAL_PURCHASE' || event.type === 'RENEWAL') {
                status = 'active';
                // Determine tier based on product_id
                const productId = event.product_id;
                if (productId.includes('premium')) tier = 'premium';
                else if (productId.includes('pro')) tier = 'pro';
                else if (productId.includes('basic')) tier = 'basic';
            } else if (event.type === 'CANCELLATION' || event.type === 'EXPIRATION') {
                status = 'expired';
                tier = 'free';
            }

            // Update user document
            // Assuming we have a 'users' collection
            await databases.updateDocument(
                'astra_db',
                'users',
                userId,
                {
                    subscriptionStatus: status,
                    subscriptionTier: tier,
                    subscriptionExpiry: event.expiration_at_ms ? new Date(event.expiration_at_ms).toISOString() : null,
                }
            );

            console.log(`Updated user ${userId} subscription to ${status} (${tier})`);
        }

        res.json({ success: true });
    } catch (e) {
        console.error("Error processing webhook:", e);
        res.json({ success: false, error: e.message }, 500);
    }
};
