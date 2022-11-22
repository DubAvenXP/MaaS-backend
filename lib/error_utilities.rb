module ErrorUtilities
    class CustomError
        def initialize()
            @errors = {
                errors: []
            }
        end

		# generate attributes errors
        def add_error_attribute(attribute, value)
            @errors[:errors] << {
                attribute: attribute,
                error: "Invalid attribute, #{value} is not valid"
            }
        end

		# generate errors with custom message
		def add_custom_error(attribute, message)
			@errors[:errors] << {
                attribute: attribute,
                error: message
            }
		end

		# format standard rails error message
		def format_error(error)
			error.each do |key, value|
				@errors[:errors] << {
					attribute: key.attribute,
					error: key.raw_type
				}
			end
		end

        # get all errors
        def get_errors
            @errors
        end
    end

    def self.validate_custom_fields(payload)
        error_handler = CustomError.new
        # for each key in payload, validate if it's a valid attribute
        payload.each do |key, value|
            # if value is nil, add error to payload
            error_handler.add_error_attribute(key, value) if value.nil? || value.empty?
        end

        error_handler.get_errors
    end

	# generate a custom error message
	def self.generate_custom_error(attribute, message)
		error_handler = CustomError.new
		error_handler.add_custom_error(attribute, message)
		error_handler.get_errors
	end

	# format rails standard error message
	def self.format_error(error)
		error_handler = CustomError.new
		error_handler.format_error(error)
		error_handler.get_errors
	end
end
