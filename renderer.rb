class Renderer
  attr_reader :result

  def initialize(blocks, **opts)
    # TODO: manage opts
    @opts = if opts.any? then opts
    else
      {width: 80, word_wrap: true}
    end
    @result = compute!(blocks)
  end

  private

  def compute!(blocks)
    blocks.map { |block| block.render(**@opts) }
  end
end
