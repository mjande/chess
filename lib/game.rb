require_relative 'library'

class Game
  attr_reader :board, :white_player, :black_player

  def start_game
    @board = Board.new
    @white_player = Player.new('white', board)
    @black_player = Player.new('black', board)
    board.add_starting_pieces(white_player)
    board.add_starting_pieces(black_player)
    white_player.assign_possible_moves
    black_player.assign_possible_moves
    play_game
  end

  def play_game
    loop do
      white_player.play_turn
      break if black_player.checkmate?

      black_player.check_message if black_player.check?
      black_player.play_turn
      break if white_player.checkmate?

      white_player.check_message if white_player.check?
    end
    end_game
  end

  def end_game
    white_player.win_message if black_player.checkmate?
    black_player.win_message if white_player.checkmate?
    play_again?
  end

  def play_again?
    response = white_player.play_again_message
    if response
      Game.new.play_game
    else
      puts 'Thanks for playing!'
    end
  end
end
