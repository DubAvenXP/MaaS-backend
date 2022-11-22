module Responder
    extend ActiveSupport::Concern

    def respond_with_not_found(error)
        render :json => {:errors => payload.errors}, :status => :not_found
    end

    def respond_with_errors(payload)
        render :json => {:errors => payload.errors}, :status => :unprocessable_entity
    end

    def respond_with_success(payload, status = :ok)
        render :json => payload, :status => status
    end
end