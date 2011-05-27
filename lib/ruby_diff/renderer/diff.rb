module RubyDiff
  module Renderer
    class Diff < Base
      def unchangedline(line)
        " #{line}"
      end
      
      def addline(line)
        "+#{line}"
      end
      
      def removeline(line)
        "-#{line}"
      end
    end
  end
  
end