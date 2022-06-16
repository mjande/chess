require_relative '../library'

class MoveInput
  attr_reader :row, :column, :piece

  def initialize(string, color, board)
    @board = board
    @row = numbered_row(string[2])
    @column = numbered_column(string[1])
    piece_class = piece_class(string[0])
    @piece = find_piece(piece_class, color)
  end

  def self.for(string, color, board)
    [PawnMoveInput, MoveInput, InvalidMoveInput]
      .find { |candidate| candidate.handles?(string) }.new(string, color, board)
  end

  def self.handles?(string)
    string.length == 3 && valid_piece?(string[0]) && valid_column?(string[1]) &&
      valid_row?(string[2])
  end

  def self.valid_piece?(character)
    letters_array = %w[P R N Q K]
    letters_array.include?(character)
  end

  def self.valid_row?(number)
    number.to_i >= 0 && number.to_i <= 7
  end

  def self.valid_column?(letter)
    letters_array = ('a'..'h').to_a
    letters_array.include?(letter)
  end

  def numbered_row(number)
    8 - number.to_i
  end

  def numbered_column(letter)
    letters_array = ('a'..'h').to_a
    letters_array.find_index(letter)
  end

  def find_piece(piece_class, color)
    selected_piece = @board.pieces.select do |board_piece|
      board_piece.instance_of?(piece_class) &&
        board_piece.possible_moves.include?([row, column]) &&
        board_piece.color == color
    end
    return if selected_piece.length > 1

    selected_piece[0]
  end

  def piece_class(piece)
    case piece
    when 'P'
      Pawn
    when 'R'
      Rook
    when 'N'
      Knight
    when 'B'
      Bishop
    when 'Q'
      Queen
    when 'K'
      King
    end
  end
end
