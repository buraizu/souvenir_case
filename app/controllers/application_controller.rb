require './config/environment'
require 'sinatra'


class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "supersecretpassword"
  end

  get '/' do
    erb :index
  end

end
