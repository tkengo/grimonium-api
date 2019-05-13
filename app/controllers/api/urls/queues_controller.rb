class Api::Queues::QueuesController < Api::ApplicationController
  def create
    url = CrawlingUrl.find params[:url_id]
    @result = url.queue!
  end
end
