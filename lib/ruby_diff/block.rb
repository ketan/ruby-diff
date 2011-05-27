module RubyDiff
  class Block < Array
    def self.header; HeaderBlock.new end
    def self.hunk; HunkBlock.new end
  end

  class HunkBlock < Block

    def left_offset; self.first.left_offset; end
    def right_offset; self.first.right_offset end
    def left_line_count; self.first.left_line_count end
    def right_line_count; self.first.right_line_count; end
    
    def left_lines
      return @left_lines if @left_lines
      parse_lines
      @left_lines
    end
    
    def right_lines
      return @right_lines if @right_lines
      parse_lines
      @right_lines
    end
    
    def parse_lines
      hunk_line = self.first
      @left_lines = []
      @right_lines = []
      self[1..-1].each do |line|
        @left_lines << line  if (UnchangedLine === line) || (RemoveLine === line)
        @right_lines << line if (UnchangedLine === line) || (AddLine === line)
      end
    end
    
  end

  class HeaderBlock < Block
    def left_file_name
      return @left_file_name if @left_file_name
      self.find { |line| @left_file_name = line.gsub(/^--- /, '') if LeftFileLine === line }
      @left_file_name
    end
  
    def right_file_name
      return @right_file_name if @right_file_name
      self.find { |line| @right_file_name = line.gsub(/^\+\+\+ /, '') if RightFileLine === line }
      @right_file_name
    end
  end
end
