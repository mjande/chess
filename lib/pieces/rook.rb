require_relative '../library'

class Rook < Piece
  WHITE_STARTING_POSITIONS = [[7, 0], [7, 7]].freeze
  BLACK_STARTING_POSITIONS = [[0, 0], [0, 7]].freeze

  def to_s
    color == 'white' ? ' ♜ '.colorize(:light_white) : ' ♜ '.colorize(:black)
  end

  def update_possible_moves
    check_direction(-1, 0).each { |position| possible_moves << position }
    check_direction(0, 1).each { |position| possible_moves << position }
    check_direction(1, 0).each { |position| possible_moves << position }
    check_direction(0, -1).each { |position| possible_moves << position }
    possible_moves << kingside_castling?(row)
    possible_moves << queenside_castling?(row)
    possible_moves.compact!
  end

  def kingside_castle_move
    move(@row, 5)
    king = @board.positions[@row][4]
    king.move(@row, 6)
  end

  def queenside_castle_move
    move(@row, 3)
    king = @board.positions[@row][4]
    rook.move(@row, 2)
  end

  private

  def kingside_castling?(row)
    king = board.positions[row][4]
    return unless king.instance_of?(King) && king.color == color

    if previous_moves.empty? &&
       king.previous_moves.empty? &&
       !king.check? &&
       !king.check?(row, 5) && empty_position?(row, 5) &&
       !king.check?(row, 6) && empty_position?(row, 6)
      [row, 5]
    end
  end

  def queenside_castling?(row)
    king = board.positions[row][4]
    return unless king.instance_of?(King) && king.color == color

    if previous_moves.empty? &&
       king.previous_moves.empty? &&
       !king.check? &&
       !king.check?(row, 3) && empty_position?(row, 3) &&
       !king.check?(row, 2) && empty_position?(row, 2) &&
       empty_position?(row, 1)
      [row, 2]
    end
  end
end
