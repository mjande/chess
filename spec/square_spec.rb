require_relative '../lib/library'

describe Square do
  describe '#axial_coordinates' do
    subject(:square) { described_class.new(3, 2) }
    
    it 'returns all coordinates down in appropriate key' do
      expect(square.axial_coordinates[:down]).to contain_exactly(
        [4, 2], [5, 2], [6, 2], [7, 2]
      )
    end
  end
end