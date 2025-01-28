require_relative "block"
require_relative "code_renderer"

class Codeblock < Block
  def render(**opts)
    @width = opts[:width]
    lang_opt = @lang.empty? ? "" : "-l #{@lang}"
    bat_opts = "-f --style=snip --theme='Visual Studio Dark+' #{lang_opt}"
    processed_code = `bat #{bat_opts} <<< "#{@code}"`.chomp

    code_to_lines(processed_code, @lang)
  end

  private

  def format(content)
    @lang = content.slice(/^```\w*/)[3..]
    @code = content.lines[1..-2].join
      .gsub("\\", "\\\\\\\\")
      .gsub('"', %(\\"))
      .gsub("`", %(\\\\`))
      .chomp
    content
  end

  def code_to_lines(code, lang)
    renderer = CodeRenderer.new(@width)
    renderer.codeblock(code, lang)
  end
end
