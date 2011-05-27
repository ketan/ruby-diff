module RubyDiff
  module Renderer
    class Base
      def render(diff_data)
        result = []
      
        diff_data.each do |block|
          result << send("before_#{classify(block)}", block)
          result << block.collect { |line| send(classify(line), line) }
          result << send("after_#{classify(block)}", block)
        end
      
        result.compact.join(new_line)
      end
    
    
      # --- begin headers ---
      def before_headerblock(block)
      end
      
      def headerline(line)
        line
      end
      
      def indexline(line)
        line
      end
      
      def leftfileline(line)
        line
      end
      
      def rightfileline(line)
        line
      end
      
      def after_headerblock(block)
      end
      # --- end headers ---
      
      
      # --- begin hunks ---
      def before_hunkblock(block)
        
      end
      
      def hunkline(line)
        line
      end
      
      def unchangedline(line)
        line
      end
      
      def addline(line)
        line
      end
      
      def removeline(line)
        line
      end
      
      def after_hunkblock(block)
      end
      # --- end hunks ---
    
      def new_line
        "\n"
      end
    
      def classify(o)
        o.class.name[/\w+$/].downcase
      end
    end
  end
end
