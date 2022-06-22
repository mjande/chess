# frozen_string_literal: true

require_relative '../library'

# The Pawn class handles starting squares and possible moves of all pawns,
# including checking for en-passant capture and handling a promotion move
class Pawn < Piece
  attr_reader :direction

  STARTING_SQUARES = { 'white' => [board.square(6, 0), board.square(6, 1),
                                   board.square(6, 2), board.square(6, 3),
                                   board.square(6, 4), board.square(6, 5),
                                   board.square(6, 6), board.square(6, 7)],
                       'black' => [board.square(1, 0), board.square(1, 1),
                                   board.square(1, 2), board.square(1, 3),
                                   board.square(1, 4), board.square(1, 5),
                                   board.square(1, 6), board.square(1, 7)] }.freeze

  def initialize(square, color, board)
    super
    @direction = (color == 'white' ? -1 : 1)
  end

  def to_s
    color == 'white' ? ' ♟ '.colorize(:light_white) : ' ♟ '.colorize(:black)
  end

  def update_possible_moves
    check_ahead
    check_up_left
    check_up_right
    check_en_passant_left
    check_en_passant_right
  end

  def check_ahead
    candidate = board.square(current_square.row + current_square.direction, column)
    return unless candidate.open?

    possible_moves << candidate
    check_double_step
  end

  def check_double_step
    new_row = row + (direction * 2)
    candidate = board.square(new_row, column)
    return unless has_not_moved && candidate.open?

    possible_moves << candidate
  end

  def check_up_left
    new_row = current_square.row + direction
    new_column = current_square.column - 1
    candidate = board.square(new_row, new_column)
    return unless candidate.different_colored_piece?(color)

    possible_moves << candidate
  end

  def check_up_right
    new_row = current_square.row + direction
    new_column = current_square.column + 1
    candidate = board.square(new_row, new_column)
    return unless candidate.different_colored_piece?(color)

    possible_moves << candidate
  end

  def check_en_passant_left
    en_passant_left = board.square(current_square.row, current_square.column - 1)
    possible_moves << en_passant_left if en_passant?(en_passant_left)
  end

  def check_en_passant_right
    en_passant_right = board.square(current_square.row, current_square.column + 1)
    possible_moves << en_passant_right if en_passant?(en_passant_right)
  end

  def en_passant?(destination)
    passed_pawn = board.square(current_square.row, destination.column).piece

    passed_pawn.instance_of?(Pawn) && passed_pawn.color != color &&
      passed_pawn.has_not_moved
  end

  def en_passant_capture(destination)
    move(destination)
    capture(current_square.row - direction, destination.column)
  end

  def promote(input)
    destination = board.square(input.row, input.column)
    move(destination)
    new_piece = input.promotion_piece.new(destination, color, board)
    board.pieces.push(new_piece)
    board.pieces.delete(self)
  end
end
