class User < ApplicationRecord
    
    has_one :profile, dependent: :destroy
    
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
                picture: user.profile.picture,
                role: user.profile.role,
                profile_id: user.profile.id
            }
        end
    end

    def show
        {
            id: self.id,
            first_name: self.profile.first_name,
            last_name: self.profile.last_name,
            email: self.email,
            phone: self.profile.phone,
            picture: self.profile.picture,
            role: self.profile.role,
            profile_id: self.profile.id
        }
    end
        

    # Creates a new user with a profile
    def self.create(params)

        # validate if first_name and last_name aren't nil
        if params[:first_name].nil? || params[:last_name].nil?
            errors = {}

            errors[:first_name] = ["first_name can't be blank"] if params[:first_name].nil?
            errors[:last_name] = ["last_name can't be blank"]   if params[:last_name].nil?
        
            return { errors: { errors: errors } }
        end

        # create new user instance
        user = User.new({
            email: params[:email],
            password: params[:password],
            password_confirmation: params[:password_confirmation],
        })

        # create new profile instance
        user.profile = Profile.new({
            first_name: params[:first_name],
            last_name: params[:last_name],
        })
        
        
        # assign role if it's present
        user.profile.role = Profile.roles[params[:role]] if params[:role].present?

        user
    end
end
