---
title: Shifting bytes left in different languages
layout: post
categories: [java, ruby, python, c, programming]
---
Compare this two lines of code:
{% highlight java linenos %}
int one = 2 << (no - 1)
int two = (2 << no) / 2;
{% endhighlight %}
They are almost identical. The only difference is for `no = 0` when `one` have value 0 and `two` has value 1.

[Bitwise and Bit Shift Operators](http://java.sun.com/docs/books/tutorial/java/nutsandbolts/op3.html "Bitwise and Bit Shift Operators")

