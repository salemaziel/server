  Privacy Guide

**Tor**
=======

Tor uses a protocol called onion routing. Onion routing was created by the US Naval Research Lab to allow them to research and get information anonymously. While creating this they realised that if only they used it then the servers they connect to will know it's them since they're the only ones who can use onion routing. This meant they had to release it to the public.  
  
Tor was then created by the Tor Project who use Tor as a way to protect people's privacy online and bypass censorship.  
  
[https://www.torproject.org/docs/faq.html.en#WhyCalledTor](https://www.torproject.org/docs/faq.html.en#WhyCalledTor)

Does Tor have a backdoor?
-------------------------

Some people believe Tor has backdoors since it was created by the US Navy. This is not true. Tor is completely open source and has been audited many times. You can check yourself for any backdoors.  
  
[https://www.torproject.org/docs/faq.html.en#Backdoor](https://www.torproject.org/docs/faq.html.en#Backdoor)

How does Tor work?
------------------

Tor encrypts your traffic three times on your machine. It then sends your traffic to three nodes/relays all across the world. These nodes are run by volunteers. Anyone can easily create a node.  
  
Each node your traffic bounces through strips away a layer of encryption and forwards it on to the next. Once you reach the exit node it decrypts your traffic fully so you can connect to the website.  
  
![This image is not displaying correctly.](images/torinfographic2.png)  
  
Since it is encrypted three times, the first and second node can't see anything but where to send the data too and where the data came from. The second node gets the first node's IP and the first node gets your real IP but it doesn't have anything to link this with so it's useless to that node. This makes it impossible for the first and second node to find out who you are and what you're doing.  
  
The exit node decrypts the traffic fully so it can see the traffic and inject malicious code. It still doesn't get your real IP and only gets the second node's IP.  
  
If you use HTTPS (which most sites use) it encrypts your traffic from the exit node to the website. This stops the exit node from seeing the full URL and only the domain. E.g. they can only see "theprivacyguide1.github.io" and not "theprivacyguide1.github.io/tor.html". HTTPS also stops the exit node from being able to inject malicious code. The Tor Browser has HTTPS Everywhere which changes a HTTP connection to HTTPS if possible.  
  
Because your data is encrypted and bounced all over the world this makes it very hard for someone to find out who you are.  
  
See [https://www.torproject.org/about/overview.html.en#thesolution](https://www.torproject.org/about/overview.html.en#thesolution) for more information.

### How do onion services work?

Onion services are websites that are only accessible through Tor and their URL ends in .onion. https://3g2upl4pq6kufc4m.onion/ is DuckDuckGo's onion service.  
  
When you use an onion service you ask the server to allow you to connect. If it accepts then you do the usual three hops and so does the onion service. It meets you at a rendezvous point. This means you can't find out where the onion service is either.  
  
Onion services are still inside the Tor network and are end to end encrypted. There are no exit nodes. These are even more secure than Tor for the clearnet.  
  
See [https://www.torproject.org/docs/onion-services.html.en](https://www.torproject.org/docs/onion-services.html.en) for more information.

Attacks against the Tor network.
--------------------------------

Tor is not bulletproof. It has vulnerabilities although these aren't very bad.

### Traffic/Timing Correlation

It's hard to protect against traffic analysis attacks. There isn't much you could do. The main ways people talk about are timing correlation and traffic correlation.  
  
Timing correlation is when you are connected to Tor at the same time something happens from Tor.  
  
E.g. the Harvard bomb threat. A student wanted to get out of class so they made a bomb threat to the school through Tor. They were the only person connected to Tor in the area when it happened. The police then found out it was them who did it. The only way to protect against this is using Tor more often and generalising it's usage or hiding your Tor usage by using a bridge or other software.  
  
Traffic correlation is when somebody monitors the traffic going into Tor and coming out of Tor. They can compare the traffic and see if any are the same. If the traffic looks the same then it could deanonymize users.  
  
You can't really protect against this unless a lot more people use Tor to hide your traffic. This attack is really hard to do and if it's performed on you then you're probably a target for the NSA so this would be the least of your problems.  
  
None of these attacks mean Tor is broken. Tor is not a magic bullet. It doesn't make you completely anonymous. The Tor project even says this.  
  
[https://www.torproject.org/docs/faq.html.en#AttacksOnOnionRouting](https://www.torproject.org/docs/faq.html.en#AttacksOnOnionRouting)

#### Other Attacks

Most other attacks are not Tor's fault but the user's fault. Lots of people claim that the FBI javascript malware means they compromised Tor. It doesn't. That malware exploited a vulnerability in an old version of Firefox. There was already an update available a month before it was exploited. This malware sent people's IP addresses to the FBI. This could have easily been mitigated by updating their browser or disabling javascript.  
  
This was also an attack against the Tor browser and not Tor itself.

Should I use a VPN with Tor?
----------------------------

Many people recommend a VPN with Tor to increase your anonymity. In most cases a VPN will not do anything with Tor and in some it can decrease your anonymity. See [this post by an expert](https://matt.traudt.xyz/posts/vpn-tor-not-mRikAa4h.html) ([onion service](http://zfob4nth675763zthpij33iq4pz5q4qthr3gydih4qbdiwtypr2e3bqd.onion/posts/vpn-tor-not-mRikAa4h.html)).

What's the difference between Tor and the Tor Browser?
------------------------------------------------------

Tor is a network. It does what I described above. The Tor Browser is a browser based off Firefox hardened for privacy that uses Tor.

Other Browsers with Tor
-----------------------

You should not use any other browser than the Tor Browser with Tor. Doing so will make your browser fingerprint completely different from other Tor users which will deanonymize you and you could easily mess it up and cause it to leak.  
  
[https://www.torproject.org/docs/faq.html.en#TBBOtherBrowser](https://www.torproject.org/docs/faq.html.en#TBBOtherBrowser)

Changing Settings/Adding Extensions in the Tor Browser
------------------------------------------------------

You should not change any settings in the Tor Browser. This will change your browser fingerprint and may make your browser insecure.  
  
I would also advise against adding extensions as they will change your browser fingerprint and may leak.  
  
[https://www.torproject.org/docs/faq.html.en#TBBOtherExtensions](https://www.torproject.org/docs/faq.html.en#TBBOtherExtensions)

Is it Tor or TOR?
-----------------

It is Tor. It used to be called TOR but the name has changed.  
  
[https://www.torproject.org/docs/faq.html.en#WhyCalledTor](https://www.torproject.org/docs/faq.html.en#WhyCalledTor)

  
  

[RETURN](https://theprivacyguide1.github.io/posts.html)