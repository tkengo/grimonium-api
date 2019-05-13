module Grimonium::Crawlers
  class Default < Base
    def crawl
      open(record.url) do |f|
        [ f.charset, f.meta, f.read ]
      end
    end
  end
end
