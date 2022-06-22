# frozen_string_literal: true

# The Queen class handles starting squares and possible moves of both queens
class Queen < Piece
  STARTING_SQUARES = { 'white' => [board.square(7, 3)],
                       'black' => [board.square(0, 3)] }.freeze

  def to_s
    color == 'white' ? ' ♛ '.colorize(:light_white) : ' ♛ '.colorize(:black)
  end

  def update_possible_moves
    check_horizontals_and_verticals
    check_diagonals
  end
end
