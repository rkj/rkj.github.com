module Excerpt
  include Liquid::StandardFilters
  def excerpt(content)
    content.match('<!--more-->') && (content.split('<!--more-->').first + "...") || truncatewords(strip_html(content), 100)
  end
end
Liquid::Template.register_filter(Excerpt)

module Jekyll
  class ExcerptTag < Liquid::Block
    include Liquid::StandardFilters
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      text = super.join
      text.match('<!--more-->') && (text.split('<!--more-->').first + "...") || truncatewords(strip_html(text), 100)
    end
  end
  Liquid::Template.register_tag('excerpt', ExcerptTag)
end

