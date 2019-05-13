module Grimonium::Scrapers
  class BeautyHotpepper < Base
    def index
      html = content.as_html

      urls = []
      html.css('#jsiHoverAlphaLayerScope li > div.jscHoverTarget a').each do |el|
        urls << el['href']
      end
      UrlQueue.register(urls, scraper: 'BeautyHotpepper.detail')

      if next_link = html.css('li.afterPage > a').first
        UrlQueue.register(next_link['href'], scraper: 'BeautyHotpepper.index', priority: 0)
      end
    end

    def detail
      html = content.as_html

      # Extract itemkey from a url. For example, if the url is:
      # "https://beauty.hotpepper.jp/slnH000260506/style/L001859156.html?cstt=1"
      # then itemkey will become "slnH000260506-L001859156".
      itemkey = content.url.to_uri.path.delete('.html').split('/').values_at(1, 3).join('-')

      # Register hair image urls.
      1.upto(3) do |i|
        scc = html.css("span#scc#{i}").first
        image_url = scc.css('img').first['src'].gsub('89-119.jpg', '271-361.jpg')

        classes = scc.parent.css('div.iS').first['class'].split(' ')
        dir = if classes.include?('SV01')
                :front
              elsif classes.include?('SV02')
                :side
              elsif classes.include?('SV03')
                :back
              else
                nil
              end

        UrlQueue.register_images(image_url, path: "#{itemkey}-#{i}.jpg", info: dir)
      end

      # Get page detail
      scope = html.css('#jsiHoverAlphaLayerScope')

      detail = nil
      scope.css('div.styleDtlRightColumn > div.mT20 > div.titleStyle').each do |style|
        next unless style.text == 'スタイルデータ'
        styles = style.parent.css('> dl > dd')
        detail = {
          title: scope.css('div.stylePageTileOuter > h2').text,
          length: styles[0].text,
          color: styles[1].text,
          looks: styles[2].text
        }
      end

      content.update_scrape_result(itemkey, detail)
    end

    def image
    end
  end
end
