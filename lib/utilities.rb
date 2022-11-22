module Utilities

    class CustomError
        def initialize()
            @payload = {
                errors: []
            }
        end

        def add_error_attribute(attribute, value)
            @payload[:errors] << {
                attribute: attribute,
                message: "Invalid attribute, #{value} is not valid"
            }
        end

        # getters
        def get_payload
            @payload
        end
    end

    def self.validate_custom_fields(payload)
        error_handler = CustomError.new
        # for each key in payload, validate if it's a valid attribute
        payload.each do |key, value|
            # if value is nil, add error to payload
            error_handler.add_error_attribute(key, value) if value.nil?
        end

        error_handler.get_payload
    end
end