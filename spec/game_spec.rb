require_relative '../lib/library'

describe Game do
  describe '#check?' do
    subject(:game) { described_class.new }
    let(:board) { Board.new }

    context 'when white is in check' do
      let(:white_king) { King.new(7, 4, 'white', board) }

      before do
        game.instance_variable_set(:@white_pieces, [white_king])
        rook = Rook.new(1, 4, 'black', board)
        black_king = King.new(0, 4, 'black', board)
        game.instance_variable_set(:@black_pieces, [black_king, rook])
      end

      it 'returns true' do
        expect(game.check?(white_king)).to be_truthy
      end
    end
    
    context 'when black is in check' do

      let(:black_king) { King.new(0, 4, 'black', board) }

      before do
        white_king = King.new(7, 4, 'white', board)
        bishop = Bishop.new(3, 1, 'white', board)
        game.instance_variable_set(:@white_pieces, [white_king, bishop])
        game.instance_variable_set(:@black_pieces, [black_king])
      end

      it 'returns true' do
        expect(game.check?(black_king)).to be_truthy
      end
    end

    context 'there is no check' do
      let(:white_king) { King.new(7, 4, 'white', board) }
      let(:black_king) { King.new(0, 4, 'black', board) }

      it 'returns false' do
        game.instance_variable_set(:@white_pieces, [white_king])
        game.instance_variable_set(:@black_pieces, [black_king])
        expect(game.check?(black_king)).to be_falsey
        expect(game.check?(white_king)).to be_falsey
      end
    end
  end

  describe '#checkmate?' do
    subject(:game) { described_class.new }
    
    context 'when there is checkmate' do
      let(:board) { Board.new }
      
      before do
        king = King.new(7, 4, 'white', board)
        game.instance_variable_set(:@white_pieces, [king])
        rook1 = Rook.new(0, 3, 'black', board)
        rook2 = Rook.new(0, 5, 'black', board)
        rook3 = Rook.new(6, 0, 'black', board)
        game.instance_variable_set(:@black_pieces, [rook1, rook2, rook3])
      end

      it 'returns the checkmated color' do
        expect(game.checkmate?).to eq('white')
      end
    end
  end
end