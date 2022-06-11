require_relative '../../lib/library'

describe King do
  describe '#possible_moves' do
    let(:board) { Board.new }

    context 'when on a blank board' do
      let(:center_king) { described_class.new(4, 4, 'white', board) }
      let(:edge_king) { described_class.new(7, 4, 'white', board) }

      it 'returns all possible moves from middle of board' do
        allow(center_king).to receive(:check?).and_return(false)
        center_king.update_possible_moves
        expect(center_king.possible_moves).to contain_exactly([3, 3], [3, 4], [3, 5], [4, 3], [4, 5], [5, 3], [5, 4], [5, 5])
      end

      it 'returns all possible moves from the edge of the board' do
        allow(edge_king).to receive(:check?).and_return(false)
        edge_king.update_possible_moves
        expect(edge_king.possible_moves).to contain_exactly([7, 3], [6, 3], [6, 4], [6, 5], [7, 5])
      end
    end

    context 'when there are other pieces on the board' do
      subject(:king) { described_class.new(7, 4, 'white', board) }

      before do
        bishop = Bishop.new(6, 4, 'black', board)
        queen = Queen.new(7, 3, 'white', board)
        board.instance_variable_set(:@pieces, [queen, bishop])
        allow(king).to receive(:check?).and_return(false)
        allow(king).to receive(:check?).with(7, 5).and_return(true)
        king.update_possible_moves
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

    context 'when castling is possible' do
      subject(:king) { described_class.new(7, 4, 'white', board) }

      before do
        Rook.new(7, 0, 'white', board)
        Rook.new(7, 7, 'white', board)
        king.update_possible_moves
      end

      it 'returns a move after kingside castling' do
        expect(king.possible_moves).to include([7, 6])
      end

      it 'returns a move after queenside castling' do
        expect(king.possible_moves).to include([7, 2])
      end
    end
  end

  describe '#check?' do
    let(:board) { Board.new }

    context 'when white is in check' do
      subject(:white_king) { King.new(7, 4, 'white', board) }

      before do
        rook = Rook.new(1, 4, 'black', board)
        rook.update_possible_moves
        black_king = King.new(0, 4, 'black', board)
        black_king.update_possible_moves
        board.instance_variable_set(:@pieces, [white_king, black_king, rook])
      end

      it 'returns true' do
        expect(white_king.check?).to be_truthy
      end
    end

    context 'when black is in check' do
      subject(:black_king) { King.new(0, 4, 'black', board) }

      before do
        white_king = King.new(7, 4, 'white', board)
        white_king.update_possible_moves
        bishop = Bishop.new(3, 1, 'white', board)
        bishop.update_possible_moves
        board.instance_variable_set(:@pieces, [black_king, white_king, bishop])
      end

      it 'returns true' do
        expect(black_king.check?).to be_truthy
      end
    end

    context 'there is no check' do
      let(:white_king) { King.new(7, 4, 'white', board) }
      let(:black_king) { King.new(0, 4, 'black', board) }

      it 'returns false' do
        board.instance_variable_set(:@pieces, [white_king, black_king])
        expect(black_king.check?).to be_falsey
        expect(white_king.check?).to be_falsey
      end
    end
  end

  describe '#checkmate?' do
    subject(:king) { described_class.new(7, 4, 'white', board) }
    let(:board) { Board.new }

    context 'when there is checkmate' do
      before do
        rook1 = Rook.new(0, 3, 'black', board)
        rook2 = Rook.new(0, 5, 'black', board)
        rook3 = Rook.new(6, 0, 'black', board)
        board.instance_variable_set(:@pieces, [king, rook1, rook2, rook3])
        board.pieces.each(&:update_possible_moves)
      end

      it 'returns true' do
        expect(king.checkmate?).to be_truthy
      end
    end

    context 'when there is not checkmate' do
      before do
        king.update_possible_moves
        rook = Rook.new(0, 3, 'black', board)
        rook.update_possible_moves
        board.instance_variable_set(:@pieces, [king, rook])
      end

      it 'returns false' do
        expect(king.checkmate?).to be_falsey
      end
    end
  end

  describe '#kingside_castle_move' do
    let(:board) { Board.new }
    subject(:king) { described_class.new(7, 4, 'white', board) }

    it 'moves king to new position' do
      Rook.new(7, 7, 'white', board)
      king.kingside_castle_move
      expect(board.positions[7][6]).to be(king)
    end

    it 'moves rook to new position' do
      rook = Rook.new(7, 7, 'white', board)
      king.kingside_castle_move
      expect(board.positions[7][5]).to be(rook)
    end
  end

  describe '#queenside_castle_move' do
    let(:board) { Board.new }
    subject(:king) { described_class.new(7, 4, 'white', board) }

    it 'moves king to new position' do
      Rook.new(7, 0, 'white', board)
      king.queenside_castle_move
      expect(board.positions[7][2]).to be(king)
    end

    it 'moves rook to new position' do
      rook = Rook.new(7, 0, 'white', board)
      king.queenside_castle_move
      expect(board.positions[7][3]).to be(rook)
    end
  end
end
