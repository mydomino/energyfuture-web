{h2, div, p, input} = React.DOM

moment = require 'moment'
RadioButton = require './RadioButton.view.coffee'
Action = require './Action.view.coffee'
auth = require '../../auth.coffee'

module.exports = React.createClass
  displayName: 'Appointment'

  laterDate: (inc) ->
    next = moment(moment().add(inc, "days"))
    { date: next.format("MMMM Do"), day: next.format("dddd") }

  dateChangeAction: ->
    callTime = $("input[name='appointment-time']:checked").parent().find('.input-description').text()
    callDate = $("input[name='appointment-date']:checked").parent().find('label').text()
    callLater = $("input[name='appointment-date']:checked").val() == 'later'
    if @isMounted()
      @setState
        callTime: callTime
        callDate: callDate
        callLater: callLater

  exploreGuideAction: ->
    page "/guides"

  confirmAction: ->
    @props.storeInSessionAndFirebaseAction()
    @setState confirmed: true

  getInitialState: ->
    confirmed: false
    callLater: false

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
          value: @laterDate(2).day.toLowerCase()
        }, {
          description: @laterDate(3).date,
          label: @laterDate(3).day,
          position: "30",
          value: @laterDate(3).day.toLowerCase()
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
      subheader = if @state.callLater
          "We'll call you later."
        else
          "We'll call you #{@state.callDate} between #{@state.callTime}."
      div {className: 'questionnaire-appointment'},
        h2 {className: 'confirmation-header'}, "Great."
        p {className: 'confirmation-subheader'}, subheader
        new Action(moreAction: @exploreGuideAction, actionName: "Explore another guide")
    else
      div {className: 'questionnaire-appointment'},
          div {className: 'appointment-item'}, new RadioButton(radio: appointmentDateData, answers: @props.answers, changeAction: @dateChangeAction)
          div {className: 'appointment-item'}, new RadioButton(radio: appointmentTimeData, answers: @props.answers, changeAction: @dateChangeAction)
          new Action(moreAction: @confirmAction, actionName: "Confirm Appointment")
