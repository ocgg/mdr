require "tty-table"
require_relative "block"
require_relative "text"

class Table < Block
  attr_reader :rows, :alignments

  private

  def format(str)
    @rows = str.split("\n").map.with_index do |row, i|
      row = row.split("|")[1..]
      next row if i == 1 # table separator

      row.map { |text| Text.new(text) }
    end

    @alignments = @rows.delete_at(1).map do |alignment|
      left = alignment[0] == ":"
      right = alignment[-1] == ":"
      if left && right then :center
      elsif right then :right
      else
        :left
      end
    end
  end
end
