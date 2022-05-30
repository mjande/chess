require 'colorize'

class Piece
  attr_reader :color

  def initialize(row, column, color, board)
    @row = row
    @column = column
    @color = color
    @board = board
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

  def valid_move?(row, column, color)
    @board.positions[row][column].nil? || different_color?(row, column, color)
  end

  def different_color?(row, column, color)
    !@board.positions[row][column].nil? && @board.positions[row][column].color != color
  end

  def move(new_row, new_column)
    @board.positions[@row][@column] = nil
    @row = new_row
    @column = new_column
    @board.positions[@row][@column] = self
  end
end

class Knight < Piece
  WHITE_STARTING_POSITIONS = [[7, 1], [7, 6]].freeze
  BLACK_STARTING_POSITIONS = [[0, 1], [0, 6]].freeze

  def to_s
    color == 'white' ? ' ♞ '.colorize(:light_white) : ' ♞ '.colorize(:black)
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
