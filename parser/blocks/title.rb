require_relative "block"

class Title < Block
  attr_reader :level

  def render(**opts)
    @width = opts[:width]
    send(:"h#{@level}")
  end

  private

  def format(string)
    sharps = string.slice!(/^#* /).size - 1
    @level = sharps
    Text.new(string)
  end

  # RENDERING #################################################################

  def h1
    upline = "┌#{"─" * (@width - 2)}┐"
    downline = "└#{"─" * (@width - 2)}┘"
    side = "│"
    # midlines = to_lines(str[2..], @width - 2).map do |line|
    #   line = line.center(@width - 2 - 2) # -2 for sides, -2 for spaces
    #   line = render_txt(line, BOLD)
    #   "#{side} #{line} #{side}"
    # end.join("\n")
    # "#{upline}\n#{midlines}\n#{downline}"

    # TODO: stylize and columnize
    title = @content.spans.map(&:content).join.center(@width - 4)
    midline = "#{side} #{title} #{side}"
    puts "#{upline}\n#{midline}\n#{downline}"
  end
end
