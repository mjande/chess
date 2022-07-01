# frozen_string_literal: true

require 'colorize'

# The Piece class handles the factory for creating different pieces at the start
# of the game, and also contains several methods that are shared by several of
# the different pieces subclasses. Most methods deal with move validation and
# movement scripts.
class Piece
  attr_reader :row, :column, :color, :board, :possible_moves, :has_not_moved

  def initialize(row, column, color, board)
    @row = row
    @column = column
    @color = color
    @board = board
    square = board.square(row, column)
    square.piece = self
    @possible_moves = []
    @has_not_moved = true
  end

  def self.add_white_pieces_to_board(board)
    self::STARTING_COORDINATES['white'].each do |coordinates|
      piece = new(coordinates[0], coordinates[1], 'white', board)
      board.pieces.push(piece)
    end
  end

  def self.add_black_pieces_to_board(board)
    self::STARTING_COORDINATES['black'].each do |coordinates|
      piece = new(coordinates[0], coordinates[1], 'black', board)
      board.pieces.push(piece)
    end
  end

  def valid_move?(candidate)
    return if candidate.nil?

    (candidate.open? || candidate.different_colored_piece?(color)) &&
      !leads_to_check?(candidate)
  end

  def leads_to_check?(candidate)
    return if board.copy

    board_copy = board.clone
    piece_copy = board_copy.square(row, column).piece
    piece_copy.move(board_copy.square(candidate.row, candidate.column))
    king = board_copy.pieces.find do |copied_piece|
      copied_piece.instance_of?(King) && copied_piece.color == color
    end
    board_copy.update_all_possible_moves
    king.check?
  end

  def add_coordinates_from_directions(hash)
    hash.each_value do |direction_array|
      i = 0
      while i <= (direction_array.length - 1)
        next_coordinate = direction_array[i]
        next_square = board.square(next_coordinate[0], next_coordinate[1])
        @possible_moves << next_coordinate if valid_move?(next_square)
        break unless next_square.open?

        i += 1
      end
    end
  end

  def move(square)
    leave_previous_square
    @row = square.row
    @column = square.column
    board.moves_since_capture += 1
    capture(square) unless square.open?
    square.piece = self
  end

  def leave_previous_square
    @has_not_moved = false
    board.square(row, column).clear
  end

  private

  def capture(square)
    piece_to_be_removed = square.piece
    board.pieces.delete(piece_to_be_removed)
    board.moves_since_capture = 0
  end
end
