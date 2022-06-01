require_relative '../../lib/library'

describe WhitePawn do
  describe '#possible_moves' do
    let(:board) { Board.new }
    subject(:pawn) { described_class.new(6, 0, 'white', board)}

    it 'returns both possible moves on new board' do
      expect(pawn.possible_moves).to contain_exactly([5, 0], [4, 0])
    end

    it 'returns just one possible move when not in start position' do
      pawn.move(4, 0)
      expect(pawn.possible_moves).to contain_exactly([3, 0])
    end

    it 'returns diagonal moves to take opposing pieces' do
      BlackPawn.new(5, 1, 'black', board)
      expect(pawn.possible_moves).to contain_exactly([5, 0], [4, 0], [5, 1])
    end
  end
end

describe BlackPawn do
  describe '#possible_moves' do
    let(:board) { Board.new }
    subject(:pawn) { described_class.new(1, 0, 'black', board) }

    it 'returns both possible moves on new board' do
      expect(pawn.possible_moves).to contain_exactly([2, 0], [3, 0])
    end

    it 'returns just one possible move when not in start position' do
      pawn.move(2, 0)
      expect(pawn.possible_moves).to contain_exactly([3, 0])
    end

    it 'returns diagonal moves to take opposing pieces' do
      WhitePawn.new(2, 1, 'white', board)
      expect(pawn.possible_moves).to contain_exactly([2, 0], [3, 0], [2, 1])
    end
  end
end
