require_relative '../../lib/library'

describe Knight do
  describe '#update_possible_moves' do
    let(:board) { Board.new }

    context 'when the board is blank' do
      it 'returns an array of all possible moves from the middle of the board' do
        knight = described_class.new(4, 3, 'white', board)
        king = King.new(7, 4, 'white', board)
        board.instance_variable_set(:@pieces, [knight, king])
        knight.update_possible_moves
        expect(knight.possible_moves).to contain_exactly([6, 4], [6, 2], [5, 5], [3, 5], [2, 4], [2, 2], [5, 1], [3, 1])
      end

      it 'returns an array of all possible moves from the edge of the board' do
        knight = described_class.new(1, 0, 'black', board)
        king = King.new(7, 4, 'black', board)
        board.instance_variable_set(:@pieces, [knight, king])
        knight.update_possible_moves
        expect(knight.possible_moves).to contain_exactly([0, 2], [2, 2], [3, 1])
      end
    end

    context 'when there are other pieces on the board' do
      subject(:knight) { described_class.new(2, 0, 'black', board) }

      before do
        rook = Rook.new(4, 1, 'white', board)
        queen = Queen.new(0, 1, 'black', board)
        bishop = Bishop.new(2, 1, 'black', board)
        king = King.new(7, 7, 'black', board)
        board.instance_variable_set(:@pieces, [knight, rook, queen, bishop, king])
        knight.update_possible_moves
      end

      it 'returns moves to capture other pieces' do
        expect(knight.possible_moves).to include([4, 1])
      end

      it 'does not return moves occupied by other same-colored pieces' do
        expect(knight.possible_moves).not_to include(0, 1)
      end

      it 'returns moves that pass over other pieces' do
        expect(knight.possible_moves).to include([3, 2])
      end
    end

    context 'when there is a threat of check' do 
      subject(:knight) { described_class.new(7, 2, 'white', board) }

      it 'adds no moves that result in check to @possible_moves' do
        king = King.new(7, 4, 'white', board)
        rook = Rook.new(7, 0, 'black', board)
        board.instance_variable_set(:@pieces, [knight, king, rook])
        knight.update_possible_moves
        expect(knight.possible_moves).to be_empty
      end
    end
  end
end
