require_relative '../../lib/library'

describe Bishop do
  describe '#possible_moves' do
    let(:board) { Board.new }
    
    context 'when the board is blank' do
      it 'returns an array of all possible moves' do
        c_bishop = described_class.new(7, 2, 'white', board)
        expect(c_bishop.possible_moves).to contain_exactly([6, 1], [5, 0], [6, 3], [5, 4], [4, 5], [3, 6], [2, 7])
      end

      it 'returns an array of all possible moves' do
        c_bishop = described_class.new(0, 2, 'black', board)
        expect(c_bishop.possible_moves).to contain_exactly([1, 1], [2, 0], [1, 3], [2, 4], [3, 5], [4, 6], [5, 7])
      end
    end

    context 'there are other pieces on the board' do
      it 'returns moves up to blocking pieces and including different colored pieces' do 
        f_bishop = described_class.new(0, 5, 'black', board)
        Rook.new(2, 7, 'white', board)
        Knight.new(2, 3, 'black', board)
        expect(f_bishop.possible_moves).to contain_exactly([1, 4], [1, 6], [2, 7])
      end
    end
  end
end 


  

