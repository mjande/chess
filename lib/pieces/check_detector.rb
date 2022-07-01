require_relative '../library'

# The CheckDetector class is used to evaluate whether a given square is in
# check.
class CheckDetector
  def self.on?(square, board, color)
    @board = board
    @square = square
    @color = color
    @king = board.pieces.find do |piece|
      piece.instance_of?(King) && piece.color == color
    end
    check_on_axials? || check_on_diagonals? || check_on_knight_squares?
  end

  def self.check_on_axials?
    @square.axial_coordinates.each_value do |direction|
      i = 0
      while i <= (direction.length - 1)
        next_coordinate = direction[i]
        next_square = @board.square(next_coordinate[0], next_coordinate[1])
        return true if axial_threat?(next_square)

        break unless next_square.open?

        i += 1
      end
    end
    false
  end

  def self.check_on_diagonals?
    @square.diagonal_coordinates.each_value do |direction|
      i = 0
      while i <= (direction.length - 1)
        next_coordinate = direction[i]
        next_square = @board.square(next_coordinate[0], next_coordinate[1])
        return true if diagonal_threat?(next_square)
        break unless next_square.open?

        i += 1
      end
    end
    false
  end

  def self.check_on_knight_squares?
    @square.knight_coordinates.any? do |coordinates|
      next_square = @board.square(coordinates[0], coordinates[1])
      knight_threat?(next_square)
    end
  end

  def self.axial_threat?(next_square)
    next_square.different_colored_piece?(@color) &&
      (next_square.piece.instance_of?(Rook) || next_square.piece.instance_of?(Queen))
  end

  def self.diagonal_threat?(next_square)
    return unless next_square.different_colored_piece?(@color)

    if next_square.piece.instance_of?(Pawn)
      next_square.row == row + 1
    else
      next_square.piece.instance_of?(Bishop) ||
        next_square.piece.instance_of?(Queen)
    end
  end

  def self.knight_threat?(next_square)
    next_square.different_colored_piece?(@color) &&
      next_square.piece.instance_of?(Knight)
  end
end
