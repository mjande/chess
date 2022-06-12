require_relative '../../lib/library'

describe Piece do
  describe '#Piece.add_to_board' do
    let(:board) { Board.new }
    let(:white_player) { double('white_player', color: 'white', pieces: []) }
    let(:black_player) { double('black_player', color: 'black', pieces: []) }

    it 'assigns pieces to starting position' do
      Rook.add_to_board(board, white_player)
      expect(board.positions[7][0]).to be_a(Rook)
      Bishop.add_to_board(board, black_player)
      expect(board.positions[0][2]).to be_a(Bishop)
    end

    it 'adds array of created pieces to player.pieces' do
      Rook.add_to_board(board, white_player)
      expect(white_player.pieces).to include(a_kind_of(Rook)).twice
    end

    it 'adds array of created pieces to board.pieces' do
      Rook.add_to_board(board, white_player)
      expect(board.pieces).to include(a_kind_of(Rook)).twice
    end
  end

  describe '#move' do
    let(:board) { Board.new }
    
    context 'when moving to an unoccopied position' do
      subject(:piece) { described_class.new(6, 0, 'white', board) }

      before do
        piece.move(5, 0)
      end

      it 'removes self from previous position' do
        expect(board.positions[6][0]).to be_nil
      end

      it 'adds self to new position' do
        expect(board.positions[5][0]).to be(piece)
      end

      it 'updates current row' do
        expect(piece.row).to eq(5)
      end
    end

    context 'when capturing another piece' do
      subject(:piece) { described_class.new(7, 0, 'white', board) }

      it 'removes captured piece from board.pieces' do
        other_piece = described_class.new(5, 0, 'black', board)
        board.instance_variable_set(:@pieces, [piece, other_piece])
        piece.move(5, 0)
        expect(board.pieces).not_to include(other_piece)
      end
    end
  end

  describe '#undo_move' do
    let(:board) { Board.new }
    subject(:piece) { described_class.new(5, 0, 'white', board) }

    before do
      piece.instance_variable_set(:@previous_moves, [[6, 0]])
      piece.undo_move
    end

    it 'removes self from requested position' do
      expect(board.positions[5][0]).to be_nil
    end

    it 'adds self to previous position' do
      expect(board.positions[6][0]).to eq(piece)
    end

    it 'updates row back to previous row' do
      expect(piece.row).to eq(6)
    end
  end
end