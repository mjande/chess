require_relative '../lib/library'

describe Board do
  describe '#add_starting_pieces' do
    subject(:board) { described_class.new }

    before do
      board.add_starting_pieces
    end

    it 'adds pieces to different squares on board' do
      expect(board.square(0, 0).piece).to be_a(Rook)
      expect(board.square(7, 4).piece).to be_a(King)
      expect(board.square(1, 3).piece).to be_a(Pawn)
      expect(board.square(7, 6).piece).to be_a(Knight)
    end

    it 'adds pieces to @pieces array' do
      expect(board.pieces).to include(a_kind_of(Pawn)).exactly(16).times
      expect(board.pieces).to include(a_kind_of(Bishop)).exactly(4).times
      expect(board.pieces).to include(a_kind_of(Queen)).twice
    end
  end

  describe '#update_all_possible_moves' do
    subject(:board) { described_class.new }
    let(:pawn) { double('pawn', update_possible_moves: nil) }
    let(:knight) { double('knight', update_possible_moves: nil) }
    let(:queen) { double('queen', update_possible_moves: nil) }
    let(:king) { double('king', update_possible_moves: nil) }

    before do
      board.instance_variable_set(:@pieces, [pawn, knight, queen, king])
    end

    it 'sends update_possible_moves to all pieces' do
      expect(pawn).to receive(:update_possible_moves)
      expect(knight).to receive(:update_possible_moves)
      expect(queen).to receive(:update_possible_moves)
      board.update_all_possible_moves
    end

    it 'sends king pieces update_possible_moves independently after others' do
      allow(king).to receive(:instance_of?).with(King).and_return(true)
      expect(king).to receive(:update_possible_moves).twice
      board.update_all_possible_moves
    end
  end

  describe '#no_possible_moves?' do
    context 'when there are no possible moves for white' do
      let(:board) { described_class.new }
      let(:player) { double('player', color: 'white') }
      let(:piece) { double('piece', color: 'white', possible_moves: []) }

      before do
        board.instance_variable_set(:@pieces, [piece])
      end

      it 'returns true' do
        expect(board.no_possible_moves?(player)).to be_truthy
      end
    end

    context 'when there are no possible moves for black' do
      subject(:board) { described_class.new }
      let(:player) { double('player', color: 'black') }
      let(:black_king) { double('black_king', color: 'black', possible_moves: []) }
      let(:white_queen) { double('white_queen', color: 'white', possible_moves: [[1, 2], [1, 3]]) }
      let(:white_king) { double('white_king', color: 'white', possible_moves: [[2, 2]]) }

      it 'returns true' do
        board.instance_variable_set(:@pieces, [black_king, white_king,
                                               white_queen])
        expect(board.no_possible_moves?(player)).to be_truthy
      end
    end

    context 'when there are still possible moves on the board' do
      subject(:board) { described_class.new }
      let(:player) { double('player', color: 'white') }
      let(:piece) { double('piece', color: 'white', possible_moves: [[1, 1], [7, 1]]) }

      it 'returns false' do
        board.instance_variable_set(:@pieces, [piece])
        expect(board.no_possible_moves?(player)).to be_falsey
      end
    end
  end

  describe '#dead_position?' do
    subject(:board) { described_class.new }
    let(:white_king) { King.new(7, 4, 'white', board) }
    let(:black_king) { King.new(0, 4, 'black', board) }
    
    context 'when there are two same-colored bishops and both kings on the board' do
      subject(:board) { described_class.new }
      let(:white_bishop) { Bishop.new(7, 2, 'white', board) }
      let(:black_bishop) { Bishop.new(0, 5, 'black', board) }

      it 'returns true' do
        board.instance_variable_set(:@pieces, [white_king, white_bishop,
                                               black_king, black_bishop])
        expect(board.dead_position?).to be_truthy
      end
    end

    context 'when there is a single bishop and both kings on the board' do
      let(:white_bishop) { Bishop.new(7, 2, 'white', board) }

      it 'returns true' do
        board.instance_variable_set(:@pieces, [white_king, black_king,
                                               white_bishop])
        expect(board.dead_position?).to be_truthy
      end
    end

    context 'when there is a single knight and both kings on the board' do
      let(:white_knight) { Knight.new(7, 6, 'white', board) }

      it 'returns true' do
        board.instance_variable_set(:@pieces, [white_king, black_king,
                                               white_knight])
        expect(board.dead_position?).to be_truthy
      end
    end

    context 'when there are three pieces that do not result in a dead position' do
      let(:black_queen) { Queen.new(0, 3, 'black', board) }

      it 'returns false' do
        board.instance_variable_set(:@pieces, [white_king, black_king, 
                                               black_queen])
        expect(board.dead_position?).to be_falsey
      end
    end

    context 'when there are four pieces on the board that do no result in a dead position' do
      let(:white_bishop) { Bishop.new(7, 2, 'white', board) }
      let(:white_rook) { Rook.new(7, 0, 'white', board) }

      it 'returns false' do
        board.instance_variable_set(:@pieces, [white_king, white_bishop,
                                               white_rook, black_king])
        expect(board.dead_position?).to be_falsey
      end
    end

    context 'when there are five or more pieces on the board' do
      let(:white_bishop) { Bishop.new(7, 2, 'white', board) }
      let(:black_bishop) { Bishop.new(0, 5, 'black', board) }
      let(:white_knight) { Knight.new(7, 1, 'white', board) }

      it 'returns false' do
        board.instance_variable_set(:@pieces, [white_king, white_bishop,
                                               white_knight, black_king,
                                               black_bishop])
        expect(board.dead_position?).to be_falsey
      end
    end
  end

  describe '#threefold_repetition?' do
    subject(:board) { described_class.new }

    it 'is able to compare different positions successfully' do
      board.add_starting_pieces
      # board.update_all_possible_moves
      3.times { board.log_position }
      expect(board.log[0]).to eq(board.log[1])
    end

    it 'returns true when there is threefold repetition' do
      board.add_starting_pieces
      board.update_all_possible_moves
      3.times { board.log_position }
      expect(board).to be_threefold_repetition
    end

    it 'returns flase if there is not threefold_repetition' do
      board.add_starting_pieces
      board.update_all_possible_moves
      2.times { board.log_position }
      expect(board.threefold_repetition?).to be_falsey
    end
  end
end
