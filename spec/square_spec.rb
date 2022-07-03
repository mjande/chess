# frozen_string_literal: true

require_relative '../lib/library'

describe Square do
  subject(:square) { described_class.new(3, 2) }

  describe '#axial_coordinates' do
    it 'returns all coordinates down with appropriate key' do
      expect(square.axial_coordinates[:down]).to contain_exactly(
        [4, 2], [5, 2], [6, 2], [7, 2]
      )
    end

    it 'returns all coordinates up with the appropriate key' do
      expect(square.axial_coordinates[:up]).to contain_exactly(
        [2, 2], [1, 2], [0, 2]
      )
    end

    it 'returns all coordinates to the left with the appropriate key' do
      expect(square.axial_coordinates[:left]).to contain_exactly([3, 1], [3, 0])
    end

    it 'returns all coordinates to the right with the appropriate key' do
      expect(square.axial_coordinates[:right]).to contain_exactly(
        [3, 3], [3, 4], [3, 5], [3, 6], [3, 7]
      )
    end
  end

  describe '#diagonal coordinates' do
    it 'returns all coordinates to the upper right with the appropriate key' do
      expect(square.diagonal_coordinates[:up_right]).to contain_exactly(
        [2, 3], [1, 4], [0, 5]
      )
    end

    it 'returns all coordinates to the upper left with the appropriate key' do
      expect(square.diagonal_coordinates[:up_left]).to contain_exactly(
        [2, 1], [1, 0]
      )
    end

    it 'returns all coordinates to the lower right with the appropriate key' do
      expect(square.diagonal_coordinates[:down_right]).to contain_exactly(
        [4, 3], [5, 4], [6, 5], [7, 6]
      )
    end

    it 'returns all coordinates to the lower left with the appropriate key' do
      expect(square.diagonal_coordinates[:down_left]).to contain_exactly(
        [4, 1], [5, 0]
      )
    end
  end

  describe '#adjacent_coordinates' do
    it 'returns an array of all adjacent coordinates' do
      expect(square.adjacent_coordinates).to contain_exactly(
        [2, 1], [2, 2], [2, 3], [3, 1], [3, 3], [4, 1], [4, 2], [4, 3]
      )
    end
  end

  describe '#knight_coordinates' do
    it 'returns an array of all coordinates accesible to a knight' do
      expect(square.knight_coordinates).to contain_exactly(
        [1, 1], [1, 3], [2, 4], [4, 4], [5, 1], [5, 3], [2, 0], [4, 0]
      )
    end
  end
end