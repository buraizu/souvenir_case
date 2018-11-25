class SouvenirsController < ApplicationController

  delete '/souvenirs/:id' do
    souvenir = Souvenir.find_by_id(params[:id])
    if Helpers.current_user(session).id == souvenir[:user_id]
      souvenir.destroy
      redirect "/my_souvenirs"
    else
      redirect "/souvenirs"
    end
  end

  get '/my_souvenirs' do
    if Helpers.is_logged_in?(session)
      @user = User.find_by_id(session[:user_id])
      @souvenirs = @user.souvenirs
      erb :'souvenirs/my_souvenirs'
    else
      redirect "/login"
    end
  end

  get '/souvenirs' do
    @souvenirs = Souvenir.all
    erb :'souvenirs/souvenirs'
  end

  get '/souvenirs/new' do
    if Helpers.is_logged_in?(session)
      @user = User.find_by_id(session[:user_id])
      erb :'/souvenirs/new_souvenir'
    else
      redirect "/login"
    end
  end

  get '/souvenirs/:id' do
    if Helpers.is_logged_in?(session)
      @souvenir = Souvenir.find_by_id(params[:id])
      @owner = User.find_by_id(@souvenir.user_id)
      erb :'souvenirs/show_souvenir'
    else
      redirect "/login"
    end
  end

  patch '/souvenirs/:id' do
    souvenir = Souvenir.find_by_id(params[:id])
    souvenir.name = params[:name]
    souvenir.source = params[:source]
    if params[:year_obtained].to_i <= 0 || params[:year_obtained].to_i >= Time.now.year
      redirect "/souvenirs/#{souvenir.id}"
    else
      souvenir.year_obtained = params[:year_obtained]
    end
    souvenir.description = params[:description]
    souvenir.save
    redirect "/souvenirs/#{souvenir.id}"
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

      souvenir.description = params[:description]
      souvenir.user_id = session[:user_id]
      binding.pry
      souvenir.save
      redirect "/my_souvenirs"
    else
      redirect "/souvenirs/new"
    end
  end

end
