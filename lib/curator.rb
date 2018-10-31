class Curator
  attr_reader :photographs, :artists

  def initialize
    @photographs = []
    @artists = []
  end

  def add_artist(artist)
    @artists << artist
  end

  def add_photograph(photograph)
    @photographs << photograph
  end

  def find_artist_by_id(artist_id)
    @artists.find { |artist| artist.id == artist_id }
  end

  def find_photograph_by_id(photo_id)
    @photographs.find { |photo| photo.id == photo_id }
  end

  def find_photographs_by_artist(artist)
    @photographs.find_all { |photo| photo.artist_id == artist.id }
  end

  def artists_with_multiple_photographs
    @artists.find_all do |artist|
      @photographs.count { |photo| photo.artist_id == artist.id } > 1
    end
  end

  def photographs_taken_by_artist_from(country)
    @photographs.find_all do |photo|
      find_artist_by_id(photo.artist_id).country == country
    end
  end

end
