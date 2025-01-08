require_relative "renderer"
require_relative "parser"

# This is the entry point and the main controller.
# Main receives a filepath at instanciation,
# Sends it to the Parser which returns a MdDocument,
# Then sends MdDocument to the Renderer which returns an array of lines,
# Then displays the lines regarding to the CLI arguments received
class Main
  def initialize(filepath)
    @filepath = filepath
    @raw = File.read(filepath)
    # @last_modified = File.mtime(filepath).strftime("%Y-%m-%d %H:%M")
    @parser = Parser.new(@raw)
    pp @parser.blocks
    # @renderer = Renderer.new
  end
end

Main.new "MD_TEST_mini.md"
