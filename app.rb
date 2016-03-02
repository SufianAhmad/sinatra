require "sinatra/base"
require "bundler/setup"

IMAGES = [
	{title: "Flower", url: "/images/0.jpeg"},
	{title: "Linux", url: "/images/1.jpeg"},
	{title: "Linux1", url: "/images/2.jpeg"}
]

class App < Sinatra::Base

	enable :sessions
	before do
		@user = "Sufian Ahmad"
		@height = session[:height]
		puts "==> starting request"
	end

	after do
		puts "<== ending request"
	end

	# get /images/ do
	# 	@message = "You are viewing flags"
	# end

	get "/" do
		erb :hello, layout: true
		
	end

	get '/sessions/new' do
		erb :"sessions/new"
	end

	post '/sessions' do
		session[:height] = params[:height]
		
	end

	get '/images' do
		@images = IMAGES
		# @message = "You are viewing flags"
		erb :images
	end

	get "/images/:index.?:format?" do |index, format|
		index = index.to_i
		@image = IMAGES[index]
		@index = index

		if format == "jpeg"
			content_type :jpeg
			send_file "images/#{index}.jpeg"
		else
			haml :"images/show", layout: true		
		end
		
	end

	get "/images/:index/download" do |index|

		@image = IMAGES[index.to_i]
		attachment @image[:title]
		send_file "images/#{index}.jpeg"
		
	end

end
