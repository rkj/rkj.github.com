---
title: Automatically adding specific files before commit to Mercurial repo
layout: post
categories: [Mercurial]
---
When you create new files, you have to add them manually to the repository using either `hg add` or `hg addremove` before issuing commit.

If you often create some files you may want not to be bothered by this additional commands. Then you may use `hg commit -A` which will add all new files automatically. You can even make an alias in your `.hgrc` so every commit will have the option turned on.

But there might be a problem if you have some unnecessary files (like logs) that are not specified in `.hgignore`. 
If for some reason you cannot/do not want to create ignore rules for them, but you still want to add some files automatically with commit you may try a simple hook in your `.hgrc`:
{% highlight ini %}
[hooks]
pre-commit = hg add . -I 'glob:**.c' -q || true
{% endhighlight %}
Where you should of course change `'glob:**.c'` to a pattern that will match your files.
And do not confuse `pre-commit` with `precommit` as they are totally different.

Personally I do not use this, because always before issuing a commit I do:
{% highlight sh %}
$ hg status
$ hg diff | mate 
{% endhighlight %}
to see all the changes made and make sure that there are no leftover changes (like some random debugging printfs). But your situation may be different and you can give the hook a try.
