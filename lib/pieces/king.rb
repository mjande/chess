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

  def old_check?(square = board.square(row, column))
    opposing_pieces = board.pieces.reject { |piece| piece.color == color }

    opposing_pieces.any? do |piece|
      piece.possible_moves.include?([square.row, square.column])
    end
  end

  def check?(square = board.square(row, column))
    check_on_axials?(square) ||
      check_on_diagonals?(square) ||
      check_on_knight_squares?(square)
  end

  # Current issue: this correctly iterates over several different positions, but
  # it doesn't stop when it hits a blocking pieces. An idea to fix this is to
  # create a hash in the used square methods that corresponds to order by
  # direction (ex. each square to the right, starting with the immediate right
  # square and continuing rightward). This change could allow it to proceed in
  # order until it needs to stop. Another idea could be to build that stopping
  # logic into the the hash in square. See further notes there.
  def check_on_axials?(square)
    square.axial_coordinates.each_value do |direction|
      i = 0
      while i <= (direction.length - 1)
        next_coordinate = direction[i]
        next_square = board.square(next_coordinate[0], next_coordinate[1])
        return true if axial_threat?(next_square)

        break unless next_square.open?

        i += 1
      end
    end
    false
  end

  def check_on_diagonals?(square)
    square.diagonal_coordinates.each_value do |direction|
      i = 0
      while i <= (direction.length - 1)
        next_coordinate = direction[i]
        next_square = board.square(next_coordinate[0], next_coordinate[1])
        return true if diagonal_threat?(next_square)
        break unless next_square.open?

        i += 1
      end
    end
    false
  end

  def check_on_knight_squares?(square)
    square.knight_coordinates.any? do |coordinates|
      next_square = board.square(coordinates[0], coordinates[1])
      knight_threat?(next_square)
    end
  end

  def axial_threat?(square)
    square.different_colored_piece?(color) &&
      (square.piece.instance_of?(Rook) || square.piece.instance_of?(Queen))
  end

  def diagonal_threat?(square)
    return unless square.different_colored_piece?(color)

    if square.piece.instance_of?(Pawn)
      square.row == row + 1
    else
      square.piece.instance_of?(Bishop) || square.piece.instance_of?(Queen)
    end
  end

  def knight_threat?(square)
    square.different_colored_piece?(color) && square.piece.instance_of?(Knight)
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

    !(side_rook.nil? || check?) &&
      pieces_have_not_moved?(side_rook) &&
      side_squares.all?(&:open?) &&
      side_squares.none? { |square| check?(square) }
  end

  def pieces_have_not_moved?(rook)
    has_not_moved && rook.has_not_moved
  end
end
