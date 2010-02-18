---
title: Mercurial rollback can cause unexpected data loss
layout: post
categories: [Mercurial]
---
One of import differences between Mercurial and git is that in the former it is very hard to change the history of a repository. It is by design (although it can be ,,bypassed'' with usage of plugins like MQ) and there are good reasons for it. This gives this warm, fuzzy feeling of security and makes harder to screw up really hard. So I consider it to be a real user-friendly aspect of Mercurial.

But recently I was bitten by rollback command which undo last transaction (commit, pull, and so others command). I use it more often than I would like - mostly for undoing commit. It helps when I have forgot to add a file, or added some garbage, etc. It is suitable only before you push you changes - but many simple mistakes are spotted right away. They may be fixed without rollback - with a second commit, but it would unnecessary clobber history and made you look silly. So if I make an erroneous commit I rollback, fix it and commit again. This procedure has worked fine many, many times. Until recently.

Let see some contrived example. First we create a repo:
{% highlight sh %}
mkdir example
cd example
hg init
echo a > a
hg ci -Am 'a'
{% endhighlight %}
Next we start some development in a branch:
{% highlight sh %}
hg branch b
echo b > b
hg ci -Am 'b'
{% endhighlight %}
And next we make mistaken commit
{% highlight sh %}
echo d > c
hg ci -Am 'c'
{% endhighlight %}
Normally if we spot error right away we can issue:
{% highlight sh%}
hg rollback
cat c # ok, the file is there, we can fix it
hg ci -Am 'c'
{% endhighlight %}
But if we change a branch and then make a rollback we are screwed:
{% highlight sh%}
hg up default
hg rollback
cat c # cat: c: No such file or directory - hmmm
hg up b # let's go to our original branch
cat c # cat: c: No such file or directory - upppsss
{% endhighlight %}
Since the commit is undone there is no `c` in branch `b`, so `update` does not help. Fortunately for me, I had editor windows still opened, where I could use undo - to redo my changes. This time I have not lost anything. But there were some scary moments ;-).

So I think the lesson is that if you are to make a rollback then be sure that you have not made any updates to the repository, because rollback will not even warn you.
