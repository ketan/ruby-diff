require 'test_helper'

module RubyDiff
  class RendererTest < Test::Unit::TestCase
    
    def test_can_perform_callback_on_headers
      diff = Parser.parse(fixture('headers_only.diff'))
      assert_equal fixture('headers_only.diff'), Renderer::Diff.new.render(diff)
    end
    
    def test_can_perform_callback_on_single_addition
      diff = Parser.parse(fixture('single_line_addition.diff'))
      assert_equal fixture('single_line_addition.diff'), Renderer::Diff.new.render(diff)
    end
    
    def test_can_perform_callback_on_single_deletion
      diff = Parser.parse(fixture('single_line_deletion.diff'))
      assert_equal fixture('single_line_deletion.diff'), Renderer::Diff.new.render(diff)
    end
    
    def test_can_perform_callback_on_big_diff
      diff = Parser.parse(fixture('big_diff.diff'))
      assert_equal fixture('big_diff.diff'), Renderer::Diff.new.render(diff)
    end
  end
end
