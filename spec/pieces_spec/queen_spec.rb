require_relative '../../lib/library'

describe Queen do
  describe '#possible_moves' do
    let(:board) { Board.new }

    context 'when the board is blank' do
      it 'returns an array of all possible moves from the middle of the board' do
        queen = described_class.new(4, 4, 'white', board)
        expect(queen.possible_moves).to contain_exactly([4, 3], [4, 2], [4, 1], [4, 0], [3, 3], [2, 2], [1, 1], [0, 0], [3, 4], [2, 4], [1, 4], [0, 4], [3, 5], [2, 6], [1, 7], [4, 5], [4, 6], [4, 7], [5, 5], [6, 6], [7, 7], [5, 4], [6, 4], [7, 4], [5, 3], [6, 2], [7, 1])
      end
      
      it 'returns an array of all possible moves from the edge of the board' do
        queen = described_class.new(7, 3, 'white', board)
        expect(queen.possible_moves).to contain_exactly([7, 2], [7, 1], [7, 0], [6, 2], [5, 1], [4, 0], [6, 3], [5, 3], [4, 3], [3, 3], [2, 3], [1, 3], [0, 3], [6, 4], [5, 5], [4, 6], [3, 7], [7, 4], [7, 5], [7, 6], [7, 7])
      end
    end

    context 'when there are other pieces on the board' do
      subject(:queen) { described_class.new(1, 4, 'black', board) }

      before do
        Rook.new(5, 0, 'black', board)
        Knight.new(4, 4, 'black', board)
        Knight.new(1, 2, 'white', board)
        Bishop.new(3, 6, 'white', board)
      end

      it 'returns moves to capture different colored pieces' do
        expect(queen.possible_moves).to include([1, 2], [3, 6])
      end

      it 'does not return moves occupied by same-colored pieces' do
        expect(queen.possible_moves).not_to include([5, 0], [4, 4])
      end

      it 'does not return moves past other pieces' do
        expect(queen.possible_moves).not_to include([1, 1], [5, 4], [4, 7])
      end
    end
  end
end