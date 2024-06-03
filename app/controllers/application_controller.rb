class ApplicationController < ActionController::API
  before_action :authenticate_user!

  include ActionController::MimeResponds
end
