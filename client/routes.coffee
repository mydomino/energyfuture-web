module.exports =
  middleware: [
    ["/", require('./middleware/redirect_from_splash')]
    ["/guides", require('./middleware/redirect_to_splash')]
    ["*", require('./middleware/authentication')]
    ["*", require('./middleware/categories')]
  ]

  pages: [
    ["/", require('./pages/Splash/Splash.view'), 'splash']
    ["/login", require('./pages/EmailLoginRegister/EmailLoginRegister.view'), 'login-register']
    ["/about", require('./pages/AboutUs/AboutUs.view'), 'aboutus']
    ["/contact", require('./pages/ContactUs/ContactUs.view'), 'contactus']
    ["/footprint", require('./pages/Footprint/Footprint.view'), 'footprint']
    ["/guides", require('./pages/Guides/Guides.view'), 'guides']
    ["/guides/:id", require('./pages/Guide/Guide.view'), 'guide']
    ["*", require('./pages/NotFound/NotFound.view'), 'not-found']
  ]
