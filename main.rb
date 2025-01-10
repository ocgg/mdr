require_relative "renderer"
require_relative "parser"

# This is the entry point and the main controller.
# Main receives a filepath at instanciation,
# Sends file content to the Parser which parses Block objects,
# Sends these blocks to the Renderer which returns an array of strings,
# Then displays the lines regarding to the CLI arguments received
class Main
  def initialize(md_filepath)
    # @last_modified = File.mtime(filepath).strftime("%Y-%m-%d %H:%M")
    @parser = Parser.new(File.read(md_filepath))
    @renderer = Renderer.new(@parser.blocks)
    puts @renderer.result.join("\n\n")
  end
end

Main.new "MD_TEST_mini.md"
