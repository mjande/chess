require_relative 'pieces'

class Board
  attr_reader :position_array

  def initialize
    @position_array = Array.new(8) { Array.new(8, nil) }
    # 8.times { |row_number| data_array[row_number].prepend(row_number) }
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
      position_array[1][column] = Pawn.new('black')
      position_array[6][column] = Pawn.new('white')
    end
  end

  def set_up_rooks
    position_array[0][0] = Rook.new('black')
    position_array[0][7] = Rook.new('black')
    position_array[7][0] = Rook.new('white')
    position_array[7][7] = Rook.new('white')
  end

  def set_up_knights
    position_array[0][1] = Knight.new('black')
    position_array[0][6] = Knight.new('black')
    position_array[7][1] = Knight.new('white')
    position_array[7][6] = Knight.new('white')
  end

  def set_up_bishops
    position_array[0][2] = Bishop.new('black')
    position_array[0][5] = Bishop.new('black')
    position_array[7][2] = Bishop.new('white')
    position_array[7][5] = Bishop.new('white')
  end

  def set_up_queens
    position_array[0][3] = Queen.new('black')
    position_array[7][3] = Queen.new('white')
  end

  def set_up_kings
    position_array[0][4] = King.new('black')
    position_array[7][4] = King.new('white')
  end
end