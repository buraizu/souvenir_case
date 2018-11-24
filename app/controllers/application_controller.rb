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

  get '/signup' do
    erb: signup
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
