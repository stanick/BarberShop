require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'SQLite3'

def get_db
db = SQLite3::Database.new ('BarberShop.db')
db.results_as_hash
return db
end

configure do
db = get_db
db.execute 'CREATE  TABLE IF NOT EXISTS "users" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , 
						"username" TEXT, 
						"phone" TEXT, 
						"datestamp" TEXT,
						 "barber" TEXT,
						 "color" TEXT)'

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