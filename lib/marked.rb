module Marked
  ;
end

require 'yaml'
require 'erb'
require 'shellwords'

require 'marked/editors'
require 'marked/cache'
require 'marked/wiki_link_preprocessor'

# Extensions
class String
  def url_encode
    ERB::Util.url_encode(self)
  end
end
