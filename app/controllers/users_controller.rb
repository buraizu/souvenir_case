class UsersController < ApplicationController

  get '/login' do
    if Helpers.is_logged_in?(session)
      redirect "/souvenirs"
    else
      erb :'users/login'
    end
  end

  get '/logout' do
    session.clear
    redirect "/"
  end

  get '/signup' do
    erb :'users/signup'
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/souvenirs"
    else
      flash[:message] = "Incorrect username or password!"
      redirect "/error"
    end
  end

  post '/signup' do
    if !params[:username].empty? && !params[:password].empty?
      usernames = []
      User.all.each do |user|
        usernames << user.username
      end
      if !usernames.include?(params[:username])
        user = User.create(username: params[:username])
        user.password = params[:password]
        user.save
        session[:user_id] = user.id
        redirect "/souvenirs"
      else
        flash[:message] = "That username is already taken!"
        redirect "/error"
      end
    else
      flash[:message] = "You left one or more fields blank!"
      redirect "/error"
    end
  end

end
