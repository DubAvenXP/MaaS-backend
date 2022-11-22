class Profile < ApplicationRecord

  belongs_to :user

  has_one_attached :image

  # enums
  enum role: [:engineer, :manager, :admin]

  # callbacks
  after_create :assign_role

  def image_url
    Rails.application.routes.url_helpers.rails_blob_path(self.image, only_path: true) if self.image.attached?
  end

  private

  # Assigns a default role to a new profile
  def assign_role
    self.update(role: :engineer) unless self.role.present?
  end

end
