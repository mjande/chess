# frozen_string_literal: true

require 'colorize'

# The Piece class handles the factory for creating different pieces at the start
# of the game, and also contains several methods that are shared by several of
# the different pieces subclasses. Most methods deal with move validation and
# movement scripts.
class Piece
  attr_reader :row, :column, :color, :board, :possible_moves, :has_not_moved

  def initialize(row, column, color, board)
    @row = row
    @column = column
    @color = color
    @board = board
    square = board.square(row, column)
    square.piece = self
    @possible_moves = []
    @has_not_moved = true
  end

  def self.add_white_pieces_to_board(board)
    self::STARTING_COORDINATES['white'].each do |coordinates|
      piece = new(coordinates[0], coordinates[1], 'white', board)
      board.pieces.push(piece)
    end
  end

  def self.add_black_pieces_to_board(board)
    self::STARTING_COORDINATES['black'].each do |coordinates|
      piece = new(coordinates[0], coordinates[1], 'black', board)
      board.pieces.push(piece)
    end
  end

  def valid_move?(candidate)
    return if candidate.nil?

    (candidate.open? || candidate.different_colored_piece?(color)) &&
    !leads_to_check?(candidate)
  end

  def leads_to_check?(candidate)
    return if board.copy

    board_copy = board.clone
    piece_copy = board_copy.square(row, column).piece
    piece_copy.move(board_copy.square(candidate.row, candidate.column))
    king = board_copy.pieces.find do |copied_piece|
      copied_piece.instance_of?(King) && copied_piece.color == color
    end
    board_copy.update_all_possible_moves
    king.check?
  end

  def check_direction(row_shift, column_shift)
    next_row = row + row_shift
    next_column = column + column_shift
    candidate = board.square(next_row, next_column)
    until candidate.nil?
      possible_moves << [candidate.row, candidate.column] if valid_move?(candidate)
      break unless candidate.open?

      candidate = next_candidate(row_shift, column_shift, candidate)
    end
  end

  def next_candidate(row_shift, column_shift, candidate)
    board.square(candidate.row + row_shift, candidate.column + column_shift)
  end

  def knight_square_coordinates
    knight_square_coordinates = []
    diffs = [1, 2, -1, -2]

    diffs.permutation(2) do |coordinate_diff|
      next if coordinate_diff[0].abs == coordinate_diff[1].abs

      coordinate =
        [row + coordinate_diff[0], column + coordinate_diff[1]]
      knight_square_coordinates << coordinate
    end
    knight_square_coordinates.uniq
  end

  def check_diagonals
    check_direction(1, -1)
    check_direction(1, 1)
    check_direction(-1, 1)
    check_direction(-1, -1)
  end

  def check_horizontals_and_verticals
    check_direction(1, 0)
    check_direction(-1, 0)
    check_direction(0, -1)
    check_direction(0, 1)
  end

  def move(square)
    leave_previous_square
    @row = square.row
    @column = square.column
    board.moves_since_capture += 1
    capture(square) unless square.open?
    square.piece = self
  end

  def leave_previous_square
    @has_not_moved = false
    board.square(row, column).clear
  end

  private

  def capture(square)
    piece_to_be_removed = square.piece
    board.pieces.delete(piece_to_be_removed)
    board.moves_since_capture = 0
  end
end
