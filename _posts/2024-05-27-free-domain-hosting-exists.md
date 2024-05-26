---
layout: post
title: "Free domains exist but with little strings attached"
tags: web domain hosting
published: true
image: /uploads/code-unix.jpeg
---
After the recent demise of [freenom.com](https://freenom.com/), most webdev related subs and other forums on the Interwebs are very keen on this topic to somehow try and fill that void, find some alternatives. Being a PHP Freelancer, I often find the need for temporary domain names to experiment with and while USD 20 per year might sound like pittance for many folks in the West, it means a considerable amount in emerging economies of Asia.

If you're on the lookout for a free domain, you need to know your requirements thoroughly so that you'll understand whether you can live with certain limitations of the free service or not. For starters, nobody is giving out any top level CC TLDs like .com anymore, Freenom used to give them for .tk, .ga, etc. but now that service is halted.

What you'll get instead will be subdomains like `your-domain.xyz.com` which can probably double up as a proper domain as long as it fulfills a few conditions:

1. The primary domain i.e. `xyz.com` should be part of the [public suffix list](https://publicsuffix.org/list/public_suffix_list.dat).
2. Ideally, it should also be widely used (indexed by Google) and aged nicely (at least 4-5 years old preferably).
3. You get full control over how the subdomain behaves, more the better. At minimum, it should allow you to control A, CNAME and TXT records for the subdomain. NS records is even better but few give that for free.
4. There should be no other conditions like login every X days, etc.

Based on this, I've prepared a brief list of providers in the order of best to worst in terms of service quality!

1. [nic.ua](https://nic.ua/en/domains/.pp.ua) offers free `myname.pp.ua` domains which is best in class. It is as good as a regular domain because you get full control over NS records, you can do whatever you want with it, point to your web host or even Cloudflare. The advantage of control over NS records is that through Cloudflare you can create even sub-sub domains like `foo.myname.pp.ua`, etc. However, the bad news is that they seem to have added some restrictions of late. Now they require credit card verification and also activation of your domain through a key received from their telegram channel. This sounds like too much work TBH!
2. [eu.org](https://nic.eu.org/arf/en/domain/new/) is in the same league as `pp.ua`. If you can get yourself a `yourname.eu.org`, consider yourself very fortunate! But the bad news is that the service seems to be dormant since several months. Threads are full of complaints for unfulfilled domain requests from their NIC.
3. [desec.io](https://desec.io/domains) - Another great provider giving *.dedyn.io subdomains but halted the service presently.
4. [Cloudns.net](http://www.cloudns.net) - You will get a subdomain on *.cloudns.be or *.cloudns.ch which are slightly longer but still good considering they allow NS records.
5. [freedns.afraid.org](https://freedns.afraid.org/) - For some reason, folks on reddit keep singing praises of this service but it is actually very feature crippled and useless. Firstly, though they have some nicely aged subdomains like *.us.to and *.moo.com, none of these domains are part of the [public suffix list](https://publicsuffix.org/list/public_suffix_list.dat). This means, they have very slim chance of getting indexed and zero chance of being considered by services like Adsense! And the biggest downside is they don't give you control over CNAME nor NS records by default. For this, you have to literally beg the passive aggressive domain owners (admins) through email and even then there is very slim chance!
6. [DuckDNS](https://www.duckdns.org/) - DuckDNS service is actually very good! The only catch is they won't let you add CNAME or NS records, nor will they let you add TXT record which means you can't verify ownership anywhere. They only provide A (Alias) records as it is primarily intended for self-hosted users. But you can still point it to something like AWS/EC2 instance or your Github Pages which works great for that use case, except for the SSL part.
7. [noip.com](https://www.noip.com/) - Now we are entering the territory of domain providers who won't let you control NS records but otherwise they are ok. The only nagging restriction with noip.com is that you must confirm once a month that you're using the DNS service by clicking an email link. Forget doing that and your domain is gone!
8. [dynv6](https://dynv6.com/) - I haven't tested this much but seems all right. But I've found some threads complaining about weird issues like A records missing all of a sudden and other hiccups.

Let me know if I've missed any good ones. Addendum are most welcome.