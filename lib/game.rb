require_relative 'library'

class Game
  attr_reader :board, :white_player, :black_player, :white_pieces, :black_pieces

  def start_game
    @board = Board.new
    @white_player = Player.new('white', board)
    @black_player = Player.new('black', board)
    add_white_pieces_to_board
    add_black_pieces_to_board
    play_game
  end

  def white_king
    white_pieces.find { |piece| piece.instance_of?(King) }
  end

  def black_king
    black_pieces.find { |piece| piece.instance_of?(King) }
  end

  def add_white_pieces_to_board
    color = 'white'
    @white_pieces = [
      WhitePawn.add_to_board(color, board),
      Rook.add_to_board(color, board),
      Knight.add_to_board(color, board),
      Bishop.add_to_board(color, board),
      Queen.add_to_board(color, board),
      King.add_to_board(color, board)
    ]
  end

  def add_black_pieces_to_board
    color = 'black'
    @black_pieces = [
      BlackPawn.add_to_board(color, board),
      Rook.add_to_board(color, board),
      Knight.add_to_board(color, board),
      Bishop.add_to_board(color, board),
      Queen.add_to_board(color, board),
      King.add_to_board(color, board)
    ]
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
    pieces = (player == white_player ? white_pieces : black_pieces)
    loop do
      board.display
      move = player.input_move
      selected_piece = pieces.find do |piece|
        piece.instance_of?(move[0]) &&
          piece.possible_moves.include?([move[1], move[2]])
      end
      selected_piece.move(move[1], move[2])
      break unless check?(pieces.find { |piece| piece.instance_of?(King) })

      puts 'Illegal move. Choose a different move.'
      selected_piece.undo_move
    end
  end

  def check?(king)
    pieces = (king.color == 'white' ? black_pieces : white_pieces)
    pieces.any? do |piece|
      piece.possible_moves.include?([king.row, king.column])
    end
  end

  def checkmate?
    if white_king.possible_moves.all? do |position|
      black_pieces.any? do |piece|
        piece.possible_moves.include?([position[0], position[1]])
      end
    end
      'white'
    elsif black_king.possible_moves.all? do |position|
      white_pieces.any? do |piece|
        piece.possible_moves.include?(position[0], position[1])
      end
    end
      'black'
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
