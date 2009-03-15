#######################################################
# tc_example_match.rb
#
# Test suite for matching with xls file made by perl.
#######################################################
base = File.basename(Dir.pwd)
if base == "test" || base =~ /spreadsheet/i
  Dir.chdir("..") if base == "test"
  $LOAD_PATH.unshift(Dir.pwd + "/lib/spreadsheet")
  Dir.chdir("test") rescue nil
end

require "test/unit"
require "excel"
include Spreadsheet

class TC_example_match < Test::Unit::TestCase

  def setup
    @filename = "tc_example_match.xls"
  end

  def teardown
    File.delete(@filename) if File.exist?(@filename)
  end

  def test_a_simple
    workbook  = Excel.new(@filename);
    worksheet = workbook.add_worksheet
    
    # The general syntax is write(row, column, token). Note that row and
    # column are zero indexed
    #
    
    # Write some text
    worksheet.write(0, 0,  "Hi Excel!")
    
    
    # Write some numbers
    worksheet.write(2, 0,  3)          # Writes 3
    worksheet.write(3, 0,  3.00000)    # Writes 3
    worksheet.write(4, 0,  3.00001)    # Writes 3.00001
    worksheet.write(5, 0,  3.14159)    # TeX revision no.?
    
    
    # Write some formulas
    worksheet.write(7, 0,  '=A3 + A6')
    worksheet.write(8, 0,  '=IF(A5>3,"Yes", "No")')
    
    
    # Write a hyperlink
    worksheet.write(10, 0, 'http://www.perl.com/')
    
    # File save
    workbook.close
    
    # do assertion
    compare_file("perl_output/a_simple.xls", @filename)
  end

  def test_regions
    workbook = Excel.new(@filename)

    # Add some worksheets
    north = workbook.add_worksheet("North")
    south = workbook.add_worksheet("South")
    east  = workbook.add_worksheet("East")
    west  = workbook.add_worksheet("West")
    
    # Add a Format
    format = workbook.add_format()
    format.set_bold()
    format.set_color('blue')
    
    # Add a caption to each worksheet
    workbook.sheets.each do |worksheet|
        worksheet.write(0, 0, "Sales", format)
    end
    
    # Write some data
    north.write(0, 1, 200000)
    south.write(0, 1, 100000)
    east.write(0, 1, 150000)
    west.write(0, 1, 100000)
    
    # Set the active worksheet
    bp=1
    south.activate()
    
    # Set the width of the first column
    south.set_column(0, 0, 20)
    
    # Set the active cell
    south.set_selection(0, 1)
    
    workbook.close

    # do assertion
    compare_file("perl_output/regions.xls", @filename)
  end

  def test_stats
    workbook = Excel.new(@filename)
    worksheet = workbook.add_worksheet('Test data')

    # Set the column width for columns 1
    worksheet.set_column(0, 0, 20)

    # Create a format for the headings
    format = workbook.add_format
    format.set_bold

    # Write the sample data
    worksheet.write(0, 0, 'Sample', format)
    worksheet.write(0, 1, 1)
    worksheet.write(0, 2, 2)
    worksheet.write(0, 3, 3)
    worksheet.write(0, 4, 4)
    worksheet.write(0, 5, 5)
    worksheet.write(0, 6, 6)
    worksheet.write(0, 7, 7)
    worksheet.write(0, 8, 8)

    worksheet.write(1, 0, 'Length', format)
    worksheet.write(1, 1, 25.4)
    worksheet.write(1, 2, 25.4)
    worksheet.write(1, 3, 24.8)
    worksheet.write(1, 4, 25.0)
    worksheet.write(1, 5, 25.3)
    worksheet.write(1, 6, 24.9)
    worksheet.write(1, 7, 25.2)
    worksheet.write(1, 8, 24.8)

    # Write some statistical functions
    worksheet.write(4,  0, 'Count', format)
    worksheet.write(4,  1, '=COUNT(B1:I1)')

    worksheet.write(5,  0, 'Sum', format)
    worksheet.write(5,  1, '=SUM(B2:I2)')

    worksheet.write(6,  0, 'Average', format)
    worksheet.write(6,  1, '=AVERAGE(B2:I2)')

    worksheet.write(7,  0, 'Min', format)
    worksheet.write(7,  1, '=MIN(B2:I2)')

    worksheet.write(8,  0, 'Max', format)
    worksheet.write(8,  1, '=MAX(B2:I2)')

    worksheet.write(9,  0, 'Standard Deviation', format)
    worksheet.write(9,  1, '=STDEV(B2:I2)')
    
    worksheet.write(10, 0, 'Kurtosis', format)
    worksheet.write(10, 1, '=KURT(B2:I2)')

    workbook.close

    # do assertion
    compare_file("perl_output/regions.xls", @filename)
  end

  def test_hidden
    workbook   = Excel.new(@filename)
    worksheet1 = workbook.add_worksheet
    worksheet2 = workbook.add_worksheet
    worksheet3 = workbook.add_worksheet

    # Sheet2 won't be visible until it is unhidden in Excel.
    worksheet2.hide

    worksheet1.write(0, 0, 'Sheet2 is hidden')
    worksheet2.write(0, 0, 'How did you find me?')
    worksheet3.write(0, 0, 'Sheet2 is hidden')

    workbook.close

    # do assertion
    compare_file("perl_output/hidden.xls", @filename)
  end

  def compare_file(expected, target)
    fh_e = File.open(expected, "r")
    fh_t = File.open(target, "r")
    while true do
      e1 = fh_e.read(1)
      t1 = fh_t.read(1)
      if e1.nil?
        assert( t1.nil?, "#{expexted} is EOF but #{target} is NOT EOF.")
        break
      elsif t1.nil?
        assert( e1.nil?, '#{target} is EOF but #{expected} is NOT EOF.')
        break
      end
      assert_equal(e1, t1, sprintf(" #{expected} = '%s' but #{target} = '%s'", e1, t1))
      break
    end
    fh_e.close
    fh_t.close
  end


end
