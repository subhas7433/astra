export default async ({ req, res, log }) => {
    log('Testing environment variables:');
    log('OPENAI_API_KEY: ' + (process.env.OPENAI_API_KEY ? 'EXISTS' : 'MISSING'));
    log('APPWRITE_FUNCTION_ENDPOINT: ' + (process.env.APPWRITE_FUNCTION_ENDPOINT || 'MISSING'));
    log('APPWRITE_FUNCTION_API_KEY: ' + (process.env.APPWRITE_FUNCTION_API_KEY ? 'EXISTS' : 'MISSING'));
    log('APPWRITE_FUNCTION_PROJECT_ID: ' + (process.env.APPWRITE_FUNCTION_PROJECT_ID || 'MISSING'));

    return res.json({
        hasOpenAI: !!process.env.OPENAI_API_KEY,
        hasEndpoint: !!process.env.APPWRITE_FUNCTION_ENDPOINT,
        hasAPIKey: !!process.env.APPWRITE_FUNCTION_API_KEY,
        hasProjectId: !!process.env.APPWRITE_FUNCTION_PROJECT_ID,
        endpoint: process.env.APPWRITE_FUNCTION_ENDPOINT || 'missing',
        projectId: process.env.APPWRITE_FUNCTION_PROJECT_ID || 'missing'
    });
};
