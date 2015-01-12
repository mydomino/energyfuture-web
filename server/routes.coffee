module.exports =
  pages: [
    ["/", require('../client/pages/Splash/Splash.view'), 'splash']
    ["/about", require('../client/pages/AboutUs/AboutUs.view'), 'aboutus']
    ["/contact", require('../client/pages/ContactUs/ContactUs.view'), 'contactus']
    ["/footprint", require('../client/pages/Footprint/Footprint.view'), 'footprint']
    ["/guides", require('../client/pages/Guides/Guides.view'), 'guides']
    ["/guides/:id", require('../client/pages/Guide/Guide.view'), 'guide']
    ["/guides/:guide_id/questionnaire", require('../client/pages/Questionnaire/Questionnaire.view'), 'guide']
  ]
