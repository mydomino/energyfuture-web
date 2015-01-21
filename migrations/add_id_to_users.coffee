# Adding ids to users
################

Firebase = require('firebase')

_ = require 'lodash'
firebaseRef = new Firebase("#{process.env.FIREBASE_URL}/")

addIdToUser = (ref) ->
  usersRef = ref.child('users')
  usersRef.on 'value', (usersSnap) =>
    updatedUserData = _.reduce usersSnap.val(), (acc, v, id) =>
      v.id = id
      acc[id] = v
      acc
    , {}
    usersRef.set updatedUserData, (err) ->
      if err
        console.log "Error while updating user data: ", err
        process.exit 1
      else
        console.log "Successfully added ids to all users."
        process.exit 0

login = (c) ->
  firebaseRef.authWithCustomToken process.env.FIREBASE_SECRET, (error, result) ->
    if error
      console.log "Login Failed!", error
      process.exit 1
    else
      console.log "Authenticated successfully."
      c(firebaseRef)

login(addIdToUser)
