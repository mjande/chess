# frozen_string_literal: true

require 'colorize'

# The Piece class handles the factory for creating different pieces at the start
# of the game, and also contains several methods that are shared by several of
# the different pieces subclasses. Most methods deal with move validation and
# movement scripts.
class Piece
  attr_reader :row, :column, :color, :board, :possible_moves, :moved

  def initialize(square, color, board)
    @color = color
    @current_square = square
    @board = board
    square.piece = self
    @possible_moves = []
    @has_not_moved = true
  end

  def self.add_white_pieces_to_board(board)
    self::STARTING_SQUARES['white'].each do |square|
      piece = new(square, 'white', board)
      board.pieces.push(piece)
    end
  end

  def self.add_black_pieces_to_board(board)
    self::STARTING_SQUARES['black'].each do |square|
      piece = new(square, 'black', board)
      board.pieces.push(piece)
    end
  end

  def valid_move?(candidate)
    return if candidate.nil?

    (candidate.open? || candidate.different_colored_piece?(color)) &&
      !leads_to_check?(candidate)
  end

  def leads_to_check?(candidate)
    board_copy = board.clone
    piece_copy = board_copy.square(row, column).piece
    piece_copy.move(candidate)
    king = board_copy.pieces.find do |copied_piece|
      copied_piece.instance_of?(King) && copied_piece.color == color
    end
    king.check?
  end

  def check_direction(row_shift, column_shift)
    candidate = next_candidate(row_shift, column_shift)
    until candidate.nil?
      possible_moves << candidate if valid_move?(candidate)
      break unless candidate.open?

      candidate = next_candidate(row_shift, column_shift, candidate)
    end
  end

  def next_candidate(row_shift, column_shift, candidate = nil)
    return board.square(row + row_shift, column + column_shift) if candidate.nil?

    board.square(candidate.row + row_shift, candidate.column + column_shift)
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
    @current_square = square
    board.moves_since_capture += 1
    capture(square) unless square.open?
    square.piece = self
  end

  def leave_previous_square
    @has_not_moved = false
    current_square.clear
  end

  private

  def capture(square)
    piece_to_be_removed = square.piece
    board.pieces.delete(piece_to_be_removed)
    board.moves_since_capture = 0
  end
end
