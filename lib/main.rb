require_relative 'library'

=begin
begin
  game = Game.new
  game.start_game
rescue StandardError => e
  puts e.class
  puts e.backtrace
end
=end

board = Board.new
king = King.new(7, 4, 'white', board)
rook = Rook.new(7, 7, 'white', board)
king.kingside_castle_move
puts "King moved: #{board.positions[7][6] == king}"
puts "Rook moved: #{board.positions[7][5] == rook}"