FirebaseJSON = require './FirebaseJSON'

fetchJSON = (callback) -> FirebaseJSON 'answers', callback

module.exports = fetchJSON
