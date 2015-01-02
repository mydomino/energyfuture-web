firebase = require './firebase'
emitter = require('events').EventEmitter
User = require './models/User'
_ = require 'lodash'

collectProviderUserData = (provider, user) ->
  if provider == 'twitter'
    return collectTwitterUserData(user.twitter.cachedUserProfile)
  else if provider == 'facebook'
    return collectFacebookUserData(user.facebook.cachedUserProfile)
  else if provider == 'password'
    return collectPasswordUserData(user)
  else
    return collectGenericUserData(user)

collectTwitterUserData = (user) ->
  provider_id: user.id
  displayName: user.name
  provider: 'twitter'
  profile_image_url: user.profile_image_url_https
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

collectPasswordUserData = (user) ->
  provider_id: user.password.email
  provider: user.provider
  email: user.password.email
  tempPassword: user.password.isTemporaryPassword

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
  _pendingCallbacks: []

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
        mixpanel.identify snap.name()
        userData = snap.val()
      else
        userData = collectProviderUserData user.provider, user
        # save new user's profile into Firebase so we can
        # list users, use them in security rules, and show profiles
        @_userRef.set userData
        mixpanel.alias(user.uid)
        mixpanel.people.set $name: userData.displayName
        mixpanel.identify(user.uid)
        mixpanel.track 'User Login'

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
        @_pendingCallbacks = _.reject @_pendingCallbacks, (func) ->
          func()
          true
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
    mixpanel.track 'View Login Modal'
    @_firebase.authWithOAuthPopup provider, (error, userData) =>
      @_onAuthStateChange(error, userData)
    , opts

  loginWithEmail: (email, password, opts = {}) ->
    Mixpanel.track 'Attempt Login with Email'
    data =
      email: email
      password: password

    @_firebase.authWithPassword data, (error, userData) =>
      Mixpanel.track 'User Login', {user_id: userData.uid, distinct_id: userData.uid} if userData
      @_onAuthStateChange(error, userData)
    , opts

  newUserFromEmail: (email, password, opts = {}) ->
    Mixpanel.track 'Register with Email'
    data =
      email: email
      password: password

    @_firebase.createUser data, (error) =>
      if error
        @_onAuthStateChange(error, {})
      else
        Mixpanel.track 'User Registered', {email: email}
        @loginWithEmail(email, password, opts)

  logout: ->
    @_firebase.unauth()
    window.location.reload()

  prompt: (expanded = false, onSuccess) ->
    if onSuccess && _.isFunction(onSuccess)
      @_pendingCallbacks.push(onSuccess)

    @emit('show-auth-prompt', expanded)

  unprompt: ->
    @emit('hide-auth-prompt')

module.exports = new Auth
