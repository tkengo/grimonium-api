class Grimonium::Scrapers::Base
  attr_reader :content

  def initialize(content)
    @content = content
  end
end
