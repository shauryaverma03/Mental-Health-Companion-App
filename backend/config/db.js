const { db } = require('./firebase');

// If db is not initialized, collection refs will be null and handlers will throw clear errors
const User = db ? db.collection('users') : null;
const Chats = db ? db.collection('chats') : null;
const CommunityMessages = db ? db.collection('communityMessages') : null;
const Sos = db ? db.collection('sos') : null;
const Day = db ? db.collection('day') : null;
const Moods = db ? db.collection('moods') : null;
const Therapist = db ? db.collection('therapist') : null;

module.exports = {
    User, Chats, CommunityMessages, Sos, Day, Moods, Therapist
};
