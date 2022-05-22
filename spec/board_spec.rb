require './lib/board'

describe Board do
  
  describe '#set_up' do
    subject(:new_board) { described_class.new }

    it 'adds the pieces to their correct starting position' do
      new_board.set_up
      correct_board = 
        [[Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook],
        [Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn],
        [NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass],
        [NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass],
        [NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass],
        [NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass, NilClass],
        [Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn],
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
      
      xit 'prints the starting board' do
        starting_board_display =
        '  ---------------------------------'
        '8 | ♜ | ♞ | ♝ | ♛ | ♚ | ♝ | ♞ | ♜ |'
        '  ---------------------------------'
        '7 | ♟ | ♟ | ♟ | ♟ | ♟ | ♟ | ♟ | ♟ |'
        '  ---------------------------------'
        '6 |   |   |   |   |   |   |   |   |'
        '  ---------------------------------'
        '5 |   |   |   |   |   |   |   |   |'
        '  ---------------------------------'
        '4 |   |   |   |   |   |   |   |   |'
        '  ---------------------------------'
        '3 |   |   |   |   |   |   |   |   |'
        '  ---------------------------------'
        '2 | ♙ | ♙ | ♙ | ♙ | ♙ | ♙ | ♙ | ♙ |'
        '  ---------------------------------'
        '1 | ♖ | ♘ | ♗ | ♕ | ♔ | ♗ | ♘ | ♖ |'
        '  ---------------------------------'
        '    a   b   c   d   e   f   g   h  '
        expect{ new_board.display }.to output(starting_board_display).to_stdout
      end
    end
  end
end
