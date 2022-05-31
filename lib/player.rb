require_relative 'library'

class Player
  attr_reader :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def add_pieces_to_board
    @pieces = [
      color == 'white' ? WhitePawn.add_to_board(color, board) : nil,
      color == 'black' ? BlackPawn.add_to_board(color, board) : nil,
      Rook.add_to_board(color, board),
      Knight.add_to_board(color, board),
      Bishop.add_to_board(color, board),
      Queen.add_to_board(color, board),
      King.add_to_board(color, board)
    ].compact
  end

  def turn
    desired_move = input_move
    @pieces.select
  end
  
  def input_move
    puts 'Input the coordinates of your next move.'
    loop do
      input = gets.chomp.chars
      input.push('P') if input[0].match(/A-Z/)
      piece = input[0]
      column = input[1]
      row = input[2].to_i
      next unless valid_input?(piece, column, row)

      coordinates = convert_to_numbered_coordinates(column, row)
      return coordinates.unshift(convert_to_class(piece))
    end
  end

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

  def search_for_move(piece, coordinates)
    @pieces.select do |possible_piece|
      next unless possible_piece.instance_of(piece[0])

      possible_piece.possible_moves.find(proc { false }) do |possible_move|
        possible_move == coordinates
      end
    end
  end
end
