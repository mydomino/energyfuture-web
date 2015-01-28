module.exports =
  middleware: [
    ["/", require('./middleware/redirect_from_splash')]
    ["/guides", require('./middleware/redirect_to_splash')]
    ["*", require('./middleware/authentication')]
    ["*", require('./middleware/friendly_guides')]
  ]

  pages: [
    ["/", require('./pages/Splash/Splash.view'), 'splash']
    ["/login", require('./pages/EmailLoginRegister/EmailLoginRegister.view'), 'login-register']
    ["/about", require('./pages/AboutUs/AboutUs.view'), 'aboutus']
    ["/contact", require('./pages/ContactUs/ContactUs.view'), 'contactus']
    ["/fortcollins", require('./pages/City/City.view'), 'city']
    ["/terms", require('./pages/TermsOfService/TermsOfService.view'), 'termsofservice']
    ["/privacy", require('./pages/PrivacyPolicy/PrivacyPolicy.view'), 'privacypolicy']
    ["/footprint", require('./pages/Footprint/Footprint.view'), 'footprint']
    ["/guides", require('./pages/Guides/Guides.view'), 'guides']
    ["/guides/:id", require('./pages/Guide/Guide.view'), 'guide']
    ["*", require('./pages/NotFound/NotFound.view'), 'not-found']
  ]
