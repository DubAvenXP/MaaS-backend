class User < ApplicationRecord
    include ErrorUtilities

    has_one :profile, dependent: :destroy
    has_many :availabilities, dependent: :destroy
    has_many :assignments, dependent: :destroy
    
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }
    validates :password_confirmation, presence: true, length: { minimum: 6 }
    
    has_secure_password


    # get list all users
    def self.index
        users = User.joins(:profile)

        users = users.map do |user|
            {
                id: user.id,
                first_name: user.profile.first_name,
                last_name: user.profile.last_name,
                email: user.email,
                phone: user.profile.phone,
                image: user.profile.image_url,
                role: user.profile.role,
				color: user.profile.color,
                profile_id: user.profile.id
				
            }
        end
    end


    # return user with correct format
    def show
        {
            id: self.id,
            first_name: self.profile.first_name,
            last_name: self.profile.last_name,
            email: self.email,
            phone: self.profile.phone,
            image: self.profile.image_url,
            role: self.profile.role,
            profile_id: self.profile.id
        }
    end
        


    # Creates a new user with a profile
    def self.create(params)

        # validate if first_name and last_name aren't nil
        validation = ErrorUtilities::validate_custom_fields({first_name: params[:first_name], last_name: params[:last_name]})

        # if errors are greater than 0 return errors and stop the execution
        return validation if validation[:errors].count > 0

        # create new user instance
        user = User.new({ email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation] })

        # create new profile instance
        user.profile = Profile.new( { first_name: params[:first_name], last_name: params[:last_name], color: params[:color] } )

        # assign role if it's present
        user.profile.role = Profile.roles[params[:role]] if params[:role].present?

        user
    end
end
