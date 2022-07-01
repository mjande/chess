# frozen_string_literal: true

require_relative '../../lib/library'

describe Pawn do
  describe '#update_possible_moves' do
    let(:board) { Board.new }

    subject(:pawn) { described_class.new(6, 0, 'white', board) }

    before do
      king = King.new(7, 4, 'white', board)
      board.instance_variable_set(:@pieces, [pawn, king])
      pawn.update_possible_moves
    end

    it 'returns both possible moves on new board' do
      expect(pawn.possible_moves).to contain_exactly([5, 0], [4, 0])
    end

    it 'returns just one possible move when not on starting square' do
      pawn.move(board.square(4, 0))
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

    context 'when there is an opportunity for en-passant capture' do
      let(:board) { Board.new }

      subject(:pawn) { described_class.new(3, 0, 'white', board) }

      it 'returns diagonal moves for en_passant capture' do
        black_pawn = described_class.new(3, 1, 'black', board)
        black_pawn.instance_variable_set(:@open_to_en_passant, true)
        pawn.update_possible_moves
        expect(pawn.possible_moves).to include([2, 1])
      end
    end

    context 'when there is a threat of check' do
      subject(:pawn) { described_class.new(6, 3, 'white', board) }

      it 'adds no moves that result in check to @possible_moves' do
        king = King.new(6, 4, 'white', board)
        rook = Rook.new(6, 0, 'black', board)
        board.instance_variable_set(:@pieces, [pawn, king, rook])
        pawn.update_possible_moves
        expect(pawn.possible_moves).to be_empty
      end
    end
  end

  describe '#en_passant_move' do
    let(:board) { Board.new }
    subject(:pawn) { described_class.new(3, 0, 'white', board) }
    let(:other_pawn) { described_class.new(3, 1, 'black', board) }

    before do
      king = King.new(7, 4, 'white', board)
      other_pawn.instance_variable_set(:@open_to_en_passant, true)
      board.instance_variable_set(:@pieces, [king, pawn, other_pawn])
      pawn.en_passant_capture(board.square(2, 1))
      pawn.update_possible_moves
    end

    it 'moves pawn to new square' do
      expect(board.square(2, 1).piece).to be(pawn)
    end

    it 'removes opposing pawn' do
      expect(board.pieces).not_to include(other_pawn)
    end
  end
end
