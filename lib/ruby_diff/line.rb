module RubyDiff
  HUNK_LINE_REGEX = /^@@ [+-]([0-9]+)(?:,([0-9]+))? [+-]([0-9]+)(?:,([0-9]+))? @@/
  
  class Line < String
    def initialize(line)
      super(line)
    end
    
    def self.hunk_line(line)
      return HunkLine.new(line)               if line =~ HUNK_LINE_REGEX
    end
    
    def self.diff_line(line)
      return AddLine.new(line[1..-1])             if line =~ /\+/
      return RemoveLine.new(line[1..-1])          if line =~ /\-/
      return Line.new(line[1..-1])                if line =~ / /
    end
    
    def self.header_line(line)
      return LeftFileLine.new(line)           if line =~ /^--- /
      return RightFileLine.new(line)          if line =~ /^\+\+\+ /
      return IndexLine.new(line)              if line =~ /^index \w+\.\.\w+( [0-9]+)?$/i
    end
    
    def self.header(line); HeaderLine.new(line) end
  end

  class AddLine < Line; end
  class RemoveLine < Line; end
  class HeaderLine < Line; end
  class IndexLine < Line; end
  class LeftFileLine < Line; end
  class RightFileLine < Line; end
  class UnchangedLine < Line; end
  
  class HunkLine < Line
    
    attr_reader :left_offset
    attr_reader :right_offset
    attr_reader :left_line_count
    attr_reader :right_line_count

    def initialize(str)
      super(str)
      str =~ HUNK_LINE_REGEX
      @left_offset = $1.to_i
      @left_line_count = $2.to_i
      @right_offset = $3.to_i
      @right_line_count = $4.to_i
    end
  end
end
