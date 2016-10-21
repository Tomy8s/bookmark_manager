ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require 'sinatra/flash'
require_relative 'models/data_mapper_setup'

class BookmarkManager < Sinatra::Base
  register Sinatra::Flash

  enable :sessions
  set :session_secret, 'super secret'

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  get '/' do
    erb :home
  end

  get '/sign-up' do
    @user = User.new
    erb :'user/sign-up'
  end

  post '/sign-up' do
      @user = User.create(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
      if !!@user.id
        session[:user_id] = @user.id
        redirect '/links'
      else
        flash.now[:error] = 'Passwords do not match. Please try again' 
        erb :'user/sign-up'
      end
  end

  get '/links' do
    @links = Link.all
    @tags = Tag.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  post '/links' do
    link = Link.new(url: params[:url], title: params[:title])
    params[:tags].split(",").each do |tag|
      tag1 = Tag.first_or_create(name: tag.strip)
      link.tags << tag1
    end
    link.save
    redirect '/links'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
