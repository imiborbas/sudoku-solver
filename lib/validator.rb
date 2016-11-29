require_relative 'sudoku'

class Validator
  def initialize(puzzle_string)
    @sudoku = Sudoku.from_string(puzzle_string)
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate(verbose: false)
    if errors.empty?
      message = "This sudoku is valid#{@sudoku.incomplete? ? ', but incomplete.' : '.'}"
    else
      message = 'This sudoku is invalid.'
      if verbose
        message
          .concat("\n")
          .concat(errors.join("\n"))
          .concat("\n")
      end
    end

    message
  end

  private

  def row_errors
    (0...9).map do |i|
      dupes = duplicates(@sudoku.row(i))
      "Number(s) #{dupes} appear more than once in row #{i + 1}." unless dupes.empty?
    end.compact
  end

  def column_errors
    (0...9).map do |i|
      dupes = duplicates(@sudoku.column(i))
      "Number(s) #{dupes} appear more than once in column #{i + 1}." unless dupes.empty?
    end.compact
  end

  def subgroup_errors
    (0..2).flat_map do |y|
      (0..2).map do |x|
        dupes = duplicates(@sudoku.subgroup(x, y))
        "Number(s) #{dupes} appear more than once in subgroup #{x + 1}, #{y + 1}." unless dupes.empty?
      end
    end.compact
  end

  def errors
    row_errors + column_errors + subgroup_errors
  end

  def duplicates(group)
    group.uniq.select { |item| item > 0 && group.count(item) > 1 }
  end
end
