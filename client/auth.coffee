firebase = require './firebase'
emitter = require('events').EventEmitter
User = require './models/User'

collectProviderUserData = (provider, user) ->
  if provider == 'twitter'
    return collectTwitterUserData(user)
  else if provider == 'facebook'
    return collectFacebookUserData(user)
  else
    return collectGenericUserData(user)

collectTwitterUserData = (user) ->
  data =
    displayName: user.displayName
    provider: user.provider
    provider_id: user.id

  data.profile_image_url = user.thirdPartyUserData.profile_image_url_https
  data.location = user.thirdPartyUserData.location

  return data

collectFacebookUserData = (user) ->
  data =
    displayName: user.displayName
    provider: user.provider
    provider_id: user.id

  data.profile_image_url = user.thirdPartyUserData.picture.data.url

  return data

collectGenericUserData = (user) ->
  return {
    displayName: user.displayName
    provider: user.provider
    provider_id: user.id
  }

class Auth extends emitter
  constructor: ->
    @_firebase = firebase.inst()
    @check()
  user: null
  _userId: null
  _userData: null
  _userRef: null
  _firebase: null
  _client: null
  _loaded: false
  _clearUser: ->
    @user = null
    @_userId = null
    @_userData = null
    @_userRef = null
  _setupUser: (user, callback) ->
    @_userRef = @_firebase.child('users').child(user.uid)

    # Check to see what data we have stored for the user
    @_userRef.once 'value', (snap) =>
      console.log snap
      if snap.val()
        userData = snap.val()
      else
        userData = collectProviderUserData user.provider, user

        # save new user's profile into Firebase so we can
        # list users, use them in security rules, and show profiles
        @_userRef.set userData

      @_userData = userData
      @_userId = user.uid

      userData.uid = user.uid
      @user = new User(userData)

      callback() if callback
  _onAuthStateChange: (error, userData) ->
    @_loaded = true
    if error
      console.log 'error:', error, userData
      @emit('authStateChange', { error: error, user: @user })
    else if userData
      @_setupUser userData, =>
        @emit('authStateChange', { user: @user })
    else
      @_clearUser()
      @emit('authStateChange', {})
  check: ->
    auth = @_firebase.getAuth()
    @_onAuthStateChange(false, auth) if auth
  login: (provider, opts = {}) ->
    @_firebase.authWithOAuthPopup(provider, @_onAuthStateChange.bind(@), opts)
  logout: ->
    @_firebase.unauth()

module.exports = new Auth
