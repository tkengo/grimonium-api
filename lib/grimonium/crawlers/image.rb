module Grimonium::Crawlers
  class Image < Base
    def crawl
      open(record.url) do |f|
        image = f.read

        path = Rails.root.join('download', record.info.path)
        open(Rails.root.join(path)) do |out|
          out.write(image)
        end

        [ nil, f.meta, image ]
      end
    end
  end
end
