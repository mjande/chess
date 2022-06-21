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
    @possible_moves = check_adjacent_squares
    possible_moves << kingside_castling?
    possible_moves << queenside_castling?
    @possible_moves.compact!
  end

  def adjacent_squares
    adjacent_squares = []
    diffs = [0, -1, -1, 1, 1]

    diffs.permutation do |coordinate_diff|
      coordinate = [row + coordinate_diff[0], column + coordinate_diff[1]]
      adjacent_squares << coordinate
    end
    adjacent_squares.uniq
  end

  def check_adjacent_squares
    adjacent_squares.select do |square|
      valid_move?(square[0], square[1])
    end
  end

  def check?(check_row = row, check_column = column)
    opposing_pieces = board.pieces.reject { |piece| piece.color == color }

    opposing_pieces.any? do |piece|
      piece.possible_moves.include?([check_row, check_column])
    end
  end

  def checkmate?
    possible_moves.empty? && check?
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
    board.open?(row, 5) && board.open?(row, 6)
  end

  def all_queenside_positions_are_open?
    board.open?(row, 3) && board.open?(row, 2) && board.open?(row, 1)
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
