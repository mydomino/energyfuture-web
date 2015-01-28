React = require 'react'
{h2, div, label, input, textarea} = React.DOM

RadioButton = require './RadioButton.view.coffee'
PaginateActions = require './PaginateActions.view.coffee'

Contact = React.createClass
  displayName: 'Contact'

  render: ->
    radioData =
      position: "1"
      type: "radio"
      text: "Do you rent or own a house?"
      name: "house-ownership"
      required: true
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
          input {id: 'first-name', name: 'contact-first-name', required: true, defaultValue: @props.answers['contact-first-name']}
          label {htmlFor: "first-name"}, "First Name"
        div {className: 'contact-last-name'},
          input {id: 'last-name', name: 'contact-last-name', required: true, defaultValue: @props.answers['contact-last-name']}
          label {htmlFor: "last-name"}, "Last Name"
        div {className: 'clear-both'}
      h2 {}, "What's your email address?"
      input {type: 'email', required: true, name: 'contact-email', defaultValue: @props.answers['contact-email']}
      h2 {}, "What's your phone number?"
      input {type: 'tel', required: true, name: 'contact-phone', required: true, defaultValue: @props.answers['contact-phone']}
      h2 {}, "What's your address?"
      textarea {name: 'contact-address', defaultValue: @props.answers['contact-address']}
      new RadioButton(radio: radioData, answers: @props.answers)
      new PaginateActions(nextAction: @props.nextAction, prevAction: @props.prevAction, page: @props.page, totalPageCount: @props.totalPageCount)

module.exports = React.createFactory Contact
