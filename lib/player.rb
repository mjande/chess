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
      chosen_move = input_move
      piece = find_piece(chosen_move)
      if piece.nil?
        puts 'That is not a valid move. Try again.'
        next
      end
      piece.move(chosen_move[1], chosen_move[2])
      break unless check?

      puts 'That move places your king in check. Try again.'
      piece.undo_move
    end
  end

  def input_move
    loop do
      input = gets.chomp.chars
      input.unshift('P') if input.length == 2
      piece = input[0]
      column = input[1]
      row = input[2].to_i
      if valid_input?(piece, column, row)
        coordinates = convert_to_numbered_coordinates(column, row)
        return coordinates.unshift(convert_to_class(piece))
      else
        puts 'Please use chess notation ("a1" or "Kc6").'
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

  def valid_input?(piece, column, row)
    possible_pieces = %w[P R N B Q K]
    possible_pieces.include?(piece) && ('a'..'h').include?(column) && (1..8).include?(row)
  end

  def convert_to_numbered_coordinates(column, row)
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
