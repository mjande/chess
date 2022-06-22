require_relative '../library'

# The PawnMoveInput class handles two-character pawn move inputs. It adds the
# leading character to indicate the class, and then sends the data up to the 
# MoveInput parent class.
class PawnMoveInput < MoveInput
  attr_reader :promotion_piece

  def initialize(string, color, board)
    clean_string = string.prepend('P')
    super(clean_string, color, board)
  end

  def self.handles?(string)
    string.length == 2 && valid_column?(string[0]) &&
      valid_row?(string[1])
  end
end

# The PawnPromotionMoveInput class handles move inputs indicating a promotion
# for a pawn. It cleans the data (just like PawnMoveInput) and saves the desired
# promotion class for later processing.
class PawnPromotionMoveInput < MoveInput
  attr_reader :promotion_piece

  def initialize(string, color, board)
    clean_string = "P#{string[0..-2]}"
    super(clean_string, color, board)
    @type = 'promotion'
    @promotion_piece = piece_class(string[-1])
  end

  def self.handles?(string)
    valid_column?(string[0]) && valid_row?(string[1]) && valid_piece?(string[2])
  end

  def move_piece
    piece.promote(self)
  end
end

# The PawnCaptureMoveInput handles move input where a pawn captures another
# piece. This cleans the data so that it can be handled by MultiPieceMoveInput,
# whose approach it most resembles.
class PawnCaptureMoveInput < MultiPieceMoveInput
  def initialize(string, color, board)
    string.prepend('P')
    super(string, color, board)
  end

  def self.handles?(string)
    string.delete!('x')
    valid_column?(string[0]) && valid_column?(string[1]) && valid_row?(string[2])
  end

  def move_piece
    if piece.en_passant?(square)
      piece.en_passant_capture(square)
    else
      super(square)
    end
  end
end
