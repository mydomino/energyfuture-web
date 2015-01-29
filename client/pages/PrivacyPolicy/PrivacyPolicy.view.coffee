React = require 'react'
{div, h2, h3, h4, p, ul, li, em} = React.DOM
Layout = require '../../components/Layout/Layout.view'
NavBar = require '../../components/NavBar/NavBar.view'
ScrollTopMixin = require '../../mixins/ScrollTopMixin'

PrivacyPolicy = React.createClass
  displayName: 'PrivacyPolicy'
  mixins: [ScrollTopMixin]

  render: ->
    new Layout {name: 'privacypolicy'},
      new NavBar user: @props.user, path: @props.context.pathname
      div {className: "privacy-container"},
        h2 { id: "privacy-header"}, "Privacy Policy"
        h3 {}, "Our Commitment to Privacy"
        p {}, "Welcome to Domino.  Your privacy is important to us.  As you use our Services, we want to be clear how we are using your information and the ways in which you can protect your privacy."
        p {}, "Our Privacy Policy explains:"
        ul {},
          li {}, "What information we collect and why we collect it."
          li {}, "How we use that information and when we disclose it."
          li {}, "How to access and update your information."
          li {}, "The steps we take to protect the information."
        p {}, "This Policy applies to all information that we have about you, and to all of the services and products provided by Domino, including the Domino website (at www.mydomino.com) and other sites owned by Domino (at www.sunible.com, www.pvsolarreport.com and www.prospectzen.com), downloadable software, and mobile applications (collectively, the “Services”).  Your privacy matters to Domino so please take the time to familiarize yourself with our policies, and if you have any questions please contact us at info@mydomino.com.  This Policy is incorporated into and is subject to the Domino Terms of Use."
        h3 {}, "What information we collect"
        p {}, "We gather the following types of information:"
        h4 {}, "Information You Provide"
        ul {},
          li {}, "Registration Information.  We collect information you provide us when creating an account on our Services or signing up for updates on our website, including your name, address, phone number, email address, and password.  We also collect any other information you voluntarily provide to us such as date of birth, geographic information, utility bill information, and your preferences."
          li {}, "Communications and Content.  We collect the contents of messages you send or receive using our Services and store them on our servers, including quotes for services.  We also collect information regarding any communications we have with you, such as if you send us an email or call our Concierge Service.  We also collect any User Content, as defined in the Domino Terms of Use, you publish on the Services."
        h4 {}, "Information We Receive From the Use of Our Services"
        ul {},
          li {}, "Usage Information.  When you use our Services, we may record certain information from your devices and your use of the Services.  This information may include your IP address or other device address or ID, operating system, web browser, device type, the web pages or sites that you visit just before or just after you use the Services, the pages or other content you view or otherwise interact with on the Services, and the dates and times that you visit, access, or use the Services. We also may use these technologies to collect information regarding your interaction with email messages, such as whether you opened, clicked on, or forwarded a message."
          li {}, "Location Information.  We may also gather geo-location information from your device.  We will only collect this information if permitted by your device’s settings and will only use it in accordance with this Policy."
          li {}, "Cookies.  Domino and our service providers use various technologies to collect and store information when you use our Services, and this may include sending “cookies” to your computer.  A cookie is a small piece of data that is sent to your Internet browser for record-keeping purposes.  We may use both session cookies and persistent cookies.  A session cookie disappears after you close your browser.  A persistent cookie remains after you close your browser and may be used by your browser on subsequent visits to the Service.  We may use cookies to collect and store information such as your IP address, the dates and times you visit our website, and the web pages that you visit.  We may associate the information we store in cookies to personal information you submit while on our website."
          li {}, "Third Party Web Beacons and Third Party Buttons.  We may also implement third-party content or advertising on the Service that may use clear gifs or other forms of web beacons, which allow the third-party content provider to read and write cookies to your browser in connection with your viewing of the third party content on the Service.  Additionally, we may implement third party buttons (such as Facebook “like” or “share” buttons) that may allow third parties to collect information about you through such third parties’ browser cookies, even when you do not interact with the button. Information collected through web beacons and buttons is collected directly by these third parties, and Domino does not participate in that data transmission. Information collected by a third party in this manner is subject to that third party’s own data collection, use, and disclosure policies."
          li {}, "Integrated Services.  You may be given the option to access or register for the Service through the use of your user name and passwords for certain services provided by third parties (each, an “Integrated Service”), such as through the use of your Facebook credentials through Facebook Connect, or otherwise have the option to authorize an Integrated Service to provide personal information or other information to us. By authorizing us to connect with an Integrated Service, you authorize us to access and store your name, email address(es), date of birth, gender, current city, profile picture URL, and other information that the Integrated Service makes available to us, and to use and disclose it in accordance with this Policy. You should check your privacy settings on each Integrated Service to understand and change the information sent to us through each Integrated Service. Please review each Integrated Service’s terms of use and privacy policies carefully before using their services and connecting to our Service."
          li {}, "Information from Other Sources.  We may obtain information, including personal information, from third parties and sources other than the Services and combine or associate that information with information we collect through the Services. If we combine or associate information from other sources with personal information that we collect through the Services, we will treat the combined information as personal information in accordance with this Policy."
        h3 {}, "How we use your information"
        p {}, "Your information is an important part of our business.  We may use the information we collect in a variety of ways in providing the Services and operating our business, including the following:"
        ul {},
          li {}, "To provide the Services.  We use the information we collect to operate, maintain, enhance, and provide the Services to you, including helping you gather information about companies and potential low carbon opportunities, facilitating quotes from companies, comparing and increasing your understanding of quotes from companies, and providing advice throughout the purchasing process.  We also use the information we collect to allow you to communicate with companies and post information on and reviews of companies on our Services or Integrated Services."
          li {}, "To improve and personalize your experience and our Services.  We use the information that we collect on the Services (i) to understand and analyze the usage trends and preferences of our users and the effectiveness of our Services and third-party marketing activities; (ii) to improve, personalize, and promote our Services, provide customized advertisements, content, and information; (iii) to develop new products, services, features, and functionality; and (iv) track your entries, submissions, and status in any promotions or other activities on the Service."
          li {}, "To communicate with you.  We will use the information we collect to communicate with you.  For example, we may use your email address, phone number, or other information to contact you for administrative purposes such as customer service, to respond to your inquiries, to manage your account, or otherwise provide user support."
        h3 {}, "How we share the information we collect"
        p {}, "We may share your information in the following ways:"
        ul {},
          li {}, "With Your Consent.  We will share personal information with companies, organizations, or individuals outside of Domino when we have your consent to do so."
          li {}, "Publicly Posted Information.  Any information that you voluntarily choose to include in a publicly accessible area of the Services, such as a public profile page or company review page, will be available to anyone who has access to that content, including other users."
          li {}, "Advertisers.  We may share your information with companies interested in offering products and services that may be of interest to you. For example, we may share your information with companies interested in providing solar or low carbon lifestyle products and services to you."
          li {}, "Service Providers and Other Third Parties.  We may share your information with service providers and other third parties who perform services on our behalf, such as providing information technology services and analytics services.  Service providers such as analytics providers may collect information about your online activities over time and across different online services when you use our Services."
          li {}, "Aggregate and Non-identifying Information.  We may share aggregate and other non-personal information and log data with our partners in order to improve the overall experience of our Services.  We may also publicly share non-personally-identifiable, aggregate data about how our users interact with and use our Services.  For example, we may publish aggregated findings on solar adoption, low carbon lifestyle product and service adoption, or other trends based on this data."
          li {}, "Compliance with Laws and Law Enforcement.  Domino cooperates with government and law enforcement officials and private parties to enforce and comply with the law. We will share your information if we, in our good faith judgment, believe it is reasonably necessary to: respond to claims and legal process (including valid subpoenas, court orders, or government requests); protect the property, rights, and safety of Domino, our users, or others as required or permitted by law; enforce our Terms of Use or other agreements; prevent or stop activity we believe to be illegal, unethical or legally actionable; and detect, prevent, or otherwise address fraud, security or technical issues."
          li {}, "Business Transfers.  If Domino is involved in a merger, acquisition, reorganization, sale of assets, or bankruptcy, our customers’ information may be disclosed and otherwise transferred to an acquirer, successor, or assignee.  We will notify you of such a change in ownership or transfer of assets by posting a notice on our website."
          li {}, "Other Sharing.  We may also disclose your information when we believe, in good faith, it is necessary to (i) take precautions against liability, (ii) protect ourselves or others from fraudulent, abusive, or unlawful uses or activity, (iii) investigate and defend ourselves against any third-party claims or allegations, (iv) protect the security or integrity of our Services and any facilities or equipment used to make the Service available, or (v) protect our property or other legal rights (including, but not limited to, enforcement of our agreements), or the rights, property, or safety of others."
        h3 {}, "The Choices you have with your information"
        p {}, "You may decline to share certain personal information with us, in which case we may not be able to provide to you some of the features and functionality of our Services.  You may update or correct your profile information and preferences at any time by accessing the account settings page on the website or mobile apps.  Please note that while any changes you make will be reflected in active user databases instantly or within a reasonable period of time, we may retain all information you submit for backups, archiving, prevention of fraud and abuse, analytics, satisfaction of legal obligations, or where we otherwise reasonably believe that we have a legitimate reason to do so."
        p {}, "If you receive marketing or promotional email from us, you may unsubscribe at any time by following the instructions contained within the email. It may take up to ten business days to process your request.  You may also receive marketing or promotional notifications from us on your mobile device.  You can disable these messages through the account settings page on the Domino apps or through your device’s settings for notifications.  Even after you opt-out of receiving marketing or promotional messages from us, you will continue to receive administrative messages from us regarding the Service."
        h3 {}, "Third-Party Services"
        p {}, "The Services may contain features or links to websites and services provided by third parties.  Any information you provide on third-party sites or services is provided directly to the operators of such services and is subject to those operators’ policies, if any, governing privacy and security, even if accessed through the Services.  We are not responsible for the content or privacy and security practices and policies of third-party sites or services to which links or access are provided through the Services. We encourage you to learn about third parties’ privacy and security policies before providing them with information."
        h3 {}, "Children’s Privacy"
        p {}, "Domino takes the online protection of children very seriously.  Our Services are not directed to children under the age of 13, and we do not knowingly collect personal information from children under the age of 13.  If you are under 13 years of age, then please do not use or access the Services. If we learn that personal information has been collected from persons under 13 years of age, then we will take the appropriate steps to delete this information.  If you are a parent or guardian and discover that your child under 13 years of age has obtained an account on the Service, then you may alert us at info@Domino.com and request that we delete that child’s personal information from our systems."
        h3 {}, "Data Security & Privacy settings"
        p {}, "We take reasonable measures to protect your personal information in accordance with this Policy.  Unfortunately, the Internet cannot be guaranteed to be 100% secure, and we cannot ensure or warrant the security of any information you transmit to us or store on the Service.   You provide your information and User Content to us at your own risk and are responsible for taking reasonable measures to secure your account."
        p {}, "Although we may allow you to adjust your privacy settings to limit access to certain personal information, please be aware that no security measures are perfect or impenetrable. We are not responsible for circumvention of any privacy settings or security measures on the Services. Additionally, we cannot control the actions of other users with whom you may choose to share your information. Further, even after information posted on the Services is removed, caching and archiving services may have saved that information, and other users or third parties may have copied or stored the information available on our Services. We cannot and do not guarantee that information you post on or transmit to the Services will not be viewed by unauthorized persons."
        h3 {}, "International Visitors"
        p {}, "Our Services are hosted in the United States and intended for visitors located within the United States. If you choose to use the Services from the European Union or other regions of the world with laws governing data collection and use that may differ from U.S. law, then please note that you are transferring your personal information outside of those regions to the United States for storage and processing."
        h3 {}, "Changes and Updates to this Policy"
        p {}, "We may from time to time make changes to this Policy.  When we do, we will post the revised Privacy Policy and update the last date of revision.  When the changes we make are significant, we may provide a more prominent notice, for example, by sending you an email or generating a pop-up when you access the Services for the first time after the changes are made.  Your continued use of our Services after the revised Policy has become effective indicates that you have read, understood and agreed to the current version of this Policy."
        h3 {}, "Our Contact Information"
        p {}, "Please contact us with any questions or comments about this Policy, your personal information, our use and disclosure practices, or your consent choices by email at info@Domino.com."
        p {}, "EFFECTIVE AS OF: January 1, 2015"

module.exports = React.createFactory PrivacyPolicy
