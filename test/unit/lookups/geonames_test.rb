# encoding: utf-8
$: << File.join(File.dirname(__FILE__), "..", "..")
require 'test_helper'

class GeonamesTest < GeocoderTestCase

  def setup
    Geocoder.configure(lookup: :geonames, username: 'demo')
  end

  def test_query_for_reverse_geocode
    lookup = Geocoder::Lookup::Geonames.new
    url = lookup.query_url(Geocoder::Query.new([45.423733, -75.676333]))
    assert_match(/countrySubdivisionJSON\?lat=45\.423733&lng=-75\.676333/, url)
  end

  def test_url_contains_username
    query = Geocoder::Query.new("Prague")
    assert_match(/&username=demo/, query.url)
  end

  def test_result_components
    result = Geocoder.search("Madison Square Garden, New York, NY").first
    assert_equal "New York", result.city
  end

end
