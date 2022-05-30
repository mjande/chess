require_relative '../../lib/board'
require_relative '../../lib/pieces/pawn'

describe WhitePawn do
  describe '#possible_moves' do
    let(:board) { Board.new }
    subject(:pawn) { described_class.new(6, 0, 'white', board)}

    it 'returns both possible moves on blank board' do
      expect(pawn.possible_moves).to contain_exactly([5, 0], [4, 0])
    end
  end
end