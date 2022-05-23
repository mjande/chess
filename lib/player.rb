class Player
  def input_move
    puts 'Input the coordinates of your next move.'
    loop do
      input = gets.chomp.chars
      column = input[0]
      row = input[1].to_i
      next unless valid_input?(column, row)

      return convert_to_numbered_coordinates(column, row)
    end
  end

  def valid_input?(column, row)
    ('a'..'h').include?(column) && (1..8).include?(row)
  end

  def convert_to_numbered_coordinates(column, row)
    letters_array = ('a'..'h').to_a
    clean_column = letters_array.find_index(column)
    clean_row = 8 - row
    [clean_row, clean_column]
  end
end