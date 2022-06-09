require_relative 'library'

class Game
  attr_reader :board, :white_player, :black_player

  def start_game
    @board = Board.new
    @white_player = Player.new('white', board)
    @black_player = Player.new('black', board)
    board.add_starting_pieces(white_player)
    board.add_starting_pieces(black_player)
    update_all_possible_moves
    play_game
  end

  def update_all_possible_moves
    white_player.update_all_possible_moves
    black_player.update_all_possible_moves
  end

  def play_game
    loop do
      white_player.play_turn
      break if black_player.checkmate?

      update_all_possible_moves
      black_player.check_message if black_player.check?
      black_player.play_turn
      break if white_player.checkmate?

      update_all_possible_moves
      white_player.check_message if white_player.check?
    end
    end_game
  end

  def end_game
    white_player.checkmate_message if black_player.checkmate?
    black_player.checkmate_message if white_player.checkmate?
    play_again?
  end

  def play_again?
    response = white_player.play_again_message
    Game.new.play_game if response
  end
end
