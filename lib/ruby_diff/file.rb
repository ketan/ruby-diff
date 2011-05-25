module RubyDiff
  class File < Array
    attr_reader :left_file_name
    attr_reader :right_file_name
    def initialize(header_block)
      @left_file_name = header_block.left_file_name
      @right_file_name = header_block.right_file_name
    end

    def hunks
      self
    end
  end
end