require_relative '../library'

class InvalidMoveInput < MoveInput
  def initialize(_string, _color, _board)
    @piece = nil
  end

  def self.handles?(_string)
    true
  end
end

class CastlingMoveInput < MoveInput
  def initialize(string, color, board)
    @board = board
    @row = (color == 'white' ? 7 : 0)
    @type = 'kingside_castling' if string == 'O-O'
    @type = 'queenside_castling' if string == 'O-O-O'
    @piece = find_piece(King, color)
  end

  def self.handles?(string)
    castling_inputs = ['O-O', 'O-O-O']
    castling_inputs.include?(string)
  end

  def move_piece
    piece.kingside_castle_move if type == 'kingside_castling'
    piece.queenside_castle_move if type == 'queenside_castling'
  end
end

class CheckMoveInput < MoveInput
  def initialize(string, color, board)
    clean_string = string
    clean_string = string.prepend('P') unless MoveInput.valid_piece?(string[0])
    super(clean_string, color, board)
  end

  def self.handles?(string)
    string[-1] == '+' &&
      ((valid_piece?(string[0]) && valid_column?(string[1])) &&
        valid_row?(string[2]) ||
    (valid_column?(string[0]) && valid_row?(string[1])))
  end
end

class OtherMoveInput < MoveInput
  def initialize(string, _color, _board)
    @type = 'draw' if string == '='
    @type = 'save' if string == 'save'
    @piece = 'other'
  end

  def self.handles?(string)
    other_inputs = ['=', 'save']
    other_inputs.include?(string.downcase)
  end

  def move_piece
    nil
  end
end
