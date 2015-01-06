module.exports =
  pages: [
    ["/about", require('./pages/AboutUs/AboutUs.view'), 'aboutus']
    ["/contact", require('./pages/ContactUs/ContactUs.view'), 'contactus']
    ["/footprint", require('./pages/Footprint/Footprint.view'), 'footprint']
    ["/guides", require('./pages/Guides/Guides.view'), 'guides']
    ["/guides/:id", require('./pages/Guide/Guide.view'), 'guide']
    ["/guides/:guide_id/questionnaire", require('./pages/Questionnaire/Questionnaire.view'), 'guide']
  ]
