class << E

  # very basic cache implementation.
  # by default the cache will be kept in memory.
  # if you want to use a different pool, set it by using `cache_pool` at class level.
  # make sure your pool behaves just like a Hash,
  # meant it responds to `[]=`, `[]`, `delete` and `clear`
  def cache_pool pool
    cache_pool! pool, true
  end

  def cache_pool! pool, keep_existing = nil
    return if locked?
    return if @cache__pool && keep_existing
    @cache__pool = pool
  end

  def cache_pool?
    @cache__pool ||= Hash.new
  end
end

class E

  # simply running a block and store returned value.
  # on next request the stored value will be returned.
  # 
  # @note
  #   value is not stored if block returns false or nil
  #
  def cache key = nil, &proc
    unless key
      if ::AppetiteConstants::RESPOND_TO__SOURCE_LOCATION # ruby1.9
        key = proc.source_location
      else # ruby1.8
        key = proc.to_s.split('@').last
      end
    end
    cache_pool[key] || ( (val = proc.call) && (cache_pool[key] = val) )
  end

  def cache_pool
    self.class.cache_pool?
  end

  # a simple way to manage stored cache.
  # @example
  #    class App < E
  #
  #      before do
  #        if 'some condition occurred'
  #          # clearing cache only for @banners and @db_items
  #          clear_cache! :banners, :db_items
  #        end
  #        if 'some another condition occurred'
  #          # clearing all cache
  #          clear_cache!
  #        end
  #      end
  #    end
  #
  #    def index
  #      @db_items = cache :db_items do
  #        # fetching items
  #      end
  #      @banners = cache :banners do
  #        # render banners partial
  #      end
  #      # ...
  #    end
  #
  #    def products
  #      cache do
  #        # fetch and render products
  #      end
  #    end
  #  end
  #
  def clear_cache! *keys
    keys.size == 0 ?
        cache_pool.clear :
        keys.each { |key| cache_pool.delete key }
  end

  # clear cache that's matching given regexp(s) or array(s).
  # if regexp given it will match only String and Symbol keys.
  # if array given it will match only Array keys.
  def clear_cache_like! *keys
    keys.each do |key|
      if key.is_a? Array
        cache_pool.keys.each do |k|
          k.is_a?(Array) &&
            k.size >= key.size &&
            k.slice(0, key.size) == key &&
            cache_pool.delete(k)
        end
      elsif key.is_a? Regexp
        cache_pool.keys.each do |k|
          (
            (k.is_a?(String) && k =~ key) ||
            (k.is_a?(Symbol) && k.to_s =~ key) 
          ) && cache_pool.delete(k)
        end
      else
        raise "#%s only accepts arrays and regexps" % __method__
      end
    end
  end

  # clear cache only if given proc returns true.
  # def index
  #   # ...
  #   @procedures = cache [user, :procedures] do
  #     # ...
  #   end
  #   @actions = cache [user, :actions] do
  #     # ...
  #   end
  #   render
  # end
  #
  # private
  # def clear_user_cache
  #   clear_cache_if! do |k|
  #     k.is_a?(Array) && k.first == user
  #   end
  # end
  #
  def clear_cache_if! &proc
    cache_pool.keys.each { |k| proc.call(k) && cache_pool.delete(k) }
  end
end
