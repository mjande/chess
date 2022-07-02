# frozen_string_literal: true

require 'colorize'

# The Square class stores data about each individual square on the board, and
# includes methods for checking the validity of those squares for movement.
class Square
  attr_accessor :piece
  attr_reader :row, :column

  def initialize(row, column)
    @row = row
    @column = column
    @piece = nil
  end

  def open?
    piece.nil?
  end

  def piece_color
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

  def axial_coordinates
    {
      up: coordinates_in_direction(-1, 0),
      down: coordinates_in_direction(1, 0),
      left: coordinates_in_direction(0, -1),
      right: coordinates_in_direction(0, 1)
    }
  end

  def diagonal_coordinates
    {
      up_right: coordinates_in_direction(-1, 1),
      up_left: coordinates_in_direction(-1, -1),
      down_left: coordinates_in_direction(1, -1),
      down_right: coordinates_in_direction(1, 1)
    }
  end

  def adjacent_coordinates
    coordinates = []
    adjacent_shifts = [1, 1, -1, -1, 0]
    adjacent_shifts.permutation(2) do |adjacent_shift|
      next_row = row + adjacent_shift[0]
      next_column = column + adjacent_shift[1]
      coordinates << [next_row, next_column]
    end
    coordinates.uniq
  end

  def knight_coordinates
    knight_square_coordinates = []
    diffs = [1, 2, -1, -2]

    diffs.permutation(2) do |coordinate_diff|
      next unless valid_knight_square?(coordinate_diff)

      coordinate =
        [row + coordinate_diff[0], column + coordinate_diff[1]]
      knight_square_coordinates << coordinate
    end
    knight_square_coordinates.uniq
  end

  def to_s
    printable_piece = (piece.nil? ? '   ' : piece.to_s)
    if (row + column).even?
      printable_piece.colorize(background: :white)
    else
      printable_piece.colorize(background: :light_black)
    end
  end

  private

  def coordinates_in_direction(row_shift, column_shift)
    coordinates = []
    next_row = row + row_shift
    next_column = column + column_shift
    while next_row.between?(0, 7) && next_column.between?(0, 7)
      coordinates << [next_row, next_column]
      next_row += row_shift
      next_column += column_shift
    end
    coordinates
  end

  def valid_knight_square?(coordinate_diff)
    return if coordinate_diff[0].abs == coordinate_diff[1].abs

    next_row = row + coordinate_diff[0]
    next_column = column + coordinate_diff[1]
    next_row.between?(0, 7) && next_column.between?(0, 7)
  end
end

# The NoSquare class is a Null Object, which responds to similar method calls as
# the Square class.
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

  def adjacent_coordinates
    []
  end

  def axial_coordinates
    {}
  end

  def diagonal_coordinates
    {}
  end

  def knight_coordinates
    []
  end
end
