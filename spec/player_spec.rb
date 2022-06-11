require_relative '../lib/player'

describe Player do
  describe '#input_move' do
    let(:board) { Board.new }
    subject(:player) { described_class.new('white', board) }

    it 'returns an array of coordinates for a valid normal input' do
      allow(player).to receive(:gets).and_return('a3')
      expect(player.input_move).to eq([WhitePawn, 5, 0])
    end

    it 'returns an array of coordinates for a castling special input' do
      allow(player).to receive(:gets).and_return('0-0')
      expect(player.input_move).to eq([King, 7, 6])
    end

    it 'loops until the player inputs a valid input' do
      allow(player).to receive(:gets).and_return('11', 'rook', 'Na1')
      # allow(player).to receive(:valid_input?).and_return(false, false, true)
      expect(player.input_move).to eq([Knight, 7, 0])
    end
  end

  describe '#find_piece' do
    let(:board) { Board.new }
    subject(:player) { described_class.new('white', board) }

    before do
      board.add_starting_pieces(player)
      board.update_all_possible_moves
    end

    it 'returns the piece that can make that move' do
      original_pawn = board.positions[6][0]
      move = [WhitePawn, 5, 0]
      expect(player.find_piece(move)).to be(original_pawn)
    end
  end

  describe '#play_turn' do
    let(:board) { Board.new }
    subject(:player) { described_class.new('white', board) }

    before do
      allow(board).to receive(:display)
      allow(player).to receive(:puts)
      allow(player).to receive(:input_move).and_return([WhitePawn, 5, 3])
    end

    context 'when player inputs a valid move that does not lead to check' do
      let(:piece) { double('piece', nil?: false, move: nil) }

      it 'sends #move to relevant piece' do
        allow(player).to receive(:find_piece).and_return(piece)
        allow(player).to receive(:check?).and_return(false)
        expect(piece).to receive(:move).with(5, 3)
        player.play_turn
      end
    end

    context 'when the player inputs an invalid move' do
      let(:piece) { double('piece', move:nil) }

      it 'loops until a valid move is inputted' do
        allow(piece).to receive(:nil?).and_return(true, false)
        allow(player).to receive(:find_piece).and_return(piece)
        allow(player).to receive(:check?).and_return(false)
        expect(piece).to receive(:nil?).twice
        player.play_turn
      end
    end

    context 'when the player inputs a move that leads to check' do
      let(:piece) { double('piece', move: nil, nil?: false) }

      it 'loops until player inputs a move that does not lead to check' do
        allow(player).to receive(:find_piece).and_return(piece)
        allow(player).to receive(:check?).and_return(true, false)
        expect(piece).to receive(:move).twice
        expect(piece).to receive(:undo_move)
        player.play_turn
      end
    end
  end
end
