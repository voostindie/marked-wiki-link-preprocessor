module Marked
  class Cache
    CACHE_FILE = '.marked'

    attr_accessor :entries

    def initialize(root, cache = CACHE_FILE)
      @path = File.join(root, cache)
      @entries = if File.exist?(@path)
                   YAML.load_file(@path)
                 else
                   {}
                 end
      @original_size = @entries.size
    end

    def persist
      if @entries.size > @original_size
        File.open(@path, 'w') { |f| f.write(YAML.dump(@entries)) }
      end
    end
  end
end