require "sinatra/base"
require "bundler/setup"

IMAGES = [
  { title: "Flower", url: "/images/0.jpeg" },
  { title: "Linux", url: "/images/1.jpeg" },
  { title: "Linux1", url: "/images/2.jpeg" }
]

class App < Sinatra::Base

  enable :sessions
  disable :show_exceptions
  register Sinatra::Prawn
  register Sinatra::Namespace

  helpers Sinatra::ContentFor
  helpers Sinatra::JSON

  helpers do
    def protected!
      unless authorized?
        response["WWW-Authenticate"] = %(Basic realm="Admins Only!")
        halt 401
      end
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ["admin", "admin"]
    end
  end

  before do
    @user = "Sufian Ahmad"
    @height = session[:height]
    @environment = settings.environment
    @request = request
    puts "==> starting request"
  end

  after do
    puts "<== ending request"
  end

  get "/" do
    erb :hello, layout: true
  end

  get "/sessions/new" do
    erb :"sessions/new"
  end

  post "/sessions" do
    session[:height] = params[:height]
  end

  get "/sample.pdf" do
    content_type :pdf
    @message = "This is a PDF extention"
    prawn :samplepdf
  end

  namespace "/images" do
    get do
      @images = Image.all
      haml :"/images/index", layout_engine: :erb
    end

    get "/:id" do |id|
      @image = Image.get(id)
      haml %s(images/show), layout_engine: :erb
    end

    post do
      protected!
      @image = Image.create params[:image]
      redirect "/images"
    end
  end

  get "/images" do
    halt 403 if session[:height].nil?
    @images = IMAGES
    # @message = "You are viewing flags"
    erb :images
  end

  not_found do
    haml :"404", layout: true, layout_engine: :erb
  end

  error do 
    haml :error, layout: true, layout_engine: :erb
  end

  error 403 do
    haml :"403", layout: true, layout_engine: :erb
  end

  get "/500" do
    raise StandardError, "Intentional erro"
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
