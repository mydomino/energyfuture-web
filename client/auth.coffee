firebase = require './firebase'
emitter = require('events').EventEmitter
User = require './models/User'

collectProviderUserData = (provider, user) ->
  if provider == 'twitter'
    return collectTwitterUserData(user.twitter.cachedUserProfile)
  else if provider == 'facebook'
    return collectFacebookUserData(user.facebook.cachedUserProfile)
  else
    return collectGenericUserData(user)

collectTwitterUserData = (user) ->
  provider_id: user.id
  displayName: user.name
  provider: 'twitter'
  profile_image_url: user.profile_background_image_url_https
  location: user.location

collectFacebookUserData = (user) ->
  provider_id: user.id
  displayName: user.name
  provider: 'facebook'
  profile_image_url: user.picture?.data.url

collectGenericUserData = (user) ->
  provider_id: user.id
  provider: user.provider
  displayName: user.displayName

class Auth extends emitter
  constructor: ->
    @_firebase = firebase.inst()
    @check()
  user: null
  loggedIn: false
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
      @loggedIn = false
      @emit('authStateChange', { error: error, user: @user })
    else if userData
      @_setupUser userData, =>
        @loggedIn = true
        @emit('authStateChange', { user: @user })
    else
      @_clearUser()
      @loggedIn = false
      @emit('authStateChange', {})
  check: ->
    auth = @_firebase.getAuth()
    if auth
      @loggedIn = true
      @_onAuthStateChange(false, auth)

  login: (provider, opts = {}) ->
    @_firebase.authWithOAuthPopup(provider, @_onAuthStateChange.bind(@), opts)
  logout: ->
    @_firebase.unauth()

module.exports = new Auth
