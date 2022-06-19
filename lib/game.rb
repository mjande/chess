require_relative 'library'
require 'yaml'

class Game
  attr_reader :board, :white_player, :black_player

  def start
    puts "Let's play chess! \n Type one of the options below to begin."
    puts "Options: 'new' or 'load'"
    case gets.chomp.downcase
    when 'new'
      start_game
    when 'load'
      load_game
    else
      'Please choose from one of the options below.'
    end
  end

  def start_game
    @board = Board.new
    @white_player = Player.new('white', board)
    @black_player = Player.new('black', board)
    @next_turn = 'white'
    board.add_starting_pieces
    board.update_all_possible_moves
    play_game
  end

  def play_game
    loop do
      case @next_turn
      when 'white'
        break if white_player.checkmate? || draw?(white_player)

        white_turn
        board.log_position
        check_responses
        @next_turn = 'black'
      when 'black'
        break if black_player.checkmate? || draw?(black_player)

        black_turn
        board.log_position
        check_responses
        @next_turn = 'white'
      end
    end
    end_game
  end

  def check_responses
    if white_player.draw
      black_player.draw_acceptance_message
    elsif black_player.draw
      white_player.draw_acceptance_message
    elsif white_player.save || black_player.save
      save_game
    end
  end

  def draw?(player)
    board.no_possible_moves?(player) || board.dead_position? ||
      mutual_agreement? || board.threefold_repetition? ||
      board.moves_since_capture > 49
  end

  def mutual_agreement?
    white_player.draw && black_player.draw
  end

  def end_game
    if black_player.checkmate?
      white_player.win_message
    elsif white_player.checkmate?
      black_player.win_message
    else
      white_player.tie_message
    end
    play_again
  end

  def play_again
    response = white_player.play_again_input
    Game.new.play_game if response
  end

  def save_game
    Dir.open('saved_games')
    save_data = serialize
    file_name = 'saved_games/save.yml'
    save_file = File.open(file_name, 'w')
    save_file.puts save_data
    save_file.close
    exit
  end

  def serialize
    game_data = { board: @board, white_player: @white_player,
                  black_player: @black_player, next_turn: @next_turn }
    YAML.dump(game_data)
  end

  def deserialize(yaml_string)
    YAML.load(yaml_string)
  end

  def load_game
    Dir.open('saved_games')
    file_name = 'saved_games/save.yml'
    file = File.open(file_name, 'r')
    data = deserialize(file)
    @board = data[:board]
    @white_player = data[:white_player]
    white_player.save = false
    @black_player = data[:black_player]
    black_player.save = false
    @next_turn = data[:next_turn]
    play_game
  end

  private

  def white_turn
    white_player.check_message if white_player.check?
    white_player.play_turn
  end

  def black_turn
    black_player.check_message if black_player.check?
    black_player.play_turn
  end
end
