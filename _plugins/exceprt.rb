module Jekyll
  class Post
    include Liquid::StandardFilters
    alias_method :original_to_liquid, :to_liquid
    def to_liquid
      original_to_liquid.deep_merge({
        'excerpt' => content.match('<!--more-->') && content.split('<!--more-->').first || truncatewords(strip_html(content), 100)
      })
    end
  end
end
