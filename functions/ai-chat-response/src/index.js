const sdk = require("node-appwrite");
const OpenAI = require("openai");

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

    // Initialize OpenAI
    const openai = new OpenAI({
        apiKey: req.variables.OPENAI_API_KEY,
    });

    if (
        !req.variables.APPWRITE_FUNCTION_ENDPOINT ||
        !req.variables.APPWRITE_FUNCTION_API_KEY
    ) {
        console.error("Appwrite Environment variables not set");
        return res.json({
            success: false,
            error: "Server configuration error",
        });
    }

    client
        .setEndpoint(req.variables.APPWRITE_FUNCTION_ENDPOINT)
        .setProject(req.variables.APPWRITE_FUNCTION_PROJECT_ID)
        .setKey(req.variables.APPWRITE_FUNCTION_API_KEY);

    try {
        const payload = JSON.parse(req.payload ?? "{}");
        const { userId, astrologerId, message, sessionId, action } = payload;

        // Handle Greeting Action
        if (action === 'greeting') {
            const prompt = `You are a Vedic Astrologer. Give a short, warm, spiritual greeting to a user. Do not ask for birth details yet.`;
            const completion = await openai.chat.completions.create({
                model: "gpt-4",
                messages: [{ role: "system", content: prompt }],
                max_tokens: 100,
            });
            return res.json({
                success: true,
                greeting: completion.choices[0].message.content,
            });
        }

        if (!message || !userId || !astrologerId) {
            return res.json({
                success: false,
                error: "Missing required fields",
            });
        }

        // 1. Fetch Astrologer Persona
        // Assuming 'astrologers' collection exists
        // const astrologerDoc = await databases.getDocument(
        //   req.variables.APPWRITE_DATABASE_ID,
        //   'astrologers',
        //   astrologerId
        // );

        // For now, using a default persona if DB fetch is not ready/mocked
        const basePersona = "You are an experienced, empathetic Vedic Astrologer. You provide spiritual guidance based on Vedic principles.";

        // 2. Content Moderation Guidelines
        const contentModerationRules = `
IMPORTANT CONTENT MODERATION RULES:
- NEVER provide medical advice or diagnose health conditions.
- NEVER provide specific financial investment advice.
- For harmful or distressing queries, respond with empathy and redirect to professional help.
- If user reports feeling suicidal or in crisis, provide helpline numbers immediately.
- Keep responses spiritually uplifting and positive.
- Avoid making definitive predictions about death, serious illness, or major negative events.
`;

        const systemPrompt = `${basePersona}\n\n${contentModerationRules}`;

        // 3. Call OpenAI
        const completion = await openai.chat.completions.create({
            model: "gpt-4",
            messages: [
                { role: "system", content: systemPrompt },
                { role: "user", content: message },
            ],
            max_tokens: 500,
        });

        const aiResponse = completion.choices[0].message.content;

        // 4. (Optional) Save to Database History here or let Client do it
        // Client-side saving is faster for UI, but Server-side is more secure.
        // We'll return the response and let the client save it for now to match current architecture.

        return res.json({
            success: true,
            response: aiResponse,
        });
    } catch (error) {
        console.error("AI Error:", error);
        return res.json({
            success: false,
            error: error.message || "Failed to generate response",
        });
    }
};
