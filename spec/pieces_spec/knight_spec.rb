require_relative '../../lib/library'

describe Knight do 
  describe '#possible_moves' do
    let(:board) { Board.new }

    it 'returns an array of all possible moves in the middle of a blank board' do
      knight = described_class.new(4, 3, 'white', board)
      expect(knight.possible_moves).to contain_exactly([6, 4], [6, 2], [5, 5], [3, 5], [2, 4], [2, 2], [5, 1], [3, 1])
    end

    it 'returns an array of all possible moves on the edge of a blank board' do
      knight = described_class.new(1, 0, 'black', board)
      expect(knight.possible_moves).to contain_exactly([0, 2], [2, 2], [3, 1])
    end

    it 'returns moves to take other pieces' do
      knight = described_class.new(2, 0, 'black', board)
      Rook.new(4, 1, 'white', board)
      expect(knight.possible_moves).to include([4, 1])
    end

    it 'does not return moves occupied by other same-colored pieces' do
      knight = described_class.new(2, 0, 'black', board)
      Queen.new(2, 1, 'black', board)
      expect(knight.possible_moves).not_to include(2, 1)
    end
  end
end