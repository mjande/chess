require 'colorize'

class Piece
  attr_reader :color

  def initialize(row, column, color, board)
    @row = row
    @column = column
    @color = color
    board.positions[row][column] = self
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
      piece = new(row, column, color, board)
      piece_set << piece
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
    check_down(board).each { |position| possible_moves_array << position }
    check_left(board).each { |position| possible_moves_array << position }
    possible_moves_array
  end

  private

  def check_up(board)
    moves_up = []
    next_row = @row - 1
    while next_row >= 0
      if board.positions[next_row][@column].nil? || board.positions[next_row][@column].color != color
        moves_up << [next_row, @column]
      end
      break unless board.positions[next_row][@column].nil?

      next_row -= 1
    end
    moves_up
  end

  def check_right(board)
    moves_right = []
    next_column = @column + 1
    while next_column <= 7
      if board.positions[@row][next_column].nil? || board.positions[@row][next_column].color != color
        moves_right << [@row, next_column]
      end
      break unless board.positions[@row][next_column].nil?

      next_column += 1
    end
    moves_right
  end

  def check_down(board)
    moves_down = []
    next_row = @row + 1
    while next_row <= 7
      if board.positions[next_row][@column].nil? || board.positions[next_row][@column].color != color
        moves_down << [next_row, @column]
      end
      break unless board.positions[next_row][@column].nil?

      next_row += 1
    end
    moves_down
  end

  def check_left(board)
    moves_left = []
    next_column = @column - 1
    while next_column >= 0
      if board.positions[@row][next_column].nil? || board.positions[@row][next_column].color != color
        moves_left << [@row, next_column]
      end
      break unless board.positions[@row][next_column].nil?

      next_column -= 1
    end
    moves_left
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
