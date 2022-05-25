require './lib/board'

describe Board do
  describe '#display' do
    # No way to initialize pieces on the board without using Player class, so I
    # can't think of a way to test display without an integration test, so I'm
    # just going to leave it alone for now. Going to comment this previous test
    # out just in case I want to test that massive string sometime down the road.

=begin
    context 'at the start of the game' do
      subject(:new_board) { described_class.new }

      it 'prints the starting board' do
        starting_board_display =
        "  --------------------------------- \n" +
        "8 | ♜ | ♞ | ♝ | ♛ | ♚ | ♝ | ♞ | ♜ | \n" +
        "  --------------------------------- \n" +
        "7 | ♟ | ♟ | ♟ | ♟ | ♟ | ♟ | ♟ | ♟ | \n" +
        "  --------------------------------- \n" +
        "6 |   |   |   |   |   |   |   |   | \n" +
        "  --------------------------------- \n" +
        "5 |   |   |   |   |   |   |   |   | \n" +
        "  --------------------------------- \n" +
        "4 |   |   |   |   |   |   |   |   | \n" +
        "  --------------------------------- \n" +
        "3 |   |   |   |   |   |   |   |   | \n" +
        "  --------------------------------- \n" +
        "2 | ♙ | ♙ | ♙ | ♙ | ♙ | ♙ | ♙ | ♙ | \n" +
        "  --------------------------------- \n" +
        "1 | ♖ | ♘ | ♗ | ♕ | ♔ | ♗ | ♘ | ♖ | \n" +
        "  --------------------------------- \n" +
        "    a   b   c   d   e   f   g   h   \n"

        expect { new_board.display }.to output(starting_board_display).to_stdout
      end
    end
  end
=end
end
