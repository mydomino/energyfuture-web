Firebase = require 'firebase'

# Make sure we can get the right firebase URL no matter what the
# current firebase is.
normalizeUrl = (suffix) ->
  url = process.env.FIREBASE_URL
  url = url.replace('-staging', '').replace('-dev', '')
  if suffix && suffix != 'production'
    return url.replace('.firebaseio', "-#{suffix}.firebaseio")
  else
    return url

module.exports = (from, to, callback) ->
    fromUrl = normalizeUrl(from) + '/guides'
    toUrl = normalizeUrl(to) + '/guides'

    fromRef = new Firebase(fromUrl)
    toRef = new Firebase(toUrl)

    fromRef.on 'value', (snap) ->
      # Commented out until we require authentication when updating guides on production
      #
      # toRef.authWithCustomToken process.env.FIREBASE_SECRET, (error, result) ->
      #   if error
      #     callback 500, "Login Failed!"
      #   else
          toRef.set snap.val(), (err) ->
            if err
              callback 500, "Error while updating user data: #{err}"
            else
              callback 200, "Successfully copied guides from #{from} to #{to}"
