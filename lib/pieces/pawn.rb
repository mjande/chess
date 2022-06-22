# frozen_string_literal: true

require_relative '../library'

# The Pawn class handles starting positions and possible moves of all pawns,
# including checking for en-passant capture and handling a promotion move
class Pawn < Piece
  attr_reader :direction

  STARTING_POSITIONS = { 'white' => [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4],
                                     [6, 5], [6, 6], [6, 7]],
                         'black' => [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4],
                                     [1, 5], [1, 6], [1, 7]] }.freeze

  def initialize(row, column, color, board)
    super
    @direction = (color == 'white' ? -1 : 1)
  end

  def to_s
    color == 'white' ? ' ♟ '.colorize(:light_white) : ' ♟ '.colorize(:black)
  end

  def update_possible_moves
    @possible_moves = []
    check_ahead
    check_up_left
    check_up_right
    check_en_passant
    possible_moves.compact!
  end

  def check_ahead
    return unless board.square(row + direction, column).open?

    possible_moves << [row + direction, column]
    check_double_step
  end

  def check_double_step
    new_row = row + (direction * 2)
    return unless previous_move.nil? && board.square(new_row, column).open?

    possible_moves << [new_row, column]
  end

  def check_up_left
    new_row = row + direction
    new_column = column - 1
    possible_square = board.square(new_row, new_column)
    return unless possible_square.different_colored_piece?(color)

    possible_moves << [new_row, new_column]
  end

  def check_up_right
    new_row = row + direction
    new_column = column + 1
    possible_square = board.square(new_row, new_column)
    return unless possible_square.different_colored_piece?(color)

    possible_moves << [new_row, new_column]
  end

  def check_en_passant
    possible_moves << en_passant?(column - 1)
    possible_moves << en_passant?(column + 1)
  end

  def en_passant_capture(new_column)
    move(row + direction, new_column)
    capture(row - direction, new_column)
  end

  def en_passant?(new_column)
    passed_pawn = board.square(row, new_column).piece
    return unless passed_pawn.instance_of?(Pawn) && passed_pawn.color != color &&
                  passed_pawn.previous_move == [row + (direction * 2), new_column]

    [row + direction, new_column]
  end

  def promote(input)
    move(input.row, input.column)
    new_piece = input.promotion_piece.new(row, column, color, board)
    board.pieces.push(new_piece)
    board.pieces.delete(self)
  end
end
