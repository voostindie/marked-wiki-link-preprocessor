module Marked
  class TextMate
    def initialize(root, settings)
      @root = root
    end

    def edit_callback_url(path)
      url = "file://#{path}"
      "txmt://open?url=#{url.url_encode}"
    end

  end

  class IAWriter
    def initialize(root, settings)
      @root = root
      @token = settings['token']
      @location = settings['location']
      raise 'IA Writer configuration is missing authentication token. Set this in \"token\".' unless @token
      raise 'IA Writer configuration is missing library path. Set this in \"location".' unless @location
    end

    def new_callback_url(name)
      location = File.join(@location, name + '.md')
      text = '# ' + name
      "iawriter://new?path=#{location.url_encode}&text=#{text.url_encode}&auth-token=#{@token}"
    end

    def edit_callback_url(path)
      location = File.join(@location, path[@root.length..])
      "iawriter://open?path=#{location.url_encode}"
    end
  end

  EDITORS = {
    'ia writer' => IAWriter,
    'iawriter' => IAWriter,
    'textmate' => TextMate,
    'mate' => TextMate
  }.freeze
end