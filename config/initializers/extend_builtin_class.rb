class String
  def to_sha1
    Digest::SHA1.hexdigest self
  end

  def to_uri
    Addressable::URI.parse self
  end
end
