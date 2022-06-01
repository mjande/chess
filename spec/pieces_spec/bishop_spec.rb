require_relative '../../lib/library'

describe Bishop do
  describe '#possible_moves' do
    let(:board) { Board.new }

    context 'when the board is blank' do
      it 'returns an array of all possible moves from the middle of the board' do
        bishop = described_class.new(4, 4, 'white', board)
        expect(bishop.possible_moves).to contain_exactly([3, 3], [2, 2], [1, 1], [0, 0], [3, 5], [2, 6], [1, 7], [5, 3], [6, 2], [7, 1], [5, 5], [6, 6], [7, 7])
      end

      it 'returns an array of all possible moves from the edge of the board' do
        bishop = described_class.new(0, 2, 'black', board)
        expect(bishop.possible_moves).to contain_exactly([1, 1], [2, 0], [1, 3], [2, 4], [3, 5], [4, 6], [5, 7])
      end
    end

    context 'there are other pieces on the board' do
      subject(:bishop) { described_class.new(0, 5, 'black', board) }

      before do
        Rook.new(2, 7, 'white', board)
        Knight.new(2, 3, 'black', board)
      end

      it 'returns moves including different colored pieces' do
        expect(bishop.possible_moves).to include([2, 7])
      end

      it 'does not return moves for same-colored pieces' do
        expect(bishop.possible_moves).not_to include([2, 3])
      end
    end
  end
end
