---
title: Shifting bytes left in different languages
layout: post
categories: [java, ruby, python, c, programming]
---
Recently I must have had a really bad day, because I wrote a very stupid line of code in java:
{% highlight java %}
int x = 2 << (s - 1);
{% endhighlight %}
when I wanted something a little simpler:
{% highlight java %}
int x = 1 << s;
{% endhighlight %}
It gave unexpected (for me) behavior for shifting negative number of bits. I was having hope that shifting -1 place left would be equal to shifting 1 place right. But I was wrong, and the result was always zero, no matter what number I would try to shift. 
After a little search I have found: [Bitwise and Bit Shift Operators](http://java.sun.com/docs/books/tutorial/java/nutsandbolts/op3.html "Bitwise and Bit Shift Operators") but is says nothing about this case.

So I tried the same code in different languages to check how they behave. I started with my favorite -- Ruby:
{% highlight ruby %}
{% include code/2010-01-19/shift.rb %}
{% endhighlight %}
Here the results were as I would like them to be.

So what does our good, old friend C has to say?
{% highlight c %}
{% include code/2010-01-19/shift.c %}
{% endhighlight %}
It gives the same results as Java code. So I have to assume that it is described in some specification, or maybe is processor specific as shifting is simple assembler instruction.

Last language I have tried is Ruby companion, Python, which behave more elegantly than C or Java:
{% highlight python %}
{% include code/2010-01-19/shift.py %}
{% endhighlight %}
It actually checked for nonsensical value and raised an exception not giving me silently wrong (from my perspective) value.
Sadly Python does not behave similarly for other basic mistakes, as:
{% highlight python %}
>>> 2 < "1"
True
{% endhighlight %}
