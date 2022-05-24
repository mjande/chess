require_relative 'pieces'

class Board
  attr_reader :position_array

  def initialize
    @position_array = Array.new(8) { Array.new(8, nil) }
  end

  def set_up
    set_up_pawns
    set_up_rooks
    set_up_knights
    set_up_bishops
    set_up_queens
    set_up_kings
  end

  def set_up_pawns
    8.times do |column|
      position_array[1][column] = BlackPawn.new('black', 1, column)
      position_array[6][column] = WhitePawn.new('white', 6, column)
    end
  end

  def set_up_rooks
    position_array[0][0] = Rook.new('black', 0, 0)
    position_array[0][7] = Rook.new('black', 0, 7)
    position_array[7][0] = Rook.new('white', 7, 0)
    position_array[7][7] = Rook.new('white', 7, 7)
  end

  def set_up_knights
    position_array[0][1] = Knight.new('black', 0, 1)
    position_array[0][6] = Knight.new('black', 0, 6)
    position_array[7][1] = Knight.new('white', 7, 1)
    position_array[7][6] = Knight.new('white', 7, 6)
  end

  def set_up_bishops
    position_array[0][2] = Bishop.new('black', 0, 2)
    position_array[0][5] = Bishop.new('black', 0, 5)
    position_array[7][2] = Bishop.new('white', 7, 2)
    position_array[7][5] = Bishop.new('white', 7, 5)
  end

  def set_up_queens
    position_array[0][3] = Queen.new('black', 0, 3)
    position_array[7][3] = Queen.new('white', 7, 3)
  end

  def set_up_kings
    position_array[0][4] = King.new('black', 0, 4)
    position_array[7][4] = King.new('white', 7, 4)
  end

  def display
    horizontal_line = '  --------------------------------- '
    column_labels = '    a   b   c   d   e   f   g   h   '

    printable_board = clean_rows.join("#{horizontal_line}\n")

    puts horizontal_line
    puts printable_board
    puts horizontal_line
    puts column_labels
  end

  def clean_rows
    clean_rows = position_array.map do |row|
      row.map { |position| position.nil? ? ' ' : position }
    end

    row_number = 8
    clean_rows.each do |row|
      row.unshift(row_number)
      row.push("\n")
      row_number -= 1
    end

    clean_rows.map { |row| row.join(' | ') }
  end
end