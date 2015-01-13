module.exports =
  pages: [
    ["/about", require('../client/pages/AboutUs/AboutUs.view'), 'aboutus', 'We’re reinventing zero-emissions living']
    ["/contact", require('../client/pages/ContactUs/ContactUs.view'), 'contactus', 'Contact the team at Domino']
    ["/guides", require('../client/pages/Guides/Guides.view'), 'guides', 'Your guides to low-carbon living']
    ["/guides/:id", require('../client/pages/Guide/Guide.view'), 'guide']
  ]
