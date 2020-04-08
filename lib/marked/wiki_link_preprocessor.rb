module Marked

  class WikiLinkPreprocessor

    CONFIG_FILE = '.datrc'
    DEFAULT_EDITOR = 'TextMate'

    def initialize(path, config_file = CONFIG_FILE)
      @path = if path.nil?
                File.join(Dir.pwd, 'tmp')
              else
                path
              end
      @root = resolve_root(@path)
      return if @root.nil?
      config = YAML.load_file(File.join(@root, config_file))
      editor = config['editor'] || DEFAULT_EDITOR
      @editor = if editor
                  clazz = EDITORS[editor.downcase]
                  if clazz.nil?
                    raise "Unsupported editor: #{editor}"
                  else
                    clazz
                  end
                else
                  EDITORS[DEFAULT_EDITOR.downcase]
                end.new(@root, config[editor])
      @cache = Cache.new(@root)
    end

    def resolve_root(path)
      dir = File.dirname(path)
      if File.exist?(File.join(dir, CONFIG_FILE))
        dir
      elsif [Dir.home, '/'].include?(dir)
        nil
      else
        resolve_root(dir)
      end
    end

    def process(input)
      output = input
      return output if @root.nil?
      if @editor.respond_to?(:edit_callback_url) && File.exist?(@path)
        url = @editor.edit_callback_url(@path)
        lines = output.lines
        lines.select { |l| l.start_with?('# ') }.take(1).map { |l| l.gsub!(/^(# .*)$/, "\\1\n([*edit*](#{url}))") }
        output = lines.join
      end
      output.gsub! /\[\[(.*?)\]\]/ do |_|
        name = $1
        key = name.downcase
        filename = Shellwords.escape(name)
        path = if @cache.entries.include?(key)
                 @cache.entries[key]
               else
                 matches = Dir.glob("#{@root}/**/#{filename}.md")
                 if matches.empty?
                   nil
                 else
                   @cache.entries[key] = matches[0]
                 end
               end
        if path.nil?
          if @editor.respond_to?(:new_callback_url)
            url = @editor.new_callback_url(name)
            "[[**#{name}**]] ([*create*](#{url}))"
          else
            "**#{name}**(*?*)"
          end
        else
          "[#{name}](x-marked://open?file=#{path.url_encode})"
        end
      end
      @cache.persist
      output
    end
  end
end
