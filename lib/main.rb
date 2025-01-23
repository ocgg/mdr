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
    top = opts[:margin_top] || margin&.div(2) || 0
    bottom = opts[:margin_bottom] || margin&.div(2) || 0

    @margin_left = " " * left
    @margin_top = "\n" * top
    @margin_bottom = "\n" * bottom
    # @last_modified = File.mtime(filepath).strftime("%Y-%m-%d %H:%M")
    @parser = Parser.new(File.read(md_filepath))
    @renderer = Renderer.new(@parser.blocks, width:)
    @results = @renderer.render
    render
  end

  private

  def find_left(term_width, opts)
    if opts[:center]
      (term_width / 2) - (opts[:width] / 2)
    else
      opts[:margin_left] || opts[:margin] || 0
    end
  end

  def render
    print @margin_top
    @results.each_with_index do |block_lines, i|
      block_lines.split("\n").each do |line|
        puts "#{@margin_left}#{line}\n"
      end
      puts unless i == @results.size - 1
    end
    print @margin_bottom
  end
end
