# Migrate guides to the new module format
##### NOTE #####
#
# This adds a new property to the Firebase data called newGuides. In order
# to complete the migration, you need to remove "guides" and rename "newGuides"
# to guides.
#
################

mapModuleToData =
  'LeadingQuestion' : 'leadingQuestion'
  'UpsidesDownsides' : ['upsides', 'downsides']
  'DidYouKnow' : 'whatToKnow'
  'QuickTips' : 'quickTips'
  'Incentives' : 'incentives'
  'FAQ' : 'faq'
  'Intro' : 'intro'
  'MapSearch' : 'mapSearch'
  'SortableTable' : 'sortable-table'
  'WhatYouCanDo' : 'whatYouCanDo'
  'Text' : 'text'
  'Amazon' : 'amazon'
  'Images' : 'images'

_ = require('lodash')
Firebase = require('firebase')

firebaseRef = new Firebase("#{process.env.FIREBASE_URL}/")

convertModuleDataFromGuide = (guide, module) ->
  dataKeys = mapModuleToData[module.name]
  return {} unless dataKeys

  if typeof dataKeys == 'string'
    data = guide[dataKeys] || ''
    delete guide[dataKeys]
    if module.name == 'DidYouKnow'
      data = _.map data, (d) -> d.content
  else
    data = {}
    _.each dataKeys, (key) ->
      data[key] = guide[key] || ''
      delete guide[key]

  data

convertGuide = (guide) =>
  newModules = {}

  _.each guide.modules, (module) ->

    newModule =
      name: module.name
      position: module.position
      content: convertModuleDataFromGuide(guide, module)

    newModules["#{module.name}-0"] = newModule

  guide.modules = newModules
  guide

convertGuides = (guides) =>
  newGuides = {}
  _.each guides, (guide) ->
    newGuides[guide.id] = convertGuide(guide)

  firebaseRef.child('newGuides').set newGuides, ->
    console.log "Converted #{_.keys(newGuides).length} guides."
    process.exit 0

processGuides = (ref) ->
  ref.child('guides').on 'value', (snap) ->
    convertGuides(snap.val())

login = (c) ->
  firebaseRef.authWithCustomToken process.env.FIREBASE_SECRET, (error, result) ->
    if error
      console.log "Login Failed!", error
      process.exit 1
    else
      console.log "Authenticated successfully."
      c(firebaseRef)

login(processGuides)
