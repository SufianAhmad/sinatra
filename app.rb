require "sinatra/base"
require "bundler/setup"

IMAGES = [
	{title: "Pakistan", url: "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSNmBHKBx-xBaxQE-WIP3OKJMwctai92-775p6cVTq1SxJlqlT0bw"},
	{title: "Maxico", url: "http://3.bp.blogspot.com/_rUW6DgdRSGc/TLi-dYYTI_I/AAAAAAAADSM/te9EwO56QfE/s1600/Flag-Mexico.png"},
	{title: "Japan", url: "http://www.thecountriesof.com/wp-content/uploads/2013/11/Japan-Flag.gif"}
]

class App < Sinatra::Base

	before do
		@user = "Sufian Ahmad"
		puts "==> starting request"
	end

	after do
		puts "<== ending request"
	end

	get /images/ do
		@message = "You are viewing flags"
	end

	get "/" do
		erb :hello, layout: true
		
	end

	get '/images' do
		@images = IMAGES
		erb :images
	end

	get "/images/:index" do |index|
		index = index.to_i
		@image = IMAGES[index]
		haml :"images/show", layout: true
	end

end
