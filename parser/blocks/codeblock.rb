require_relative "block"

class Codeblock < Block
  def format(content)
    @lang = content.slice(/^```\w*/)[3..]
    @code = content.lines[1..-2].join.gsub('"', %(\\")).gsub("`", %(\\\\`)).chomp
    content
  end

  def render(**opts)
    @width = opts[:width]
    lang_opt = @lang.empty? ? "" : "-l #{@lang}"
    bat_opts = "-fP --style=snip --theme='Visual Studio Dark+' #{lang_opt}"
    processed_code = `bat #{bat_opts} <<< "#{@code}"`.chomp

    code_to_lines(processed_code, @lang)
  end

  private

  def codeblock_separator(lang = nil)
    return "▀" * @width if lang.nil?

    right = lang.empty? ? "" : " #{lang} "
    left = "▄" * (@width - right.size)
    "#{left}#{right}"
  end
end
