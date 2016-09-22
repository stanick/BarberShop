require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'SQLite3'

def is_barber_exist? db, barber
db.execute('select * from barbers where name = ?', [barber]).length > 0

#db.execute('select * from Barbers where name=?', [barber]).length > 0

end

def seed_db db, barbers
 barbers.each do |barber|
 if !is_barber_exist? db, barber 
 db.execute 'insert into barbers (name) values (?)', [barber]
 end
 end
end

def get_db
db = SQLite3::Database.new ('BarberShop.db')
db.results_as_hash = true
return db
end

before do
db = get_db
@barbers = db.execute 'select * from barbers'
end 

configure do
db = get_db
db.execute 'CREATE  TABLE IF NOT EXISTS "users" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , 
						"username" TEXT, 
						"phone" TEXT, 
						"datestamp" TEXT,
						 "barber" TEXT,
						 "color" TEXT)'


db.execute 'CREATE  TABLE IF NOT EXISTS "barbers" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "name" TEXT)'

seed_db db, ['Рудько Марта', 'Галишанова Маряна']
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			

end

get '/about' do
erb :about
end

get '/visit' do
erb :visit
end

get '/contacts' do
erb :contacts
end

post '/visit' do
@barber = params[:barber]
@username = params[:username]
@phone = params[:phone]
@datetime = params[:datetime]

hh = {:username =>'Не заполнено имя', :phone => 'Не указан телефон',
      :datetime => 'Не указано время'}
@error = hh.select{|key,_| params[key]==''}.values.join(', ')

if not @error == ''
return erb :visit
end

db = get_db
db.execute 'insert into users (username, phone, datestamp, barber)
			values (?,?,?,?)', [@username, @phone, @datetime, @barber] 

 erb "Имя: #{@username} к парикмахеру: #{@barber}телефон: #{@phone} время приема: #{@datetime}"

end

post '/contacts' do
@email = params[:email]
@message = params[:message]

hh = {:email =>'Не заполнен Email',
      :message => 'Введите сообщение'}
@error = hh.select{|key,_| params[key]==''}.values.join(', ')

if not @error==''
return erb :contacts
end

erb "Email: #{@email} Сообщение: #{@message}"

end                                        


get '/showusers' do
db = get_db
@results = db.execute 'select * from users order by id desc'
erb :showusers
end