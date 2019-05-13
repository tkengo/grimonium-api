module QueueHelper
  def crawl_status(url_queue)
    t "model.url_queue.attributes.crawl_status.#{url_queue.crawl_status}"
  end
end
