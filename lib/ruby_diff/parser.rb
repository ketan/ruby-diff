module RubyDiff
  class Parser
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
      
      if header = Line.header_line(line)
        @data.last << header
        return
      end
      
      if hunk = Line.hunk_line(line)
        @data << Block.hunk
        @data.last << hunk
        return
      end
      
      @data.last << UnchangedLine.diff_line(line)
      
    end
    
    def finish
    end
    
    def current_block
      @data.last
    end
    
    def start_file_line?(line)
      return true if line =~ /^diff \-\-git/
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
