class Queen < Piece
  WHITE_STARTING_POSITIONS = [[7, 3]].freeze
  BLACK_STARTING_POSITIONS = [[0, 3]].freeze

  def to_s 
    color == 'white' ? ' ♛ '.colorize(:light_white) : ' ♛ '.colorize(:black)
  end

  def possible_moves
    possible_moves = []
    check_direction(-1, 0).each { |position| possible_moves << position }
    check_direction(-1, 1).each { |position| possible_moves << position }
    check_direction(0, 1).each { |position| possible_moves << position }
    check_direction(1, 1).each { |position| possible_moves << position }
    check_direction(1, 0).each { |position| possible_moves << position }
    check_direction(1, -1).each { |position| possible_moves << position }
    check_direction(0, -1).each { |position| possible_moves << position }
    check_direction(-1, -1).each { |position| possible_moves << position }
    possible_moves
  end
end