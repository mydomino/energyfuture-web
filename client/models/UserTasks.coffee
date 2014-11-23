_ = require 'lodash'
auth = require '../auth'
Task = require './Task'

module.exports = class UserTasks
  constructor: (user, @status) ->
    @user = user || auth.user

  filteredTasks: =>
    _.reduce @user.get('tasks'), ((_tasks, task, uniqId) =>
      _tasks[uniqId] = new Task(task) if task.status == @status
      _tasks
    ), {}

  add: (task) ->
    @user.addTask(_.merge(task.attributes, status: @status))

  includesTask: (task) ->
    _.some @filteredTasks(), (_task) => _task.id == task.id

  includesTasks: (challengeTaskIds) ->
    ids = _.map @filteredTasks(), (task) -> task.id
    _.all challengeTaskIds, (challengeTaskId) => _.contains(ids, challengeTaskId)

  includesChallenge: (challenge) ->
    _.some @filteredTasks(), (_task) => _task.get('challengeId') == challenge.id

  getPoints: ->
    _.reduce @filteredTasks(), ((total, task) ->
      total += parseInt(task.get('score'), 10)
      total
    ), 380
