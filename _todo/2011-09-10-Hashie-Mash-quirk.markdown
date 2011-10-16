---
title: Little quirk in using Hashie::Mash
layout: post
categories: [ruby, pitfall]
---
Consider this simple code:
{% highlight ruby %}
m = Hashie::Mash.new
a = (m[:a] ||= [])
a << 3
p [a, m[:a]] # => [[3], []]
{% endhighlight %}
And tell me why this other, one-line longer version works as expected:
{% highlight ruby %}
m = Hashie::Mash.new
m[:a] ||= []
a = m[:a]
a << 3
p [a, m[:a]] # => [[3], []]
{% endhighlight %}
In the first version if you would use Hash instead of Mash everything would be also just fine.

It took me a while to find a bug in the code. Quick look at the source of Mash tells where the problem comes from:
https://github.com/intridea/hashie/blob/master/lib/hashie/mash.rb
{% highlight ruby %}
def []=(key,value) #:nodoc:
  regular_writer(convert_key(key), convert_value(value))
end
{% endhighlight %}

