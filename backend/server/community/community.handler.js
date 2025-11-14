const { CommunityMessages } = require('../../config/db'); // Admin Firestore collection ref
const { admin } = require('../../config/firebase');

if (!CommunityMessages) {
    throw new Error('Firestore "communityMessages" collection not initialized. Check Firebase Admin config.');
}

// Add a new community message
async function addCommunityMessage(data) {
    try {
        // Add a new document to the communityMessages collection
        const messageRef = await CommunityMessages.add({
            message: data.message,
            userId: data.userId,
            timestamp: Date.now(),
            comments: [] // Initially, there are no comments
        });
        return messageRef.id;
    } catch (error) {
        throw error;
    }
}

async function addCommentToMessage(messageId, commentData) {
    try {
        const messageRef = CommunityMessages.doc(messageId);
        // Append the comment to the comments array using FieldValue.arrayUnion
        await messageRef.update({
            comments: admin.firestore.FieldValue.arrayUnion(commentData)
        });
    } catch (error) {
        throw error;
    }
}

// Get all community messages
async function getCommunityMessages() {
    try {
        const querySnapshot = await CommunityMessages.get();
        const messages = querySnapshot.docs.map(d => ({ id: d.id, ...d.data() }));
        return messages;
    } catch (error) {
        throw error;
    }
}

// Get a specific community message by ID
async function getCommunityMessageById(messageId) {
    try {
        const messageRef = CommunityMessages.doc(messageId);
        const messageDoc = await messageRef.get();
        if (messageDoc.exists) {
            return { id: messageDoc.id, ...messageDoc.data() };
        } else {
            throw new Error('Message not found');
        }
    } catch (error) {
        throw error;
    }
}

module.exports = {
    addCommunityMessage,
    addCommentToMessage,
    getCommunityMessages,
    getCommunityMessageById
};
