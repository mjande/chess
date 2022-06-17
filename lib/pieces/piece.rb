require 'colorize'

class Piece
  attr_reader :row, :column, :color, :board, :possible_moves, :previous_move

  def initialize(row, column, color, board)
    @row = row
    @column = column
    @color = color
    @board = board
    board.add_to_position(row, column, self)
    @possible_moves = []
  end

  def self.add_white_pieces_to_board(board)
    self::STARTING_POSITIONS['white'].each do |position|
      row = position[0]
      column = position[1]
      piece = new(row, column, 'white', board)
      board.pieces.push(piece)
    end
  end

  def self.add_black_pieces_to_board(board)
    self::STARTING_POSITIONS['black'].each do |position|
      row = position[0]
      column = position[1]
      piece = new(row, column, 'black', board)
      board.pieces.push(piece)
    end
  end

  def valid_move?(row, column, color)
    if board.on_the_board?(row, column) &&
       (board.open?(row, column) || board.different_color?(row, column, color))
      [row, column]
    end
  end

  def check_direction(row_shift, column_shift)
    moves = []
    next_row = row + row_shift
    next_column = column + column_shift
    while next_row.between?(0, 7) && next_column.between?(0, 7)
      moves << valid_move?(next_row, next_column, color)
      break unless board.open?(next_row, next_column)

      next_row += row_shift
      next_column += column_shift
    end
    moves.compact
  end

  def move(new_row, new_column)
    @previous_move = [@row, @column]
    board.clear_position(row, column)
    @row = new_row
    @column = new_column
    capture(row, column) unless board.open?(row, column)
    board.add_to_position(row, column, self)
  end

  def undo_move
    @board.clear_position(row, column)
    @row = @previous_move[0]
    @column = @previous_move[1]
    board.add_to_position(row, column, self)
  end

  private

  def capture(new_row, new_column)
    piece_to_be_removed = board.at_position(new_row, new_column)
    board.pieces.delete(piece_to_be_removed)
    board.clear_position(new_row, new_column)
  end
end
