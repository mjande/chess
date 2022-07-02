# frozen_string_literal: true

require_relative '../lib/library'

describe Board do
  subject(:board) { described_class.new }

  describe '#add_starting_pieces' do
    before do
      board.add_starting_pieces
    end

    it 'adds at least one piece to its starting square on board' do
      expect(board.square(0, 0).piece).to be_a(Rook)
    end

    it 'adds other pieces to their starting squares on the board' do
      expect(board.square(7, 4).piece).to be_a(King)
    end

    it 'adds pieces to @pieces array' do
      expect(board.pieces).to include(a_kind_of(Pawn)).exactly(16).times
    end
  end

  describe '#update_all_possible_moves' do
    let(:pawn) { instance_double('Pawn', update_possible_moves: nil) }
    let(:knight) { instance_double('Knight', update_possible_moves: nil) }
    let(:queen) { instance_double('Queen', update_possible_moves: nil) }
    let(:king) { instance_double('King', update_possible_moves: nil) }

    before do
      allow(king).to receive(:instance_of?).with(King).and_return(true)
      board.instance_variable_set(:@pieces, [pawn, knight, queen, king])
      board.update_all_possible_moves
    end

    it 'sends update_possible_moves to at least one piece' do
      expect(pawn).to have_received(:update_possible_moves)
    end

    it 'sends update_possible_moves to other pieces' do
      expect(knight).to have_received(:update_possible_moves)
    end

    it 'sends king pieces update_possible_moves independently after others' do
      expect(king).to have_received(:update_possible_moves).twice
    end
  end

  describe '#no_possible_moves?' do
    context 'when there are no possible moves for white' do
      let(:board) { described_class.new }
      let(:player) { instance_double('Player', color: 'white') }
      let(:piece) do
        instance_double('Piece', color: 'white', possible_moves: [])
      end

      before do
        board.instance_variable_set(:@pieces, [piece])
      end

      it 'returns true' do
        expect(board).to be_no_possible_moves(player)
      end
    end

    context 'when there are no possible moves for black' do
      let(:player) { instance_double('Player', color: 'black') }
      let(:black_king) do
        instance_double('King', color: 'black', possible_moves: [])
      end
      let(:white_queen) do
        instance_double('Queen', color: 'white',
                                 possible_moves: [[1, 2], [1, 3]])
      end
      let(:white_king) do
        instance_double('King', color: 'white', possible_moves: [[2, 2]])
      end

      it 'returns true' do
        board.instance_variable_set(:@pieces, [black_king, white_king,
                                               white_queen])
        expect(board).to be_no_possible_moves(player)
      end
    end

    context 'when there are still possible moves on the board' do
      let(:player) { instance_double('Player', color: 'white') }
      let(:piece) do
        instance_double('Piece', color: 'white',
                                 possible_moves: [[1, 1], [7, 1]])
      end

      it 'returns false' do
        board.instance_variable_set(:@pieces, [piece])
        expect(board).not_to be_no_possible_moves(player)
      end
    end
  end

  describe '#dead_position?' do
    let(:white_king) { King.new(7, 4, 'white', board) }
    let(:black_king) { King.new(0, 4, 'black', board) }

    context 'when there are two same-colored bishops and both kings on the board' do
      let(:white_bishop) { Bishop.new(7, 2, 'white', board) }
      let(:black_bishop) { Bishop.new(0, 5, 'black', board) }

      it 'returns true' do
        board.instance_variable_set(:@pieces, [white_king, white_bishop,
                                               black_king, black_bishop])
        expect(board).to be_dead_position
      end
    end

    context 'when there is a single bishop and both kings on the board' do
      let(:white_bishop) { Bishop.new(7, 2, 'white', board) }

      it 'returns true' do
        board.instance_variable_set(:@pieces, [white_king, black_king,
                                               white_bishop])
        expect(board).to be_dead_position
      end
    end

    context 'when there is a single knight and both kings on the board' do
      let(:white_knight) { Knight.new(7, 6, 'white', board) }

      it 'returns true' do
        board.instance_variable_set(:@pieces, [white_king, black_king,
                                               white_knight])
        expect(board).to be_dead_position
      end
    end

    context 'when there are three pieces that do not result in a dead position' do
      let(:black_queen) { Queen.new(0, 3, 'black', board) }

      it 'returns false' do
        board.instance_variable_set(:@pieces, [white_king, black_king,
                                               black_queen])
        expect(board).not_to be_dead_position
      end
    end

    context 'when there are four pieces on the board that do no result in a dead position' do
      let(:white_bishop) { Bishop.new(7, 2, 'white', board) }
      let(:white_rook) { Rook.new(7, 0, 'white', board) }

      it 'returns false' do
        board.instance_variable_set(:@pieces, [white_king, white_bishop,
                                               white_rook, black_king])
        expect(board).not_to be_dead_position
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
        expect(board).not_to be_dead_position
      end
    end
  end

  describe '#threefold_repetition?' do
    subject(:board) { described_class.new }

    it 'is able to compare different positions successfully' do
      board.add_starting_pieces
      3.times { board.log_position }
      expect(board.log[0]).to eq(board.log[1])
    end

    it 'returns true when there is threefold repetition' do
      board.add_starting_pieces
      3.times { board.log_position }
      expect(board).to be_threefold_repetition
    end

    it 'returns flase if there is not threefold_repetition' do
      board.add_starting_pieces
      2.times { board.log_position }
      expect(board).not_to be_threefold_repetition
    end
  end
end
