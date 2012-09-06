module Jekyll
  class Site
    attr_accessor :locales

    def locales
      self.config['locales'].split(',')
    end
  end

  class Post
    attr_accessor :locale
    
    def locale
      self.data['locale']
    end

    def url
      return "/#{self.data['locale']}#{@url}" if @url

      url = if permalink
        permalink
      else
        {
          "year"       => date.strftime("%Y"),
          "month"      => date.strftime("%m"),
          "day"        => date.strftime("%d"),
          "title"      => CGI.escape(slug),
          "i_day"      => date.strftime("%d").to_i.to_s,
          "i_month"    => date.strftime("%m").to_i.to_s,
          "categories" => categories.map { |c| URI.escape(c) }.join('/'),
          "output_ext" => self.output_ext
        }.inject(template) { |result, token|
          result.gsub(/:#{Regexp.escape token.first}/, token.last)
        }.gsub(/\/\//, "/")
      end

      # sanitize url
      @url = url.split('/').reject{ |part| part =~ /^\.+$/ }.join('/')
      @url += "/" if url =~ /\/$/
      "/#{self.data['locale']}#{@url}"
    end
  end

  class Page
    attr_accessor :locale
    
    def locale
      self.data['locale']
    end

    def url
      @url = '/index.html' if @url && @url =~ /index(.*).html/
      return "/#{self.data['locale']}#{@url}" if @url

      url = if permalink
        permalink
      else
        {
          "basename"   => self.basename,
          "output_ext" => self.output_ext,
        }.inject(template) { |result, token|
          result.gsub(/:#{token.first}/, token.last)
        }.gsub(/\/\//, "/")
      end

      # sanitize url
      @url = url.split('/').reject{ |part| part =~ /^\.+$/ }.join('/')
      @url += "/" if url =~ /\/$/
      "/#{self.data['locale']}#{@url}"
    end
  end
end
