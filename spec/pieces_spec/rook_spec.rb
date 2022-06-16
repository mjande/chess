require_relative '../../lib/library'

describe Rook do
  describe '#possible_moves' do
    let(:board) { Board.new }

    context 'when the board is blank' do
      it 'returns an array of all possible moves from the middle of the board' do
        rook = described_class.new(4, 4, 'white', board)
        rook.update_possible_moves
        expect(rook.possible_moves).to contain_exactly([3, 4], [2, 4], [1, 4], [0, 4], [4, 3], [4, 2], [4, 1], [4, 0], [5, 4], [6, 4], [7, 4], [4, 5], [4, 6], [4, 7])
      end

      it 'returns an array of all possible moves from edge of board' do
        rook = described_class.new(0, 7, 'black', board)
        rook.update_possible_moves
        expect(rook.possible_moves).to contain_exactly([0, 6], [0, 5], [0, 4], [0, 3], [0, 2], [0, 1], [0, 0], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7])
      end
    end

    context 'there are other pieces on the board' do
      subject(:rook) { described_class.new(7, 0, 'white', board) }

      before do
        Bishop.new(7, 2, 'white', board)
        Pawn.new(1, 0, 'black', board)
        rook.update_possible_moves
      end

      it 'returns moves to capture different colored pieces' do
        expect(rook.possible_moves).to include([1, 0])
      end

      it 'does not return moves occupied by same-colored pieces' do
        expect(rook.possible_moves).not_to include([7, 2])
      end

      it 'does not return moves past other pieces' do
        expect(rook.possible_moves).not_to include([0, 0], [7, 3])
      end
    end

    context 'when it is possible to castle' do
      subject(:rook) { described_class.new(7, 0, 'white', board) }

      before do
        King.new(7, 4, 'white', board)
        rook.update_possible_moves
      end

      it 'returns move to castle' do
        expect(rook.possible_moves).to include([7, 3])
      end
    end
  end
end
