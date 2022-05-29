require_relative 'pieces'

class Player
  attr_reader :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def add_pieces_to_board
    @pieces = []
    @pieces << WhitePawn.add_to_board(color, board) if color == 'white'
    @pieces << BlackPawn.add_to_board(color, board) if color == 'black'
    @pieces << Rook.add_to_board(color, board)
    @pieces << Knight.add_to_board(color, board)
    @pieces << Bishop.add_to_board(color, board)
    @pieces << Queen.add_to_board(color, board)
    @pieces << King.add_to_board(color, board)
  end

  def turn
    desired_move = input_move
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

      return convert_to_numbered_coordinates(column, row)
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

  def search_for_move(coordinates)
    @pieces.select do |piece|
      piece.possible_moves.find(proc { false }) do |possible_move|
        possible_move == coordinates
      end
    end
  end
end
