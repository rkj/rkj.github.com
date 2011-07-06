module Excerpt
  include Liquid::StandardFilters
  def excerpt(content)
    content.match('<!--more-->') && (content.split('<!--more-->').first + "...") || truncatewords(strip_html(content), 100)
  end
end
Liquid::Template.register_filter(Excerpt)
