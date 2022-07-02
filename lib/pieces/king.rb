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

  def check_adjacent_squares
    current_square = board.square(row, column)
    valid_coordinates =
      current_square.adjacent_coordinates.select do |square_coordinates|
        square = board.square(square_coordinates[0], square_coordinates[1])
        valid_move?(square)
      end
    valid_coordinates.each { |coordinates| possible_moves << coordinates }
  end

  def checkmate?
    current_square = board.square(row, column)
    possible_moves.empty? && CheckDetector.for?(current_square, board, color)
  end

  # These special move methods are used instead of the normal piece.move method
  # whenever castling occurs.
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

    !(side_rook.nil? ||
      CheckDetector.for?(board.square(row, column), board, color)) &&
      pieces_have_not_moved?(side_rook) &&
      side_squares_available(side_squares)
  end

  def side_squares_available(squares)
    squares.all?(&:open?) &&
      squares.none? { |square| CheckDetector.for?(square, board, color) }
  end

  def pieces_have_not_moved?(rook)
    has_not_moved && rook.has_not_moved
  end
end
