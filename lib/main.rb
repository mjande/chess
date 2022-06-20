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
pawn = Pawn.new(6, 0, 'white', board)
pawn.update_possible_moves