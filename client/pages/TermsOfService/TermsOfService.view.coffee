{div, h2, h3, p, em, ol, li} = React.DOM
Layout = require '../../components/Layout/Layout.view'
NavBar = require '../../components/NavBar/NavBar.view'
ScrollTopMixin = require '../../mixins/ScrollTopMixin'

module.exports = React.createClass
  displayName: 'TermsOfService'
  mixins: [ScrollTopMixin]
  render: ->
    new Layout {name: 'termsofservice'},
      new NavBar user: @props.user, path: @props.context.pathname
      div {className: "terms-container"},
        h2 {}, "Terms of Service"
        p {}, "Welcome, and thank you for your interest in Domino 2030, Inc. (“Domino”, “we,” or “us”) and our Web site at MyDomino.com (the “Site”), as well as all related web sites (www.sunible.com, www.pvsolarreport.com and www.prospectzen.com), networks, embeddable widgets, downloadable software, mobile applications (including tablet applications) (each such application, an “App”), and other services provided by us and on which a link to this End User License Agreement and Terms of Use is displayed (collectively, together with the Site, our “Service”).  This End User License Agreement and Terms of Use is a legally binding contract between you and Domino regarding your use of the Service."
        p {}, "PLEASE READ THE FOLLOWING END USER LICENSE AGREEMENT AND TERMS OF USE CAREFULLY.  BY CLICKING “I ACCEPT,” YOU ACKNOWLEDGE THAT YOU HAVE READ, UNDERSTOOD, AND AGREE TO BE BOUND BY THE FOLLOWING TERMS AND CONDITIONS, INCLUDING THE DOMINO PRIVACY POLICY (COLLECTIVELY, THESE “TERMS”).  If you are not eligible, or do not agree to these Terms, then please do not use the Service."
        h3 {}, "Summary of Material Items"
        p {}, "As provided in greater detail in the Terms (and without limiting the express language of these Terms), you acknowledge the following:"
        ol {className: "list-letters"},
          li {}, "the App is licensed, not sold to you, and that you may use the App only as set forth in these Terms;"
          li {}, "the use of the App may be subject to separate third party terms of service and fees, including, without limitation, your mobile network operator’s (the “Carrier”) terms of service and fees, including fees charged for data usage and overage, which are your sole responsibility;"
          li {}, "you consent to the collection, use, and disclosure of your personally identifiable information in accordance with the Privacy Policy www.mydomino.com/privacy;"
          li {}, "the App is provided “as is” without warranties of any kind and Domino’s liability to you is limited;"
          li {}, "disputes arising hereunder will be resolved by binding arbitration.  By accepting these Terms, as provided in greater detail in Section 25 of these Terms, you and Domino are each waiving the right to a trial by jury or to participate in a class action;"
          li {}, "the App may require access to the other services on your mobile device; and"
          li {}, "if you are using the App on an iOS-based device, then you agree to and acknowledge the “Notice Regarding Apple,” below."
        h3 {}, "Domino Service Overview"
