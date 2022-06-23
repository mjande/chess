# frozen_string_literal: true

require_relative '../library'

# King class handles starting squares and possible moves of both player's
# kings, and possesses special methods for king-specific checks (ex. check?,
# checkmate?, and making sure king cannot move into check)
class King < Piece
  STARTING_COORDINATES = { 'white' => [[7, 4]], 'black' => [[0, 4]] }.freeze

  def to_s
    color == 'white' ? ' ♚ '.colorize(:light_white) : ' ♚ '.colorize(:black)
  end

  def update_possible_moves
    check_adjacent_squares
    possible_moves << [row, 6] if castling?('kingside')
    possible_moves << [row, 2] if castling?('queenside')
  end

  def adjacent_squares_coordinates
    adjacent_square_coordinates = []
    diffs = [0, -1, -1, 1, 1]

    diffs.permutation do |coordinate_diff|
      coordinate =
        [row + coordinate_diff[0], column + coordinate_diff[1]]
      adjacent_square_coordinates << coordinate
    end
    adjacent_square_coordinates.uniq
  end

  def check_adjacent_squares
    valid_coordinates =
      adjacent_squares_coordinates.select do |square_coordinates|
        square = board.square(square_coordinates[0], square_coordinates[1])
        valid_move?(square)
      end
    valid_coordinates.each { |coordinates| possible_moves << coordinates }
  end

  def check?(square = board.square(row, column))
    opposing_pieces = board.pieces.reject { |piece| piece.color == color }

    opposing_pieces.any? do |piece|
      piece.possible_moves.include?([square.row, square.column])
    end
  end

  def checkmate?
    possible_moves.empty? && check?
  end

  def kingside_castle_move
    king_destination = board.square(row, 6)
    move(king_destination)
    rook = board.square(row, 7).piece
    rook_destination = board.square(row, 5)
    rook.move(rook_destination)
  end

  def queenside_castle_move
    king_destination = board.square(row, 2)
    move(king_destination)
    rook = board.square(row, 0).piece
    rook_destination = board.square(row, 3)
    rook.move(rook_destination)
  end

  private

  def rook(side)
    rook =
      if side == 'kingside'
        board.square(row, 7).piece
      else
        board.square(row, 0).piece
      end
    return unless rook.instance_of?(Rook) && rook.color == color

    rook
  end

  def assign_side_squares(side)
    if side == 'kingside'
      [board.square(row, 5), board.square(row, 6)]
    else
      [board.square(row, 3), board.square(row, 2),
       board.square(row, 1)]
    end
  end

  def castling?(side)
    side_squares = assign_side_squares(side)
    side_rook = rook(side)

    !(side_rook.nil? && check?) &&
      pieces_have_not_moved?(side_rook) &&
      side_squares.all?(&:open?) &&
      side_squares.none? { |square| check?(square) }
  end

  def pieces_have_not_moved?(rook)
    has_not_moved && rook.has_not_moved
  end

=begin
  def kingside_castling?
    kingside_squares = [board.square(row, 5), board.square(row, 6)]
    !rook.nil? && king_and_hrook_have_not_moved?(rook) &&
      squares_are_open_and_not_in_check?(kingside_squares)
  end

  def queenside_castling?
    queenside_squares = [board.square(row, 3), board.square(row, 2),
                         board.square(row, 1)]
    !rook.nil? &&
      king_and_arook_have_not_moved?(rook) &&
      all_squares_are_open?(queenside_squares) &&
      no_squares_are_in_check?(queenside_squares)
  end

  def king_and_hrook_have_not_moved?(rook)
    previous_move.nil? && rook.previous_move.nil?
  end

  def king_and_arook_have_not_moved?(rook)
    previous_move.nil? && rook.previous_move.nil?
  end

  def squares_are_open_and_not_in_check?(squares)
    squares.all?(&:open?) &&
      !check? &&
      squares.none? { |square| check?(square) }
  end

  def all_squares_are_open?(squares)
    squares.all?(&:open?)
  end

  def all_queenside_squares_are_open?
    queenside_squares = [board.square(row, 3), board.square(row, 2),
                         board.square(row, 1)]
    queenside_squares.all?(&:open?)
  end

  def no_squares_are_in_check?(squares)
    !check? && squares.none? { |square| check?(square) }
  end

  def no_queenside_squares_are_in_check?
    !(check? && check?(row, 3) && check?(row, 2))
  end

=end
end
