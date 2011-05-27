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
  
  class HunkBlockTest < Test::Unit::TestCase
    def test_a_hunk_should_know_left_and_right_lines
      hunk = Block.hunk
      hunk << Line.hunk_line("@@ -14,8 +12,6 @@")
      hunk << Line.diff_line("     <td><%= user.name %></td>")
      hunk << Line.diff_line("     <td><%= user.login %></td>")
      hunk << Line.diff_line("     <td><%= link_to 'Show', user %></td>")
      hunk << Line.diff_line("-    <td><%= link_to 'Edit', edit_user_path(user) %></td>")
      hunk << Line.diff_line("-    <td><%= link_to 'Destroy', user, :confirm => 'Are you sure?', :method => :delete %></td>")
      hunk << Line.diff_line("   </tr>")
      hunk << Line.diff_line(" <% end %>")
      hunk << Line.diff_line(" </table>")
      
      left_lines = hunk[1..-1]
      right_lines = hunk[1..3] + hunk[6..-1]
      
      assert_equal left_lines, hunk.left_lines
      assert_equal right_lines, hunk.right_lines
    end
    
    def test_a_hunk_should_add_a_add_line
      hunk = Block.hunk
      hunk << Line.diff_line("+this line was added")
      assert_equal AddLine, hunk.last.class
      assert_equal 'this line was added', hunk.last
    end
    
    def test_a_hunk_should_add_a_remove_line
      hunk = Block.hunk
      hunk << Line.diff_line("-this line was removed")
      assert_equal RemoveLine, hunk.last.class
      assert_equal 'this line was removed', hunk.last
    end
    
    def test_a_hunk_should_add_an_unchanged_line
      hunk = Block.hunk
      hunk << Line.diff_line(" this line was not changed")
      assert_equal UnchangedLine, hunk.last.class
      assert_equal 'this line was not changed', hunk.last
    end
    
    def test_a_hunk_block_should_identify_removed_lines_followed_by_added_lines_as_a_changed_block
      hunk = Block.hunk
      hunk << Line.diff_line("-this line was removed")
      hunk << Line.diff_line("-another line was removed")
      hunk << Line.diff_line("+this line was added")
      hunk << Line.diff_line("+this was another line added")
      
      assert_equal 1, hunk.size
      assert_equal ChangedBlock, hunk.first.class
      assert_equal 4, hunk.first.size
    end
    
    def test_a_hunk_block_should_identify_changed_blocks
      hunk = Block.hunk
      hunk << Line.diff_line("-this line was removed")
      hunk << Line.diff_line("-another line was removed")
      hunk << Line.diff_line("+this line was added")
      hunk << Line.diff_line("+this was another line added")
      
      hunk << Line.diff_line(" this line was unchanged")
      hunk << Line.diff_line(" this line was unchanged")
      
      hunk << Line.diff_line("-this line was removed")
      hunk << Line.diff_line("-another line was removed")
      hunk << Line.diff_line("+this line was added")
      hunk << Line.diff_line("+this was another line added")
      
      assert_equal [ChangedBlock, UnchangedLine, UnchangedLine, ChangedBlock], hunk.collect(&:class)
      assert_equal 4, hunk.first.size
      assert_equal 4, hunk.last.size
    end
  end
end
