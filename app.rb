require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
	
def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true 
	return db
end

def is_barber_exists? db, name
	db.execute('select * from barbers where name=?', [name]).length	> 0 
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute('insert into barbers (name) values (?)', [barber])
		end
	end 

end

before do
	db = get_db
 	@barbers = db.execute 'select * from barbers'
end

configure do
	db = get_db	
#	db.execute 'CREATE TABLE "Users" ("Id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
#	            "Name" VARCHAR, "Phone" VARCHAR, "DateStamp" VARCHAR, "Barber" VARCHAR, "Color" VARCHAR)'

	seed_db db, ['Barb 1', 'Barb 2', 'Barb 3']
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

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	# хеш
	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
			:datetime => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	# Save to DB
	#db = SQLite3::Database.new '../Base/Barbershop.sqlite'

	#db.execute ""
	db = get_db
	db.execute 'insert into users 	(name, phone, DateStamp, barber, color) 
	values (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]

	#db.close

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"

end

get '/showusers' do
	db = get_db

 	@results = db.execute 'select * from Users'

	erb :showusers
end