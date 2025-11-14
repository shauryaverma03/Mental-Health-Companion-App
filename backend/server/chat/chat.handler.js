const { Chats } = require('../../config/db'); // Admin Firestore collection ref
const { admin } = require('../../config/firebase');

if (!Chats) {
    throw new Error('Firestore "chats" collection not initialized. Check Firebase Admin config.');
}

async function addChat(userId, date, data, platform = null) {
    try {
        const chatDocId = `${userId}_${date}`;
        const chatRef = Chats.doc(chatDocId);

        try {
            await chatRef.update({
                messages: admin.firestore.FieldValue.arrayUnion(data)
            });
        } catch (error) {
            // If the document doesn't exist, create it
            // Different environments may produce different error messages/codes; check common cases
            const msg = (error && (error.message || '')).toLowerCase();
            if (msg.includes('no document') || msg.includes('not-found') || error.code === 5) {
                await chatRef.set({
                    messages: [data],
                    userId: userId,
                    date: date,
                    platform: platform || null
                });
            } else {
                throw error;
            }
        }

        return;
    } catch (e) {
        throw e;
    }
}

// Get all messages for a specific user and day
async function getChat(userId, date) {
    try {
        const chatDocId = `${userId}_${date}`;
        const chatRef = Chats.doc(chatDocId);
        const chatDoc = await chatRef.get();

        if (chatDoc.exists) {
            return chatDoc.data().messages || [];
        } else {
            return []; // No messages found for this date
        }
    } catch (e) {
        throw e;
    }
}

module.exports = {
    addChat,
    getChat
};
