  Privacy Guide

about:config settings
=====================

This is an explanation of all the settings in my [Firefox hardening guide](browsers.html#firefox).

media.peerconnection.enabled = false

This setting disables [WebRTC](https://en.wikipedia.org/wiki/WebRTC) which can [leak your IP address](https://browserleaks.com/webrtc) even with a VPN.

privacy.firstparty.isolate = true

This enables first party isolation which seperates cookies from different websites. This means cookies from one site cannot interact with cookies from other websites which prevents websites from seeing your open tabs.

privacy.resistFingerprinting = true

This enables [fingerprinting](https://panopticlick.eff.org) protection which helps protect against [multiple browser fingerprinting techniques](https://wiki.mozilla.org/Security/Fingerprinting).

browser.cache.offline.enable = false

This disables [offline caching](http://kb.mozillazine.org/Browser.cache.offline.enable) to prevent any data about what you did in your browser being stored on your hard drive.

browser.sessionstore.max\_tabs\_undo = 0

This prevents your previous tabs from being saved in your browser.

browser.urlbar.speculativeConnect.enabled = false

This disables [preloading of autocomplete URLs](https://www.ghacks.net/2017/07/24/disable-preloading-firefox-autocomplete-urls/).

dom.event.clipboardevents.enabled = false

This prevents websites from [seeing what you do with your clipboard](https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/Preference_reference/dom.event.clipboardevents.enabled) e.g. copying or pasting certain things on their website.

geo.enabled = false

This disables [geolocation](https://browserleaks.com/geo).

media.eme.enabled = false

This disables [playback of DRM controlled content](https://support.mozilla.org/en-US/kb/enable-drm#w_opt-out-of-cdm-playback-uninstall-cdms-and-stop-all-cdm-downloads) which automatically downloads the Widevine Content Decryption Module by Google.

media.gmp-widevinecdm.enabled = false

This disables the Widevine Content Decryption Module.

media.navigator.enabled = false

This prevents websites from being able to track your webcam and microphone status.

network.cookie.cookieBehavior = 1

This [blocks third party cookies](https://developer.mozilla.org/en-US/docs/Mozilla/Cookies_Preferences).

network.cookie.lifetimePolicy = 2

This [clears cookies](https://developer.mozilla.org/en-US/docs/Mozilla/Cookies_Preferences) at the end of each browser session.

network.http.referer.trimmingPolicy = 2

This makes Firefox only send the scheme, host and port in the [referer header](https://wiki.mozilla.org/Security/Referrer).

network.http.referer.XOriginPolicy = 2

This makes Firefox send the referer header only when the [hostnames match](https://wiki.mozilla.org/Security/Referrer).

network.http.referer.XOriginTrimmingPolicy = 2

This makes Firefox only send the scheme, host and port in the [referer header](https://wiki.mozilla.org/Security/Referrer) of cross-origin requests.

webgl.disabled = true

This disables webgl which can be used for [browser fingerprinting](https://browserleaks.com/webgl) and is [insecure](https://security.stackexchange.com/questions/13799/is-webgl-a-security-concern).

browser.sessionstore.privacy\_level = 2

This setting makes Firefox [never store any extra session data](http://kb.mozillazine.org/Browser.sessionstore.privacy_level).

network.IDN\_show\_punycode = true

This renders IDNs as [punycode](https://en.wikipedia.org/wiki/Punycode) which if not set, may make you vulnerable to [hard to notice phishing attacks](https://krebsonsecurity.com/2018/03/look-alike-domains-and-visual-confusion/#more-42636).

extensions.blocklist.url = https://blocklists.settings.services.mozilla.com/v1/blocklist/3/%20/%20/

This limits the amount of [identifiable information](https://old.reddit.com/r/privacytoolsIO/comments/9uqeew/firefox_tip_sanitize_firefox_blocklist_url_so_it/) sent when requesting the Mozilla harmful extension blocklist.

dom.event.contextmenu.enabled = false

This prevents websites from messing with the context menu.

network.http.referer.spoofSource = true

This makes Firefox send [the target URL as the referer](https://wiki.mozilla.org/Security/Referrer).

privacy.trackingprotection.enabled = false

This disables [tracking protection](https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Privacy/Tracking_Protection) which is useless and just adds to your fingerprint when used with Ublock Origin.

geo.wifi.uri = blank  
browser.search.geoip.url = blank

These remove Firefox's geolocation provider.

browser.aboutHomeSnippets.updateUrL = blank  
browser.startup.homepage\_override.mstone = ignore  
browser.startup.homepage\_override.buildID = blank  
startup.homepage\_welcome\_url = blank  
startup.homepage\_welcome\_url.additional = blank  
startup.homepage\_override\_url = blank

These disable [connections Firefox makes](https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections) when your start the browser or visit your home page.

toolkit.telemetry.cachedClientID = blank

Disables telemetry ID.

browser.send\_pings.require\_same\_host = true

This makes Firefox only send pings to the website [you are currently on](http://kb.mozillazine.org/Browser.send_pings.require_same_host).

network.dnsCacheEntries = 100

This limits the [amount of entries in your DNS cache](http://kb.mozillazine.org/About:config_entries#Network.) which can give someone who has access to your computer a list of websites you visited.

places.history.enabled = false

This disables [recording of visited websites](https://wiki.mozilla.org/Places).

browser.formfill.enable = false

This disables the [saving of form data](http://kb.mozillazine.org/About:config_entries#Browser.).

browser.cache.disk.enable = false  
browser.cache.disk\_cache\_ssl = false  
browser.cache.memory.enable = false  
browser.cache.offline.enable = false

Disables caching.

network.predictor.enabled = false network.dns.disablePrefetch = true network.prefetch-next = false

Disables prefetching.

network.http.speculative-parallel-limit = 0

Disable prefetching on mouse hover.

extensions.pocket.enabled = false  
extensions.pocket.site = blank  
extensions.pocket.oAuthConsumerKey = blank  
extensions.pocket.api = blank

Disables [Pocket](https://www.mozilla.org/en-US/firefox/pocket/).

browser.newtabpage.activity-stream.feeds.telemetry = false  
browser.newtabpage.activity-stream.telemetry = false  
browser.ping-centre.telemetry = false  
toolkit.telemetry.archive.enabled = false  
toolkit.telemetry.bhrPing.enabled = false  
toolkit.telemetry.enabled = false  
toolkit.telemetry.hybridContent.enabled = false  
toolkit.telemetry.firstShutdownPing.enabled = false  
toolkit.telemetry.newProfilePing.enabled = false  
toolkit.telemetry.reportingpolicy.firstRun = false  
toolkit.telemetry.server = blank  
toolkit.telemetry.shutdownPingSender.enabled = false  
toolkit.telemetry.unified = false  
toolkit.telemetry.updatePing.enabled = false  
network.allow-experiments = false  
browser.tabs.crashReporting.sendReport = false  
dom.ipc.plugins.flash.subprocess.crashreporter.enabled = false  
toolkit.crashreporter.infoURL = blank  
datareporting.healthreport.infoURL = blank  
datareporting.healthreport.uploadEnabled = false  
datareporting.policy.firstRunURL = blank

Disables [telemetry](https://wiki.mozilla.org/Telemetry), datareporting, [crash reporting](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/Crash_reporting) and experiments.

privacy.spoof\_english = 2

This makes websites only able to see "English" and not your set language for enhanced privacy.

intl.accept\_languages = en-US

This sets your language to "en-US" which is the most common language so you will blend more.

accessibility.force\_disabled = 1

This prevents accessibility services from [accessing your browser](https://wiki.mozilla.org/Electrolysis/Accessibility#Preferences).

network.captive-portal-service.enabled = false  
captivedetect.canonicalURL = blank

This disables Firefox's [captive portal](https://wiki.mozilla.org/QA/Captive_Portals) which sends requests to detectportal.firefox.com every time you start the browser. This may give Mozilla information about you or your browser. The captive portal also uses http which can be [manipulated](https://forums.whonix.org/t/universal-firefox-attack-through-http-manipulation-and-wont-fix/6726).

browser.newtabpage.activity-stream.feeds.snippets = false

This disables [snippets](https://wiki.mozilla.org/Firefox/Projects/Firefox_Start/Snippet_Service).

gfx.font\_rendering.graphite.enabled = false

This disables graphite which is a "smart font" system. Mozilla was [convinced](https://bugzilla.mozilla.org/show_bug.cgi?id=1255731) that leaving this enabled was too risky but reverted that decision after a few bug fixes.

network.jar.block-remote-files = true

This blocks remote JAR files to reduce attack surface.

javascript.options.ion = false  
javascript.options.native\_regexp = false  
javascript.options.baselinejit = false

These disable the JavaScript ION JIT, native regular expressions and Baseline JIT. This improves security as JIT causes a lot of security problems such as heap spraying attacks.

dom.webaudio.enabled = false  
media.webaudio.enabled = false

This disables WebAudio which can be used to fingerprint your browser.

mathml.disabled = true

This disables mathml to reduce attack surface.

gfx.font\_rendering.opentype\_svg.enabled = false  
svg.disabled = true

These disable SVG images. In the past, these have had vulnerabilities that helped to [de-anonymize](https://blog.mozilla.org/security/2016/11/30/fixing-an-svg-animation-vulnerability/) Tor Browser users by giving them malware so it's best to disable these.