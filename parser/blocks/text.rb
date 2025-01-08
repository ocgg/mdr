class Span
  def initialize(content, *styles)
    @content = content
    @styles = styles
  end
end

class Text
  attr_reader :spans

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

  def initialize(formatted_string)
    @spans = format(formatted_string)
  end

  private

  def delimiter_to_style(content, delimiter)
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
    # pp "############\nCONTENT: #{format(content)}\n###############"
    delimiter = md[:open_tag]
    styles << delimiter_to_style(content, delimiter)
    spans_from(content, results, styles)

    aftermatch = $'
    spans_from(aftermatch, results, styles)
    results
  end

  def format(string)
    string = string.strip.tr("\n", " ").squeeze(" ")
    spans_from(string)
  end
end
