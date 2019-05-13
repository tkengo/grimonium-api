class Tasks::Base
  def start(argv)
    process parse_opts(argv)
  end

  def process(opts); end

  def parse_opts(argv); end
end
