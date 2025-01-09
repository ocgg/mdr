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
    opts = (@level < 6) ? {default_styles: [:bold]} : {}
    Text.new(string, **opts)
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
    opts = {width: @width - 4, align: :center}
    title = content_to_lines(**opts).map do |line|
      "#{side} #{line} #{side}"
    end.join("\n")
    puts "#{upline}\n#{title}\n#{downline}"
  end
end
