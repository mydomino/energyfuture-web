React = require 'react'
{h2, div, p, input} = React.DOM

_ = require 'lodash'
moment = require 'moment'
RadioButton = require './RadioButton.view'
Action = require './Action.view'
auth = require '../../auth'

Appointment = React.createClass
  displayName: 'Appointment'

  componentDidMount: ->
    @setCallDetails()

  laterDate: (days) ->
    next = @nextBusinessDate(days)
    day = if next.diff(moment(), 'days') == 1 then 'Tomorrow' else next.format("dddd")
    { date: next.format("MMMM Do"), day: day }

  isTodaySaturday: ->
    moment().isoWeekday() == 6

  nextBusinessDate: (days) ->
    offset = 0
    _.times days, (idx) =>
      if @isTodaySaturday()
        offset = 1
      else
        day = moment().add(idx + 1, "days").format('dddd')
        offset = 2 if (day == "Saturday" || day == "Sunday")
    moment(moment().add(days + offset, "days"))

  setCallDetails: ->
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
    return unless @props.isFormValid()
    mixpanel.track 'Confirm Appointment', guide_id: @props.guideId
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
          label: @laterDate(1).day,
          position: "1",
          value: @laterDate(1).day.toLowerCase()
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
          position: "40",
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
        div {className: 'appointment-item'}, new RadioButton(radio: appointmentDateData, answers: @props.answers, changeAction: @setCallDetails)
        div {className: 'appointment-item'}, new RadioButton(radio: appointmentTimeData, answers: @props.answers, changeAction: @setCallDetails)
        new Action(moreAction: @confirmAction, actionName: "Confirm Appointment")

module.exports = React.createFactory Appointment
