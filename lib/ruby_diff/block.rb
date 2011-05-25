module RubyDiff
  class Block < Array
    def self.header; HeaderBlock.new end
    def self.hunk; HunkBlock.new end
  end

  class HunkBlock < Block
    def <<(line)
      super(line)
    
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
