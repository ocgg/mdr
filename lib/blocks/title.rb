require_relative "block"

class Title < Block
  attr_reader :level

  def render(**opts)
    @width = opts[:width]
    case @level
    when 1 then h1
    when 2 then h2
    else
      generic_title
    end
  end

  private

  def format(string)
    if string.match?(/^ *#/)
      sharps = string.slice!(/^#* /).size - 1
      @level = sharps
    else
      sign = string.rstrip[-1]
      @level = (sign == "=") ? 1 : 2
      lines = string.split(/((?:.(?:\\\n)?)*?)\n/).reject(&:empty?)
      string = lines[..-2].join
    end
    opts = case @level
    when 1 then {default_styles: [:bold]}
    when 2 then {default_styles: [:bold]}
    when 3 then {default_styles: [:bold, :underline]}
    when 4 then {default_styles: [:underline]}
    when 5 then {default_styles: [:bold, :dim]}
    when 6 then {default_styles: [:dim]}
    end
    Text.new(string, **opts)
  end

  # RENDERING #################################################################

  def generic_title = content_to_lines.join("\n")

  def h2
    downline = "─" * @width
    title = content_to_lines.join("\n")
    "#{title}\n#{downline}"
  end

  def h1
    upline = "┌#{"─" * (@width - 2)}┐"
    downline = "└#{"─" * (@width - 2)}┘"
    side = "│"

    opts = {width: @width - 4, align: :center}
    title = content_to_lines(**opts).map do |line|
      "#{side} #{line} #{side}"
    end.join("\n")
    "#{upline}\n#{title}\n#{downline}"
  end
end
