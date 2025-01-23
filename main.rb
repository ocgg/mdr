#!/usr/bin/env ruby

require "optparse"
require_relative "renderer"
require_relative "parser"

# This is the entry point and the main controller.
# Main receives a filepath at instanciation,
# Sends file content to the Parser which parses Block objects,
# Sends these blocks to the Renderer which returns an array of strings,
# Then displays the lines regarding to the CLI arguments received
class Main
  def initialize(md_filepath, **opts)
    opts[:left_margin] && @lm = " " * opts[:left_margin]
    # @last_modified = File.mtime(filepath).strftime("%Y-%m-%d %H:%M")
    @parser = Parser.new(File.read(md_filepath))
    @renderer = Renderer.new(@parser.blocks)
    @renderer.result.flatten.each do |line|
      puts "#{@lm}#{line}\n\n"
    end
  end
end

opts = {}
OptionParser.new do |parser|
  # parser.banner = "Usage: example.rb [opts]"
  {
    left_margin: ["-l", "--margin-left=COLS", Integer, "Left margin"],
    # right_margin: ["-r", "--margin-right=COLS", Integer, "Right margin"]
  }.each do |name, args|
    parser.on(*args) { |val| opts[name] = val }
  end
end.parse!

raise "Please specify only one file." if ARGV.size > 1

Main.new(ARGF.filename, **opts)
