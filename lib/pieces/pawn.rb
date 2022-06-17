# frozen_string_literal: true

require_relative '../library'

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
    @possible_moves = Array[
      board.open?(row + direction, column),
      board.different_color?(row + direction, column - 1, color),
      board.different_color?(row + direction, column + 1, color),
      double_step,
      en_passant?(column - 1),
      en_passant?(column + 1)
    ].compact
  end

  def double_step
    return unless previous_move.nil?

    new_row = row + (direction * 2)
    [new_row, column] if board.open?(new_row, column)
  end

  def en_passant_capture(new_column)
    move(row + direction, new_column)
    capture(row - direction, new_column)
  end

  def en_passant?(new_column)
    passed_pawn = board.at_position(row, new_column)
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
