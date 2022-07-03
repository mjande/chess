# frozen_string_literal: true

require_relative '../library'

# The InvalidMoveInput class handles move inputs that do not fit into any other
# class (ie that are not valid).
class InvalidMoveInput < MoveInput
  def initialize(_string, _color, _board)
    @piece = nil
  end

  def self.handles?(_string)
    true
  end
end

# The CastlingMoveInput class handles the unique input that describes queenside
# and kingside castling. The class turns that unique move input into data that
# can be processed by other objects in the program.
class CastlingMoveInput < MoveInput
  def initialize(string, color, board)
    @board = board
    @type = 'kingside_castling' if string == 'O-O'
    @type = 'queenside_castling' if string == 'O-O-O'
    row = (color == 'white' ? 7 : 0)
    column = (type == 'kingside_castling' ? 6 : 2)
    @square = board.square(row, column)
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

# The CheckMoveInput class handles move inputs that involve check or checkmate.
# The class mainly cleans up the input and then sends it to methods in the
# parent class.
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

# The OtherMoveInput class handles the unique move inputs that indicating saving
# or asking for a draw. Instead of cleaning up data, this class changes the type
# instance variable to signal to the game loop to end the game with one of these
# conditions.
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
