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

    upline = codeblock_separator(@lang)
    downline = codeblock_separator
    processed_code = `bat #{bat_opts} <<< "#{@code}"`.chomp

    # This code shouldnt be here
    # pp processed_code
    processed_code.gsub!(/(\e\[0m)/, "\1\e[48;2;45;45;45;m")

    # bgcol = esc_seq_from(CODE_BG)
    # opts = {
    #   bg_color: {seq: bgcol, fill: true},
    #   pad_x: 1,
    #   keep_indent: true
    # }
    # processed_code = to_lines_with_style(processed_code, **opts).join("\n")

    "#{upline}\n#{processed_code}\n#{downline}"
  end

  private

  def codeblock_separator(lang = nil)
    return "▀" * @width if lang.nil?

    right = lang.empty? ? "" : " #{lang} "
    left = "▄" * (@width - right.size)
    "#{left}#{right}"
  end
end
