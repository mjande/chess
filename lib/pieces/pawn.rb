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
      empty_position?(row + direction, column),
      different_color?(row + direction, column - 1, color),
      different_color?(row + direction, column + 1, color),
      double_step,
      en_passant?(column - 1),
      en_passant?(column + 1)
    ].compact
  end

  def double_step
    return unless previous_move.nil?

    [row + (direction * 2), column]
  end

  def en_passant_capture(new_column)
    move(row + direction, new_column)
    capture(row + (direction * 2), new_column)
  end

  private

  def en_passant?(new_column)
    passed_pawn = board.at_position(row, new_column)
    return unless passed_pawn.instance_of?(Pawn) && passed_pawn.color != color &&
                  passed_pawn.previous_move == [row + (direction * 2), new_column]

    [row + direction, new_column]
  end
end
