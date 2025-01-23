require "tty-table"
require_relative "block"
require_relative "text"

class Table < Block
  attr_reader :rows, :alignments

  def render(**opts)
    @width = opts[:width]

    stylized_rows = @rows.map do |row|
      row.map { |text| spans_to_string(text.spans) }
    end

    table = TTY::Table.new(stylized_rows)
    table_options = {
      alignments: @alignments,
      multiline: true,
      resize: true,
      padding: [0, 1, 0, 1],
      width: @width,
      border: {
        separator: :each_row,
        style: :dark
      }
    }

    table.render(:unicode, table_options)
  end

  private

  def format(str)
    @rows = str.split("\n").map.with_index do |row, i|
      row = row.split("|")[1..]
      next row if i == 1 # table separator

      if i.zero?
        row.map { |text| Text.new(text, default_styles: [:bold]) }
      else
        row.map { |text| Text.new(text) }
      end
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
