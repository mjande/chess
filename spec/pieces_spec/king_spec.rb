require_relative '../../lib/library'

describe King do
  describe '#possible_moves' do
    let(:board) { Board.new }

    context 'when on a blank board' do
      it 'returns all possible moves from middle of board' do
        king = described_class.new(4, 4, 'white', board)
        expect(king.possible_moves).to contain_exactly([3, 3], [3, 4], [3, 5], [4, 3], [4, 5], [5, 3], [5, 4], [5, 5])
      end

      it 'returns all possible moves from the edge of the board' do
        king = described_class.new(7, 4, 'white', board)
        expect(king.possible_moves).to contain_exactly([7, 3], [6, 3], [6, 4], [6, 5], [7, 5])
      end
    end

    context 'when there are other pieces on the board' do
      subject(:king) { described_class.new(7, 4, 'white', board) }

      before do
        Bishop.new(6, 4, 'black', board)
        Queen.new(7, 3, 'white', board)
      end

      it 'returns moves to capture other pieces' do
        expect(king.possible_moves).to include([6, 4])
      end

      it 'does not return moves occupied by other same-colored pieces' do
        expect(king.possible_moves).not_to include([7, 3])
      end

      it 'does not return moves that place the king in check' do
        expect(king.possible_moves).not_to include([7, 5])
      end
    end
  end
end
