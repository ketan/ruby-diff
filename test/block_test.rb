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
    def test_a_hunk_block
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
  end
end
