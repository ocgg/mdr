class Text
  attr_reader :spans

  def initialize(formatted_string)
    @spans = format(formatted_string)
  end

  private

  TEXT_REGEXP = /
    # prefix
    (?<=(?<beforebegin>\W))?
    # opening tag
    (?<open_tag>\*\*\*|___|\*\*|__|\*|_|`|~~|~)
    # content
    (?<content>
      (?(<beforebegin>).|\w)
      .*?
      (?<beforeend>\w)?
    )
    # closing tag
    (?<close_tag>\k<open_tag>)
    # suffix
    (?=(?(<beforeend>).|\W)|$)
    .*?
  /x

  class Span
    def initialize(content, *styles)
      @content = content
      @styles = styles
    end
  end

  def delimiter_to_style(delimiter)
    case delimiter
    when "***", "___" then [:bold, :italic]
    when "**", "__" then [:bold]
    when "*", "_" then [:italic]
    when "~~", "~" then [:strike]
    when "`" then [:inline_code]
    # Should never reach this line
    else raise "Unknown delimiter '#{delimiter}'"
    end
  end

  def spans_from(string, results = [], styles = [])
    md = string.match(TEXT_REGEXP)
    unless md
      results << Span.new(string, *styles.flatten) unless string.empty?
      styles.pop # keep this here
      return results
    end

    beforematch = $`
    results << Span.new(beforematch, *styles.flatten) unless beforematch.empty?

    content = md[:content]
    delimiter = md[:open_tag]
    styles << delimiter_to_style(delimiter)
    spans_from(content, results, styles)

    aftermatch = $'
    spans_from(aftermatch, results, styles)
  end

  def format(string)
    string = string.strip.tr("\n", " ").squeeze(" ")
    spans_from(string)
  end
end
