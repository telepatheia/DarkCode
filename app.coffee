express = require 'express'
bodyParser = require 'body-parser'
mongojs = require 'mongojs'
Agenda = require('agenda');

port = 3010
#-------[nama collection]-----#
namedb = "projek"
collection_user = "user"
collection_formpage = "formpage"
collection_agenda = "agenda"
#-----------------------------#

ejs = require('ais-ejs-mate')({ open: '{{' , close: '}}' })

db = mongojs('127.0.0.1/' + namedb) #setup koneksi mongodb

app = express()
app.engine '.html',ejs
app.use bodyParser()



app.set('views', __dirname);
app.use(express.static(__dirname + '/public'));

app.set 'views' , "./views"
app.set 'view engine' , 'html'

validasiLogin = (req , res, next) ->
	if req.body.email == ''
		error = { status: 'Email must be filled' }
		return res.render 'login', { error: error }
	else if req.body.password == ''
		error = { status: 'Password must be filled' }
		return res.render 'login', { error: error }
	else
		next()

validasiFormnotif = (req , res, next) ->
	{ template_list, tipe_pengiriman, tipe_engine } = require('./public/mock/list_template.js')
	if req.body.namarules == ''
		error = { status: 'Nama rules must be filled' }
		return res.render 'form-page' , { error: error , dataJson: [{}], template_list: template_list, tipe_pengiriman: tipe_pengiriman, tipe_engine: tipe_engine }
	else if req.body.query == ''
		error = { status: 'Query must be filled' }
		return res.render 'form-page' , { error: error , dataJson: [{}], template_list: template_list, tipe_pengiriman: tipe_pengiriman, tipe_engine: tipe_engine }
	else if req.body.query == '{}'
		error = { status: 'Query must be filled with something' }
		return res.render 'form-page' , { error: error , dataJson: [{}], template_list: template_list, tipe_pengiriman: tipe_pengiriman, tipe_engine: tipe_engine }
	else if req.body.tipepengirimancustom == ''
		error = { status: 'Tipe Pengiriman must be filled' }
		return res.render 'form-page' , { error: error , dataJson: [{}], template_list: template_list, tipe_pengiriman: tipe_pengiriman, tipe_engine: tipe_engine }
	else if req.body.mailengine == ''
		error = { status: 'Mail Engine must be choosed like Haraka or Mandrill' }
		return res.render 'form-page' , { error: error , dataJson: [{}], template_list: template_list, tipe_pengiriman: tipe_pengiriman, tipe_engine: tipe_engine }
	else
		next()

app.get '/login',(req , res ) ->
	res.render 'login', { error: false }

app.get '/form-page', (req , res ) ->
	{ template_list, tipe_pengiriman, tipe_engine } = require('./public/mock/list_template.js')
	#console.dir(template_list)
	res.render 'form-page' , { error: false , dataJson: [{}], template_list: template_list, tipe_pengiriman: tipe_pengiriman, tipe_engine: tipe_engine }

app.post '/form-page',validasiFormnotif, (req, res, next) ->
	{ template_list, tipe_pengiriman, tipe_engine } = require('./public/mock/list_template.js')
	minutes = req.body.minutes
	hours	= req.body.hours
	day = req.body.day
	month = req.body.month
	weekday = req.body.weekday
	custom_tipe_pengiriman = req.body.custom_tipe_pengiriman
	custom_tipe_pengiriman = "" if not custom_tipe_pengiriman
	if req.body.tipe_pengiriman == "Custom"
		custom_tipe_pengiriman = minutes + ' ' + hours + ' ' + day + ' ' + month + ' ' + weekday

	#format json untuk masuk kedalam database
	insertObject = 
		name : req.body.namarules
		template : req.body.template
		query : req.body.query
		scheduleType : req.body.tipe_pengiriman
		engine : req.body.mailengine
		customType : custom_tipe_pengiriman
	
	#console.dir(insertObject)
	db.collection(collection_formpage).save insertObject, (error , result) ->
		if error
			return res.send(error)
		error = { statusSuccess : 'Successfully' }
		res.render 'form-page' , { error: error , dataJson: [{}] , template_list: template_list , tipe_pengiriman: tipe_pengiriman , tipe_engine: tipe_engine}
		next()

app.get '/list-rule', (req , res) ->
	db.collection(collection_formpage).find {}, (error, result) ->
		data =
			dataJson: result		
		#console.dir(data)
		res.render 'list-page', data

app.get '/list-rule/:id/edit', (req , res) ->
	tipeaction = "Edit"
	id_rules	= req.params.id
	{ template_list, tipe_pengiriman, tipe_engine } = require('./public/mock/list_template.js')

	if tipeaction == 'Edit'
		db.collection(collection_formpage).find { _id: mongojs.ObjectId(id_rules) }, (error, result) ->
			idrules =
				dataJson: result
				error: false
				template_list: template_list
				tipe_pengiriman: tipe_pengiriman
				tipe_engine: tipe_engine
			#console.dir(idrules)	
			res.render 'form-page' , idrules
	if tipeaction == 'Delete'
		db.collection(collection_formpage).remove { _id: mongojs.ObjectId(id_rules) }, true, (error, result) ->
			res.redirect 'list-rule'

app.post '/list-rule/:id/edit', (req , res) ->
	id_rules	= req.params.id
	minutes = req.body.minutes
	hours	= req.body.hours
	day = req.body.day
	month = req.body.month
	weekday = req.body.weekday
	custom_tipe_pengiriman = req.body.custom_tipe_pengiriman
	custom_tipe_pengiriman = "" if not custom_tipe_pengiriman
	if req.body.tipe_pengiriman == "Custom"
		custom_tipe_pengiriman = minutes + ' ' + hours + ' ' + day + ' ' + month + ' ' + weekday

	#format json untuk masuk kedalam database
	updateObject = 
		name : req.body.namarules
		template : req.body.template
		query : req.body.query
		scheduleType : req.body.tipe_pengiriman
		engine : req.body.mailengine
		customType : custom_tipe_pengiriman	
	console.dir(updateObject)
	db.collection(collection_formpage).update { _id: mongojs.ObjectId(id_rules) }, { $set: updateObject }, (error, result) ->	
		if error
			return res.send(error)	
		res.redirect '/list-rule'

app.post '/auth-login', validasiLogin, (req , res) ->
	mail = req.body.email
	pass = req.body.password

app.post '/list-rule', (req , res) ->
	tipeaction = req.body.tipeaction
	idrules	= req.body.idrules
	
	if tipeaction == 'Edit'
		db.collection(collection_formpage).find { _id: mongojs.ObjectId(idrules) }, (error, result) ->
			idrules =
				dataJson: result
				error: false
			console.dir(idrules)
			res.render 'form-page' , idrules
	if tipeaction == 'Delete'
		db.collection(collection_formpage).remove { _id: mongojs.ObjectId(idrules) }, true, (error, result) ->
			res.redirect 'list-rule'

app.post '/count' , (req , res) ->
	query = JSON.parse req.body.query
	#console.dir(query)
	db.collection(collection_user).count query, (error, result) ->
		if error
			return res.send(error)
			#return res.json(result)		
		res.json { total: result }

app.listen port , () ->
	console.log  'listen port ' + port