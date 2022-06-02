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
      break if checkmate?
      play_turn(black_player)
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
      break unless check? == player.color

      puts 'Illegal move. Choose a different move.'
      selected_piece.undo_move
    end
    player.check_message(check?) if check?
  end

  def check?
    white_king = white_pieces.find { |piece| piece.instance_of?(King) }
    black_king = black_pieces.find { |piece| piece.instance_of?(King) }
    if black_pieces.any? do |piece|
      piece.possible_moves.include?([white_king.row, white_king.column])
    end
      'white'
    elsif white_pieces.any? do |piece|
      piece.possible_moves.include?([black_king.row, black_king.column])
    end
      'black'
    end
  end

  def checkmate?
    white_king = white_pieces.find { |piece| piece.instance_of?(King) }
    black_king = black_pieces.find { |piece| piece.instance_of?(King) }
  end

  def end_game
  end
end
