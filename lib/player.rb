require_relative 'pieces'

class Player
  attr_reader :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def create_pieces
    @pieces = []
    case color
    when 'white'
      @pieces << WhitePawn.create_pieces(board)
      @pieces << Rook.create_pieces('white', board)
      @pieces << Knight.create_pieces('white', board)
      @pieces << Bishop.create_pieces('white', board)
      @pieces << Queen.create_pieces('white', board)
      @pieces << King.create_pieces('white', board)
    when 'black'
      @pieces << BlackPawn.create_pieces(board)
      @pieces << Rook.create_pieces('black', board)
      @pieces << Knight.create_pieces('black', board)
      @pieces << Bishop.create_pieces('black', board)
      @pieces << Queen.create_pieces('black', board)
      @pieces << King.create_pieces('black', board)
    end
  end

  def input_move
    puts 'Input the coordinates of your next move.'
    loop do
      input = gets.chomp.chars
      column = input[0]
      row = input[1].to_i
      next unless valid_input?(column, row)

      return convert_to_numbered_coordinates(column, row)
    end
  end

  def valid_input?(column, row)
    ('a'..'h').include?(column) && (1..8).include?(row)
  end

  def convert_to_numbered_coordinates(column, row)
    letters_array = ('a'..'h').to_a
    clean_column = letters_array.find_index(column)
    clean_row = 8 - row
    [clean_row, clean_column]
  end
end
