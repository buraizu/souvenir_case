require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "supersecretpassword"
  end

  delete '/souvenirs/:id' do

    souvenir = Souvenir.find_by_id(params[:id])
    if Helpers.current_user(session).id == souvenir[:user_id]
      souvenir.destroy
      redirect "/my_souvenirs"
    else
      redirect "/souvenirs"
    end
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

  get '/my_souvenirs' do

    if Helpers.is_logged_in?(session)
      @user = User.find_by_id(session[:user_id])
      @souvenirs = @user.souvenirs
      erb :my_souvenirs
    else
      redirect "/login"
    end
  end

  get '/souvenirs' do
    @souvenirs = Souvenir.all
    erb :souvenirs
  end

  get '/souvenirs/new' do
    if Helpers.is_logged_in?(session)
      @user = User.find_by_id(session[:user_id])
      erb :new_souvenir
    else
      redirect "/login"
    end
  end

  get '/souvenirs/:id' do
    if Helpers.is_logged_in?(session)
      @souvenir = Souvenir.find_by_id(params[:id])
      @owner = User.find_by_id(@souvenir.user_id)
      erb :show_souvenir
    else
      redirect "/login"
    end
  end

  patch '/souvenirs/:id' do
    souvenir = Souvenir.find_by_id(params[:id])
    souvenir.name = params[:name]
    souvenir.source = params[:source]
    souvenir.year_obtained = params[:year_obtained]
    souvenir.description = params[:description]
    souvenir.save
    redirect "/souvenirs/#{souvenir.id}"
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

  post '/souvenirs/new' do
    if !params.has_value?("")
      souvenir = Souvenir.create(name: params[:name])
      souvenir.source = params[:source]
      if params[:year_obtained].to_i <= 0 || params[:year_obtained].to_i >= Time.now.year
        redirect "/souvenirs"
      else
        souvenir.year_obtained = params[:year_obtained]
      end
      binding.pry
      souvenir.description = params[:description]
      souvenir.user_id = session[:user_id]
      souvenir.save
      redirect "/my_souvenirs"
    else
      redirect "/souvenirs/new"
    end
  end

end
