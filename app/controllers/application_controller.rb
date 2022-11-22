class ApplicationController < ActionController::API
    include Responder

    rescue_from ActiveRecord::RecordNotFound, :with => :respond_with_not_found
end
