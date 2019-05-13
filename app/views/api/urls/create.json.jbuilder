json.status 'success'
json.urls do
  json.queued @urls.queued
  json.crawled @urls.crawled
  json.registered @urls.registered
end
