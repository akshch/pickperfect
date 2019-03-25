class User < ApplicationRecord

  before_create :generate_access_token
  
  validates :contact, uniqueness: true

  has_many :accounts, dependent: :destroy

  has_many :user_categories
  has_many :categories, through: :user_categories, dependent: :destroy

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  def avatar_url
    if avatar.exists?
      avatar.url(:medium)
    else
      nil
    end
  end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end
end
