require_relative '../../lib/library'

describe Rook do
  describe '#possible_moves' do
    let(:board) { Board.new }

    context 'when the board is blank' do
      it 'returns an array of all possible moves' do
        a_rook = described_class.new(7, 0, 'white', board)
        expect(a_rook.possible_moves).to contain_exactly([6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7])
      end

      it 'returns an array of all possible moves' do
        h_rook = described_class.new(0, 7, 'black', board)
        expect(h_rook.possible_moves).to contain_exactly([0, 6], [0, 5], [0, 4], [0, 3], [0, 2], [0, 1], [0, 0], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7])
      end
    end

    context 'there are other pieces on the board' do
      it 'returns moves up to blocking pieces and including different colored pieces' do
        a_rook = described_class.new(7, 0, 'white', board)
        Bishop.new(7, 2, 'white', board)
        BlackPawn.new(1, 0, 'black', board)
        expect(a_rook.possible_moves).to contain_exactly([7, 1], [6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0])
      end

      it 'returns moves up to blocking pieces and including different colored pieces' do
        h_rook = described_class.new(0, 7, 'black', board)
        Queen.new(0, 3, 'black', board)
        Bishop.new(5, 7, 'white', board)
        expect(h_rook.possible_moves).to contain_exactly([1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [0, 6], [0, 5], [0, 4])
      end
    end
  end
end