class Location < ApplicationRecord

  has_many :game_locations
  has_many :games, through: :game_locations, dependent: :destroy
end
