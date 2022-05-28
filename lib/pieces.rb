require 'colorize'

class Piece
  attr_reader :color
  
  def initialize(row, column, color)
    @row = row
    @column = column
    @color = color
  end

  def self.add_to_board(color, board)
    piece_set = []
    case color
    when 'white'
      starting_positions = self::WHITE_STARTING_POSITIONS
    when 'black'
      starting_positions = self::BLACK_STARTING_POSITIONS
    end

    starting_positions.each do |position|
      row = position[0]
      column = position[1]
      piece = new(row, column, color)
      piece_set << piece
      board.positions[row][column] = piece
    end
    piece_set
  end
end

class WhitePawn < Piece
  WHITE_STARTING_POSITIONS = [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]].freeze

  def to_s
    ' ♟ '.colorize(:light_white)
  end
end

class BlackPawn < Piece
  BLACK_STARTING_POSITIONS = [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]].freeze

  def to_s
    ' ♟ '.colorize(:black)
  end
end

class Rook < Piece
  WHITE_STARTING_POSITIONS = [[7, 0], [7, 7]].freeze
  BLACK_STARTING_POSITIONS = [[0, 0], [0, 7]].freeze

  def to_s
    color == 'white' ? ' ♜ '.colorize(:light_white) : ' ♜ '.colorize(:black)
  end
  
  def possible_moves(board)
    next_row = @row
    next_column = @column
    possible_moves_array = []
    check_up(board).each { |position| possible_moves_array << position }
    check_right(board).each { |position| possible_moves_array << position }
    possible_moves_array
  end

  private

  def check_up(board)
    moves_up = []
    next_row = @row - 1
    while board.positions[next_row][@column].nil? && next_row.between?(0, 7)
      moves_up << [next_row, @column]
      next_row -= 1
    end
    moves_up
  end

  def check_right(board)
    moves_right = []
    next_column = @column + 1
    while board.positions[@row][next_column].nil? && next_column.between?(0, 7)
      moves_right << [@row, next_column]
      next_column += 1
    end
    moves_right
  end
end

class Knight < Piece
  WHITE_STARTING_POSITIONS = [[7, 1], [7, 6]].freeze
  BLACK_STARTING_POSITIONS = [[0, 1], [0, 6]].freeze

  def to_s 
    color == 'white' ? ' ♞ '.colorize(:light_white) : ' ♞ '.colorize(:black)
  end
end

class Bishop < Piece
  WHITE_STARTING_POSITIONS = [[7, 2], [7, 5]].freeze
  BLACK_STARTING_POSITIONS = [[0, 2], [0, 5]].freeze

  def to_s 
    color == 'white' ? ' ♝ '.colorize(:light_white) : ' ♝ '.colorize(:black)
  end
end

class Queen < Piece
  WHITE_STARTING_POSITIONS = [[7, 3]].freeze
  BLACK_STARTING_POSITIONS = [[0, 3]].freeze

  def to_s 
    color == 'white' ? ' ♛ '.colorize(:light_white) : ' ♛ '.colorize(:black)
  end
end

class King < Piece
  WHITE_STARTING_POSITIONS = [[7, 4]].freeze
  BLACK_STARTING_POSITIONS = [[0, 4]].freeze
  SYMBOL = ' ♚ '.freeze

  def to_s 
    color == 'white' ? ' ♚ '.colorize(:light_white) : ' ♚ '.colorize(:black)
  end
end
