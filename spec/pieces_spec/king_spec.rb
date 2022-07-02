# frozen_string_literal: true

require_relative '../../lib/library'

describe King do
  let(:board) { Board.new }

  describe '#update_possible_moves' do
    context 'when on a blank board' do
      let(:center_king) { described_class.new(4, 3, 'white', board) }
      let(:edge_king) { described_class.new(7, 4, 'white', board) }

      before do
        board.instance_variable_set(:@pieces, [center_king, edge_king])
      end

      it 'updates possible moves from middle of the board' do
        center_king.update_possible_moves
        expect(center_king.possible_moves).to contain_exactly(
          [3, 2], [3, 3], [3, 4], [4, 2], [4, 4], [5, 2], [5, 3], [5, 4]
        )
      end

      it 'updates possible moves from the edge of the board' do
        edge_king.update_possible_moves
        expect(edge_king.possible_moves).to contain_exactly(
          [7, 3], [6, 3], [6, 4], [6, 5], [7, 5]
        )
      end
    end

    context 'when there are other pieces on the board' do
      subject(:king) { described_class.new(7, 4, 'white', board) }

      before do
        bishop = Bishop.new(6, 4, 'black', board)
        queen = Queen.new(7, 3, 'white', board)
        board.instance_variable_set(:@pieces, [queen, bishop, king])
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
        rook1 = Rook.new(7, 0, 'white', board)
        rook2 = Rook.new(7, 7, 'white', board)
        board.instance_variable_set(:@pieces, [king, rook1, rook2])
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

  describe '#checkmate?' do
    subject(:white_king) { described_class.new(7, 4, 'white', board) }

    context 'when there is checkmate' do
      before do
        rook1 = Rook.new(0, 3, 'black', board)
        rook2 = Rook.new(0, 5, 'black', board)
        rook3 = Rook.new(6, 0, 'black', board)
        rook4 = Rook.new(0, 4, 'black', board)
        black_king = described_class.new(0, 0, 'black', board)
        board.instance_variable_set(:@pieces, [white_king, black_king, rook1,
                                               rook2, rook3, rook4])
        board.update_all_possible_moves
      end

      it 'returns true' do
        expect(white_king).to be_checkmate
      end
    end

    context 'when there is not checkmate' do
      before do
        rook = Rook.new(0, 3, 'black', board)
        black_king = described_class.new(0, 0, 'black', board)
        board.instance_variable_set(:@pieces, [white_king, black_king, rook])
        white_king.update_possible_moves
        rook.update_possible_moves
      end

      it 'returns false' do
        expect(white_king).not_to be_checkmate
      end
    end
  end

  describe '#kingside_castle_move' do
    subject(:king) { described_class.new(7, 4, 'white', board) }

    it 'moves king to new square' do
      Rook.new(7, 7, 'white', board)
      king.kingside_castle_move
      expect(board.square(7, 6).piece).to be(king)
    end

    it 'moves rook to new square' do
      rook = Rook.new(7, 7, 'white', board)
      king.kingside_castle_move
      expect(board.square(7, 5).piece).to be(rook)
    end
  end

  describe '#queenside_castle_move' do
    subject(:king) { described_class.new(7, 4, 'white', board) }

    it 'moves king to new square' do
      Rook.new(7, 0, 'white', board)
      king.queenside_castle_move
      expect(board.square(7, 2).piece).to be(king)
    end

    it 'moves rook to new square' do
      rook = Rook.new(7, 0, 'white', board)
      king.queenside_castle_move
      expect(board.square(7, 3).piece).to be(rook)
    end
  end
end
