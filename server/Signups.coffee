FirebaseJSON = require './FirebaseJSON'

fetchJSON = (callback) -> FirebaseJSON 'newsletter-signups', callback

module.exports = fetchJSON
