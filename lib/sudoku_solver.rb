require 'grid'
require 'solver_grid'

class SudokuSolver
  def initialize(puzzle_string)
    @grid = Grid.from_string(puzzle_string)
  end

  def self.solve(puzzle_string)
    new(puzzle_string).solve
  end

  def solve
    compute(@grid).tap do |grid|
      return grid.to_s unless grid.nil?
    end

    'This puzzle is not solvable.'
  end

  private

  def compute(grid)
    solver_grid = SolverGrid.new(grid)
    solver_grid.attempt!

    return nil unless solver_grid.solvable?

    return grid if grid.complete?

    solver_grid.easiest_unsolved_cell.tap do |cell|
      cell.possible_values.each do |value|
        experimental_grid = grid.copy
        experimental_grid.set(cell.x, cell.y, value)

        compute(experimental_grid).tap do |result|
          return result unless result.nil?
        end
      end
    end

    nil
  end
end
