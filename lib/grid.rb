class Grid
  def initialize(rows)
    @rows = rows
  end

  def self.from_string(input)
    new(input
          .each_line
          .map { |line| line.scan(/\d/).map(&:to_i) }
          .select { |row| row.count == 9 })
  end

  def to_s
    @rows.map { |row| row.join(' ') }.join("\n")
  end

  def row(number)
    @rows[number]
  end

  def column(number)
    @rows.transpose[number]
  end

  def subgroup(x, y)
    from_col = 3 * x
    to_col = 3 * (x + 1)
    from_row = 3 * y
    to_row = 3 * (y + 1)

    (from_row...to_row).flat_map do |row|
      @rows[row][from_col...to_col]
    end
  end

  def incomplete?
    @rows.flatten.include?(0)
  end
end
