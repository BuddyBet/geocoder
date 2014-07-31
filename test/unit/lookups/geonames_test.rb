# encoding: utf-8
$: << File.join(File.dirname(__FILE__), "..", "..")
require 'test_helper'

class GeonamesTest < GeocoderTestCase

  def setup
    Geocoder.configure(lookup: :geonames)
  end

  def test_truth
    assert true
  end

end
