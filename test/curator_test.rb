require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/curator'
require './lib/photograph'
require './lib/artist'

class CuratorTest < Minitest::Test
  def setup
    @curator = Curator.new
    attributes_1 = {
      id: "1",
      name: "Henri Cartier-Bresson",
      born: "1908",
      died: "2004",
      country: "France"
    }
    attributes_2 = {
      id: "2",
      name: "Ansel Adams",
      born: "1902",
      died: "1984",
      country: "United States"
    }
    @artist_1 = Artist.new(attributes_1)
    @artist_2 = Artist.new(attributes_2)
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    p_attributes_1 = {
      id: "1",
      name: "Rue Mouffetard, Paris (Boy with Bottles)",
      artist_id: "1",
      year: "1954"
    }
    p_attributes_2 = {
      id: "2",
      name: "Moonrise, Hernandez",
      artist_id: "2",
      year: "1941"
    }
    p_attributes_3 = {
      id: "3",
      name: "Moonrise, Another",
      artist_id: "2",
      year: "1942"
    }
    @photo_1 = Photograph.new(p_attributes_1)
    @photo_2 = Photograph.new(p_attributes_2)
    @photo_3 = Photograph.new(p_attributes_3)
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
  end
  def test_it_exists
    curator = Curator.new
    assert_instance_of Curator, curator
  end

  def test_it_has_default_empty_photographs
    curator = Curator.new
    assert_equal true, curator.photographs.empty?
  end

  def test_it_can_add_photographs
    curator = Curator.new
    attributes_1 = {
      id: "1",
      name: "Rue Mouffetard, Paris (Boy with Bottles)",
      artist_id: "1",
      year: "1954"
    }
    attributes_2 = {
      id: "2",
      name: "Moonrise, Hernandez",
      artist_id: "2",
      year: "1941"
    }
    photo_1 = Photograph.new(attributes_1)
    photo_2 = Photograph.new(attributes_2)

    curator.add_photograph(photo_1)
    curator.add_photograph(photo_2)
    expected = [photo_1, photo_2]
    assert_equal expected, curator.photographs
    assert_equal photo_1, curator.photographs.first
    assert_equal "Rue Mouffetard, Paris (Boy with Bottles)", curator.photographs.first.name
  end

  def test_it_can_add_artists
    curator = Curator.new
    attributes_1 = {
      id: "1",
      name: "Henri Cartier-Bresson",
      born: "1908",
      died: "2004",
      country: "France"
    }
    attributes_2 = {
      id: "2",
      name: "Ansel Adams",
      born: "1902",
      died: "1984",
      country: "United States"
    }
    artist_1 = Artist.new(attributes_1)
    artist_2 = Artist.new(attributes_2)

    assert_equal true, curator.artists.empty?

    curator.add_artist(artist_1)
    curator.add_artist(artist_2)

    expected = [artist_1, artist_2]
    assert_equal expected, curator.artists
    assert_equal artist_1, curator.artists.first
  end

  def test_it_can_find_artist_by_id
    curator = Curator.new
    attributes_1 = {
      id: "1",
      name: "Henri Cartier-Bresson",
      born: "1908",
      died: "2004",
      country: "France"
    }
    attributes_2 = {
      id: "2",
      name: "Ansel Adams",
      born: "1902",
      died: "1984",
      country: "United States"
    }
    artist_1 = Artist.new(attributes_1)
    artist_2 = Artist.new(attributes_2)

    assert_equal true, curator.artists.empty?
    curator.add_artist(artist_1)
    curator.add_artist(artist_2)
    assert_equal artist_2, curator.find_artist_by_id("2")
  end

  def test_it_can_find_photograph_by_id
    curator = Curator.new
    attributes_1 = {
      id: "1",
      name: "Rue Mouffetard, Paris (Boy with Bottles)",
      artist_id: "1",
      year: "1954"
    }
    attributes_2 = {
      id: "2",
      name: "Moonrise, Hernandez",
      artist_id: "2",
      year: "1941"
    }
    photo_1 = Photograph.new(attributes_1)
    photo_2 = Photograph.new(attributes_2)

    curator.add_photograph(photo_1)
    curator.add_photograph(photo_2)
    assert_equal photo_2, curator.find_photograph_by_id("2")
  end

  def test_it_can_find_photographs_by_artist
    expected = [@photo_2, @photo_3]
    assert_equal expected, @curator.find_photographs_by_artist(@artist_2)
  end

  def test_it_can_find_artists_with_multiple_photographs
    expected = [@artist_2]
    assert_equal expected, @curator.artists_with_multiple_photographs
  end

  def test_it_can_find_photographs_taken_by_artist_from_country
    attributes_3 = {
      id: "3",
      name: "George Washington",
      born: "1733",
      died: "1798",
      country: "United States"
    }
    p_attributes_4 = {
      id: "4",
      name: "They're Coming",
      artist_id: "3",
      year: "1776"
    }
    photo_4 = Photograph.new(p_attributes_4)
    artist_3 = Artist.new(attributes_3)
    @curator.add_artist(artist_3)
    @curator.add_photograph(photo_4)
    expected = [@photo_2, @photo_3, photo_4]
    assert_equal expected, @curator.photographs_taken_by_artist_from("United States")
    assert_equal [], @curator.photographs_taken_by_artist_from("Moon")
  end
end
