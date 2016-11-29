require 'validator'

describe Validator do
  let(:input) { File.read(File.expand_path('../fixtures/easy.sudoku', __dir__)) }

  describe '#duplicates' do
    it 'returns an empty array if all the passed values are unique' do
      validator = Validator.new(input)

      expect(validator.send(:duplicates, [1, 2, 3, 4, 5, 6, 7, 8, 9])).to eq([])
    end

    it 'returns the repeated values in an array' do
      validator = Validator.new(input)

      expect(validator.send(:duplicates, [1, 2, 1, 2, 5, 6, 7, 8, 9])).to eq([1, 2])
    end
  end
end
