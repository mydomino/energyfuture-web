module.exports =
  middleware: []

  pages: [
    ["/", require('../client/pages/Splash/Splash.view'), 'splash']
    ["/about", require('../client/pages/AboutUs/AboutUs.view'), 'aboutus', 'We’re reinventing zero-emissions living']
    ["/contact", require('../client/pages/ContactUs/ContactUs.view'), 'contactus', 'Contact the team at Domino']
    ["/fortcollins", require('../client/pages/City/City.view'), 'city', 'Domino – Fort Collins']
    ["/terms", require('../client/pages/TermsOfService/TermsOfService.view'), 'termsofservice', 'Domino - Terms Of Service']
    ["/privacy", require('../client/pages/PrivacyPolicy/PrivacyPolicy.view'), 'privacypolicy', 'Domino - Privacy Policy']
    ["/guides", require('../client/pages/Guides/Guides.view'), 'guides', 'Your guides to low-carbon living']
    ["/guides/:id", require('../client/pages/Guide/Guide.view'), 'guide']
  ]
