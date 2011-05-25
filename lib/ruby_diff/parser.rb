module RubyDiff
  class Parser
    HUNK_LINE_REGEX = /^@@ [+-]([0-9]+)(?:,([0-9]+))? [+-]([0-9]+)(?:,([0-9]+))? @@/
    def self.parse(diff_text)
      parser = Parser.new
      
      diff_text.each_line do |line|
        parser.process(line.chomp)
      end
      
      parser.finish
      parser.data
    end
    
    attr_reader :data
    
    def initialize
      @data = Data.new
    end
    
    def process(line)
      if start_file_line?(line)
        @data << Block.header
        @data.last << Line.header(line)
        return
      end
      
      if header = header_line(line)
        @data.last << header
        return
      end
      
      if hunk = hunk_line(line)
        @data << Block.hunk
        @data.last << hunk
        return
      end
      
      @data.last << diff_line(line)
      
    end
    
    def finish
    end
    
    protected
    def current_block
      @data.last
    end
    
    def start_file_line?(line)
      return true if line =~ /^diff \-\-git/
    end

    def hunk_line(line)
      return HunkLine.new(line)               if line =~ HUNK_LINE_REGEX
    end
    
    def diff_line(line)
      return AddLine.new(line[1..-1])             if line =~ /\+/
      return RemoveLine.new(line[1..-1])          if line =~ /\-/
      return Line.new(line[1..-1])                if line =~ / /
    end
    
    def header_line(line)
      return LeftFileLine.new(line)           if line =~ /^--- /
      return RightFileLine.new(line)          if line =~ /^\+\+\+ /
      return IndexLine.new(line)              if line =~ /^index \w+\.\.\w+( [0-9]+)?$/i
    end
  end
  
  
  # contains a list of files
  class Data < Array
    def files
      result = []
      self.each do |block|
        if HeaderBlock === block
          result << File.new(block)
        end
        if HunkBlock === block
          result.last << block
        end
      end
      result
    end
    
  end

end
