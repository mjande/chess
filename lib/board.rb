require 'colorize'

class Board
  attr_reader :positions, :white_pieces, :black_pieces

  def initialize
    @positions = Array.new(8) { Array.new(8, nil) }
  end

  def add_starting_pieces(color)
    pieces = [
      if color == 'white'
        WhitePawn.add_to_board(color, self)
      else
        BlackPawn.add_to_board(color, self)
      end,
      Rook.add_to_board(color, self),
      Knight.add_to_board(color, self),
      Bishop.add_to_board(color, self),
      Queen.add_to_board(color, self),
      King.add_to_board(color, self)
    ]
    @white_pieces = pieces if color == 'white'
    @black_pieces = pieces if color == 'black'
  end

  def assign_all_possible_moves
    white_pieces.each { |piece| piece.update_possible_moves }
    black_pieces.each { |piece| piece.update_possible_moves }
  end

  def find_piece(move, color)
    pieces = (color == 'white' ? white_pieces : black_pieces)
    pieces.find do |piece|
      piece.instance_of?(move[0]) &&
        piece.possible_moves.include?([move[1], move[2]])
    end
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
    clean_rows = positions.map do |row|
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