# frozen_string_literal: true

require_relative 'library'
require 'colorize'

# The Board class handles storage of the squares and pieces of the chess board.
# It also handles methods for checking the details of a particular square
# (whether it is open and what color piece is occupying it). Several methods
# which make changes to all the pieces in the game are handled here as well.
# (This class is one that might need to be broken into several, as it is doing
# several distinct types of functions).
class Board
  attr_reader :data_array, :pieces, :squares
  attr_accessor :moves_since_capture

  def initialize
    @data_array = Array.new(8) { Array.new(8, nil) }
    @squares = []
    create_squares
    @pieces = []
    @log = []
    @moves_since_capture = 0
  end

  def create_squares
    8.times do |row|
      8.times do |column|
        new_square = Square.new(row, column)
        squares << new_square
      end
    end
  end

  def square(row, column)
    wanted_square = squares.find do |square|
      square.row == row && square.column == column
    end
    wanted_square.nil? ? NoSquare.new(row, column) : wanted_square
  end

  def add_starting_pieces
    piece_types = [Rook, Knight, Bishop, Queen, King, Pawn]
    piece_types.each do |piece_type|
      piece_type.add_white_pieces_to_board(self)
      piece_type.add_black_pieces_to_board(self)
    end
  end

  def update_all_possible_moves
    pieces.each(&:update_possible_moves)
    pieces.select do |piece|
      piece.instance_of?(King)
    end.each(&:update_possible_moves)
  end

  def no_possible_moves?(player)
    player_pieces = pieces.select { |piece| piece.color == player.color }
    player_pieces.all? { |piece| piece.possible_moves.empty? }
  end

  def dead_position?
    case pieces.length
    when 4
      dead_bishops_position?
    when 3
      knight_count = pieces.count { |piece| piece.instance_of?(Knight) }
      bishop_count = pieces.count { |piece| piece.instance_of?(Bishop) }
      knight_count == 1 || bishop_count == 1
    end
  end

  def threefold_repetition?
    current_board = @log[-1]
    repetitions = @log.count { |position| position == current_board }
    repetitions > 2
  end

  def clone
    YAML.load(YAML.dump(self))
  end

  def display
    0.upto(7) do |row_num|
      print "#{8 - row_num} "
      row_squares = squares.select { |candidate| candidate.row == row_num }
      row_squares.sort_by!(&:column)
      row_squares.each { |row_square| print row_square }
      print "\n"
    end
    puts '   a  b  c  d  e  f  g  h   '
  end

  def log_position
    @log << squares
  end

  def inspect
    'Board'
  end

  private

  def dead_bishops_position?
    bishops = pieces.select { |piece| piece.instance_of?(Bishop) }
    return unless bishops.length == 2

    bishops[0].territory == bishops[1].territory
  end
end
