require_relative 'pieces'

class Player
  attr_reader :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def add_pieces_to_board
    @pieces = []
    case color
    when 'white'
      @pieces << WhitePawn.add_to_board('white', board)
      @pieces << Rook.add_to_board('white', board)
      @pieces << Knight.add_to_board('white', board)
      @pieces << Bishop.add_to_board('white', board)
      @pieces << Queen.add_to_board('white', board)
      @pieces << King.add_to_board('white', board)
    when 'black'
      @pieces << BlackPawn.add_to_board('black', board)
      @pieces << Rook.add_to_board('black', board)
      @pieces << Knight.add_to_board('black', board)
      @pieces << Bishop.add_to_board('black', board)
      @pieces << Queen.add_to_board('black', board)
      @pieces << King.add_to_board('black', board)
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
