class Game < ApplicationRecord
  has_many :questions, dependent: :destroy

  has_many :game_locations
  has_many :locations, through: :game_locations, dependent: :destroy

  has_many :game_categories
  has_many :categories, through: :game_categories, dependent: :destroy

  accepts_nested_attributes_for :locations

  has_attached_file :avatar, styles: {medium: "300x300>", thumb: "100x100>"}, default_url: "No Image"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  def avatar_url
    if avatar.exists?
      avatar.url(:medium)
    else
      nil
    end
  end
end
