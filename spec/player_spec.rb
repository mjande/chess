require_relative '../lib/player'
require_relative '../lib/board'

describe Player do
  describe '#input_move' do
    let(:board) { double('board') }
    subject(:player) { described_class.new('white', board) }
    let(:whitepawn) { double('WhitePawn') }

    before do
      allow(player).to receive(:puts)
      allow(player).to receive(:convert_to_numbered_coordinates).and_return([7, 0])
      allow(player).to receive(:convert_to_class).and_return(whitepawn)
    end

    it 'returns an array of coordinates for a valid input' do
      allow(player).to receive(:gets).and_return('a1')
      allow(player).to receive(:valid_input?).and_return(true)
      expect(player.input_move).to eq([whitepawn, 7, 0])
    end

    it 'loops until the player inputs a valid input' do
      allow(player).to receive(:gets).and_return('11', 'rook', 'Na1')
      allow(player).to receive(:valid_input?).and_return(false, false, true)
      expect(player.input_move).to eq([whitepawn, 7, 0])
    end
  end

  describe '#valid_input?' do
    let(:board) { double('board') }
    subject(:input) { described_class.new('white', board) }

    it 'returns true if both coordinates are valid' do
      expect(input.valid_input?('P', 'a', 1)).to be_truthy
    end

    it 'returns false if the piece input is not valid' do
      expect(input.valid_input?('pawn', 'a', 1)).to be_falsey
    end

    it 'returns false if the column coordinate is not valid' do
      expect(input.valid_input?('N', '17', 1)).to be_falsey
    end

    it 'returns false if the row coordinate is not valid' do
      expect(input.valid_input?('B', 'a', 17)).to be_falsey
    end
  end

  describe '#convert_to_numbered_coordinates' do
    let(:board) { double('board') }
    subject(:coordinates) { described_class.new('white', board) }

    it 'returns [7, 0] for a1' do
      expect(coordinates.convert_to_numbered_coordinates('a', 1)).to eq([7, 0])
    end

    it 'returns [0, 7] for h8' do
      expect(coordinates.convert_to_numbered_coordinates('h', 8)).to eq([0, 7])
    end

    it 'returns [4, 3] for d4' do
      expect(coordinates.convert_to_numbered_coordinates('d', 4)).to eq([4, 3])
    end
  end

  describe '#search_for_move' do
    let(:board) { Board.new }
    subject(:player) { described_class.new('white', board) }

    before do
      player.add_pieces_to_board
    end

    xit 'returns the piece that can make that move' do
    end
  end
end