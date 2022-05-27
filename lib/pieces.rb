require 'colorize'

class Piece
  attr_reader :color
  
  def initialize(row, column, color)
    @row = row
    @column = column
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
    ' ♟ '.colorize(:white)
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
    color == 'white' ? ' ♜ '.colorize(:white) : ' ♜ '.colorize(:black)
  end
  
  def possible_moves(board)
    row = @row
    column = @column
    possible_moves = []
    while board.positions[row + 1][column].nil?
      possible_moves << [row + 1, column]
      row += 1
    end
    possible_moves << [row, column] if board.positions[row][column]

  end
    
end

class Knight < Piece
  WHITE_STARTING_POSITIONS = [[7, 1], [7, 6]].freeze
  BLACK_STARTING_POSITIONS = [[0, 1], [0, 6]].freeze

  def to_s 
    color == 'white' ? ' ♞ '.colorize(:white) : ' ♞ '.colorize(:black)
  end
end

class Bishop < Piece
  WHITE_STARTING_POSITIONS = [[7, 2], [7, 5]].freeze
  BLACK_STARTING_POSITIONS = [[0, 2], [0, 5]].freeze

  def to_s 
    color == 'white' ? ' ♝ '.colorize(:white) : ' ♝ '.colorize(:black)
  end
end

class Queen < Piece
  WHITE_STARTING_POSITIONS = [[7, 3]].freeze
  BLACK_STARTING_POSITIONS = [[0, 3]].freeze

  def to_s 
    color == 'white' ? ' ♛ '.colorize(:white) : ' ♛ '.colorize(:black)
  end
end

class King < Piece
  WHITE_STARTING_POSITIONS = [[7, 4]].freeze
  BLACK_STARTING_POSITIONS = [[0, 4]].freeze
  SYMBOL = ' ♚ '.freeze

  def to_s 
    color == 'white' ? ' ♚ '.colorize(:white) : ' ♚ '.colorize(:black)
  end
end
