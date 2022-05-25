require_relative 'pieces'

class Board
  attr_reader :position_array

  def initialize
    @position_array = Array.new(8) { Array.new(8, nil) }
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