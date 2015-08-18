module.exports = function(app){
  app.get('',function(req,res){
   res.render('index.html');
  });

  app.get('/home',function(req,res){
   res.render('index.html');
  });

  app.get('/gallery',function(req,res){
   res.render('gallery.html');
  });

  app.get('/about',function(req,res){
   res.render('about.html');
  });

}