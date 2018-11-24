require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    # set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "supersecretpassword"
  end

  get '/' do
    erb :index
  end

  get '/login' do
    if Helpers.is_logged_in?(session)
      redirect "/souvenirs"
    else
      erb :login
    end
  end

  get '/logout' do
    session.clear
    redirect "/login"
  end

  get '/signup' do
    erb :signup
  end

  get '/souvenirs' do
    @souvenirs = Souvenir.all
    erb :souvenirs
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/souvenirs"
    else
      redirect "/login"
    end
  end

  post '/signup' do
    if !params[:username].empty? && !params[:password].empty?
      user = User.create(username: params[:username])
      user.password = params[:password]
      user.save
      session[:user_id] = user.id
      redirect '/souvenirs'
    else
      redirect '/signup'
    end
  end

end
