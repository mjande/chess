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
    if on_the_board?(row, column) &&
       (@board.positions[row][column].nil? || different_color?(row, column, color))
      [row, column]
    end
  end

  def different_color?(row, column, color)
    return nil if @board.positions[row][column].nil?

    [row, column] if @board.positions[row][column].color != color
  end

  def on_the_board?(row, column)
    row >= 0 && row <= 7 && column >= 0 && column <= 7
  end

  def check_direction(row_shift, column_shift)
    moves = []
    next_row = @row + row_shift
    next_column = @column + column_shift
    while next_row.between?(0, 7) && next_column.between?(0, 7)
      moves << valid_move?(next_row, next_column, color)
      break unless @board.positions[next_row][next_column].nil?

      next_row += row_shift
      next_column += column_shift
    end
    moves.compact
  end

  def move(new_row, new_column)
    @board.positions[@row][@column] = nil
    @row = new_row
    @column = new_column
    @board.positions[@row][@column] = self
  end
end
