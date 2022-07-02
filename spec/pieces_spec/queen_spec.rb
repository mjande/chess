# frozen_string_literal: true

require_relative '../../lib/library'

describe Queen do
  let(:board) { Board.new }

  describe '#update_possible_moves' do
    context 'when the board is blank' do
      let(:center_queen) { described_class.new(4, 4, 'white', board) }
      let(:edge_queen) { described_class.new(7, 3, 'black', board) }

      before do
        white_king = King.new(0, 2, 'white', board)
        black_king = King.new(0, 5, 'black', board)
        board.instance_variable_set(:@pieces, [white_king, black_king])
        center_queen.update_possible_moves
        edge_queen.update_possible_moves
      end

      it 'updates possible moves from middle of the board' do
        expect(center_queen.possible_moves).to contain_exactly(
          [4, 3], [4, 2], [4, 1], [4, 0], [3, 3], [2, 2], [1, 1], [0, 0], [3, 4],
          [2, 4], [1, 4], [0, 4], [3, 5], [2, 6], [1, 7], [4, 5], [4, 6], [4, 7],
          [5, 5], [6, 6], [7, 7], [5, 4], [6, 4], [7, 4], [5, 3], [6, 2], [7, 1]
        )
      end

      it 'updates possible moves from the edge of the board' do
        expect(edge_queen.possible_moves).to contain_exactly(
          [7, 2], [7, 1], [7, 0], [6, 2], [5, 1], [4, 0], [6, 3], [5, 3],
          [4, 3], [3, 3], [2, 3], [1, 3], [0, 3], [6, 4], [5, 5], [4, 6],
          [3, 7], [7, 4], [7, 5], [7, 6], [7, 7]
        )
      end
    end

    context 'when there are other pieces on the board' do
      subject(:queen) { described_class.new(1, 4, 'black', board) }

      before do
        rook = Rook.new(5, 0, 'black', board)
        knight1 = Knight.new(4, 4, 'black', board)
        knight2 = Knight.new(1, 2, 'white', board)
        bishop = Bishop.new(3, 6, 'white', board)
        king = King.new(0, 7, 'black', board)
        board.instance_variable_set(:@pieces, [queen, rook, knight1, knight2, bishop, king])
        queen.update_possible_moves
      end

      it 'returns moves to capture different colored pieces' do
        expect(queen.possible_moves).to include([1, 2], [3, 6])
      end

      it 'does not return moves occupied by same-colored pieces' do
        expect(queen.possible_moves).not_to include([5, 0], [4, 4])
      end

      it 'does not return moves past other pieces' do
        expect(queen.possible_moves).not_to include([1, 1], [5, 4], [4, 7])
      end
    end

    context 'when there is a threat of check' do
      subject(:queen) { described_class.new(7, 3, 'white', board) }

      it 'adds no moves that result in check to @possible_moves' do
        king = King.new(7, 4, 'white', board)
        rook = Rook.new(7, 0, 'black', board)
        board.instance_variable_set(:@pieces, [queen, rook, king])
        queen.update_possible_moves
        expect(queen.possible_moves).not_to include([6, 2], [6, 3], [6, 4])
      end
    end
  end
end
