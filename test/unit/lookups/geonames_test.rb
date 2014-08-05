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
    result = Geocoder.search("Prague").first
    assert_equal "Prague", result.city
    assert_equal "Czech Republic", result.country
  end

  def test_reverse_geocoding
    result = Geocoder.search(Geocoder::Query.new([50, 14])).first
    assert_equal "CZ", result.country_code
    assert_equal "Czech Republic", result.country
  end

  def test_raises_over_limit_exception
    Geocoder.configure Geocoder.configure(:always_raise => [Geocoder::OverQueryLimitError])
    assert_raises Geocoder::OverQueryLimitError do
      Geocoder.search("over query limit")
    end
  end

  def test_raises_request_denied
    Geocoder.configure Geocoder.configure(:always_raise => [Geocoder::RequestDenied])
    assert_raises Geocoder::RequestDenied do
      Geocoder.search("request denied")
    end
  end

  def test_raises_generic_error
    Geocoder.configure Geocoder.configure(:always_raise => [Geocoder::Error])
    assert_raises Geocoder::Error do
      Geocoder.search("generic error")
    end
  end

end
