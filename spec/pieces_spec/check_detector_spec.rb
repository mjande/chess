require_relative '../../lib/library'

describe CheckDetector do
  describe 'CheckDetector.for?' do
    let(:board) { Board.new }
    let(:king_square) { Square.new(7, 4) }

    it 'returns true when there is a check on one of the axies' do
      Rook.new(7, 0, 'black', board)
      expect(CheckDetector.for?(king_square, board, 'white')).to be_truthy
    end

    it 'returns true when there is a check on one of the diagonals' do
      Bishop.new(5, 2, 'black', board)
      expect(CheckDetector.for?(king_square, board, 'white')).to be_truthy
    end

    it 'returns true when there is a pawn check near the king' do
      Pawn.new(6, 5, 'black', board)
      expect(CheckDetector.for?(king_square, board, 'white')).to be_truthy
    end

    it 'returns true when there is a check on one of the knight squares' do
      Knight.new(5, 5, 'black', board)
      expect(CheckDetector.for?(king_square, board, 'white')).to be_truthy
    end

    it 'returns false when there is no check' do
      expect(CheckDetector.for?(king_square, board, 'white')).to be_falsey
    end
  end
end

