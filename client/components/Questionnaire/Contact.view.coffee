{h2, div, label, input, textarea} = React.DOM

RadioButton = require './RadioButton.view.coffee'

module.exports = React.createClass
  displayName: 'Contact'

  render: ->
    radioData =
      position: "1"
      type: "radio"
      text: "Do you rent or own a house?"
      name: "roof"
      options: [
        {
          value: "rent"
          label: "Rent"
          position: "1"
        }
        {
          value: "own"
          label: "Own"
          position: "10"
        }
      ]
    div {className: 'questionnaire-contact'},
      h2 {}, "What's your name?"
      div {className: 'contact-names'},
        div {className: 'contact-first-name'},
          input {id: 'first-name'}
          label {htmlFor: "first-name"}, "First Name"
        div {className: 'contact-last-name'},
          input {id: 'last-name'}
          label {htmlFor: "last-name"}, "Last Name"
        div {className: 'clear-both'}
      h2 {}, "What's your email address?"
      input {}
      h2 {}, "What's your phone number?"
      input {}
      h2 {}, "Where are you located?"
      textarea {}
      new RadioButton(radio: radioData)
