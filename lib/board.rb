class Board
  attr_reader :data_array

  def initialize
    @data_array = Array.new(8) { Array.new(8, nil) }
  end

  def display
    board = clean_board

    puts '---------------------------------'
    puts board
    puts '---------------------------------'
  end

  def clean_board
    clean_board = data_array.map do |row|
      row.map! { |col| ' ' if col.nil? }
      "| #{row.join(' | ')} |"
    end

    clean_board.join("\n---------------------------------\n")
  end
end

Board.new.display
