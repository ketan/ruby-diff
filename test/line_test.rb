require 'test_helper'

module RubyDiff
  class HunkLineTest < Test::Unit::TestCase
    
    def test_a_hunk_line_knows_its_offsets
      line = HunkLine.new('@@ -14,8 +12,6 @@')
      assert_equal 14, line.left_offset
      assert_equal 12, line.right_offset
      
      assert_equal 8, line.left_line_count
      assert_equal 6, line.right_line_count
    end
    
  end
end
