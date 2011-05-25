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
      
      if header = header_line(line)
        @data.last << header
        return
      end
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

    def header_line(line)
      return LeftFileLine.new(line)           if line =~ /^--- /
      return RightFileLine.new(line)          if line =~ /^\+\+\+ /
      return IndexLine.new(line)              if line =~ /^index \w+\.\.\w+( [0-9]+)?$/i
    end
  end
  
  class Line < String
    def initialize(line)
      super(line)
    end
    
    def self.header(line); HeaderLine.new(line) end
  end
  
  class HeaderLine < Line; end
  class IndexLine < Line; end
  class LeftFileLine < Line; end
  class RightFileLine < Line; end
  

  class Block < Array
    def self.header; HeaderBlock.new end
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
  
  # contains a list of files
  class Data < Array
    def files
      result = []
      self.each do |block|
        if HeaderBlock === block
          result << File.new(block)
        end
      end
      result
    end
    
  end
  
  class File
    attr_reader :left_file_name
    attr_reader :right_file_name
    
    def initialize(header_block)
      @header_block = header_block
      @left_file_name = header_block.left_file_name
      @right_file_name = header_block.right_file_name
    end
  end
  
end
