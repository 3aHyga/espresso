class EApp

  include ::AppetiteUtils

  # Rack interface to all found controllers
  #
  # @example config.ru
  #    module App
  #      class Forum < E
  #        map '/forum'
  #
  #        # ...
  #      end
  #
  #      class Blog < E
  #        map '/blog'
  #
  #        # ...
  #      end
  #    end
  #
  #    run EApp
  def self.call env
    new.call env
  end

  module Setup

    include ::AppetiteUtils
    include ::AppetiteHelpers

    # set/get app root
    def root path = nil
      @root = ('%s/' % path).sub(/\/+\Z/, '/').freeze if path
      @root ||= (::Dir.pwd << '/').freeze
    end

    alias app_root root

    # allow app to use sessions.
    #
    # @example keep sessions in memory
    #    class App < E
    #      # ...
    #    end
    #    app = EApp.new
    #    app.session :memory
    #    app.run
    #
    # @example keep sessions in memory using custom options
    #    class App < E
    #      # ...
    #    end
    #    app = EApp.new
    #    app.session :memory, :domain => 'foo.com', :expire_after => 2592000
    #    app.run
    #
    # @example keep sessions in cookies
    #    class App < E
    #      # ...
    #    end
    #    app = EApp.new
    #    app.session :cookies
    #    app.run
    #
    # @example keep sessions in memcache
    #    class App < E
    #      # ...
    #    end
    #    app = EApp.new
    #    app.session :memcache
    #    app.run
    #
    # @example use a custom pool, i.e. github.com/migrs/rack-session-mongo
    #    #> gem install rack-session-mongo
    #
    #    class App < E
    #      # ...
    #    end
    #
    #    require 'rack/session/mongo'
    #
    #    app = EApp.new
    #    app.session Rack::Session::Mongo
    #    app.run
    #
    # @param [Symbol, Class] use
    # @param [Array] args
    def session use, *args
      args.unshift case use
                     when :memory
                       ::Rack::Session::Pool
                     when :cookies
                       ::Rack::Session::Cookie
                     when :memcache
                       ::Rack::Session::Memcache
                     else
                       use
                   end
      use(*args)
    end

    # middleware declared here will be used on all controllers.
    #
    # especially, here should go middleware that changes app state,
    # which wont work if defined inside controller.
    #
    # you can of course define any type of middleware at app level,
    # it is even recommended to do so to avoid redundant
    # middleware declaration at controllers level.
    #
    # @example
    #
    #    class App < E
    #      # ...
    #    end
    #    app = EApp.new
    #    app.use SomeMiddleware, :with, :some => :opts
    #    app.run
    #
    # Any middleware that does not change app state,
    # i.e. non-upfront middleware, can be defined inside controllers.
    #
    # @note middleware defined inside some controller will run only for that controller.
    #       to have global middleware, define it at app level.
    #
    # @example defining middleware at app level
    #    module App
    #      class Forum < E
    #        map '/forum'
    #        # ...
    #      end
    #
    #      class Blog < E
    #        map '/blog'
    #        # ...
    #      end
    #    end
    #
    #    app = EApp.new
    #    app.use Rack::CommonLogger
    #    app.use Rack::ShowExceptions
    #    app.run
    #
    def use ware = nil, *args, &proc
      @middleware ||= []
      @middleware << {:ware => ware, :args => args, :proc => proc} if ware
      @middleware
    end

    # declaring rewrite rules.
    #
    # first argument should be a regex and a proc should be provided.
    #
    # the regex(actual rule) will be compared against Request-URI,
    # i.e. current URL without query string.
    # if some rule depend on query string,
    # use `params` inside proc to determine either some param was or not set.
    #
    # the proc will decide how to operate when rule matched.
    # you can do:
    # `redirect('location')`
    #     redirect to new location using 302 status code
    # `permanent_redirect('location')`
    #     redirect to new location using 301 status code
    # `pass(controller, action, any, params, with => opts)`
    #     pass control to given controller and action without redirect.
    #     consequent params are used to build URL to be sent to given controller.
    # `halt(status|body|headers|response)`
    #     send response to browser without redirect.
    #     accepts an arbitrary number of arguments.
    #     if arg is an Integer, it will be used as status code.
    #     if arg is a Hash, it is treated as headers.
    #     if it is an array, it is treated as Rack response and are sent immediately, ignoring other args.
    #     any other args are treated as body.
    #
    # @note any method available to controller instance are also available inside rule proc.
    #       so you can fine tune the behavior of any rule.
    #       ex. redirect on GET requests and pass control on POST requests.
    #       or do permanent redirect for robots and simple redirect for browsers etc.
    #
    # @example
    #    app = EApp.new
    #
    #    # redirect to new address
    #    app.rewrite /\A\/(.*)\.php$/ do |title|
    #      redirect Controller.route(:index, title)
    #    end
    #
    #    # permanent redirect
    #    app.rewrite /\A\/news\/([\w|\d]+)\-(\d+)\.html/ do |title, id|
    #      permanent_redirect Forum, :posts, :title => title, :id => id
    #    end
    #
    #    # no redirect, just pass control to News controller
    #    app.rewrite /\A\/latest\/(.*)\.html/ do |title|
    #      pass News, :index, :scope => :latest, :title => title
    #    end
    #
    #    # Return arbitrary body, status-code, headers, without redirect:
    #    # If argument is a hash, it is added to headers.
    #    # If argument is a Integer, it is treated as Status-Code.
    #    # Any other arguments are treated as body.
    #    app.rewrite /\A\/archived\/(.*)\.html/ do |title|
    #      if page = Model::Page.first(:url => title)
    #        halt page.content, 'Last-Modified' => page.last_modified.to_rfc2822
    #      else
    #        halt 404, 'page not found'
    #      end
    #    end
    #
    #    app.run
    #
    def rewrite rule = nil, &proc
      rewrite_rules << [rule, proc] if proc
    end

    alias rewrite_rule rewrite

    def rewrite_rules
      @rewrite_rules ||= []
    end
  end
  include Setup

  def initialize automount = false, &proc
    @controllers = automount ? discover_controllers : []
    proc && self.instance_exec(&proc)
  end

  # proc given here will be executed inside each controller
  def mount namespace, *roots, &setup
    umount namespace
    extract_controllers(namespace).each do |ctrl|
      (root = roots.shift) && ctrl.remap!(root, *roots)
      @controllers << [ctrl, setup]
    end
    self
  end

  # umount given slices/controllers.
  # if called without args, will umount all controllers.
  def umount *namespaces
    if namespaces.size > 0
      namespaces.each do |ns|
        controllers = extract_controllers ns
        @controllers.reject! { |c| controllers.include? c }
      end
    else
      @controllers.clear
    end
    self
  end

  # proc given here will be executed inside app instance
  def setup &proc
    self.instance_exec &proc
    self
  end

  def lock!
    @locked = true
    self
  end

  def locked?
    @locked
  end

  # displays URLs the app will respond to,
  # with controller and action that serving each URL.
  def url_map opts = {}
    app
    map = {}
    @controllers.each do |c|
      c.first.url_map.each_pair do |r, s|
        s.each_pair { |rm, as| (map[r] ||= {})[rm] = as.dup.unshift(c.first) }
      end
    end

    map.define_singleton_method :to_s do
      out = []
      map = self
      map.each do |data|
        route, request_methods = data
        next if route.size == 0
        out << "%s\n" % route
        next unless opts[:verbose]
        request_methods.each_pair do |request_method, route_setup|
          out << "  %s%s" % [request_method, ' ' * (10 - request_method.size)]
          out << "%s#%s\n" % [route_setup[0], route_setup[3]]
        end
        out << "\n"
      end
      out.join
    end

    map
  end

  alias urlmap url_map

  # by default, Espresso will use WEBrick server and default WEBrick port.
  # pass :server option and any option accepted by selected(or default) server:
  #
  # @example use Thin server with its default port
  #   app.run server: :Thin
  # @example use EventedMongrel server with custom options
  #   app.run server: :EventedMongrel, Port: 9090, num_processors: 1000
  #
  # @param [Hash] opts
  def run opts = {}
    server = opts.delete(:server)
    server && ::Rack::Handler.const_defined?(server) || (server = :WEBrick)
    ::Rack::Handler.const_get(server).run self, opts
  end

  # Rack interface
  def call env
    app.call env
  end

  def app
    @app ||= builder
  end

  alias to_app app

  private
  def builder
    builder = ::Rack::Builder.new
    use.each { |w| builder.use w[:ware], *w[:args], &w[:proc] }
    @controllers.each do |ctrl|
      ctrl, global_setup = ctrl

      ctrl.app = self
      ctrl.setup!
      ctrl.global_setup! &global_setup
      ctrl.map!

      ctrl.url_map.each_pair do |route, rest_map|
        builder.map route do
          ctrl.use?.each { |w| use w[:ware], *w[:args], &w[:proc] }
          run lambda { |env| ctrl.new(nil, rest_map).call env }
        end
      end
      ctrl.freeze!
      ctrl.lock! if locked?
    end
    rewrite_rules.size > 0 ?
        ::AppetiteRewriter.new(rewrite_rules, builder.to_app) :
        builder.to_app
  end

  def discover_controllers namespace = nil
    controllers = ::ObjectSpace.each_object(::Class).
        select { |c| is_app?(c) }.
        reject { |c| [::Appetite, ::AppetiteRewriter, ::E].include? c }
    return controllers unless namespace

    namespace.is_a?(Regexp) ?
        controllers.select { |c| c.name =~ namespace } :
        controllers.select { |c| [c.name, c.name.split('::').last].include? namespace.to_s }
  end

  def extract_controllers namespace

    return ([namespace] + namespace.constants.map { |c| namespace.const_get(c) }).
        select { |c| is_app? c } if [Class, Module].include?(namespace.class)

    discover_controllers namespace
  end

end
