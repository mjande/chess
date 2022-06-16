require_relative 'library'

class Player
  attr_reader :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def play_turn
    board.display
    loop do
      puts "If you like to save, quit, or call for a draw, type 'options'."
      input = input_move
      input.piece.move(input.row, input.column) # unless special_move(input.piece, input)
      board.update_all_possible_moves
      break unless check?

      puts 'That move places your king in check. Try again.'
      piece.undo_move
      board.update_all_possible_moves
    end
  end

  def special_move(input)
    kingside_castling_moves = [[King, 0, 6], [King, 7, 6]]
    queenside_castling_moves = [[King, 0, 2], [King, 7, 2]]
    if input.piece.instance_of?(King) && input.piece.previous_move.empty?
      if kingside_castling_moves.include?(chosen_move)
        piece.kingside_castle_move
      elsif queenside_castling_moves.include?(chosen_move)
        piece.queenside_castle_move
      end
    end
    if piece.instance_of?(Pawn) && piece.en_passant?(chosen_move[2])
      piece.en_passant_capture(chosen_move[2])
    end
  end

  def input_move
    loop do
      puts "#{color.capitalize}, input the coordinates of your next move."
      input_string = gets.chomp
      input = MoveInput.for(input_string, color, board)
      if input.piece.is_a?(Array)
        puts 'There are two or more pieces with that move.'
        puts 'Please indicate which piece using standard chess notation (Rdf8).'
      elsif input.piece.nil?
        puts 'There is not a piece that is able to make that move.'
      elsif input.instance_of?(InvalidMoveInput)
        puts 'Please use chess notation ("a1" or "Kc6"), or enter "save" to save or "=" to draw.'
      else
        return input
      end
    end
  end

  def find_piece(move)
    board.pieces.find do |piece|
      piece.instance_of?(move[0]) &&
        piece.possible_moves.include?([move[1], move[2]]) &&
        piece.color == color
    end
  end

  def king
    board.pieces.find { |piece| piece.instance_of?(King) && piece.color == color }
  end

  def check?
    king.check?
  end

  def checkmate?
    king.checkmate?
  end

  def check_message
    puts "Check! #{color.capitalize}, you must get your king out of check."
  end

  def win_message
    puts "Checkmate! #{color.capitalize}, you win!"
  end

  def play_again_input
    puts 'Would you like to play again? (Y or N)'
    response = gets.chomp.upcase
    if response == 'Y'
      true
    else
      puts 'Thanks for playing!'
      false
    end
  end

  private

  def castling_input?(string)
    castling_codes = ['0-0', '0-0-0']
    castling_codes.include?(string)
  end

  def convert_to_castling_coordinates(string)
    if string == '0-0'
      color == 'white' ? [King, 7, 6] : [King, 0, 6]
    else
      color == 'white' ? [King, 7, 2] : [King, 0, 2]
    end
  end

  def valid_input?(string)
    input_array = string.chars
    puts input_array
    possible_pieces = %w[P R N B Q K]
    if input_array.length == 3
      possible_pieces.include?(input_array[0]) &&
        ('a'..'h').include?(input_array[1]) &&
        (1..8).include?(input_array[2].to_i)
    else
      ('a'..'h').include?(input_array[0]) &&
        (1..8).include?(input_array[1].to_i)
    end
  end

  def convert_to_numbered_coordinates(input_array)
    row = input_array[2].to_i
    column = input_array[1]
    letters_array = ('a'..'h').to_a
    clean_column = letters_array.find_index(column)
    clean_row = 8 - row
    [clean_row, clean_column]
  end

  def convert_to_class(piece)
    case piece
    when 'P'
      Pawn
    when 'R'
      Rook
    when 'N'
      Knight
    when 'B'
      Bishop
    when 'Q'
      Queen
    when 'K'
      King
    end
  end
end
