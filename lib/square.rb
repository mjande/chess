require 'colorize'

class Square
  attr_accessor :piece
  attr_reader :row, :column

  def initialize(row, column)
    @row = row
    @column = column
    @piece = nil
  end

  def ==(other)
    row == other.row && column == other.column
  end

  def eql?(other)
    self == other && piece == other.piece
  end

  def open?
    piece.nil?
  end

  def piece_color?
    return if piece.nil?

    piece.color
  end

  def different_colored_piece?(color)
    return if piece.nil?

    color != piece.color
  end

  def clear
    @piece = nil
  end

  def color
    (row + column).even? ? 'light' : 'dark'
  end

  def to_s
    printable_piece = (piece.nil? ? '   ' : piece.to_s)
    if (row + column).even?
      printable_piece.colorize(background: :white)
    else
      printable_piece.colorize(background: :light_black)
    end
  end
end

class NoSquare
  attr_accessor :piece
  attr_reader :row, :column

  def initialize(_row, _column)
    @row = nil
    @column = nil
    @piece = nil
  end

  def open?
    nil
  end

  def different_colored_piece?(_color)
    nil
  end
end
