hostUrl = '/* @echo HOST_URL */'
Autolinker = require 'autolinker'

injectHostUrl = (text) ->
  text.replace /HOST_URL/g, hostUrl

module.exports =
  link: (text, opts) ->
    Autolinker.link(injectHostUrl(text), opts)
