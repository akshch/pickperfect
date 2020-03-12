module GamesHelper
  def get_game_locations(game)
    game_locations = []
    game.locations.each do |location|
      game_locations << location.name
    end
    return game_locations.join(",")
  end
end
