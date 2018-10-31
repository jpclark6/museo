require './lib/file_io'
require './lib/photograph'
require './lib/artist'

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

  def photographs_taken_by_artists_from(country)
    @photographs.find_all do |photo|
      find_artist_by_id(photo.artist_id).country == country
    end
  end

  def load_photographs(file)
    photo_data = FileIO.load_photographs(file)
    photo_data.each do |photo_info|
      add_photograph(Photograph.new(photo_info))
    end
  end

  def load_artists(file)
    artist_data = FileIO.load_artists(file)
    artist_data.each do |artist_info|
      add_artist(Artist.new(artist_info))
    end
  end

  def photographs_taken_between_range(range)
    @photographs.find_all { |photo| range.cover? photo.year.to_i }
  end

  def artists_photographs_by_age(artist)
    age_and_photo_array = find_photographs_by_artist(artist).map do |photo|
      [photo.year.to_i - artist.born.to_i, photo.name]
    end
    create_age_and_photo_name_hash(age_and_photo_array)
  end

  def create_age_and_photo_name_hash(age_photos)
    age_photo_hash = {}
    age_photos.each do |age, photo_name|
      if age_has_photo?(age_photo_hash, age)
        age_photo_hash[age] = "'age_photo_hash[age]', '#{photo_name}'"
      else
        age_photo_hash[age] = photo_name
      end
    end
    age_photo_hash
  end

  def age_has_photo?(age_photo_hash, age)
    age_photo_hash.has_key? age
  end

end
