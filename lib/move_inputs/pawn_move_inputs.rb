require_relative '../library'

class PawnMoveInput < MoveInput
  def initialize(string, color, board)
    clean_string = string.prepend('P')
    super(clean_string, color, board)
  end

  def self.handles?(string)
    string.length == 2 && valid_column?(string[0]) &&
      valid_row?(string[1])
  end
end

class PawnPromotionMoveInput < MoveInput
  def initialize(string, color, board)
    clean_string = "P#{string[0..-2]}"
    super(clean_string, color, board)
    @type = 'promotion'
    @promotion_piece = piece_class(string[-1])
  end

  def self.handles?(string)
    valid_column?(string[0]) && valid_row?(string[1]) && valid_piece?(string[2])
  end
end

class PawnCaptureMoveInput < MultiPieceMoveInput
  def initialize(string, color, board)
    string.prepend('P')
    super(string, color, board)
  end

  def self.handles?(string)
    string.delete!('x')
    valid_column?(string[0]) && valid_column?(string[1]) && valid_row?(string[2])
  end
end