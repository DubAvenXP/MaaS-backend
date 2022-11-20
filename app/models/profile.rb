class Profile < ApplicationRecord

  belongs_to :user

  # has_one_attached :picture

  # enums
  enum role: [:engineer, :manager, :admin]

  # callbacks
  after_create :assign_role

  private

  # Assigns a default role to a new profile
  def assign_role
    self.update(role: :engineer) unless self.role.present?
  end

end
