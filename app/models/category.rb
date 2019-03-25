class Category < ApplicationRecord
  has_many :user_categories
  has_many :users, through: :user_categories, dependent: :destroy

  has_many :game_categories
  has_many :games, through: :game_categories, dependent: :destroy
end
