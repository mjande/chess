require_relative '../library'

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

class PawnCaptureMoveInput < MultiPieceMoveInput
  def initialize(string, color, board)
    string.prepend('P')
    super(string, color, board)
    # @type = 'en_passant' if en_passant_move?
  end

  def self.handles?(string)
    string.delete!('x')
    valid_column?(string[0]) && valid_column?(string[1]) && valid_row?(string[2])
  end

  def move_piece
    if en_passant_move?
      piece.en_passant_capture(column)
    else
      super(row, column)
    end
  end

  def en_passant_move?
    row = string[1]
    column = string[0]
    direction = (color == 'white' ? -1 : 1)

    passed_pawn = board.square(row, column).piece
    passed_pawn.instance_of?(Pawn) && passed_pawn.color != color &&
      passed_pawn.previous_move == [row + (direction * 2), new_column]
  end
end
