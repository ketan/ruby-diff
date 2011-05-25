require 'test_helper'

module RubyDiff
  class HeaderBlockTest < Test::Unit::TestCase
    def test_header_block_should_identify_left_and_right_file
      header = Block.header
      header << LeftFileLine.new('foo/left.txt')
      header << RightFileLine.new('foo/right.txt')
      header << IndexLine.new('does not matter')
      
      assert_equal 'foo/left.txt', header.left_file_name
      assert_equal 'foo/right.txt', header.right_file_name
    end
  end
end