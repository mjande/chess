# frozen_string_literal: true

require 'colorize'

# The Piece class handles the factory for creating different pieces at the start
# of the game, and also contains several methods that are shared by several of
# the different pieces subclasses. Most methods deal with move validation and
# movement scripts.
class Piece
  attr_reader :row, :column, :color, :board, :possible_moves, :previous_move

  def initialize(row, column, color, board)
    @row = row
    @column = column
    @color = color
    @board = board
    board.add_to_position(row, column, self)
    @possible_moves = []
    @previous_move = nil
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

  def valid_move?(possible_row, possible_column)
    if board.on_the_board?(possible_row, possible_column) &&
       (board.open?(possible_row, possible_column) ||
       board.different_color?(possible_row, possible_column, color)) &&
       leads_to_check?(possible_row, possible_column)
      [row, column]
    end
  end

  def leads_to_check?(possible_row, possible_column)
    board_copy = board.clone
    piece_copy = board_copy.at_position(row, column)
    piece_copy.move(possible_row, possible_column)
    king = board_copy.pieces.find do |copied_piece|
      copied_piece.instance_of?(King) && copied_piece.color == color
    end
    king.check?
  end

  def check_direction(row_shift, column_shift)
    moves = []
    next_row = row + row_shift
    next_column = column + column_shift
    while next_row.between?(0, 7) && next_column.between?(0, 7)
      moves << valid_move?(next_row, next_column)
      break unless board.open?(next_row, next_column)

      next_row += row_shift
      next_column += column_shift
    end
    moves.compact
  end

  def check_diagonals
    check_direction(1, -1).each { |position| possible_moves << position }
    check_direction(1, 1).each { |position| possible_moves << position }
    check_direction(-1, 1).each { |position| possible_moves << position }
    check_direction(-1, -1).each { |position| possible_moves << position }
  end

  def check_horizontals_and_verticals
    check_direction(1, 0).each { |position| possible_moves << position }
    check_direction(-1, 0).each { |position| possible_moves << position }
    check_direction(0, -1).each { |position| possible_moves << position }
    check_direction(0, 1).each { |position| possible_moves << position }
  end

  def move(new_row, new_column)
    leave_previous_square
    @row = new_row
    @column = new_column
    board.moves_since_capture += 1
    capture(row, column) unless board.open?(row, column)
    board.add_to_position(row, column, self)
  end

  def leave_previous_square
    @previous_move = [row, column]
    board.clear_position(row, column)
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
    board.moves_since_capture = 0
  end
end
