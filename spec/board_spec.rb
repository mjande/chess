require './lib/board'

describe Board do
  describe '#add_starting_pieces' do
    subject(:board) { described_class.new }
    

    it 'sends #add_white_pieces_to_board to each type of piece' do
      expect(Rook).to receive(:add_white_pieces_to_board)
      expect(Knight).to receive(:add_white_pieces_to_board)
      expect(Bishop).to receive(:add_white_pieces_to_board)
      expect(Queen).to receive(:add_white_pieces_to_board)
      expect(King).to receive(:add_white_pieces_to_board)
      expect(Pawn).to receive(:add_white_pieces_to_board)
      board.add_starting_pieces
    end
  end
end
