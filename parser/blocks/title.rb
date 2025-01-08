require_relative "block"

class Title < Block
  private

  def format(string)
    sharps = string.slice!(/^#* /).size - 1
    @level = sharps
    Text.new(string)
  end
end
