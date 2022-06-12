require 'colorize'

class Piece
  attr_reader :row, :column, :color, :board, :possible_moves, :previous_moves

  def initialize(row, column, color, board)
    @row = row
    @column = column
    @color = color
    @board = board
    @previous_moves = [[row, column]]
    board.positions[row][column] = self
    @possible_moves = []
  end

  def self.add_to_board(board, player)
    case player.color
    when 'white'
      starting_positions = self::WHITE_STARTING_POSITIONS
    when 'black'
      starting_positions = self::BLACK_STARTING_POSITIONS
    end

    starting_positions.each do |position|
      row = position[0]
      column = position[1]
      piece = new(row, column, player.color, board)
      player.pieces.push(piece)
      board.pieces.push(piece)
    end
  end

  def valid_move?(row, column, color)
    if on_the_board?(row, column) &&
       (empty_position?(row, column) || different_color?(row, column, color))
      [row, column]
    end
  end

  def empty_position?(row, column)
    [row, column] if @board.positions[row][column].nil?
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
    capture(row, column) unless board.positions[row][column].nil?
    @board.positions[@row][@column] = self
    @previous_moves << [@row, @column]
  end

  def undo_move
    @board.positions[@row][@column] = nil
    @row = @previous_moves[-1][0]
    @column = @previous_moves[-1][1]
    @board.positions[@row][@column] = self
    @previous_moves.pop
  end

  private

  def capture(new_row, new_column)
    piece_to_be_removed = board.positions[new_row][new_column]
    board.pieces.delete(piece_to_be_removed)
  end
end
