class Queen < Piece
  STARTING_POSITIONS = { 'white' => [[7, 3]], 'black' => [[0, 3]] }.freeze

  def to_s
    color == 'white' ? ' ♛ '.colorize(:light_white) : ' ♛ '.colorize(:black)
  end

  def update_possible_moves
    check_direction(-1, 0).each { |position| possible_moves << position }
    check_direction(-1, 1).each { |position| possible_moves << position }
    check_direction(0, 1).each { |position| possible_moves << position }
    check_direction(1, 1).each { |position| possible_moves << position }
    check_direction(1, 0).each { |position| possible_moves << position }
    check_direction(1, -1).each { |position| possible_moves << position }
    check_direction(0, -1).each { |position| possible_moves << position }
    check_direction(-1, -1).each { |position| possible_moves << position }
  end
end