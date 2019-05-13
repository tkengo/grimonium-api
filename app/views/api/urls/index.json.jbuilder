json.queues(@urls) do |url|
  json.extract! url,
    :id,
    :hashkey,
    :url,
    :crawler,
    :scraper,
    :info,
    :crawl_status,
    :priority,
    :failed_count,
    :queued_at,
    :created_at,
    :updated_at
end
