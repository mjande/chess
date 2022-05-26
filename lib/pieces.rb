class Piece
  def initialize(row, column)
    @row = row
    @column = column
  end

  def self.add_to_board(color, board)
    piece_set = []
    case color
    when 'white'
      starting_positions = self::WHITE_STARTING_POSITIONS
      symbol = self::WHITE_SYMBOL
    when 'black'
      starting_positions = self::BLACK_STARTING_POSITIONS
      symbol = self::BLACK_SYMBOL
    end

    starting_positions.each do |position|
      row = position[0]
      column = position[1]
      piece = new(row, column)
      piece_set << piece
      board.position_array[row][column] = symbol
    end
    piece_set
  end
end

class WhitePawn < Piece
  WHITE_STARTING_POSITIONS = [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]].freeze
  WHITE_SYMBOL = '♙'.freeze
end

class BlackPawn < Piece
  BLACK_STARTING_POSITIONS = [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]].freeze
  BLACK_SYMBOL = '♟'.freeze
end

class Rook < Piece
  WHITE_STARTING_POSITIONS = [[7, 0], [7, 7]].freeze
  WHITE_SYMBOL = '♖'.freeze
  BLACK_STARTING_POSITIONS = [[0, 0], [0, 7]].freeze
  BLACK_SYMBOL = '♜'.freeze
end

class Knight < Piece
  WHITE_STARTING_POSITIONS = [[7, 1], [7, 6]].freeze
  WHITE_SYMBOL = '♘'.freeze
  BLACK_STARTING_POSITIONS = [[0, 1], [0, 6]].freeze
  BLACK_SYMBOL = '♞'.freeze
end

class Bishop < Piece
  WHITE_STARTING_POSITIONS = [[7, 2], [7, 5]].freeze
  WHITE_SYMBOL = '♗'.freeze
  BLACK_STARTING_POSITIONS = [[0, 2], [0, 5]].freeze
  BLACK_SYMBOL = '♝'.freeze
end

class Queen < Piece
  WHITE_STARTING_POSITIONS = [[7, 3]].freeze
  WHITE_SYMBOL = '♕'.freeze
  BLACK_STARTING_POSITIONS = [[0, 3]].freeze
  BLACK_SYMBOL = '♛'.freeze
end

class King < Piece
  WHITE_STARTING_POSITIONS = [[7, 4]].freeze
  WHITE_SYMBOL = '♔'.freeze
  BLACK_STARTING_POSITIONS = [[0, 4]].freeze
  BLACK_SYMBOL = '♚'.freeze
end
