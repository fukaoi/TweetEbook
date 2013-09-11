class EpubError < StandardError
  def initialize(msg = 'Not Found Parameter')
    super(msg)
  end
end