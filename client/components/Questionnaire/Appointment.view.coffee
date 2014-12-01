{h2, div, p, input} = React.DOM

moment = require 'moment'
RadioButton = require './RadioButton.view.coffee'
Action = require './Action.view.coffee'

module.exports = React.createClass
  displayName: 'Appointment'

  laterDate: (inc) ->
    next = moment(moment().add(inc, "days"))
    { date: next.format("MMMM Do"), day: next.format("dddd") }

  confirmAction: ->
    @setState confirmed: true

  guideIndexAction: ->
    page "/guides"

  getInitialState: ->
    confirmed: false

  render: ->
    appointmentDateData = {
      name: "appointment-date",
      position: "1",
      text: "When is a good day to talk?",
      type: "radio",
      required: true,
      options: [
        {
          description: @laterDate(1).date,
          label: "Tomorrow",
          position: "1",
          value: "tomorrow"
        }, {
          description: @laterDate(2).date,
          label: @laterDate(2).day,
          position: "10",
          value: "thursday"
        }, {
          description: @laterDate(3).date,
          label: @laterDate(3).day,
          position: "30",
          value: "friday"
        }, {
          description: "In the future...",
          label: "Later",
          position: "30",
          value: "later"
        }
      ]
    }

    appointmentTimeData = {
      name: "appointment-time",
      position: "3",
      text: "What time should we call you?",
      type: "radio",
      required: true,
      options: [
        {
          description: "9a-11a",
          label: "Morning",
          position: "1",
          value: "morning"
        }, {
          description: "11a-3p",
          label: "Afternoon",
          position: "10",
          value: "afternoon"
        }, {
          description: "3p-7p",
          label: "Evening",
          position: "30",
          value: "evening"
        }
      ]
    }

    if @state.confirmed
      div {className: 'questionnaire-appointment'},
        h2 {className: 'confirmation-header'}, "Great."
        p {className: 'confirmation-subheader'}, "We'll call you #{@props.answers['appointment-date']} between #{@props.answers['appointment-time']}."
        new Action(moreAction: @guideIndexAction, actionName: "Explore another guide")
    else
      div {className: 'questionnaire-appointment'},
          div {className: 'appointment-item'}, new RadioButton(radio: appointmentDateData, answers: @props.answers)
          div {className: 'appointment-item'}, new RadioButton(radio: appointmentTimeData, answers: @props.answers)
          new Action(moreAction: @confirmAction, actionName: "Confirm Appointment")
