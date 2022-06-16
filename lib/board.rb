require 'colorize'

class Board
  attr_reader :data_array, :pieces

  def initialize
    @data_array = Array.new(8) { Array.new(8, nil) }
    @pieces = []
  end

  def add_starting_pieces
    piece_types = [Rook, Knight, Bishop, Queen, King, Pawn]
    piece_types.each do |piece_type|
      piece_type.add_white_pieces_to_board(self)
      piece_type.add_black_pieces_to_board(self)
    end
  end

  def update_all_possible_moves
    pieces.each(&:update_possible_moves)
  end

  def open?(row, column)
    data_array[row][column].nil?
  end

  def different_color?(row, column, color)
    piece = data_array[row][column]
    piece.color != color
  end

  def at_position(row, column)
    data_array[row][column]
  end

  def clear_position(row, column)
    data_array[row][column] = nil
  end

  def add_to_position(row, column, piece)
    data_array[row][column] = piece
  end

  def add_background_color(array)
    array.map.with_index do |row, row_index|
      row.map.with_index do |position, column_index|
        if row_index.even?
          if column_index.even?
            position.to_s.colorize(background: :white)
          else
            position.to_s.colorize(background: :light_black)
          end
        elsif row_index.odd?
          if column_index.even?
            position.to_s.colorize(background: :light_black)
          else
            position.to_s.colorize(background: :white)
          end
        end
      end
    end
  end

  def display
    column_labels = '   a  b  c  d  e  f  g  h   '

    printable_board = clean_rows

    puts printable_board
    puts column_labels
  end

  def clean_rows
    clean_rows = data_array.map do |row|
      row.map { |position| position.nil? ? '   ' : position }
    end

    clean_rows = add_background_color(clean_rows)

    row_number = 8
    clean_rows.each do |row|
      row.unshift("#{row_number} ")
      row.push("\n")
      row_number -= 1
    end

    clean_rows.join
  end
end