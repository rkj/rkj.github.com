---
title: Email notification for multiple Mercurial repositories
layout: post
categories: Mercurial notifications
---

# Mercurial-server

Recently I have discovered the awesome [mercurial-server](http://www.lshift.net/mercurial-server.html). It gives flexible access control, takes care of file permission (which was problematic in our previous setup) and allows to hide physical path of the repo from its URL. It also offers global configuration file, which can include hooks for all of the repositories.

This offers an advantage in setting mail notifications using [NotifyExtension](http://mercurial.selenic.com/wiki/NotifyExtension). In our previous setup we had included all the options and the template in each's repository hgrc file. It required us to use some setup script for creating repositories and was somewhat clumsy - there were no feel of some global administration.

Using global configuration allow us to easily put the configuration in the global rc file (in `/etc/mercurial-server/remote-hgrc.d/` dir) pointing to the template inside `hgadmin` repo. There would still be need to put `usersubs` or `reposubs` sections in each repository' hgrc to specify who gets notification from which repo but it is now much cleaner and only info about specific repo goes to the hgrc.

# Global subscribers configuration

We wanted to get one step further and have some global configuration of subscribers in one place (and preferably in `hgadmin` repo), but this required some extra effort. Since I have not found a way to use any variables in `reposubs` section (which specifies who gets notified) we decided that all emails will go to local account (`hg@localhost` at the server), and will include custom header (X-Repo) with the repository name (it was easily added in the style file).
Then we use [procmail](http://www.procmail.org/) to handle routing:
{% highlight bash %}
:0c
* ^X-Repo: \/.*
{
  RPATH=/repos/hgadmin/subscriptions/${MATCH}
  DEFAULT=`cat /repos/hgadmin/subscriptions/default`
  EMAIL=`if [ -f $RPATH ]; then cat $RPATH; else echo "Please create file /hgadmin/subscriptions/${MATCH}!" | mail -s "No subscriptions for repository >>${MATCH}<<" $DEFAULT; echo $DEFAULT ; fi `
  :0
  ! ${EMAIL}
}
{% endhighlight %}
If email have the `X-Repo` header we search for subscribers in the  repository's file (addresses can be separated by spaces or newlines). If there is no relevant file, a warning email is sent to the default address, so we do not forget about any created repo.

Then procmail forwards the notification email to the subscribers and we are happy. Of course one could have even more advanced setup involving reading groups or privileges from LDAP, etc.

But maybe you know a simpler way (without procmail) to achieve this? 

Below you see our configuration files:

# /etc/mercurial-server/remote-hgrc.d/notify.rc

{% highlight ini %}
[extensions]
hgext.notify =

[hooks]
changegroup.notify = python:hgext.notify.hook

[email]
from = vcs-hg@itiner.pl

[smtp]
host = localhost

[notify]
test = false
strip = 0
style = /repos/hgadmin/styles/notify.style

[reposubs]
# key is glob pattern, value is comma-separated list of subscriber emails
* = hg@localhost
{% endhighlight %}

# /repos/hgadmin/styles/notify.style

{% highlight ini %}
start_files = 'files:      '
file = ' {file}'
end_files = '\n'
start_file_mods = 'files:      '
file_mod = ' {file_mod}'
end_file_mods = '\n'
start_file_adds = 'files+:     '
file_add = ' {file_add}'
end_file_adds = '\n'
start_file_dels = 'files-:     '
file_del = ' {file_del}'
end_file_dels = '\n'
start_file_copies = 'copies:     '
file_copy = ' {name} ({source})'
end_file_copies = '\n'
extra = 'extra:       {key}={value|stringescape}\n'

changeset="X-Repo: {webroot|basename}\nSubject: [{webroot|basename}] Mercurial changeset {rev} by {author}\n\nrepository: https://vcs.itiner.pl/projects/{webroot|basename}/repository\nchangeset: {rev}\nuser:      {author}\ndate:      {date|date}\n{file_mods}{file_adds}{file_dels}{file_copies_switch}{extras}\ndescription:\n{desc}\n"
{% endhighlight %}
