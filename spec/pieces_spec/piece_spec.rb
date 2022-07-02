# frozen_string_literal: true

require_relative '../../lib/library'

describe Piece do
  describe '#Piece.add_white_pieces_to_board' do
    let(:board) { Board.new }

    it 'assigns pieces to starting squares' do
      Rook.add_white_pieces_to_board(board)
      expect(board.square(7, 0).piece).to be_a(Rook)
    end

    it 'adds created pieces to board.pieces' do
      Bishop.add_white_pieces_to_board(board)
      expect(board.pieces).to include(a_kind_of(Bishop)).twice
    end
  end

  describe '#Piece.add_black_pieces_to_board' do
    let(:board) { Board.new }

    it 'assigns pieces to starting squares' do
      Knight.add_black_pieces_to_board(board)
      expect(board.square(0, 1).piece).to be_a(Knight)
    end

    it 'adds created pieces to board.pieces' do
      Queen.add_black_pieces_to_board(board)
      expect(board.pieces).to include(a_kind_of(Queen)).once
    end
  end

  describe '#move' do
    let(:board) { Board.new }

    context 'when moving to an unoccopied square' do
      subject(:piece) { described_class.new(6, 0, 'white', board) }

      before do
        piece.move(board.square(5, 0))
      end

      it 'removes self from previous square' do
        expect(board.square(7, 0)).to be_open
      end

      it 'adds self to new square' do
        expect(board.square(5, 0).piece).to be(piece)
      end

      it 'updates current row' do
        expect(piece.row).to eq(5)
      end

      it 'adds to moves_since_capture counter' do
        expect { piece.move(board.square(4, 0)) }.to change(board, :moves_since_capture).by(1)
      end
    end

    context 'when capturing another piece' do
      subject(:piece) { described_class.new(7, 0, 'white', board) }

      let(:other_piece) { described_class.new(5, 0, 'black', board) }

      before do
        board.instance_variable_set(:@pieces, [piece, other_piece])
        piece.move(board.square(5, 0))
      end

      it 'removes captured piece from board.pieces' do
        expect(board.pieces).not_to include(other_piece)
      end

      it 'resets moves_since_capture to zero' do
        expect(board.moves_since_capture).to eq(0)
      end
    end
  end
end
