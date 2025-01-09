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

    opts = {width: @width - 4, align: :center}
    title = content_to_lines(**opts).map do |line|
      "#{side} #{line} #{side}"
    end.join("\n")
    puts "#{upline}\n#{title}\n#{downline}"
  end
end
