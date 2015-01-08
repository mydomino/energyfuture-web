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
        userData = snap.val()
      else
        userData = collectProviderUserData user.provider, user
        # save new user's profile into Firebase so we can
        # list users, use them in security rules, and show profiles
        @_userRef.set userData
        registrationAttribs =
          if user.provider == 'password'
            provider: userData.provider, email: userData.email
          else
            provider: userData.provider
        mixpanel.track 'User Registration', registrationAttribs
        mixpanel.alias(user.uid)

      mixpanel.people.set $name: userData.displayName if userData.displayName
      mixpanel.identify(user.uid)

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
    @_firebase.authWithOAuthPopup provider, (error, userData) =>
      if userData
        mixpanel.identify(userData.uid)
        mixpanel.track 'User Login', provider: provider, user_id: userData.uid
      @_onAuthStateChange(error, userData)
    , opts

  loginWithEmail: (email, password, opts = {}) ->
    data =
      email: email
      password: password

    @_firebase.authWithPassword data, (error, userData) =>
      if userData
        mixpanel.identify(userData.uid)
        mixpanel.track 'User Login', provider: 'password', user_id: userData.uid
      @_onAuthStateChange(error, userData)
    , opts

  newUserFromEmail: (email, password, opts = {}) ->
    data =
      email: email
      password: password

    @_firebase.createUser data, (error) =>
      if error
        @_onAuthStateChange(error, {})
      else
        @loginWithEmail(email, password, opts)

  resetPassword: (email, callback) ->
    @_firebase.resetPassword email: email, (err) =>
      callback(err)

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
