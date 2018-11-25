require './config/environment'

require_relative 'app/controllers/application_controller.rb'
require_relative 'app/controllers/souvenirs_controller.rb'
require_relative 'app/controllers/users_controller.rb'

use Rack::MethodOverride
use SouvenirsController
use UsersController
run ApplicationController
