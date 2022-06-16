# frozen_string_literal: true

require_relative '../library'

# King class handles starting positions and possible moves of both player's
# kings, and possesses special methods for king-specific checks (ex. check?,
# checkmate?, and making sure king cannot move into check)
class King < Piece
  STARTING_POSITIONS = { 'white' => [[7, 4]], 'black' => [[0, 4]] }.freeze

  def to_s
    color == 'white' ? ' ♚ '.colorize(:light_white) : ' ♚ '.colorize(:black)
  end

  def update_possible_moves
    @possible_moves = Array[
      valid_move?(@row - 1, @column, color),
      valid_move?(@row - 1, @column + 1, color),
      valid_move?(@row, @column + 1, color),
      valid_move?(@row + 1, @column + 1, color),
      valid_move?(@row + 1, @column, color),
      valid_move?(@row + 1, @column - 1, color),
      valid_move?(@row, @column - 1, color),
      valid_move?(@row - 1, @column - 1, color),
      kingside_castling?,
      queenside_castling?
    ].compact
  end

  def check?(check_row = row, check_column = column)
    opposing_pieces = board.pieces.reject { |piece| piece.color == color }

    opposing_pieces.any? do |piece|
      piece.possible_moves.include?([check_row, check_column])
    end
  end

  def checkmate?
    return false if possible_moves.empty?

    check? &&
      possible_moves.all? do |position|
        check?(position[0], position[1])
      end
  end

  def kingside_castle_move
    move(@row, 6)
    rook = board.at_position(row, 7)
    rook.move(@row, 5)
  end

  def queenside_castle_move
    move(@row, 2)
    rook = board.at_position(row, 0)
    rook.move(@row, 3)
  end

  private

  def valid_move?(row, column, color)
    if on_the_board?(row, column) &&
       (board.open?(row, column) || board.different_color?(row, column, color)) &&
       !check?(row, column)
      [row, column]
    end
  end

  def kingside_castling?
    rook = board.at_position(row, 7)
    return unless rook.instance_of?(Rook) && rook.color == color &&
                  king_and_hrook_have_not_moved?(rook) &&
                  all_kingside_positions_are_open? &&
                  no_kingside_positions_are_in_check?

    [row, 6]
  end

  def king_and_hrook_have_not_moved?(rook)
    previous_move.nil? && rook.previous_move.nil?
  end

  def king_and_arook_have_not_moved?(rook)
    previous_move.nil? && rook.previous_move.nil?
  end

  def all_kingside_positions_are_open?
    empty_position?(row, 5) && empty_position?(row, 6)
  end

  def all_queenside_positions_are_open?
    empty_position?(row, 3) && empty_position?(row, 2) && empty_position?(row, 1)
  end

  def no_kingside_positions_are_in_check?
    !(check? && check?(row, 5) && check?(row, 6))
  end

  def no_queenside_positions_are_in_check?
    !(check? && check?(row, 3) && check?(row, 2))
  end

  def queenside_castling?
    rook = board.at_position(row, 0)
    return unless rook.instance_of?(Rook) && rook.color == color &&
                  king_and_arook_have_not_moved?(rook) &&
                  all_queenside_positions_are_open? &&
                  no_queenside_positions_are_in_check?

    [row, 2]
  end
end
