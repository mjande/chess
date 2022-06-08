require_relative 'library'

begin
  game = Game.new
  game.start_game
rescue StandardError => e
  puts e.class
  puts e.backtrace
end
