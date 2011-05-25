require 'test_helper'
require 'pp'

module RubyDiff
  class ParserTest < Test::Unit::TestCase
    def test_parse_a_git_header
      diff = Parser.parse(fixture('headers_only.diff'))
      
      assert_equal 1, diff.size

      block = diff.first
      assert_equal [HeaderBlock], diff.collect(&:class)
      assert_equal fixture_lines('headers_only.diff').collect(&:chomp), block
      
      files = diff.files
      assert_equal 1, files.size
      
      file = files.first
      assert_equal ['a/test/parser_test.rb', 'b/test/parser_test.rb'], [file.left_file_name, file.right_file_name]
    end
    
    def test_parse_a_diff_with_single_line_addition
      diff = Parser.parse(fixture('single_line_addition.diff'))
      
      assert_equal 2, diff.size
      assert_equal [HeaderBlock, HunkBlock], diff.collect(&:class)

      block = diff.first
      assert_equal fixture_lines('single_line_addition.diff').collect(&:chomp)[0..3], block
      
      files = diff.files
      assert_equal 1, files.size
      
      file = files.first
      hunks = file.hunks
      assert_equal 1, hunks.size
      
      file = files.first
      assert_equal ['a/test/parser_test.rb', 'b/test/parser_test.rb'], [file.left_file_name, file.right_file_name]
    end
    
  end
end
