$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require "test/unit"
require 'writeexcel'
require 'stringio'

###############################################################################
#
# A test for Chart.
#
# Tests for the Excel chart.rb methods.
#
# reverse(''), December 2009, John McNamara, jmcnamara@cpan.org
#
# original written in Perl by John McNamara
# converted to Ruby by Hideo Nakamura, cxn03651@msj.biglobe.ne.jp
#
class TC_chart_subclasses < Test::Unit::TestCase
  def setup
    io = StringIO.new
    @workbook = WriteExcel.new(io)
  end

  def test_store_chart_type_of_column
    chart = Chart.factory(Chart::Column, nil, nil, nil, nil, nil, nil,
                                         nil, nil, nil)
    expected = %w(
        17 10 06 00 00 00 96 00 00 00
      ).join(' ')
    got = unpack_record(chart.store_chart_type)
    assert_equal(expected, got)
  end

  def test_store_chart_type_of_bar
    chart = Chart.factory(Chart::Bar, nil, nil, nil, nil, nil, nil,
                                         nil, nil, nil)
    expected = %w(
        17 10 06 00 00 00 96 00 01 00
      ).join(' ')
    got = unpack_record(chart.store_chart_type)
    assert_equal(expected, got)
  end

  def test_store_chart_type_of_line
    chart = Chart.factory(Chart::Line, nil, nil, nil, nil, nil, nil,
                                         nil, nil, nil)
    expected = %w(
        18 10 02 00 00 00
      ).join(' ')
    got = unpack_record(chart.store_chart_type)
    assert_equal(expected, got)
  end

  def test_store_chart_type_of_area
    chart = Chart.factory(Chart::Area, nil, nil, nil, nil, nil, nil,
                                         nil, nil, nil)
    expected = %w(
        1A 10 02 00 01 00
      ).join(' ')
    got = unpack_record(chart.store_chart_type)
    assert_equal(expected, got)
  end

  def unpack_record(data)
    data.unpack('C*').map! {|c| sprintf("%02X", c) }.join(' ')
  end
end
