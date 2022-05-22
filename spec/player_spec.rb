require_relative '../lib/player'

describe Player do
  describe '#input_move' do
    subject(:player) { described_class.new }
    
    it 'returns an array of coordinates for a valid input' do
      allow(player).to receive(:puts)
      allow(player).to receive(:gets).and_return('a1')
      allow(player).to receive(:valid_input?).and_return(true)
      allow(player).to receive(:convert_to_indices).and_return([7, 0])
      expect(player.input_move).to eq([7, 0])
    end
  end
end