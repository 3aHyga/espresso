class EApp
  module Setup

    # set the baseurl for assets.
    # by default, assets URL is empty.
    # 
    # @example assets_url not set
    #   script_tag 'master.js'
    #   => <script src="master.js"
    #   style_tag 'theme.css'
    #   => <link href="theme.css"
    #
    # @example assets_url set to /assets
    #
    #   script_tag 'master.js'
    #   => <script src="/assets/master.js"
    #   style_tag 'theme.css'
    #   => <link href="/assets/theme.css"
    #
    # @note
    #   if second argument given, Espresso will reserve given URL for serving assets,
    #   so make sure it does not interfere with your actions.
    #
    # @example
    #
    # class App < E
    #   map '/'
    #
    #   # actions inside controller are not affected 
    #   # cause app is not set to serve assets, thus no URLs are reserved.
    #   
    # end
    #
    # app = EApp.new do
    #   assets_url '/'
    #   mount App
    # end
    # app.run
    #
    #
    # @example
    #
    # class App < E
    #   map '/'
    #   
    #   # no action here will work cause "/" URL is reserved for assets
    #   
    # end
    #
    # app = EApp.new do
    #   assets_url '/', :serve
    #   mount App
    # end
    # app.run
    #
    # @example
    #
    # class App < E
    #   map '/'
    #  
    #   def assets
    #     # this action wont work cause "/assets" URL is reserved for assets
    #   end
    #
    #   # other actions will work normally
    #  
    # end
    #
    # app = EApp.new do
    #   assets_url '/assets', :serve
    #   mount App
    # end
    # app.run
    #
    def assets_url url = nil, serve = nil
      if url
        assets_url     = url =~ /\A[\w|\d]+\:\/\// ? url : rootify_url(url)
        @assets_url    = (assets_url =~ /\/\Z/ ? assets_url : assets_url << '/').freeze
        @assets_server = true if serve
      end
      @assets_url ||= ''
    end
    alias assets_map assets_url

    def assets_server?
      @assets_server
    end

    # used when app is set to serve assets.
    # by default, Espresso will serve files found under public/ folder inside app root.
    # use `assets_path` at class level to set custom path.
    #
    # @note `assets_path` is used to set paths relative to app root.
    #       to set absolute path to assets, use `assets_fullpath` instead.
    #
    def assets_path path = nil
      @assets_path = root + normalize_path(path).freeze if path
      @assets_path ||= '' << root << 'public/'.freeze
    end

    def assets_fullpath path = nil
      @assets_fullpath = normalize_path(path).freeze if path
      @assets_fullpath
    end

  end

end

class E

  class EspressoFrameworkInstanceVariables

    def assets__opts_to_s opts
      (@assets_opts ||= {})[opts] = opts.keys.inject([]) do |f, k|
        f << '%s="%s"' % [k, ::CGI.escapeHTML(opts[k])]
      end.join(' ')
    end
  end

  def assets_url path = nil
    base = self.class.app.assets_url.dup
    path ? base << path : base
  end

  # handy method to load multiple assets from same path,
  # avoiding typing same path multiple times.
  #
  # @example Assuming `assets_map` was set to /
  #
  #   load_assets 'master.js', 'styles.css'
  #
  # => <script src="/master.js" type="text/javascript"></script>
  # => <link href="/styles.css" rel="stylesheet" />
  #
  # @example passing path to load assets from via :from option
  #
  #   load_assets 'jquery.js', 'reset.css', 'blah/doh.js', :from => 'vendor'
  #
  # => <script src="/vendor/jquery.js" type="text/javascript"></script>
  # => <link href="/vendor/reset.css" rel="stylesheet" />
  # => <script src="/vendor/blah/doh.js" type="text/javascript"></script>
  #
  # @note if path passed via :from option starting with a protocol or a slash, 
  #       it is used as base URL, ignoring `assets_url` setup.
  #
  # @note please make sure the given path ending in a slash!
  #       Espresso will not handle this automatically cause it is too expensive.
  def load_assets *assets_and_opts
    opts = assets_and_opts.last.is_a?(Hash) ? assets_and_opts.pop : {}
    if base = opts[:from]
      # using base URL only if given path does not start with a protocol or a slash
      base = assets_url(base) unless base =~ /\A[\w|\d]+\:\/\/|\A\//
    else
      base = assets_url
    end
    html = ''
    assets_and_opts.each do |asset|
      ext = ::File.extname(asset)
      src = base + asset
      # passing URL as :src opt instead of first argument
      # to avoid redundant `assets_url` calling
      html << script_tag(:src => src ) if ext == '.js'
      html << style_tag( :src => src ) if ext == '.css'
    end
    html
  end

  # building HTML script tag from given URL and opts.
  # if passing URL as first argument, 
  # it will be appended to the assets base URL, set via `assets_map` at app level.
  # 
  # if you want an unmapped URL, pass it via :src option.
  # this will avoid `assets_map` setup and use the URL as is.
  def script_tag src = nil, opts = {}, &proc
    src.is_a?(Hash) && (opts = src.dup) && (src = nil)
    opts[:type] ||= 'text/javascript'
    if proc
      "<script %s>\n%s\n</script>\n" % [__e__.assets__opts_to_s(opts), proc.call]
    else
      opted_src = opts.delete(:src)
      src ||= opted_src || raise('Please provide script URL as first argument or via :src option')
      "<script src=\"%s\" %s></script>\n" % [
        opted_src ? opted_src : assets_url(src),
        __e__.assets__opts_to_s(opts)
      ]
    end
  end

  # same as `script_tag`, except it building an style/link tag
  def style_tag src = nil, opts = {}, &proc
    src.is_a?(Hash) && (opts = src.dup) && (src = nil)
    if proc
      opts[:type] ||= 'text/css'
      "<style %s>\n%s\n</style>\n" % [__e__.assets__opts_to_s(opts), proc.call]
    else
      opts[:rel] = 'stylesheet'
      opted_src = opts.delete(:href) || opts.delete(:src)
      src ||= opted_src || raise('Please URL as first argument or :href option')
      "<link href=\"%s\" %s />\n" % [
        opted_src ? opted_src : assets_url(src),
        __e__.assets__opts_to_s(opts)
      ]
    end
  end

  # builds and HTML img tag.
  # URLs are resolved exactly as per `script_tag` and `style_tag`
  def image_tag src = nil, opts = {}
    src.is_a?(Hash) && (opts = src.dup) && (src = nil)
    opted_src = opts.delete(:src)
    src ||= opted_src || raise('Please provide image URL as first argument or :src option')
    opts[:alt] ||= ::File.basename(src, ::File.extname(src))
    "<img src=\"%s\" %s />\n" % [
      opted_src ? opted_src : assets_url(src),
      __e__.assets__opts_to_s(opts)
    ]
  end
  alias img_tag image_tag

end
