require "benchmark"

def create_ntimes_summary(n)
  file = "tmp-summary-#{n}"
  `touch #{file}`
  n.times do
    `cat MD_SUMMARY.md >> #{file}`
    `echo "\n" >> #{file}`
  end
  file
end

puts "Creating temp files"

`touch tmp-short`
`echo "# title\n\nParagraph" >> tmp-short`

files = ["tmp-short"]
files << create_ntimes_summary(2)
files << create_ntimes_summary(5)
files << create_ntimes_summary(10)

chars = `wc -m MD_SUMMARY.md`.split(" ").first.to_i

puts "Running benchmark"

Benchmark.bm do |x|
  x.report("Short") { system("./mdr tmp-short >> /dev/null") }
  x.report("MD Summary, #{chars} chars") { system("./mdr MD_SUMMARY.rb >> /dev/null") }
  x.report("2 X MD Summary, #{chars * 2} chars") { system("./mdr tmp-summary-2 >> /dev/null") }
  x.report("5 X MD Summary, #{chars * 5} chars") { system("./mdr tmp-summary-5 >> /dev/null") }
  x.report("10 X MD Summary, #{chars * 10} chars") { system("./mdr tmp-summary-10 >> /dev/null") }
end

puts "Deleting temp files"

files.each { |file| `rm #{file}` }

puts "Done"
