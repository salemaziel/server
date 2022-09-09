     Browser Tracking | Madaidan's Insecurities 🌓

Browser Tracking
================

_Last edited: March 11th, 2022_

Many common methods of preventing browser tracking are ineffective. This article goes over misguided ways in which people attempt to improve their privacy when browsing the web.

[Tracker Blockers](#tracker-blockers)
-------------------------------------

Blocking a few tracker domains does not actually prevent tracking. You cannot make a list of every single tracker domain and block them all since there are far too many. [Enumerating badness does not work](https://www.ranum.com/security/computer_security/editorials/dumb/).  
  
Even if you did magically create a blacklist of every single tracker domain ever, the website does not need to connect to a third party domain to run tracking code. For example, blocking Google Analytics does not prevent the website from simply running their own first party tracking code or even [hosting third party tracking code from a first party domain](https://gist.github.com/paivaric/211ca15afd48c5686226f5f747539e8b).  
  
The website can then share this information to the people that made the trackers you've blocked, so everyone gets the exact same information they would have gotten in the first place.  
  
Blocking trackers can only remove some low hanging fruit and is not a proper approach to systemically improving privacy. This is the reason why [the Tor Browser does not include any tracker blockers](https://2019.www.torproject.org/projects/torbrowser/design/#philosophy).

[Configuring / "Hardening" the Browser](#configuring-the-browser)
-----------------------------------------------------------------

You cannot configure your browser to prevent tracking either. Everyone will configure their browser differently, so when you change a bunch of about:config settings, such as `privacy.resistFingerprinting`, and pile on browser extensions like Privacy Badger, you're making yourself stand out and are effectively _reducing_ privacy.  
  
Additionally, just disabling JavaScript, while preventing large vectors for fingerprinting, does not prevent fingerprinting entirely. Fingerprinting can be done with only CSS and HTML. One example is [using @media rules to figure out your browser resolution](https://matt.traudt.xyz/posts/2016-09-04-how-css-alone-can-help-track-you/).  
  
You also cannot substantially improve security by configuring the browser. Changing a few settings will not fix deep architectural security issues. You can at _most_ reduce some attack surface by disabling things, but most people don't do this to an extent where it actually matters.

[Fingerprint Testing Websites](#fingerprint-testing-websites)
-------------------------------------------------------------

Fingerprint testing websites, such as [Cover Your Tracks](https://coveryourtracks.eff.org/), [cannot](https://matt.traudt.xyz/posts/2019-01-19-about-to-use-tor/#testing-your-fingerprint) [reliably](https://blog.torproject.org/effs-panopticlick-and-torbutton) [test](https://github.com/brave/brave-browser/wiki/Fingerprinting-Protections#why-does-panopticlickefforg-or-some-other-site-say-that-i-am-fingerprintable) your fingerprint.  
  
These websites determine the uniqueness of your fingerprint based off of their own userbase, which will miss out on the majority of real users, thereby providing inaccurate statistics and is not a viable way of determining how well you fair off against fingerprinting in the real world.  
  
These websites also don't test for much. Do these websites fingerprint you by [where your cursor is on the screen](https://twitter.com/davywtf/status/1124146339259002881)? By your [clock skew](https://trac.torproject.org/projects/tor/ticket/31324)? By the [performance of your device](https://lists.torproject.org/pipermail/tor-dev/2019-August/013989.html)? etc.

[Conclusion](#conclusion)
-------------------------

The only real approach to preventing browser tracking/fingerprinting is by using a browser that is designed to prevent this by default and the users do not change it. The most effective browser that does this is the [Tor Browser](https://www.torproject.org/). However, the Tor Browser's [fingerprinting protections](https://2019.www.torproject.org/projects/torbrowser/design/) aren't perfect, and its security [is quite weak](firefox-chromium.html).

[Go back](/index.html)