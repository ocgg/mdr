require_relative "renderer"
require_relative "parser"

# This is the entry point and the main controller.
# Main receives a filepath at instanciation,
# Sends file content to the Parser which parses Block objects,
# Sends these blocks to the Renderer which returns an array of strings,
# Then displays the lines regarding to the CLI arguments received
class Main
  def initialize(md_filepath, **opts)
    term_width = `tput cols`.to_i
    left = find_left(term_width, opts)
    width = opts[:width] || term_width - left
    margin = opts[:margin]
    top = opts[:mtop] || margin&.div(2) || 0
    bottom = opts[:mbottom] || margin&.div(2) || 0

    @mleft = " " * left
    @mtop = "\n" * top
    @mbottom = "\n" * bottom
    @clear = opts[:clear]
    # @last_modified = File.mtime(filepath).strftime("%Y-%m-%d %H:%M")
    @parser = Parser.new(File.read(md_filepath))
    @renderer = Renderer.new(@parser.blocks, width:)
    @results = @renderer.render
    render
  end

  private

  def find_left(term_width, opts)
    case opts[:align]
    when "center"
      (term_width / 2) - (opts[:width] / 2)
    when "right"
      term_width - opts[:width] - (opts[:mright] || opts[:margin] || 0)
    else
      opts[:mleft] || opts[:margin] || 0
    end
  end

  def render
    puts `clear` if @clear
    print @mtop
    @results.each_with_index do |block_lines, i|
      block_lines.split("\n").each do |line|
        puts "#{@mleft}#{line}\n"
      end
      puts unless i == @results.size - 1
    end
    print @mbottom
  end
end
