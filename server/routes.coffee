module.exports =
  pages: [

    ["/about", require('../client/pages/AboutUs/AboutUs.view'), 'aboutus']
    ["/contact", require('../client/pages/ContactUs/ContactUs.view'), 'contactus']
    ["/guides", require('../client/pages/Guides/Guides.view'), 'guides']
    ["/guides/:id", require('../client/pages/Guide/Guide.view'), 'guide']
    ["/guides/:guide_id/questionnaire", require('../client/pages/Questionnaire/Questionnaire.view'), 'guide']
  ]
