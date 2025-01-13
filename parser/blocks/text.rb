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
    (?<open_tag>\*\*\*|___|\*\*|__|\*|_|``|`|~~|~)
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

  def initialize(string, **opts)
    @styles = opts[:default_styles] || []
    @spans = string ? format(string) : []
  end

  def append_str(string) = spans_from(string)

  def prepend_span(span)
    @spans.unshift(span)
  end

  private

  def delimiter_to_style(delimiter)
    case delimiter
    when "***", "___" then [:bold, :italic]
    when "**", "__" then [:bold]
    when "*", "_" then [:italic]
    when "~~", "~" then [:strike]
    when "``", "`" then [:inline_code]
    # Should never reach this line
    else raise "Unknown delimiter '#{delimiter}'"
    end
  end

  def spans_from(string)
    return @results if string.empty?

    md = string.match(TEXT_REGEXP)

    # TODO: this logic should be in the TextRenderer, not at format stage.
    # let's keep it like this while we use tty-tables for table rendering
    if @styles.include?(:inline_code)
      @results << Span.new("🭒", :inline_code_around)
      @results << Span.new(string, *@styles)
      @results << Span.new("🭌", :inline_code_around)
      return @results
    elsif md.nil? || @styles.include?(:inline_code)
      @results << Span.new(string, *@styles)
      return @results
    end

    beforematch = $`
    @results << Span.new(beforematch, *@styles) unless beforematch.empty?

    # Get spans from inner match content
    content = md[:content]
    delimiter = md[:open_tag]
    @styles += delimiter_to_style(delimiter)
    spans_from(content)
    @styles.pop # keep this here

    # Then from the rest of the string
    aftermatch = $'
    spans_from(aftermatch)
  end

  def format(string)
    @results = []
    string = string.strip.tr("\n", " ").squeeze(" ")
    spans_from(string)
  end
end
