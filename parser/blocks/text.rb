class Span
  attr_reader :content, :styles

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

  def initialize(formatted_string, **opts)
    @styles = opts[:default_styles] || []
    @spans = formatted_string ? format(formatted_string) : []
  end

  def concatenate!(string)
    new_spans = spans_from(string)
    @spans += new_spans
  end

  private

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

  def spans_from(string, results = [], styles = @styles)
    md = string.match(TEXT_REGEXP)
    unless md
      unless string.empty?
        results << Span.new(string, *styles)
      end
      return results
    end

    beforematch = $`
    results << Span.new(beforematch, *styles) unless beforematch.empty?

    content = md[:content]
    delimiter = md[:open_tag]
    styles += delimiter_to_style(delimiter)
    spans_from(content, results, styles)
    styles.pop # keep this here

    aftermatch = $'
    spans_from(aftermatch, results, styles)
  end

  def format(string)
    string = string.strip.tr("\n", " ").squeeze(" ")
    spans_from(string)
  end
end
