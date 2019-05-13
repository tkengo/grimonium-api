class Api::UrlsController < Api::ApplicationController
  def index
    @urls = CrawlingUrl.where(crawl_status: [ :registered, :queued ])
  end

  def create
    urls_from_params = params[:urls].split('\n')

    @urls = CrawlingUrl.register(
      urls_from_params,
      crawler: params[:crawler],
      scraper: params[:scraper],
      force: params[:force]
    )
  end
end
