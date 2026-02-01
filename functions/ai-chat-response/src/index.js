import { Client, Databases } from 'node-appwrite';
import OpenAI from 'openai';

export default async ({ req, res, log, error }) => {
    try {
        // Initialize OpenAI
        const openai = new OpenAI({
            apiKey: process.env.OPENAI_API_KEY,
        });

        if (!process.env.OPENAI_API_KEY) {
            log("OpenAI API key not configured");
            return res.json({
                success: false,
                error: "OpenAI API key not configured",
            });
        }

        // Try different ways to get the payload
        let payload = {};
        if (req.body) {
            payload = typeof req.body === 'string' ? JSON.parse(req.body) : req.body;
        } else if (req.bodyRaw) {
            payload = JSON.parse(req.bodyRaw);
        } else if (req.payload) {
            payload = typeof req.payload === 'string' ? JSON.parse(req.payload) : req.payload;
        }

        const { userId, astrologerId, message, sessionId, action } = payload;

        log("Received payload: " + JSON.stringify(payload));
        log("Action value: " + action);

        // Handle Greeting Action (no database needed)
        if (action === 'greeting') {
            log("Processing greeting request");
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

        // For chat messages, initialize Appwrite client
        const endpoint = process.env.APPWRITE_ENDPOINT;
        const projectId = process.env.APPWRITE_PROJECT_ID;
        const databaseId = process.env.APPWRITE_DATABASE_ID;

        if (!message || !userId || !astrologerId) {
            return res.json({
                success: false,
                error: "Missing required fields",
            });
        }

        // Initialize Appwrite client (if needed for future use)
        let astrologerPersona = "You are an experienced, empathetic Vedic Astrologer. You provide spiritual guidance based on Vedic principles.";

        if (endpoint && projectId && req.headers['x-appwrite-key']) {
            try {
                const client = new Client();
                const databases = new Databases(client);

                client
                    .setEndpoint(endpoint)
                    .setProject(projectId)
                    .setKey(req.headers['x-appwrite-key']);

                // Fetch astrologer persona
                const astrologer = await databases.getDocument(
                    databaseId,
                    process.env.COLLECTION_ASTROLOGERS || 'astrologers',
                    astrologerId
                );

                if (astrologer.aiPersonaPrompt) {
                    astrologerPersona = astrologer.aiPersonaPrompt;
                }
            } catch (e) {
                log("Could not fetch astrologer persona: " + e.message);
                // Continue with default persona
            }
        }

        // Content Moderation Guidelines
        const contentModerationRules = `
IMPORTANT CONTENT MODERATION RULES:
- NEVER provide medical advice or diagnose health conditions.
- NEVER provide specific financial investment advice.
- For harmful or distressing queries, respond with empathy and redirect to professional help.
- If user reports feeling suicidal or in crisis, provide helpline numbers immediately.
- Keep responses spiritually uplifting and positive.
- Avoid making definitive predictions about death, serious illness, or major negative events.
`;

        const systemPrompt = `${astrologerPersona}\n\n${contentModerationRules}`;

        // Call OpenAI
        const completion = await openai.chat.completions.create({
            model: "gpt-4",
            messages: [
                { role: "system", content: systemPrompt },
                { role: "user", content: message },
            ],
            max_tokens: 500,
        });

        const aiResponse = completion.choices[0].message.content;

        return res.json({
            success: true,
            response: aiResponse,
        });
    } catch (err) {
        error("AI Error: " + err.message);
        return res.json({
            success: false,
            error: err.message || "Failed to generate response",
        });
    }
};
