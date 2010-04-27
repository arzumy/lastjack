class Track
  attr_reader :title, :artist, :album

  def initialize(title=nil, artist=nil, album=nil)
    @title, @artist, @album = title, artist, album
    CONFIG['api'] ? api : rss
  end

  def rss
    url       = "http://ws.audioscrobbler.com/2.0/user/#{CONFIG['user']}/recenttracks.rss"
    rss       = SimpleRSS.parse(open(url))
    track     = rss.items.first.title.split("\342\200\223").map { |r| r.strip }
    unless track.empty?
      @artist = track.first
      @title  = track.last
    end
  end

  def api
    url       = "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&limit=1&user=#{CONFIG['user']}&api_key=#{CONFIG['api']}"
    xml       = Nokogiri::XML(open(url))
    if xml
      @title  = xml.search("track > name").text
      @artist = xml.search("track > artist").text
      @album  = xml.search("track > album").text
    end
  end

  def valid?
    @title && @artist
  end
end
