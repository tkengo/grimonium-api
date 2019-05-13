class Grimonium::URI
  def self.normalize(url)
    uri = url.to_uri.normalize
    uri.query = uri.query_values.sort.map{|v| v.join('=') }.join('&')
    uri.to_s
  end
end
