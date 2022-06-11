require_relative 'library'

class Player
  attr_reader :color, :board
  attr_accessor :pieces

  def initialize(color, board)
    @color = color
    @board = board
    @pieces = []
  end

  def update_pieces
    pieces = []
    board.positions.each do |row|
      row.each do |position|
        pieces << position unless !position.nil? && position.color == color
      end
    end
  end

  def play_turn
    update_pieces
    board.display
    loop do
      puts "#{color.capitalize}, input the coordinates of your next move."
      puts "If you like to save, quit, or call for a draw, type 'options'."
      chosen_move = input_move
      piece = find_piece(chosen_move)
      if piece.nil?
        puts 'That is not a valid move. Try again.'
        next
      end
      piece.move(chosen_move[1], chosen_move[2]) unless special_move(piece, chosen_move)
      board.update_all_possible_moves
      break unless check?

      puts 'That move places your king in check. Try again.'
      piece.undo_move
      board.update_all_possible_moves
    end
  end

  def special_move(piece, chosen_move)
    kingside_castling_moves = [[King, 0, 6], [King, 7, 6]]
    queenside_castling_moves = [[King, 0, 2], [King, 7, 2]]
    if piece.instance_of?(King) && piece.previous_moves.empty?
      if kingside_castling_moves.include?(chosen_move)
        piece.kingside_castle_move
      elsif queenside_castling_moves.include?(chosen_move)
        piece.queenside_castle_move
      end
    end
  end

  def input_move
    loop do
      input_string = gets.chomp
      if input_string == 'options'
        # Go to options interface / return 'options'
      elsif castling_input?(input_string)
        return convert_to_castling_coordinates(input_string)
      elsif valid_input?(input_string)
        input_array = input_string.chars
        input_array.unshift('P') if input_array.length == 2
        coordinates = convert_to_numbered_coordinates(input_array)
        return coordinates.unshift(convert_to_class(input_array[0]))
      else
        puts 'Please use chess notation ("a1" or "Kc6"), or enter "options".'
      end
    end
  end

  def search_for_move(piece, coordinates)
    @pieces.select do |possible_piece|
      next unless possible_piece.instance_of(piece[0])

      possible_piece.possible_moves.find(proc { false }) do |possible_move|
        possible_move == coordinates
      end
    end
  end

  def find_piece(move)
    pieces.find do |piece|
      piece.instance_of?(move[0]) &&
        piece.possible_moves.include?([move[1], move[2]])
    end
  end

  def update_all_possible_moves
    pieces.each(&:update_possible_moves)
  end

  def king
    pieces.find { |piece| piece.instance_of?(King) }
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

  def checkmate_message
    puts "Checkmate! #{color.capitalize}, you win!"
  end

  def play_again_message
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
      color == 'white' ? WhitePawn : BlackPawn
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
