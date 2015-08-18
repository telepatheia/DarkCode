Agenda = require 'agenda'
mongojs = require 'mongojs'

agenda = new Agenda({db : {address:'localhost/projek', collection:'agenda'}})

dbProjek = mongojs('127.0.0.1/projek', ['formpage'])
dbSetipe = mongojs('127.0.0.1/setipe', ['user'])


dbProjek.formpage.find {}, (error, result) ->
	result.forEach (item) ->
		console.dir(item)
		agenda.define item.name, (job,done) ->
			query = JSON.parse item.query
			console.dir("Query = " + query)
			dbSetipe.user.find {query}, (error2,result2) ->
				console.dir(result2)		
			console.log("Test 2")
			done()
		agenda.schedule item.customType, item.name
	agenda.start()

console.log 'Wait'