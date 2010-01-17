---
title: Rakefile for dealing with mercurial subrepos
layout: post
categories: [Mercurial, rake, subrepositories]
---
Subrepositories is quite an important thing if you have any bigger project, where you can extract some libraries, modules, parts or any other such things. We have chosen Mercurial for version control, because it distributed (svn suxx ass), easy to use, and have good cross-platform support. Until version 1.3 it did not have any support for subrepositories, now it has one.
It is far from perfect, but still much better than nothing. And I am sure it will get better, or eventually great. 

But for the time I have made quite simple Rakefile to help with subrepos. It works fine also with Mercurial versions less than 1.3. To use it you must have Ruby and gems: rake, term-ansicolor installed. Script assumes that you have subdirectories which are Mercurial repositiories and issues commands on each of them.

`rake -T` will give you list of available tasks:
- hg - generic task. You can invoke it like: `CMD=status rake hg` and it will invoke CMD on every repository. In this case it will display status.
- pull, push, status - does what the name says.
- update - does pull -u.
- rebase - does pull --rebase. You must have `hgext.rebase=` enabled for it to work.
- tag - invoked `rake tag name=0.1` will tag each repository with tag 0.1.
- upto - invoked `rake upto rev=0.2` will do `hg up -r 0.2`. It makes sense with branches and tags, not so much with revisions, because each subrepo have its own history ;-).
- commit - if you have main repository, that contains all the others (as when you use Mercurial subrepo support) it will read commit messages from all the subrepos since last commit to the main repo and copy them into clipboard (works on a Mac only, I think).

{% highlight ruby linenos %}
{% include Mercurial_Rakefile %}
{% endhighlight %}

