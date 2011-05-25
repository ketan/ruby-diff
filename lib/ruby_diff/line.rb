module RubyDiff
  class Line < String
    def initialize(line)
      super(line)
    end
  
    def self.header(line); HeaderLine.new(line) end
  end

  class AddLine < Line; end
  class RemoveLine < Line; end
  class HeaderLine < Line; end
  class IndexLine < Line; end
  class LeftFileLine < Line; end
  class RightFileLine < Line; end
  class HunkLine < Line; end
end
