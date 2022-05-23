require './lib/board'

describe Board do
  
  describe '#set_up' do
    subject(:new_board) { described_class.new }

    it 'adds the pieces to their correct starting position' do
      new_board.set_up
      correct_board = 
        [[Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook],
         [BlackPawn, BlackPawn, BlackPawn, BlackPawn, BlackPawn, BlackPawn, BlackPawn, BlackPawn],
         [NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass],
         [NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass],
         [NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass],
         [NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass],
         [WhitePawn, WhitePawn, WhitePawn, WhitePawn, WhitePawn, WhitePawn, WhitePawn, WhitePawn],
         [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]]

      correct_board.each_with_index do |row, row_index|
        row.each_with_index do |type, column_index|
          expect(new_board.position_array[row_index][column_index]).to be_instance_of(type)
        end
      end
    end
  end

  describe '#display' do
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
        new_board.set_up
        expect{ new_board.display }.to output(starting_board_display).to_stdout
      end
    end
  end
end
