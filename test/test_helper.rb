require 'test/unit'
require 'ruby_diff'
require 'pp'

module UnitTestHelper
  def fixture(file)
    File.read(File.join(File.dirname(__FILE__), 'fixtures', file))
  end
  def fixture_lines(file)
    File.readlines(File.join(File.dirname(__FILE__), 'fixtures', file))
  end
end

class Test::Unit::TestCase
  include UnitTestHelper
end