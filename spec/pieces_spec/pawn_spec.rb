require_relative '../../lib/library'

describe Pawn do
  describe '#update_possible_moves' do
    let(:board) { Board.new }
    subject(:pawn) { described_class.new(6, 0, 'white', board) }

    before do
      pawn.update_possible_moves
    end

    it 'returns both possible moves on new board' do
      expect(pawn.possible_moves).to contain_exactly([5, 0], [4, 0])
    end

    it 'returns just one possible move when not on starting square' do
      pawn.move(4, 0)
      pawn.update_possible_moves

      expect(pawn.possible_moves).to contain_exactly([3, 0])
    end

    it 'does not return any possible moves with a blocking piece in front' do
      Pawn.new(5, 0, 'black', board)
      pawn.update_possible_moves
      expect(pawn.possible_moves).not_to include([5, 0])
    end

    it 'returns diagonal moves to take opposing pieces' do
      Pawn.new(5, 1, 'black', board)
      pawn.update_possible_moves
      expect(pawn.possible_moves).to include([5, 1])
    end

    context 'there is an opportunity for en-passant capture' do
      let(:board) { Board.new }
      subject(:pawn) { described_class.new(3, 0, 'white', board) }

      it 'returns diagonal moves for en_passant capture' do
        black_pawn = Pawn.new(3, 1, 'black', board)
        black_pawn.instance_variable_set(:@has_not_moved, true)
        pawn.update_possible_moves
        expect(pawn.possible_moves).to include([2, 1])
      end
    end
  end

  describe '#en_passant_move' do
    let(:board) { Board.new }
    subject(:pawn) { described_class.new(3, 0, 'white', board) }

    it 'moves pawn to new square' do
      other_pawn = Pawn.new(3, 1, 'black', board)
      other_pawn.instance_variable_set(:@has_not_moved, true)
      pawn.update_possible_moves
      pawn.en_passant_capture(1)
      expect(board.square(2, 1).piece).to be(pawn)
    end

    it 'removes opposing pawn' do
      other_pawn = Pawn.new(3, 1, 'white', board)
      other_pawn.instance_variable_set(:@has_not_moved, true)
      pawn.update_possible_moves
      pawn.en_passant_capture(1)
      expect(board.pieces).not_to include(other_pawn)
    end
  end
end
