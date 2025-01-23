require_relative "renderer"
require_relative "parser"

# This is the entry point and the main controller.
# Main receives a filepath at instanciation,
# Sends file content to the Parser which parses Block objects,
# Sends these blocks to the Renderer which returns an array of strings,
# Then displays the lines regarding to the CLI arguments received
class Main
  def initialize(md_filepath, **opts)
    @lm = " " * (opts[:margin_left] || opts[:margin] || 0)
    @tm = "\n" * (opts[:margin_top] || opts[:margin] / 2 || 0)
    @bm = "\n" * (opts[:margin_bottom] || opts[:margin] / 2 || 0)
    # @last_modified = File.mtime(filepath).strftime("%Y-%m-%d %H:%M")
    @parser = Parser.new(File.read(md_filepath))
    @renderer = Renderer.new(@parser.blocks)
    @results = @renderer.result
    render
  end

  private

  def render
    print @tm
    @results.each_with_index do |block_lines, i|
      block_lines.split("\n").each do |l|
        puts "#{@lm}#{l}\n"
      end
      puts unless i == @results.size - 1
    end
    print @bm
  end
end
