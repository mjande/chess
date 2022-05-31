require_relative '../../lib/library'

describe Piece do
  describe '#Piece.add_to_board' do
    let(:positions) { Array.new(8) { Array.new(7, nil)} }
    let(:board) { double('board', positions: positions) }

    it 'assigns pieces to starting position' do
      Rook.add_to_board('white', board)
      expect(board.positions[7][0]).to be_a(Rook)
      Bishop.add_to_board('black', board)
      expect(board.positions[0][2]).to be_a(Bishop)
    end

    it 'returns array of created piece objects' do
      result = Rook.add_to_board('white', board)
      expect(result).to all(be_a(Rook))
      expect(result.length).to eq(2)
    end
  end

  describe '#move' do
    let(:board) { Board.new }
    subject(:piece) { described_class.new(6, 0, 'white', board) }

    it 'removes self from previous position' do
      piece.move(5, 0)
      expect(board.positions[6][0]).to be_nil
    end

    it 'adds self to new position' do
      piece.move(5, 0)
      expect(board.positions[5][0]).to be(piece)
    end
  end
end