class Player
  def input_move
    puts 'Input the coordinates of your next move.'
    loop do
      input = gets.chomp.chars
      next unless valid_input?(input)
      
      return convert_to_indices(input)
    end
  end

  def valid_input?(_)
  end

  def convert_to_indices(_)
  end
end