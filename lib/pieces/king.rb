require_relative '../library'

class King < Piece
  WHITE_STARTING_POSITIONS = [[7, 4]].freeze
  BLACK_STARTING_POSITIONS = [[0, 4]].freeze
  SYMBOL = ' ♚ '.freeze

  def to_s
    color == 'white' ? ' ♚ '.colorize(:light_white) : ' ♚ '.colorize(:black)
  end

  def update_possible_moves
    @possible_moves = Array[
      valid_move?(@row - 1, @column, color),
      valid_move?(@row - 1, @column + 1, color),
      valid_move?(@row, @column + 1, color),
      valid_move?(@row + 1, @column + 1, color),
      valid_move?(@row + 1, @column, color),
      valid_move?(@row + 1, @column - 1, color),
      valid_move?(@row, @column - 1, color),
      valid_move?(@row - 1, @column - 1, color),
      kingside_castling?(@row),
      queenside_castling(@row)
    ].compact
  end

  def kingside_castling?(row)
    if board.positions[row][7].instance_of?(Rook) && board.positions[row][7].color == color
      rook = board.positions[row][7]
    end
    if king.previous_moves.empty? &&
       rook.previous_moves.empty? &&
       !check? &&
       !check?(row, 5) && empty_position?(row, 5) &&
       !check?(row, 6) && empty_position?(row, 6)
      [row, 6]
    end
  end

  def queenside_castling(row)
    if board.positions[row][0].instance_of?(Rook) && board.positions[row][0].color == color
      rook = board.positions[row][0]
    end
    if king.previous_moves.empty? &&
       rook.previous_moves.empty? &&
       !check? &&
       !check?(row, 3) && empty_position?(row, 3) &&
       !check?(row, 2) && empty_position?(row, 2) &&
       empty_position?(row, 1)
      [row, 2]
    end
  end

  def check?(check_row = row, check_column = column)
    opposing_pieces = board.pieces.reject { |piece| piece.color == color }

    opposing_pieces.any? do |piece|
      piece.possible_moves.include?([check_row, check_column])
    end
  end

  def checkmate?
    return false if possible_moves.empty?

    possible_moves.all? do |position|
      check?(position[0], position[1])
    end
  end

  private

  def valid_move?(row, column, color)
    if on_the_board?(row, column) &&
       (@board.positions[row][column].nil? || different_color?(row, column, color)) &&
       !check?(row, column)
      [row, column]
    end
  end
end
