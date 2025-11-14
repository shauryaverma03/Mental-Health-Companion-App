const { User } = require('../../config/db'); // Admin Firestore collection ref

if (!User) {
    throw new Error('Firestore "users" collection not initialized. Check Firebase Admin config.');
}

// Create or update a user
async function createUser(userId, data) {
    try {
        const userRef = User.doc(userId);
        await userRef.set(data, { merge: true }); // Merge if the document already exists
        return { userId, ...data };
    } catch (error) {
        throw error;
    }
}

// Get a user by userId
async function getUserById(userId) {
    try {
        const userRef = User.doc(userId);
        const userDoc = await userRef.get();
        if (userDoc.exists) {
            return { userId, ...userDoc.data() };
        } else {
            return null; // User not found
        }
    } catch (error) {
        throw error;
    }
}

module.exports = {
    createUser,
    getUserById
};
