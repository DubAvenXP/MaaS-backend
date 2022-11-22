module Responder
	include ErrorUtilities
    extend ActiveSupport::Concern


    def respond_with_not_found(message)
		errors = ErrorUtilities::generate_custom_error("id", message)[:errors]
        render :json => { :errors => errors }, :status => :not_found
    end

    def respond_with_errors(payload)
		errors = payload.errors
		errors = ErrorUtilities::format_error(errors) if errors.present?
		errors = payload[:errors] unless errors.present?
		
        render :json => errors, :status => :unprocessable_entity
    end

    def respond_with_success(payload, status = :ok)
        render :json => payload, :status => status
    end
end
