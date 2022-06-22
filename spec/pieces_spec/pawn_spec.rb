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

    it 'returns just one possible move when not in start position' do
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
        black_pawn.instance_variable_set(:@previous_move, [1, 1])
        pawn.update_possible_moves
        expect(pawn.possible_moves).to include([2, 1])
      end
    end
  end

  describe '#en_passant_move' do
    let(:board) { Board.new }
    subject(:pawn) { described_class.new(3, 0, 'white', board) }

    it 'moves pawn to new position' do
      other_pawn = Pawn.new(3, 1, 'black', board)
      other_pawn.instance_variable_set(:@previous_moves, [[1, 1]])
      pawn.update_possible_moves
      pawn.en_passant_capture(1)
      expect(board.square(2, 1).piece).to be(pawn)
    end

    it 'removes opposing pawn' do
      other_pawn = Pawn.new(3, 1, 'white', board)
      other_pawn.instance_variable_set(:@previous_moves, [[1, 1]])
      pawn.update_possible_moves
      pawn.en_passant_capture(1)
      expect(board.pieces).not_to include(other_pawn)
    end
  end
end

=begin
describe BlackPawn do
  describe '#possible_moves' do
    let(:board) { Board.new }
    subject(:pawn) { described_class.new(1, 0, 'black', board) }

    before do
      pawn.update_possible_moves
    end

    it 'returns both possible moves on new board' do
      expect(pawn.possible_moves).to contain_exactly([2, 0], [3, 0])
    end

    it 'returns just one possible move when not in start position' do
      pawn.move(2, 0)
      pawn.update_possible_moves
      expect(pawn.possible_moves).to contain_exactly([3, 0])
    end

    it 'does not return any possible moves with a blocking piece in front' do
      WhitePawn.new(2, 0, 'black', board)
      pawn.update_possible_moves
      expect(pawn.possible_moves).not_to include([2, 0])
    end

    it 'returns diagonal moves to take opposing pieces' do
      WhitePawn.new(2, 1, 'white', board)
      pawn.update_possible_moves
      expect(pawn.possible_moves).to include([2, 1])
    end

    context 'there is an opportunity for en-passant capture' do
      let(:board) { Board.new }
      subject(:pawn) { described_class.new(4, 6, 'black', board) }

      it 'returns diagonal moves for en_passant capture' do
        white_pawn = WhitePawn.new(4, 5, 'white', board)
        white_pawn.instance_variable_set(:@previous_moves, [[6, 5]])
        pawn.update_possible_moves
        expect(pawn.possible_moves).to include([5, 5])
      end
    end
  end

  describe '#en_passant_move' do
    let(:board) { Board.new }
    subject(:pawn) { described_class.new(4, 0, 'black', board) }

    it 'moves pawn to new position' do
      pawn.en_passant_capture(1)
      expect(board.positions[5][1]).to be(pawn)
    end

    it 'removes opposing pawn' do
      other_pawn = WhitePawn.new(4, 1, 'white', board)
      board.instance_variable_set(:@pieces, [pawn, other_pawn])
      pawn.en_passant_capture(1)
      expect(board.pieces).not_to include(other_pawn)
    end
  end
end
=end
