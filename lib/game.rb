require_relative 'library'

class Game
  attr_reader :board, :white_player, :black_player, :white_pieces, :black_pieces

  def start_game
    @board = Board.new
    @white_player = Player.new('white', board)
    @black_player = Player.new('black', board)
    board.add_starting_pieces('white')
    board.add_starting_pieces('black')
    play_game
  end

  def white_king
    white_pieces.find { |piece| piece.instance_of?(King) }
  end

  def black_king
    black_pieces.find { |piece| piece.instance_of?(King) }
  end

  def play_game
    until checkmate?
      play_turn(white_player)
      black_player.check_message if check?(black_king)
      break if checkmate?

      play_turn(black_player)
      white_player.check_message if check?(white_king)
    end
    end_game
  end

  def play_turn(player)
    pieces = (player == white_player ? board.white_pieces : board.black_pieces)
    loop do
      board.display
      move = player.input_move
      selected_piece = board.find_piece(move, player.color)
      selected_piece.move(move[1], move[2])
      break unless check?(pieces.find { |piece| piece.instance_of?(King) })

      puts 'Illegal move. Choose a different move.'
      selected_piece.undo_move
    end
  end

  def end_game
    white_player.win_message if checkmate? == 'black'
    black_player.win_message if checkmate? == 'white'
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
