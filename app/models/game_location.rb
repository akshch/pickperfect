class GameLocation < ApplicationRecord
  belongs_to :game
  belongs_to :location
end
