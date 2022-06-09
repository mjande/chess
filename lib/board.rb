require 'colorize'

class Board
  attr_reader :positions, :pieces

  def initialize
    @positions = Array.new(8) { Array.new(8, nil) }
    @pieces = []
  end

  def add_starting_pieces(player)
    Rook.add_to_board(self, player)
    Knight.add_to_board(self, player)
    Bishop.add_to_board(self, player)
    Queen.add_to_board(self, player)
    King.add_to_board(self, player)
    if player.color == 'white'
      WhitePawn.add_to_board(self, player)
    else
      BlackPawn.add_to_board(self, player)
    end
  end

  def update_all_possible_moves
    pieces.each(&:update_possible_moves)
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