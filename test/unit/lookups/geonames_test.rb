# encoding: utf-8
$: << File.join(File.dirname(__FILE__), "..", "..")
require 'test_helper'

class GeonamesTest < GeocoderTestCase

  def setup
    Geocoder.configure(lookup: :geonames, username: 'demo')
  end

  def test_truth
    assert true
  end

  def test_query_for_reverse_geocode
    lookup = Geocoder::Lookup::Geonames.new
    url = lookup.query_url(Geocoder::Query.new([45.423733, -75.676333]))
    assert_match(/countrySubdivisionJSON\?lat=45\.423733&lon=-75\.676333&username=demo/, url)
  end

end
