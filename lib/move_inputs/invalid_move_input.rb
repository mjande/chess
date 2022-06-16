require_relative '../library'

class InvalidMoveInput < MoveInput
  def initialize(_string, _color, _board)
    @piece = nil
  end

  def self.handles?(_string)
    true
  end
end

class PawnMoveInput < MoveInput
  def initialize(string, color, board)
    @board = board
    @row = numbered_row(string[1])
    @column = numbered_column(string[0])
    @piece = find_piece(Pawn, color)
  end

  def self.handles?(string)
    string.length == 2 && valid_column?(string[0]) &&
      valid_row?(string[1])
  end
end
