Agenda = require 'agenda'
mongojs = require 'mongojs'

agenda = new Agenda({db : {address:'localhost/projek', collection:'agenda'}})

db = mongojs('127.0.0.1/projek')

collection_form = "formpage"

db.collection(collection_form).find {}, (error, result) ->
	result.forEach (item) ->
		console.dir(item)
		agenda.define item.name, (job,done) ->
			console.dir(item.query)
			done()
		agenda.schedule item.customType, item.name
	agenda.start()

console.log 'Wait'