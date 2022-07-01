# frozen_string_literal: true

require_relative 'library'
require 'colorize'

# The Board class handles storage of the squares and pieces of the chess board,
# and includes several methods which make changes to all the pieces in the game.
class Board
  attr_reader :pieces, :squares
  attr_accessor :moves_since_capture, :copy

  def initialize
    @squares = []
    create_squares
    @pieces = []
    @log = []
    @moves_since_capture = 0
    @copy = false
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
    board_clone = YAML.load(YAML.dump(self))
    board_clone.copy = true
    board_clone
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
    @log << YAML.dump(self)
  end

  def inspect
    'Board'
  end

  private

  def dead_bishops_position?
    bishops = pieces.select { |piece| piece.instance_of?(Bishop) }
    return unless bishops.length == 2

    square(bishops[0].row, bishops[0].column).color ==
      square(bishops[1].row, bishops[1].column).color
  end
end
