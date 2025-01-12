class Renderer
  def initialize(blocks, **opts)
    @blocks = blocks
    # TODO: manage opts
    @opts = if opts.any? then opts
    else
      {width: 80, word_wrap: true}
    end
  end

  def result
    @blocks.map { |block| block.render(**@opts) }
  end
end
