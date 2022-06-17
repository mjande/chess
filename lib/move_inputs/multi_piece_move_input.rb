require_relative '../library'

class MultiPieceMoveInput < MoveInput
  def initialize(string, color, board)
    @original_column = numbered_column(string[1]) if MoveInput.valid_column?(string[1])
    write_original_coordinates(string)
    clean_string = string[0] + string[-2, 2]
    super(clean_string, color, board)
    @type = 'capture' if string[2] == 'x' || string[3] == 'x'
  end

  def self.handles?(string)
    valid_piece?(string[0]) && valid_column?(string[-2]) &&
      valid_row?(string[-1]) &&
      (valid_row?(string[1]) || valid_column?(string[1]))
  end

  def write_original_coordinates(string)
    @original_row = numbered_row(string[1]) if MoveInput.valid_row?(string[1])
    @original_row = numbered_row(string[2]) if MoveInput.valid_row?(string[2])
  end

  def find_piece(piece_class, color)
    matching_pieces = super(piece_class, color)
    matching_pieces = find_piece_by_origin(matching_pieces)
    return matching_pieces if matching_pieces.length > 1

    matching_pieces[0]
  end

  def find_piece_by_origin(pieces)
    pieces.select do |matching_piece|
      if @original_column.nil?
        matching_piece.row == @original_row
      elsif @original_row.nil?
        matching_piece.column == @original_column
      else
        matching_piece.row == @original_row
        matching_piece.column == @original_column
      end
    end
  end
end