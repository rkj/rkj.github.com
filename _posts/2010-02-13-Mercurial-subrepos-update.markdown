---
title: Updated Rakefile for dealing with mercurial subrepos
layout: post
categories: [Mercurial, rake, subrepositories]
---
Previously I have described my solution for subrepos in Mercurial. It was working nicely but, a little painfully, because you had to add every single Mercurial command you like to use as Rake task. After little googleing and scratching head I have come with a much nicer and general solution:
{% highlight ruby %}
desc "Invokes any hg command on every repo."
task "hg:command"
rule /^hg:/ do |t| # rule selecting task starting with hg:
  on_repos("hg #{t.name.sub(/^hg:/, "")}") # 'hg:' is in task name so we have to erase it
end # and that's all folks :D
{% endhighlight %}
It is shorter and any command may be used, with any parameters, like:
{% highlight ruby %}
rake hg:status
rake hg:"revert -a"
{% endhighlight %}
and so on. Enjoy!
