require 'solver_grid'
require 'grid'

describe SolverGrid do
  let(:input) { File.read(File.expand_path('../fixtures/hard.sudoku', __dir__)) }
  let(:unsolvable_input) { File.read(File.expand_path('../fixtures/unsolvable.sudoku', __dir__)) }

  describe '#new' do
    it 'returns a new SolverGrid' do
      grid = Grid.from_string(input)

      solver_grid = SolverGrid.new(grid)

      expect(solver_grid.class).to eq(SolverGrid)
    end
  end

  describe '#cell' do
    it 'returns the possible values for the given cell' do
      solver_grid = SolverGrid.new(Grid.from_string(input))
      solver_grid.attempt!

      cell = solver_grid.cell(1, 2)

      expect(cell).to eq([1, 5, 6, 8, 9])
    end
  end

  describe '#row' do
    it 'returns an array of the possible values for each cell in the given row' do
      solver_grid = SolverGrid.new(Grid.from_string(input))
      solver_grid.attempt!

      row = solver_grid.row(6)

      expect(row).to eq([[2, 8, 9], [8, 9], [2, 8, 9], [6], [4, 5, 9], [3], [1, 2, 5, 9], [7], [1, 2, 4, 8, 9]])
    end

    it 'returns an array of the possible values for each cell in the given row, except for the specified column' do
      solver_grid = SolverGrid.new(Grid.from_string(input))
      solver_grid.attempt!

      row = solver_grid.row(6, except_column: 3)

      expect(row).to eq([[2, 8, 9], [8, 9], [2, 8, 9], [4, 5, 9], [3], [1, 2, 5, 9], [7], [1, 2, 4, 8, 9]])
    end
  end

  describe '#column' do
    it 'returns an array of the possible values for each cell in the given column' do
      solver_grid = SolverGrid.new(Grid.from_string(input))
      solver_grid.attempt!

      column = solver_grid.column(4)

      expect(column).to eq([
        [2, 3, 6, 9], [2, 4, 5, 6, 9], [2, 3, 4, 5, 6, 9], [3, 4, 5, 7, 9], [8], [1], [4, 5, 9], [4, 7, 9], [5, 7, 9]
      ])
    end

    it 'returns an array of the possible values for each cell in the given column, except for the specified row' do
      solver_grid = SolverGrid.new(Grid.from_string(input))
      solver_grid.attempt!

      column = solver_grid.column(4, except_row: 2)

      expect(column).to eq([
        [2, 3, 6, 9], [2, 4, 5, 6, 9], [3, 4, 5, 7, 9], [8], [1], [4, 5, 9], [4, 7, 9], [5, 7, 9]
      ])
    end
  end

  describe '#box' do
    it 'returns an array of the possible values for each cell in the given box' do
      solver_grid = SolverGrid.new(Grid.from_string(input))
      solver_grid.attempt!

      box = solver_grid.box(2, 1)

      expect(box).to eq([
        [1, 3, 5, 7, 9], [6],             [1, 3, 7, 8, 9],
        [4],             [1, 2, 3, 5, 9], [1, 2, 3, 7, 9],
        [2, 3, 5, 7, 9], [2, 3, 5, 8, 9], [2, 3, 7, 8, 9]
      ])
    end

    it 'returns an array of the possible values for each cell in the given box, except for the specified cell' do
      solver_grid = SolverGrid.new(Grid.from_string(input))
      solver_grid.attempt!

      box = solver_grid.box(2, 1, except_at: [8, 4])

      expect(box).to eq([
        [1, 3, 5, 7, 9], [6],             [1, 3, 7, 8, 9],
        [4],             [1, 2, 3, 5, 9],
        [2, 3, 5, 7, 9], [2, 3, 5, 8, 9], [2, 3, 7, 8, 9]
      ])
    end
  end

  describe '#attempt!' do
    let (:solution_state) {
      [
        '    4     |   1679    |   12679   |    139    |   2369    |    269    |     8     |   1239    |     5    ',
        '----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+----------',
        '  26789   |     3     |  1256789  |   14589   |   24569   |  245689   |   12679   |   1249    |  124679  ',
        '----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+----------',
        '  2689    |   15689   |  125689   |     7     |  234569   |  245689   |   12369   |   12349   |  123469  ',
        '----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+----------',
        '  3789    |     2     |   15789   |   3459    |   34579   |   4579    |   13579   |     6     |   13789  ',
        '----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+----------',
        '  3679    |   15679   |   15679   |    359    |     8     |   25679   |     4     |   12359   |   12379  ',
        '----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+----------',
        '  36789   |     4     |   56789   |    359    |     1     |   25679   |   23579   |   23589   |   23789  ',
        '----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+----------',
        '   289    |    89     |    289    |     6     |    459    |     3     |   1259    |     7     |   12489  ',
        '----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+----------',
        '    5     |   6789    |     3     |     2     |    479    |     1     |    69     |    489    |   4689   ',
        '----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+----------',
        '    1     |   6789    |     4     |    589    |    579    |   5789    |   23569   |   23589   |   23689  '
      ].join("\n")
    }

    it 'figures out as many values as possible from the current state of the grid' do
      solver_grid = SolverGrid.new(Grid.from_string(input))

      solver_grid.attempt!

      expect(solver_grid.to_s).to eq(solution_state)
    end

    it 'updates the underlying grid with the newly found values' do
      grid = Grid.from_string(input)
      solver_grid = SolverGrid.new(grid)

      solver_grid.attempt!

      expect(grid.get(1, 5)).to eq(4)
    end
  end

  describe '#easiest_unsolved_cell' do
    it 'returns a Grid::UnsolvedCell instance' do
      solver_grid = SolverGrid.new(Grid.from_string(input))
      solver_grid.attempt!

      result = solver_grid.easiest_unsolved_cell

      expect(result.class).to eq(SolverGrid::UnsolvedCell)
    end

    it 'returns the cell with the least number of possibilities' do
      solver_grid = SolverGrid.new(Grid.from_string(input))
      solver_grid.attempt!

      result = solver_grid.easiest_unsolved_cell

      expect(result.possible_values.count).to eq(2)
    end
  end

  describe '#solvable?' do
    it 'returns true if the grid is in a solvable state' do
      solver_grid = SolverGrid.new(Grid.from_string(input))
      solver_grid.attempt!

      result = solver_grid.solvable?

      expect(result).to eq(true)
    end

    it 'returns false if the grid is not in a solvable state' do
      solver_grid = SolverGrid.new(Grid.from_string(unsolvable_input))
      solver_grid.attempt!

      result = solver_grid.solvable?

      expect(result).to eq(false)
    end
  end
end
