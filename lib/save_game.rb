# frozen_string_literal: true

# The SaveGame class handles methods for saving and loading the game.
class SaveGame
  # When created, an instance of SaveGame will serialize all game data into a
  # YAML file, and store the file in the 'saved_games' directory. After saving
  # it will end the program.
  def initialize(game)
    Dir.open('saved_games')
    save_data = serialize(game)
    file_name = 'saved_games/save.yml'
    save_file = File.open(file_name, 'w')
    save_file.puts save_data
    save_file.close
    exit
  end

  def serialize(game)
    game_data = { board: game.board, white_player: game.white_player,
                  black_player: game.black_player, next_player: game.next_player }
    YAML.dump(game_data)
  end

  def self.deserialize(yaml_string)
    YAML.load(yaml_string)
  end

  def self.load(game)
    Dir.open('saved_games')
    file_name = 'saved_games/save.yml'
    file = File.open(file_name, 'r')
    data = deserialize(file)
    assign_loaded_variables(game, data)
    game.play
  end

  def self.assign_loaded_variables(game, data)
    game.board = data[:board]
    game.white_player = data[:white_player]
    game.white_player.save = false
    game.black_player = data[:black_player]
    game.black_player.save = false
    game.next_player = data[:next_player]
  end
end
