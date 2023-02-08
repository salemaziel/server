http://wmj5kiic7b6kjplpbvwadnht2nh2qnkbnqtcv3dyvpqtz7ssbssftxid.onion/optout/into-the-crypt
# *Into the Crypt: The Art of Anti-Forensics*

- [Introduction](#introduction)
    - [General Premise](#general-premise)
- [Philosophy](#philosophy)
- [Identifiers](#identifiers)
- [Hardware Selection](#hardware-selection)
    - [Operating System](#operating-system)
    - [Disable Logging](#disable-logging)
        - [Clear Caches](#clear-caches)
    - [Secure Deletion](#secure-deletion)
    - [MAC Randomization](#mac-randomization)
    - [Traffic Manipulation](#traffic-manipulation)
        - [Packet Filter](#packet-filter)
        - [Proxy](#proxy)
        - [Leak Prevention](#leak-prevention)
        - [Routing](#routing)
- [Browsing](#browsing)
    - [Browser Configuration](#browser-configuration)
    - [Search Engine](#search-engine)
- [Live Boot](#live-boot)
- [Physical Destruction](#physical-destruction)
- [Cryptography](#cryptography)
    - [Randomness](#randomness)
    - [Keys](#keys)
    - [Cryptographic Software](#cryptographic-software)
        - [Signature-Based Identification](#signature-based-identification)
        - [Encrypting Drives and Files](#encrypting-drives-and-files)
        - [Offline Password Managers](#offline-password-managers)
- [Obscurity](#obscurity)
    - [Justification](#justification)
    - [Code Implementation](#code-implementation)
    - [Blending](#blending)
- [Minimize Architecture](#minimize-architecture)
- [Automated Shutdown Procedures](#automated-shutdown-procedures)
    - [Dead Man's Switch](#dead-mans-switch)
- [Play on Resources](#play-on-resources)
- [Radio Transmitters](#radio-transmitters)
- [EMF Shielding](#emf-shielding)
- [Noise](#noise)
- [Optimization](#optimization)
- [Alibi Creation](#alibi-creation)
- [False Compromise](#false-compromise)
- [Traceless Procurement](#traceless-procurement)
    - [Cryptocurrency](#cryptocurrency)
- [Account Security](#account-security)
- [Defensive Mechanisms](#defensive-mechanisms)
- [Physical Precautions](#physical-precautions)
- [Use Cases](#use-cases)
    - [Anonymous Activism](#anonymous-activism)
    - [Journalist](#journalist)
    - [Market Vendor](#market-vendor)
- [Conclusion](#conclusion)
- [Appendix A](#appendix-a)
- [Contact Us](#contact-us)
- [Donations](#donations)
- [References](#references)

## Introduction
The digital age has ushered in a dystopia, at least for those unwilling to circumvent or stretch the bounds of the law. There is a significant gap in literature in regards to circumvention, largely due to this being an underground activity. It is pseudo-illegal; authors would be afraid that creations today will come back to haunt them. Exposing anti-forensic procedures will erode some of their operational security (OPSEC) in the process. This being said, not all of my tactics, techniques, and procedures (TTP) will be sand-grain granular. However, I hope the ideas described can be applied to help disguise yourself in the sand-swept dunes.

### General Premise
Several concepts will be reiterated throughout this work as security is a process that acts in layers (think about the layers of an onion that is commonly alluded to). Here is a layout of the general concepts that will be explained in further detail throughout this work:
- Operate on a zero-trust model
- Treat all signals as hostile
- Reduce the use of proprietary (closed-source) software
- Prioritize Communications Security (COMSEC)
- Operate with minimal architecture


## Philosophy
There is now a concerted effort with the primary goal as follows: control the flow of information to expand the current power structure. If one controls the information, they control the perception, and subsequently the questions being asked. If those in power have you asking the wrong questions, you no longer are a threat to the system. If the language can be altered to prevent various forms of dissent from occurring, this manipulation will take the form of Orwellian double-speak. Double-speak is used to control our symbolic creation of thought. For example, freedom is slavery, ignorance is strength. As the Nazi propagandist, Joseph Goebbels, recorded in his diaries, "It would not be impossible to prove with sufficient repetition and a psychological understanding of the people concerned that a square is in fact a circle. They are mere words, and words can be molded until they clothe ideas and disguise." If we lack the capacity to understand what concepts such as freedom are, how could an individual defend the foreign concept? As Camus once said, "It is the job of the thinking people not to be on the side of the executioner," hence the conception of this book. The goal is to preserve freedom and autonomy by means of disrupting investigations.

From a technological standpoint, they will redirect internet traffic and inject malware into your devices as disclosed from the Snowden revelations (e.g. NSA's TURMOIL program). Not only will they create passive attack mechanisms against you, they have extensive disinformation and suppression campaigns. They control the flow of information in a multitude of ways. "Private" (I say this loosely) contractors will collaboratively process censor requests on behalf of governmental institutions. Platforms will unilaterally censor dissident journalists and news outlets across various platforms. These cases are difficult to record as the vast majority are not conducted in the light of day. Even in this new age of technological censorship of anything that does not cater to the system's narrative, the activity falls behind a veil of private companies acting on ambiguous "policy" violations.

While I have primarily focused on examples  solely with the tech-industry, financial blockades are also leveraged to censor and snuff out organizations. Wikileaks was perhaps the first example of the integrated power dynamic with both the tech and financial industry alike. They lay out an excellent chronology of the events on their site, but the summary is that their servers being hosted by AWS were pulled, Apple removed their application from the App Store with Paypal, and a financial blockade was set in place between VISA, Mastercard, Bank of America, and Western Union. Bank of America commissioned proposals for a systematic attack against their computer systems with firms of the intelligence community such as Palantir, Berico, and HBGary. Palo Alto, the parent company of Palantir, even came out publicly to apologize and severed all relations with HBGary.[^1] It seems this set the stage as they were the test run.

More systematic censorship was witnessed in mid 2018 where sites and individuals such as InfoWars, RTNews journalists, and many more were banned without reason from Youtube, Facebook, Instagram, Twitter, Disqus, Flickr, Vimeo, Tumblr, Paypal. They will control Domain Name Service (DNS) records from the main root servers. They will have search engines such as Google blacklist the DNS resolution for websites. An example of this occurred in early February, 2019 where CodeIsFreeSpeech.com was hidden from public domain. The government's relationship with tech-industry oligarchs have become even more apparent in early January, 2021 where the President of the United States (POTUS) was silenced.[^2] The platform Parlor, while insecurely coded, offered a censorship resistant platform (by policy). Not only will Google/Apple remove access to platforms such as these, but even those hosting web services (predominantly Amazon and Digital Ocean) can and will pull the plug to shutdown the platforms. Most occurrences come from recollection as there is no journal detailing the cases of censorship at large; my recollection is largely incomplete. This being said, we have collectively facilitated their bulk data collection, aggregation, surveillance, and censorship to where it is mere child's play.

This is being observed more clearly in modern day where the auspices of surveillance in the name of safety have been habitualized in the public eye. And one should note that this is solely a case example pertaining to American-based companies. There are plenty of private-public engagements in other countries such as the NSO with the Israeli government.[^3] Coupling the private-public engagements, embedded relations between other foreign intelligence agencies brings a new depth of maliciousness to light. Think 5 eyes, 9 eyes, 14 eyes, etc. Global collaborative surveillance is an early panacea to the long held prospects of the "New World Order," or stated differently, a global institution subjugating the common man to despotism.

When their suppression campaigns prove incapable to pull something from the public eye, the next tool in the box is slander which will be applied liberally. When one side of the argument deems a propagated idea as "dangerous" to the public well-being, it becomes clear not necessarily who is right, but who is wrong. The most popular MCs, the musicians, the media, actors, journalists become propagandists for the system. Surpassing a set threshold without the consent of the system will not be permitted. The only allowed controversy is that which is controlled.

*"Think of the press as a great keyboard on which the government can play."* - Joseph Goebbels

While federal agents certainly aren't possessors of divine power and are largely inefficient, there are layers of loosely-spoken private contractors who can play many suits with their ever-expanding budgets funded by various forms of hacking (or selling products to various extremist groups). They can form at-will layers of subsidiary Limited Liability Companies (LLC) with no connection to the umbrella organization. These organizations can perform various tasks that violate legal boundaries and are dismembered once a task is accomplished. The term I use for this activity is incestual contracting. It is unlikely that you will be unable to find substantial material into this activity for reasons that are self-explanatory.

While we understand that circumvention is not a simple nor passive process, it doesn't take billions of dollars in black budget funds to orchestrate. The vast majority of the work is placed in security procedures such as network traffic encryption, local disk encryption, and communications security.

Anti-forensics, or the reduction, removal, and obscuration of forensic data, has been around for quite some time. There are a variety of methods for stifling both private and public investigations. From the physical side, this could include any action that removes traces such as fingerprints, hair samples, etc.

The digital side of forensics has taken off in recent years. This is multi-faceted from network traffic to random access memory (RAM) to disk storage, and ultimately ties back into physical security.

What is to come throughout this book consists of not only methods of strong cryptographic implementations, automated tasking, and obscurity, but underlying concepts for increasing the time expended on investigations. If you make a large enough splash against the system, they will come after you with all of their resources. If you dive deep enough, you can at least reach the bottom and muddy the waters. Successful operations often depend on how long you can hold your breathe.

## Identifiers
Before diving deep into the concepts, I must layout some of the identifiers that stand to de-anonymize systems. Users must understand what they are trying to defend before they lay a target on their back.

There are identifiers that pertain to hardware, software, and networking. Hardware identifiers that can be used to fingerprint a system include (and are not limited to) the computer model, CPU information, motherboard information via the system BIOS, USB interaction with the system DBUS, type and amount of RAM, connected HDD/SSD drives. Software identifiers are vast and include any software that attempts to beacon home to services with telemetry to create a profile on the user. Network-based identifiers include the IPv4 address, IPv6 address (if enabled), Domain Name Resolution (DNS) communication, and MAC address (can be randomized). Any, if not all of these identifiers can be used to fingerprint or de-anonymize a host.

## Hardware Selection
This section has been prioritized as hardware is at the core of your operations. A supply chain attack resulting in embedded hardware or inherently vulnerable hardware can compromise your operation before it has even begun.

Unfortunately, there are no easy solutions in the realm of hardware. There are many rabbit holes one can take in regards to the avoidance of negative ring architecture (layers below the operating system), selecting processors that gut/avoid the use of MinixOS and Intel's management engine (ME), inherent vulnerabilities to the processor, chipsets that require proprietary blobs, and ultimately procuring hardware that isn't subject to side-loading attacks (can weaken device encryption).

Central processing units (CPU) have a narrowed list of options. For the vast majority of desktops and laptops, the competitors are Intel and AMD. Both of these CPUs have the potential for root level backdoors that are undetectable by your OS. Some privacy-oriented organizations, such as Purism and System76, claim to neutralize Intel's ME (See Purism's technical write-up[^4]). If you are going to select a system with an Intel CPU and detest this critical design, you are limited to a few options. You can shill out the money to System76 (disables ME) and Purism (neutralizes ME by gutting critical components), or you can flash the computer's motherboard with a Raspberry Pi by running the me_cleaner program[^5] (if supported processor/architecture) and installing coreboot[^6] in replace of the BIOS. The novice runs the risk of ruining their device, coupled with the fact that the setup was likely completed for legacy hardware that has unpatched vulnerabilities. This process is not a trivial task and will cause headaches for those who simply want the system to work. If you are not willing to shill out the money to one of these organizations that disables the ME and are not technologically savvy, consider using a CPU by AMD while noting that this is far from a silver bullet.This is not to say AMD's PSP is impervious to exploitation. See [^7].

## Operating System
Researching the right operating system (OS) for your specific operation can be a monstrous task. If Operations Security (OPSEC) is of utmost importance, then operating systems that generate excess logs and call home with telemetry and error reporting should be ruled out.

For desktop, this process eliminates Windows, Mac, and ChromiumOS/CloudReady from the race. While there are significant attempts at undermining Windows telemetry, this requires a substantial amount of effort that is bound to corrupt processes and retain the bloat from disabled software.

>Note: Solutions with Windows 10 aren't necessarily the anti-thesis to anti-forensics. These systems have excessive bloat, however they can pursue the same aims. Windows provides many areas to hide files amongst the system. Windows systems can also be an overload to inexperienced investigators with the caches, shellbags, shortcut files, monolithic registry hives, and a myriad of ways to set persistence mechanisms. This could force investigators to expend more time in the investigation. The reason it is avoided in this book is due to the proprietary blobs, bloatware, legacy protocols (which will continue to render it vulnerable to exploitation), and excess telemetry. In good faith, one could not claim to provide secure cryptography on a system that was designed for the aims of counterinsurgency.

GNU/Linux is one of the few operating system baselines that will not phone home and create excess logs locally. Even after making such a decision, whether that be Linux, BSD, or Xen, there are hundreds of derivatives to sift through. At the time of writing, the only anti-forensic friendly distributions designed to reduce the creation and storage of artifacts are TAILS and Whonix. However, any OS lacking telemetry with properly implemented full-disk encryption (FDE) and physical security is sufficient for the job of anti-forensics. If more persistence is desired while keeping distribution size minimal, hardened variants of Arch, Void, Gentoo, or Alpine are advised.

One more factor to consider for the OS selection is the service manager being used. There are plenty of security enthusiasts who justifiably denounce the use of the SystemD service manager (used to spawn processes like networking, scheduled tasks, logging, etc).[^8] There are a variety of service managers that have less bloat and a more simple codebase - OpenRC, runit, etc. The fact that most of these OSs are open-source results in the problem of funding. A side-project that has peaked a developer's interest often go long durations (if not permanently) without any efforts to maintain/patch. Some recommended OS alternatives without systemD at the time of writing include Artix (Arch variant)[^9], Void Linux[^10], and Alpine Linux[^11].

>Note: Ideally, an operating system running a micro-kernel (minimal core) such as seL4 could be in the running. These alternatives are still too adolescent to advise with little community support.

For mobile devices, options are extraordinarily limited. Phones are designed to constantly ping telecommunications infrastructure and receive incoming packets by design. The core purpose is to be reached. Google, Apple, and other players in the telecommunications industry have taken this to an intrusive extent. Android stock phones home an average of 90 times per hour. Apple accounts for at least 18 times per hour.[^12] Both operating systems do not operate in a manner that is conducive to privacy. It seems that the only remaining options are to disable all sync capabilities on iPhone, or flash an open-source operating system to an Android.

For Android, the best operating system to date is GrapheneOS.[^13] This operating system can only be flashed to Google Pixel variants. This is a security-centric OS that accounts for many hardening mechanisms from software to hardware. GrapheneOS encrypts the entire device using block-level encryption, unlike most Android versions which use file-level encryption. If physical forensics of the handset is an issue, GrapheneOS is the best solution.

GNU/Linux based phones, such as Pine64's Pine Phone[^14] or Purism's Librem 5,[^15] are now hitting the market. These devices are inherently insecure in early conception. One could consider these devices private but not secure. If an injection could reach the device, then all privacy is lost.

## Disable Logging
Disabling logs at the source is the best solution to ensure excess logs are not being stored. Daemons or processes can automate the process of log collection. This has its useful functions for both debugging and security (auditing), however it is detrimental to the idea of information retention. It is strongly advised to periodically shred the log files if not disabling the logging daemons entirely.

Some developers have created simple bash and python scripts that remove and disable the logging daemons such as CoverMyAss.[^16] Scripts aren't necessarily needed, however they could automate a manual process and identify logging components of your system that you did not know were present.

Here is a quick example of disabling logging daemons on GNU/Linux with the SystemD service manager:
```
systemctl disable syslog.service
systemctl disable rsyslog.service
systemctl disable systemd-journald.service
```

>Note: These commands will not work on systems running lightweight service managers such as OpenRC, runit, or S6, nor is this comprehensive.

While it is wise to reduce your logging footprint locally on your device, full disk encryption (FDE) is a sufficient anti-forensic mitigation for logging. If the attacker obtains access to your device as it is running (either physical or remote via a security compromise), logging is likely the least of your concerns.

### Clear Caches
There are various caches containing sensitive information on both mobile devices and GNU/Linux systems. Linux systems have the tendency to push most logs to the /var/log/ directory. This is a simple deletion process.

Due to Android sandbox implementations, caches can no longer be centrally erased; caches must be cleared on individual applications. System logging is also sprawled across various directories.  Reducing locally generated logs on Android is comparable to removing telemetry from Windows OS variants. Clearing caches on Android provides no serious benefit, but it does remove the amount of data present on the device. For proper privacy, only trusted applications should be used - preferably Free and Open-Source (FOSS).

## Secure Deletion
Deletion of files in most operating systems today is a loose version of the term. Deletion implies the eradication of the selected file. Rather, this is deletion of the file's reference. To truly delete a file from the drive, one must completely overwrite the data. This can be done over time by passive dumb luck or it could be a conscious effort. There are existing tools for secure deletion (wiping over the file) on most platforms. On GNU/Linux systems, there is a tool in the "secure-delete" package called shred that will zero over the file. This performs deletion using the Gutmann method. Another tool called Bleachbit[^17] is known to clean the caches of the system. Built into the tool is an option to overwrite all free space on the disk. This could be a routine cleanup procedure for the concerned. On Windows, there is a tool included in the SysInternals[^18] package called SDelete that will provide a similar function to GNU/Linux's shred.

A simple shred command in a Linux bash shell: `shred -n 32 -z -u <FILE>`
This command would use GNU coreutils shred function to wipe over the designated file with 32 iterations. The -z adds a final overwrite to hide the shredding process, and the -u unlinks the file completely.

>Note: This is an example command; I am not recommending 32 overwrites.

The NSA has in the past developed malicious firmware for HDDs that can create secret copies of user-written data. SSDs which make use of wear-leveling cannot have information securely erased by the user.  However, SSDs with wear leveling also pose a significant annoyance, and even create difficulty for, forensic investigators. Such annoyance cannot be considered a security guarantee. In short, wear-leveling, garbage collection, and trim operations are largely outside of the user's control, therefore "secure" deletion should not be assumed to be possible. Regarding SSDs, trim operations should always be enabled as it stands to make files unreadable using "Deterministic Read After Trim" or "Deterministic Zeroes After Trim." Consider trim as an unreliable backup mitigation to FDE.

## MAC Randomization
Media access control (MAC) addresses are unique identifiers for network interface controllers/cards (NIC). These identifiers exist at Layer 2 of the OSI model.[^19] As one could expect, unique identifiers can be problematic. Proprietary router firmware such as Netgear and other vendors can attempt to correlate static MACs to individuals. Your MAC could also be correlated between different routers and subsequently different router SSIDs. Wardriving is a method by which organizations will scan for SSIDs around different areas to collect MAC addresses and SSIDs.

All anti-forensic operating systems  spoof or randomize the MAC address by default. A GNU/Linux utility called `macchanger` can alter and randomize the MAC address.

Set MAC to one by the same vendor: `macchanger -a <interface (i.e. eth0)>`

Set a random vendor MAC of any kind: `macchanger -A <interface (i.e. eth0)>`

Using the `-r` flag will set a fully random MAC. This isn't necessarily a problem, but it will stand to make an anomaly out of you. Mimic known vendors to help blend in the crowd. Combine this with a service manager to automatically run on each boot.

This is not the only implementation of MAC randomization. Some services such Network Manager now provide this feature by setting MAC randomization via service configuration files.

GrapheneOS, and other non-stock OSs have begun to randomize MAC address upon connection to different wireless networks.

To check whether this setting is enabled, go to `Settings > Wi-Fi > Settings Gear > Advanced > Privacy > Use fully randomized MAC (default)`

## Traffic Manipulation
### Packet Filter
While physical forensics is a primary concern of investigations, network forensics can provide fruit-bearing evidence to investigators. Therefore it is vital to restrict and regulate what traffic is passed on.

Packet filters (often mistakenly called firewalls) can be leveraged to place limitations on ingress (inbound) and egress (outbound) traffic from the perspective of the local system's network interface card (NIC). Firewalls are packet filters that are their own separate device intended solely for the function of filtering traffic. If you don't want certain applications phoning home with device information, they can be restricted based on application, port, and/or IP address. This can become very granular. For most purposes using a local client, you should block all incoming traffic. If services are being hosted by a server such as a website or Instant Messenger (IM) instance, packet filtering becomes more complex as certain ports have to remain open to properly host a service.

### Proxy
One method to understand what is calling home on your device(s) is to setup a proxy to regulate all communications inbound and out. Proxies are often used to analyze traffic emitted from certain applications. They are commonly configured with browsers to analyze web requests. A proxy can be configured to passive mode where traffic can be reviewed or full intercept mode (active) where the user must explicitly allow a request to be transmitted. Proxies are not recommended for those who are not tech-savvy, or at least not recommended to be relied upon.

### Leak Prevention
If you are more concerned with a traffic leakage, leak prevention of traffic (meaning packets will not deviate from a defined route) can be accomplished in a couple of different ways. Physical network devices can be configured to accomplish these ends. For $20, you can acquire a GL-inet travel router. Through its network configuration, all traffic can be forced via a Virtual Private Network (VPN) or TOR. This is a simple and quick procedure as long as you have the .ovpn configuration file from the VPN provider. Wireguard VPN configurations are also available for setup on the OpenWRT (native open-source operating system). A VPN installed directly on your phone may be enticing. While there are available VPN applications that contain a leak prevention setting in the software, these should not be relied on. Software-based firewalls and VPNs alike have been prone to failure in the past with preventing traffic leakage. However security works in layers, and software-based applications will not harm you unless they are solely relied upon. There is no one-stop-shop for this setup. Feel free to get creative and add as many layers as you deem fit.

### Routing
As it stands today, there are three avenues for anonymization and encryption of internet packets: VPN, TOR, and Mixnets.

Each avenue possesses pitfalls. Virtual Private Networks (VPN) can provide privacy from the local internet service providers (ISP). Internet traffic will be encrypted based on designated configurations and protocols. OpenVPN is subject to various attacks.
Wireguard is currently the most secure. Unfortunately, it has faced little scrutiny. Often security defects are uncovered with the right amount of time. Disregarding its adolescence, the Wireguard protocol has been formally verified. Also, the reduced complexity of the protocol makes it easier to properly implement than OpenVPN. Easier implementation reduces room for error that could lead to compromise. The primary issue with VPNs today lies with the inherent trust given to the provider. If you decide a VPN is desired for your operation(s), you should be searching for a provider that has strict privacy laws, a no logging policy, and jurisdiction being outside of the known growing number of eyes (collaborative government intelligence community). This intelligence community went from 5 eyes to 9 eyes to 14 eyes. I suspect the number will continue its pattern of growth as discussed in the Philosophy section of the book. VPNs are rarely suitable against powerful (government or corporate) attackers; VPNs cannot grant anonymity.[^20]

The Onion Router (TOR) has faced the most scrutiny of all protocols and provides the most anonymity. While facing the most scrutiny from various individuals and governments, TOR has many overarching issues yet to be addressed. Someone with a God's eye view of the telecommunications traffic could de-anonymize users by sending out certain sized packets to different destinations. This is something to keep in mind while hosting infrastructure, however the standard user sending out typical sized packets from web requests has little concern of this de-anonymization tactic. TOR does not add timing obfuscations or decoy traffic to hinder traffic pattern analysis which can be used to de-anonymize users.

Both of these channels have some pitfalls, so why not combine them for layered security? There have been numerous articles published by Whonix[^21] and TAILS[^22] developers along with other Information Security professionals highlighting the ineffectiveness of the VPN / TOR combination. The synopsis of their articles is that at best it doesn't help you, at worst, it hurts you. I find it useful if I am trying to mask the fact that I am using TOR from the ISP. Bridges can also be used for this purpose, but they are likely easier to identify by the Intelligence Community (IC). While on public WiFi, I recommend solely using TOR.

I2P[^23] or the Invisible Internet Project spawned in 2003. This is an encrypted private network layer designed to mask user identity. I2P is not the same idea as TOR, although some concepts cross over. I2P users cannot officially communicate with clearnet sites like TOR users can; all I2P traffic stays internal to the I2P network. Without having the exit of traffic via exit nodes or outproxies to the internet, this reduces usability and enhances privacy. I2P can prove useful at limiting the information captured by global passive adversaries. I should note that some mixnets have called I2P legacy technology claiming that it opens up users to a number of attacks that can isolate, misdirect, and de-anonymize users. Therefore I2P should not be solely relied on. If one is adament about using I2P, there are configurations that facilitate the use of I2P via TOR.

Mixnets have the goal of anonymizing packets through uniformity. The design is to obscure and craft packets of the same size despite the amount of data being transmitted. Often times mixnets have technology that address time-based attacks, provide decoy or cover traffic, and implement uniformity of packets, however the pitfalls tend to be lack of scrutiny and adoption. Anonymity loves company, and most mixnets lack that component, especially in their early conceptions. Due to the lack of scrutiny with early conception and lack of adoption, I cannot provide any recommendations. Even if one is to involve themselves with the use of a mixnet, they should be on guard. Intelligence agencies are not ones to shy away from a good honeypot. While not a perfect example as this wasn't a mixnet, the FBI ran an operation with an operating system called ArcaneOS and a built-in messaging platform called anom[.]io[^24] designed for organized crime.

ANOM was an application that opened as a calculator which had the user enter a pin to reach the hidden messenger. All communications were intercepted. The morale of the story is that the slightest amount of skepticism into the website communications, hosting platform, or the closed-source application could've prevented the downfall of multiple criminal enterprises globally. The same skepticism should be applied to any organization unwilling to address their shortcomings and model their potential attack vectors. Many are willing to route your traffic, and node-based cryptocurrency projects with a model that resembles that of a ponzi-scheme could always be a source of both black budget funds and traffic analysis for letter agencies. I have no fingers to point or organizations to accuse. However, it is far from a half-cocked conspiracy that intelligence agencies would engage in this type of activity.

In regards to implementation, there are a variety of options. Host-based virtualization with preconfigured systems like Whonix can be used. This routes all of the Whonix workstation's traffic through the Whonix gateway to prevent leakage. A bootable TAILS USB is also preconfigured to allow only TOR traffic, excluding the exempt or whitelisted insecure browser designed for getting your device through WiFi portals. Open-source operating systems, such as OpenWRT, on a travel router can force certain subnets to use a VPN configuration or route via TOR.

As previously stated in the Traffic Leakage section, software-based routing should not be relied on. If it is to be implemented, it should be viewed as adding an additional layer of security. There are applications such as Orbot[^25] which allows the use of the TOR network, a variety of VPN applications (which are primarily wrappers for OpenVPN), and there are scripts that configure local packet filters to "torrify" all traffic. While I have no basis in saying all software-based leak prevention mechanisms are prone to failure, historically leak prevention has been inadequate. Even Whonix reports that they "cannot do the impossible and magically prevent every kind of protocol leak and identifier disclosure." [^26] Hardware routing adds more architecture into the mix, but it provides the bulletproof assurance that there is no leakage of traffic. For critical operations, consider hardware mechanisms. For the privacy-centric individual, software-based kill switches should be more than sufficient.

## Browsing
### Browser Configuration
It is no secret that governments deliver malware based on anomalous internet activity, alternately put, flagged activity. While the common forms of investigations are typically conducted via physical device seizure, security mechanisms should be taken into account to stunt "passive" investigations. Browsers can be configured to disable the installation of extensions, device storage usage, setting alterations, theme changes, cookie restrictions, and cache deletions. The most important facets of private internet browsing include the browser security model, fingerprinting mitigations, and reliance on JavaScript.

For the security model, ungoogled variants of Chromium[^27] are advised. The security model exists unlike Gecko-based browser derivatives (i.e. Firefox).
Browser security and anti-fingerprinting do not always align. For instance, the TOR Browser is not unique based on fingerprinting. Tor Browser with JavaScript disabled is generally a secure setup despite being based on Gecko. Most browser-based vulnerabilities require JavaScript or some other browser-run code (fonts, WebGL, etc). Tor Browser on security setting "Safest" reduces this attack surface significantly. While Chromium browsers may have upped the ante in terms of security, many do not have any built-in anti-fingerprinting mechanisms. Some projects have taken the initiative to provide anti-fingerprinting configurations such as Bromite[^28] or Brave Browser[^29]. Using a privacy-tweaked configuration of Brave Browser is the best option for those who are not technical. However, many of the problems that plague vanilla Chromium can be mitigated with the right appended flags for process execution.

To further elaborate, whenever Chromium is executed, it can be ran by typing the following into terminal:
```
/usr/bin/chromium %U --disable-reading-from-canvas --disable-3d-apis --disable-component-update --disable-background-networking --user-agent="" --no-default-browser-check --incognito --disable-breakpad --no-crash-upload --no-report-upload --disable-crash-reporter --disable-speech-synthesis-api --disable-speech-api --disable-cloud-policy-on-signin --disable-print-preview --disable-drive --disable-full-history-sync --disable-sync
```

These flags can also be appended directly to the `/usr/bin/Chromium` file so every execution forces the use of the flags. (See browser hardening configurations from Anonymous Planet[^30]).

### Search Engine Selection
#### DuckDuckGo
DuckDuckGo (DDG)[^31] has long been used as an alternative to Google. It is worth mentioning that DDG is TOR Projects default selection. This has granted them significant notoriety and trust. There are some underlying problems with DDG such as being based in the US, and they are not completely open-source. Without having reviewable source code, there is no way of validating their seemingly well-intentioned privacy mission statement. However, source code review becomes a moot point when you consider the fact that you are using their centralized services. Odds are that the providers of the service do not make the entirety of their systems publicly reviewable/auditable. Arbitrary code or excess applications could exist on their servers.

#### Searx
Searx instances[^32] are decentralized search engines that can be stood up by anyone. Decentralization with Searx doesn't remove the issue of inherent trust that must be placed in the instances, but it ensures that you have control in where you place your trust. This also enables people to stand up their own instances and configure them with better protections. Decentralization is preferred, however some of the instances are likely ran by intelligence agencies.

>Note: There are certainly more variants of search engines that I have not covered that are further from the beaten path. The landscape is often changing, and it is advised to practice due diligence when researching alternate search engines. Many of the self-hosted options provide a safer alternative over centralized providers with a monetization model.

## Live Boot
Live media (USB or CD) can be booted from in a process called Live Boot. Data is prevented from being stored on the hard drive of your computer (so long as you do not attempt to decrypt your hard drive that is detected). Nothing lives in permanence from the live boot. This is a useful tool for the privacy conscious as there is little to no cleanup process of your actions. Some operating systems such as The Amnesiac Incognito Live System (TAILS)[^33] are forensic-minded and wipe the data from the device's physical memory once the USB is removed or the system is shutdown. This is not always the case for live media. Be conscious of network activity living on in permanence. This is where the use of strong cryptography can come into play from Virtual Private Network (VPN) configurations to the use of TOR. Live booting reduces the effectiveness of the Cold Boot attacks. Cold boot is heavily reliant upon data that is temporarily stored in Random Access Memory (RAM).

>Note: Cold boot attacks require a system to be under attacker control. DDR3 memory modules lose data within 3 seconds of losing power under normal circumstances. DDR4 loses data within 1 second (more like a fraction of a second) after losing power under normal conditions. Sufficient mitigation against cold boot attacks is generally to simply remove memory before control of the system is released. Linux allows this via the "magic" SysRq combo SysRq+o. This is available by default on some OSs, but needs to be enabled manually on others. Parrot enables many SysRq commands by default. Among those allowed by Parrot include SysRq+o (immediate poweroff, with no shutdown cycle).

Systems can be started in non-persistent sessions with the use of `grub-live` and `grub-live-default` packages. `grub-live` boots to persistence by default, while `grub-live-default` starts directly to a non-persistent session.

>Note: These packages are primarily available for Debian-based systems

## Physical Destruction
Physical destruction of critical operation data is advised. Institutional authorities such as the National Security Agency (NSA) and Department of Defense (DoD) see no value in the wiping of critical data. If they believe data is at risk or a device under classification is to be removed from a closed area, all media drives must be completely degaussed. The lesson to be learned here is that if institutional authorities do not trust wiping and overwriting methods, be cautious in your operational threat model. If your life depends on the media being sanitized, save yourself the stress and physically destroy it. If your operation would have adverse consequences if you are caught, there is no room for sentiment.

Destroying HDDs:
- Open the drive (with a screwdriver, usually Torx T8)
- Remove the platters (with a screwdriver, usually Torx T6)
- Rub the platters with powerful magnet
- Break and deform the platters
- Drill holes through the platters
- Separate and displace the remains

Destroying SSDs:
- Open the drive
- Break/Crush the board and memory cells
- Burn the remains
- Separate and scatter the debris[^34]

>Note: The DoD generally cites a drive wiping policy of 7 passes using random data. Each pass is performed on the entire drive. Other acceptable means of data removal include a single random pass (modern drives make it nearly impossible to recover data, even with a single overwrite), microwaving the platter (the platter should be removed from the enclosure before doing this), applying sand paper aggressively to the platter, heating the drive in an oven (500 degrees Fahrenheit for 15 minutes? 30 if you want to be extra paranoid, or just leave it in the oven until investigators arrive), or taking a powerful magnet (perhaps from a home/car stereo) to degauss the drive. The platter should be removed first in this method to maximize effectiveness.


## Cryptography
Cryptography is a monolith of a topic that is included with the anti-forensics threat model. If the cryptography cannot be broken, forensic investigations are stunted in their tracks. Cryptography can range from encryption of individual files or messages to Full Disk Encryption (FDE). As Simon Singh has said in The Code Book, "I must mention a problem that faces any author who tackles the subject of cryptography: the science of secrecy is largely a secret science."[^35]

History goes back and forth favoring both codemakers and codebreakers through different eras. While there are algorithms that exist (and yet to be created) that could be unbreakable for the necessary classification time (at least outside the statute of limitations) against codebreakers. Such encryption could involve the use of multiple algorithms such as Serpent((Twofish)(AES)) with the hash algorithm of Whirlpool, Streebog-512, or SHA512. Do be warned that there are threats imposed from the use of cascading algorithms or the use of multiple algorithms with the same key.

All this being said, there is only one form of unbreakable encryption that will stand the test of time. This is a one-time pad (OTP) cipher. This encrypts the message based on completely randomized data. This cannot be digitally or mentally generated; this needs pure randomness to be bulletproof.

"The security of the onetime pad cipher is wholly due to the randomness of the key. The key injects randomness into the ciphertext, and if the ciphertext is random then it has no patterns, no structure, nothing the cryptanalyst can latch onto. In fact, it can be mathematically proved that it is impossible for a cryptanalyst to crack a message encrypted with a onetime pad cipher. In other words, the onetime pad cipher is not merely believed to be unbreakable, just as the Vigenère cipher was in the nineteenth century, it really is absolutely secure. The onetime pad offers a guarantee of secrecy: the Holy Grail of cryptography." - Simon Sughes, The Code Book[^35]

>Note: An OTP using a CSPRNG (cryptographically secure pseudo-random number generator) still maintains the security of the CSPRNG used, although isn't really an OTP anymore. Instead, it acts as a stream cipher. OTPs are information-theoretically secure, but are not tamper-resistant. Full-disk encryption should only ever be performed using the XTS mode of operation. AES is considered secure against the most powerful attackers in the world, even those with access to quantum computing. If quantum computing is a threat, a 256-bit key should be used. Serpent was the most secure of the 5 AES semifinalists. Rijndael (now known as AES) was the least secure. Rijndael displays a concerningly linear structure, which causes many cryptoanalysts discomfort. However, Rijndael has received the most review of all AES semifinalists and is therefore the best understood. This provides higher assurance that Rijndael is secure than for any other AES semifinalist. ChaCha20 is considered equivalent in security to AES and peforms better on embedded devices. ChaCha20 is also more resistant to improper implementations.

### Randomness
Randomness or entropy is the complement to cryptography, or rather a fundamental component. There are two forms of randomness that one would use to generate a One-Time Pad (OTP) message. This randomness can be derived from computational randomness (pseudo random) or pure (theoretical) randomness. Pure randomness is always the goal with the use of OTPs. Unfortunately, there are few ways of achieving this pure randomness. Computational randomness but not theoretical randomness has potential to be broken.

>Note: Many (most) modern computers contain hardware true-random number generators (TRNG). To identify if your hardware has such hardware, run `cat /dev/random` on a Linux-based OS. For systems with no TRNG, `cat /dev/random` will produce some amount of output, then produce nothing or produce output slowly. For systems with a TRNG, `cat /dev/random` will produce output continuously, appearing to behave the same as `cat /dev/urandom`. On some systems with TRNGs, `cat /dev/random` will actually produce output faster than `cat /dev/urandom`.

For systems with TRNGs, the /dev/random and /dev/urandom devices provide no security difference from each other. However, /dev/urandom performs additional processing on the random data which could help mitigate certain hardware (mis)trust issues, specifically the risk of a backdoored TRNG (while there's no evidence TRNGs have ever been backdoored, this is a concern for some). To increase entropy on GNU/Linux systems, the packages `haveged` and `jitterentropy` can be used along with the boot parameter `random.trust_cpu=off` in the `/etc/default/grub` file. See Madaidan's Linux hardening guide for more details on increasing system entropy.[^36]

### Key Usage
Properly implemented cryptographic usage of keys provides a substantial barrier to overcome for the assigned analyst. Key usage renders bruteforce password cracking ineffective. The randomness or entropy contained in the key allows for much stronger encryption than could be created by a simple or complex password (especially since the keys are typically password protected in implementation).

For the justified paranoid, keep a hardware-based key or a separate USB/Micro-SD for the sole purpose of key storage. Create hundreds of keys varying in bit length. Take mental note of the key (or keys) that you decide to use. Only connect designated key storage device into the system when the volume decryption is necessary.

### Cryptographic Software
While we would love to maintain idealism and believe that we could write something that would retain relevance in perpetuity, we understand that this is not the nature of the technological system. To successfully orchestrate safe operations, I must address software-based cryptographic solutions.

#### Signature-Based Identification
Chances are most operations will be conducted remotely, and there is a chance that the need to validate those whom you are communicating with will arise. There are some simple tools that can be leveraged to mathematically validate someone is who they say they are.

Pretty Good Privacy (PGP) is a timeless tool for message verification. One can create a key pair, and use this key pair to sign and encrypt/decrypt messages.

To start using PGP, one must generate a key pair:
```
gpg --full-generate-key
> Enter 1 for default value
> Enter 4096 for key bit size
> Set expiration
```
You will now be prompted to enter information. This can be as real or fabricated.
```
Real name: alias1
Email Address: frosty1@whichdoc.org
Comment:
```
Now you will type characters in the terminal to generate entropy (randomness) for the encryption. You will then be prompted to enter a passphrase.

Now you can use commands via terminal with gpg/gpg2, or you can use a tool with a Graphical User Interface (GUI) such as GNU Privacy Assistant (GPA)[^37] to sign, validate, and encrypt messages to your affiliates.
ex.

Signing the file `plaintext.txt` via terminal:
`gpg -s plaintext.txt`

For the party trying to validate the signature, they can issue the following command:
`gpg --check-signatures plaintext.txt.gpg`

Minisign[^38] is an incredibly simple tool developed in python for the purpose of signature validation. It is a more modern tool than PGP that is user-friendly.
Generate key pair: `minisign -G`

The public key can be distributed as needed, while the private key should remain strictly under user control for signing files.

`minisign -S [-x sigfile] [-s seckey] -m file [file ...]`

#### Encrypting Drives and Files
To date, Linux Unified Key Setup (LUKS) and Veracrypt[^39] are the two most notable options.
- LUKS: Primarily used for FDE
- Veracrypt: Primarily container-based encrypt for file storage and plausible deniability with hidden volumes
- PGP: Used for file-based encryption

>Note: Veracrypt can be set to leverage cascading ciphers. Its cascading encryption uses mutually-independent keys.

#### Offline Password Managers
Security often comes down to the basics; Make your devices/accounts/services hard to crack. Feds & private forensics companies may be able to allocate ridiculous amounts of computing power against your services to see logs and compromise your accounts, but their brute forcing efforts can be rendered useless.

Consider offline variants of KeePass[^40] for secure password storage, then consider placing the KeePass database inside of a hidden veracrypt. Having a password with an absurd amount of characters such as `dHK&*/4pk_!i??5R=^K}~FU!kxF{fG}*&>oMdRt([);7?=v(e^,ch_n)r()]:&k$D@f4#G"Y\v_5-*i$E[+)"bT*@BF+{hkvn7[B]{qq'[~]3@+-Ju6C(@<]=TEM6a\h$c+:W[k$=;Jy[Un7&~NtvK*{Bn` is enough to stunt any brute force attempt. Cryptographic security can only be as strong as the key being used.

>Note: A 20-character random password (letters, numbers, and symbols) provides 132.877 bits of security (compare to 128 bit symmetric encryption keys).

>A 29-character random password (letters, numbers, and symbols) provides 192.671 bits of security (compare to 192 bit symmetric encryption keys).

>A 39-character random password (letters, numbers, and symbols) provides 259.110 bits of security (compare to 256 bit symmetric encryption keys).

> Security margins greater than 256 bits are unnecessary, even against quantum attacks (256 bits of security against classical attack = 128 bits of security against quantum attack). Breaking 128 bits of security requires time approximately equal to 1000 times the life of the universe (measured from the big bang to the projected death of the universe). Passwords larger than 39 characters are unnecessary (although rounding to 40 is reasonable).

### PIM (Personal Iterations Multiplier)
PIM is treated as a secret value that controls the number of iterations used by the header key derivation function. So long as PIM is treated as a secret parameter, this increases the complexity that an attacker would have to guess.

>Note: Larger-value PIMs also increase the time complexity of attacks, at the expense of time taken to perform password hashing. Most cryptologists would argue that a PIMs should not be treated as a secret parameter (or at least, such secrecy should not be relied on). The user's own password should be the source of security. Password hashing, in general, is a mitigation for users with less-than-secure passwords. As a person who values security against the world's most powerful attackers, one should make a point to not rely on password hashing for security.

## Obscurity
### Justification
Security professionals will often preach that security through obscurity is an inadequate method of security and should never be a way of addressing your current threat model. The original basis is the distinction "security through obscurity" vs "security by design," often cited as "Kerkhoff's Principle," which concludes a secure cryptosystem should be secure even if everything about the system, except the key, is public knowledge. Kerckhoff's Principal is sometimes cited in terms of Shannon's Maxim: "One ought to design systems under the assumption that the enemy will immediately gain full familiarity with them," or more simply "The enemy knows the system." With the maxim in mind, "security though obscurity" is specifically a cryptographic principal which has been extended to include any system designed with security. It is not discouraged to use security through obscurity. However, it is discouraged to rely on security through obscurity instead of relying on security by design. Obscurity can be used as an additional layer, but security should be guaranteed by the design, with obscurity used only as a padding against unforeseen vulnerabilities.

A threat model with the application of anti-forensics should not adhere strictly to one distinction of security vs design. Cryptographic software can perform means of obscurity. For instance, Veracrypt produces cryptographically secured volumes that contain differential hidden volumes for plausible deniability. These hidden volumes can hinder the effectiveness of an amateur (and perhaps well-versed) investigator. We are not claiming the process to be systematically flawless, however security has never been fault-less. If you have applied some of the cryptographic advice heeded in the book like full-disk encryption (FDE), and the adversary has managed to gain unbridled, decrypted access to your computer regardless, it becomes self-evident that obscurity is friend when the design has been bypassed or simply failed.

Perhaps mechanisms for clandestine messaging are set in place, standing up your own instances or using decentralized services can reduce your attack surface. It is difficult to attack infrastructure that did not provide any indication of its existence. You added more architecture into the mix for this chatter, however the attack surface from using centralized servers is removed. Snowden also recommended using decentralized servers over TOR with strong cryptography.

### Code Implementation
Code is a great complement to cryptographic ciphers. It has an incredibly easy implementation, and its application can be as simple or complex as desired. Using the principle of randomness, you and your affiliates could generate a word list to send out messages in a similar way that cryptocurrency wallets generate word phrase seeds. Anyone in the conversation would be given the word list and their correlated meanings (i.e. snow = money, owl = printer). Think of this method as speaking cryptically without a real cryptographic implementation. For conversations over-the-air, phrases and words can be reused; however, reuse of codes will give away more and more of the true message (under the assumption that your messages are decrypted by unauthorized parties). Once a certain amount of messages have been sent using the code for messages, it is advised to have each of your affiliates burn the page correlating the words and code. Frequency analysis is a cryptographic code-breaking technique for deciphering messages that could make short work of finding the hidden meanings. The technique is exactly how it sounds - praying upon reused messages to determine the meaning of words and phrases.

### Blending
"Do not speak truth to power; they will hammer you." While this is more a statement from the perspective of dissident political discourse, it stands true in an anti-forensic threat model. Operating under the radar in your operations can stand to provide valuable protection. To say the least, having federal agents breathing down your neck is an undesirable position. The concept of blending is applied with the use of previously discussed TOR and mixnet traffic routing. Simply put, "anonymity loves company," and standing out in the vulnerable world of computing is ill-advised.

Standard security mechanisms are inadequate for the purpose of anti-forensics. Nation-States and Advanced Persistent Threat (APT) groups do not play by the rules. All bets are on that no matter how hardened your system kernel is or how safe your OPSEC precautions may be, there is always a point of compromise. An unpatched vulnerability is waiting to be exploited against your system. If your device is emitting traffic, all bets are on that with enough resources, these groups will be able to decrypt the traffic. Maybe it won't be today, but it certainly will be in the not-so-distant future. If you are a target, chances are that you are already compromised. Use the masses as cover; open deviation is ill-advised.

## Minimal Attack Surface

While living in the "end of trust," we must follow standard system hardening practices. These practices emphasize the reduction of software and hardware needed throughout the operation. There is no purpose of strong keys in cryptography if the underlying system operations have compromised you via keylogging and other variants of malware. You can create an intricate system of firewalls, intrusion prevention/detection systems (IPS/IDS), event log management to detect compromises, proxies, virtual private networks, TOR, I2P, but your must recognize the underlying fingerprint of these systems. Minimal architecture should not be limited to solely software and hardware, but also the signals being used; treat all signals as hostile. On mobile devices, consider the different Cellular protocols such as 3-5G variants and LTE. In times of unrest, the state has the power to disable and manipulate the protocols available for use. Most modern devices allow you to select settings such as LTE only or whitelist specific towers. You may go offline in times of unrest, but at least they aren't leveraging legacy protocols, potentially engaging in packet injection, and redirecting your device like a good puppet following dictates of its puppeteer.

Limit the use of these Cellular protocols with the following setting alteration:
`Settings > Network & Internet > Mobile Network > Preferred Network Type > Select LTE Only`

Every introduced system creates a larger fingerprint and attack vector, ultimately leading to more trust in more systems and services. The most anonymizing and secure operations require minimal architecture and physical security.

>Note: Cellular radio modules lack randomization, rendering mobile devices inadequate for anti-forensics. This has been a pain point to many operations and has often been the sole cause of de-anonymization.

## Automated Shutdown Procedures
Depending on your threat model, not all operations can be conducted from a coffee shop. There are an increasing amount of cameras, and facial recognition technology is already being deployed, along with license plate scanners at every street light. If operations are sensitive and must be conducted from the same location consistently, preparation should always lean towards the worst-case scenario.

While some of these proposed methods may be unconventional, these are unconventional times. Mechanisms can be put in place to ensure that your systems are sent shutdown signals that will lock them behind disk encryption. Shutdown signals are the most common, however we are not limited to the commands we issue. The use of radio transmitters to issue shutdowns have some level of intricacy that surpasses skills of the novice user.

### Dead Man's Switch
A physical wired dead man's switch reduces attack surface and intricacy. After the dead man's switch aka killswitch is configured, we can move on to the commands to issue. If we wanted to securely wipe the random access memory before shutting down, we could issue the "sdmem -v" command to verbosely clean the RAM as the killswitch is activated. The killswitch can be activated from a system event. Any form of shell command that is compatible with the particular GNU/Linux system can be ran based on a specified system behavior. See resources at the end of this section [^41], [^42], and [^43] for USB dead man's switch. In a nutshell, this is configured to watch system USB events. When a change occurs, the switch commands are invoked. Panic buttons are another form of a killswitch that essentially remains active on your display and is ready to select at any moment. (Centry.py[^44] is a good example of a panic button). There are USB devices known as "Mouse Jigglers" that are used by forensic teams after device seizure. These jigglers are serial devices plugged in to interface with the system to keep the screenlock from being invoked.

There are easy preventative software-based solutions such as USBCTL[^45] that can prevent these devices for operating, however this will likely be picked up on and human mouse jigglers can take their place. Ideally a process can be utilized to detect such a device and invoke a shutdown process. A mitigation for the human mouse jigglers could be implementing forced authentication every half hour to an hour. If the credentials have not been entered, the user session could be terminated, memory could be cleared, or the shutdown command could even be invoked.

Remote switches are interesting devils, and their utility should be placed under high consideration if the size of the operation warrants it. Panic buttons such as Centry.py can be used to broadcast or propagate a panic signal to all nodes on the network.

## Play on Resources
Earlier, it was said that these groups have unlimited resources; this is not entirely true. The one resource which they lack is time. While they have infinite funds to allocate towards password and key cracking methods, so long as quantum physics strays behind computing, time is their main constraint. Taking methods from obscurity, the use of non-default encryption algorithms and hashing mechanisms for keys substantially increases the amount of time the analyst must expend on cracking. If the analyst cannot identify the hash function or cipher, they must try all possible options. Even if the correct password is obtained, this becomes useless without the proper cipher. For instance, Veracrypt uses over fifteen combinations of individual encryption algorithms and cascaded/stacked ciphers. Complement this with the five supported hash functions, and we are looking at 75 possible combinations of symmetric ciphers and one-way hash functions. As stated by ElcomSoft,[^46] "Trying all possible combinations is about 175 times slower compared to attacking a single combination of AES+SHA-512."

Hypothetically, if the algorithm/hash combination is known by the attacker, here is where the cascading algorithms display their value:

"Whether they choose to encrypt with AES, Serpent, Twofish or any other single algorithm, the speed of the attack will remain the same. Attacks on cascaded encryption with two algorithms (e.g. AES(Twofish)) work at half the speed, while cascading three algorithms slows them down to around 1/3 the speed."

>Note: VeraCrypt does not keep encryption/hashing algorithms secret. Keeping such information secret would break the functionality of VeraCrypt (unless the user were to enter such information on every boot, comparably to how PIMs work). An attacker will never need to attempt multiple combinations. They will simply need to attempt cracking a single, different, algorithm.

Leveraging Veracrypt:
1. Generate keyfiles: `veracrypt --create-keyfile`
2. Create a Normal volume: `veracrypt -t -c /home/user/crypt/vault --volume-type=Normal --encryption=Serpent-Twofish-AES --hash=Whirlpool --filesystem=FAT --pim=<INSERT VALUE> -k </PATH/TO/KEYFILE> --random-source=</PATH/TO/RANDOMSOURCE>`
3. Create a Hidden volume: `veracrypt -t -c /home/user/crypt/vault --volume-type=Hidden --encryption=Serpent-Twofish-AES --hash=Whirlpool --filesystem=FAT --pim=<INSERT VALUE> -k </PATH/TO/KEYFILE> --random-source=</PATH/TO/RANDOMSOURCE>`

Distractions are also effective methods of increasing the resources allocated to an investigation. All of the previously listed methods for increasing time of the investigation so far have dealt with decrypting a single Veracrypt or LUKS volume. What happens if multiple decoy volumes are set up? The investigation increases in cost and time consumption.

Unless you are an undeniably high-value target, it is unlikely to have entire infrastructures simultaneously aimed at cracking your volumes.

## Radio Transmitters
Every radio transmitter, the hardware component that emits a radio frequency, adds a substantial attack vector. Near-field communication (NFC), Bluetooth, Wi-Fi, Cellular, and GPS are all examples of wireless communications.

When feasible, radio transmitters should be physically removed from devices. From a software perspective, the use of certain transmitters can be limited; however, without purging the hardware, there is no absolute assurance. Chipsets could still emit frequencies, and there is a potential for leakage.

For an adversary who gains a foothold on your system(s) without the physically removed hardware, they could activate certain frequencies to create a persistent foothold and compromise your system even further.

For critical operations, reduce reliance on wireless radio transmissions. Consider the process of removing all radio transmitter chipsets, otherwise known as airgapping, to mitigate a medley of threats.

Methods of "jumping" airgaps have been found in the past.[^47] One must be sure to remove all hardware which could be used for communication. This includes Wi-Fi cards (often Bluetooth and Wi-Fi are within the same physical card), Bluetooth card (if you have a Bluetooth card separate from your Wi-Fi card), microphones (communications protocols have been devised to transmit data through ultrasonic audio). Many modern OSs still have the drivers to support these protocols, and the attacks surface therefore still exists), speakers (usable for data exfiltration using the same means), physical ports (USB, SD, headphone jack). Even power cords have been used as a means of compromise (on both laptop and desktop systems).

The traditional methods of interfacing with the internet stand to be the most secure. Systems using direct ethernet connection is optimal. While this is not a technical "airgap," this does prevent packet communications from being analyzed over the air.

For those who still require the use of wireless technology in their daily lives, consider the option of airgapping and utilizing a wireless dongle when necessary. Radio transmissions are only allowed when your device powers the USB wireless dongle. If hardware emitting signals cannot be physically removed from the device, consider implementing faraday cages. ([See EMF Shielding section](#emf-shielding))

>Note:
    Wireless drivers have been used as a means of system compromise in the past.

Once the device is ready to be shutdown, simply pull the dongle from the device, and there you have a physical killswitch for wireless technology. Not only is time reduced for remote exploitation, but inherent device identifiers with the built-in chipset are removed.

Many of the radio frequencies require close proximity or directed antennas to effectively capture data and perform exploitation. Another method to consider if wireless technology must be used is the implementation of jamming.

Currently jamming is not a bulletproof method of preventing wireless communications from being intercepted. Wireless removal would be simple to implement in comparison.
While jamming isn't the best route for sniffing/snooping, the creation of excess noise is not a bad idea. ([See Noise section](#noise))


## EMF Shielding
Electro-magnetic frequency (EMF) shielding, otherwise known as a Faraday cage, is essential to maintaining privacy. Certain fabrics, paints, and foam with the proper alloys can prevent the infiltration and exfiltration of device traffic. If you're on a tight budget, purchasing the material from reputable vendors and making a DIY project out of it may be the best option. However, if you mess up the material with stitching or have any loose points where traffic can travel, it could end up being more costly than purchasing a pre-made Faraday bag. Try to store the Faraday caged items next to a ground. Electro-magnetic energy wants somewhere to go; it looks for a path. When the radio waves contact the structure, it is best to provide them an easy path that leads them away from the shielded device.


## Noise
Generating excess noise through logging or traffic can be an excellent method to throw investigators for a whirl. Anyone who has worked with security logging mechanisms for system auditing can attest that noise is the enemy of understanding. Traffic in mass can be hard to piece together, especially if it's not all being generated by you. For the natural sadists who want to more or less troll, consider hosting services such as a TOR node. Instead of trying to find pertinent clues in a small pond, investigators are trying to search a great lake, or perhaps the rivers of Nanthala National Forest. To couple the size, the clues they find may even lead them down false bends. So long as the data is not revealing information relevant to your operation(s), this will stand to make the water a little more murky.

If the operation is mobile (I suspect it would be if you cannot remove radio transmitters), best practice is to store each item in its own faraday bag and then store them inside a larger shielded bag. When you add or transfer items, the devices don't leak signal when the outer bag is opened. Think two is one, one is none.

## Optimization
Ultimately, you may find that many of these precautions are far out of your scope or threat model. You may find them to be immensely inconvenient.

Every intricacy added for security reduces operation uptime and as a result, productivity. For such extensive security mechanisms to be used, there must be a practical method of implementing given procedures.

Your operations and system must remain accessible despite such intense OPSEC precautions. Instead of compromising on security, consider implementing automation. Simple scripts can reduce the effort needed while keeping nested layers of cryptographic solutions. For instance, create a function for mounting your encrypted drive, closing out an encrypted volume, and the "when things get out of hand" function where files should undergo the process of secure deletion.

>Note: As previously noted, secure deletion is generally impossible on SSDs. Also, any bad sectors on a drive (SSD or HDD) cannot be securely erased by software. Such bad sectors must be erased physically. Kali and Parrot include a LUKS "nuke" feature which erases the LUKS headers. This can be used to ensure an encrypted drive cannot be decrypted, even if your password can be broken. This feature can also be installed on any Linux-based OS. Installation of the LUKS nuke feature may conflict with Secure Boot on OSs which don't support it by default.

With the Bourne Again Shell (BASH) built into GNU/Linux systems, you can create simple functions that will perform these tasks. ([See Appendix A](#appendix-a))

Paste the text from Appendix A inside a text file > Rename the script to script.sh > Run `chmod +x script.sh` to make the script executable > Now all you must do is open a terminal and type `./script.sh` and do your will.
That wasn't so painful now, was it?

Some of this efficiency does come with a high price to be paid; obscurity and cryptographic security are harmed in the production of this script. The script would give away your PIM number for your encrypted drive. This gives investigators one less field to guess in the decryption process. As for obscurity, it becomes evident which keys are being used and which hidden volume is being decrypted. Kiss your plausible deniability goodbye. To retain some of the obscurity, one could create multiple dummy scripts, one for each volume, and even create scripts for volumes that don't actually exist. Take a mental note at the specific script needed for execution, and the varying duplicates will add to the case's confusion.

## Alibi Creation
We are in an age where we are constantly connected. Dropping off for even a few hour span begins to induce psychological stress on individuals. There are always expectations to quickly answer that text or view this post or like this status. To be successful in your operations, you must learn to kick these habits. Make it routine to disappear. Routine has substantial importance, and we must learn to create alibis or narratives around what we are working on. Perhaps it's a side project of some sort, or some harmless hobby. If there is no attestation from anyone during a substantial amount of time, even with plausible deniability, the situation can start to look grim.

Regarding the creation of online accounts and personas, don't use identifiable names. Your operations should be treated as a second life that should be appropriately segmented. While you may find some of your ideas to be profound/esoteric and want to reuse and redistribute across platforms - refrain. You're only creating a trail that could come back to bite you. Not only should you segment your usernames creative talents, but ensure that projects also become segmented. The more you divulge into separate projects, the less connection you want to have - unless of course they are related and you desire the marketing crossover.

The physical use of your device, from pinging telecommunications infrastructure to local area network (LAN) connections will rat you out. Geofencing requests have gained increasing popularity with American law enforcement. Google self-reported, "Year over year, Google has observed over a 1,500% increase in the number of geofence requests it received in 2018 compared to 2017; and to date, the rate has increased over 500% from 2018 to 2019."[^48]

After the physical side is dealt with, the digital side can start to be addressed. Just like scripts can be implemented to increase efficiency, they can also be used to aid and/or create alibis.

Consider the creation of python scripts to engage your devices to perform certain functions. For instance, create a wordlist that your browser searches for on demand (with a hint of randomness). Program your music player to play certain songs at certain times. The goal of these actions is to emulate real activity that could provide that alibi for you.
Often times a double-edged pendulum comes to swing. If an investigator were to become aware of such things being in place, it could add to your suspicion and increase the difficulty of legal defense, acting contrary to the intended result.

You will likely not come out unscathed from the psychological toll of withholding secrets. Not only do fabrications add unneeded complexity into your relationships by forcing you to drain energy keeping narratives intact, but they place you in a state of isolation from others. All tyranny stems from deceit, and your own psyche can stand to be a worse tyrant than the state. Make sure the endeavor is worth the burden.

"As we have seen, every personal secret has the effect of a sin or of guilt—whether or not it is, from the standpoint of popular morality, a wrongful secret. Now another form of concealment is the act of "withholding"—it being usually emotions that are withheld. As in the case of secrets, so here also we must make a reservation: self-restraint is healthful and beneficial; it is even a virtue. This is why we find self-discipline to have been one of man's earliest moral attainments. Among primitive peoples it has its place in the initiation ceremonies, chiefly in the forms of ascetic continence and the stoical endurance of pain and fear. Self-restraint, however, is here practiced within the secret society as something undertaken in company with others. But if self-restraint is only a private matter, and perhaps devoid of any religious aspect, then it may be as harmful as the personal secret." - C. G. Jung, Modern Man in Search of a Soul[^49]


## False Compromise
Malware with computing is still in the early stages. It truly is the wild west in many regards. For an extra layer of plausible deniability, embed a tailored backdoor or malware variant. This method will not protect you if there are logs that correlate your activity and no logs correlating connection attempts.

The vast majority of cases related to online operations become unsolved mysteries in the archives of law enforcement. Most happenings become heresay or mere hunches. Take APT groups and nation-states as an example; the majority of cyberwarfare that occurs today is between state-funded APT groups with a primary focus of non-attribution. Despite how many correlating clues lead back to the APT groups and their communications with nation-states, the water remains murky. In replacement or in conjunction with the killswitch, consider weaponizing your own variant of ransomware. You could create a maintain ownership of the key or you could accept the loss of your data. The malware could also perform shred functions as with any script that you could program. Not only does the embedded malware render your data inaccessible, but it provides another level of plausible deniability. "I was not aware my infrastructure was being used for that." Technically, "malware" implies the application of code that will create adverse or undesired action to the system. This is not truly malware, but rather programmed code designed to mimic malicious function.

On GNU/Linux, there are many ways to embed malware on the system. Some of which leverage crontabs or other variants of scheduling tools. Aliases can be altered to perform malicious functions rather than the desired results. System process in `bin/` directories can perform unintended tasks, or simply be swapped out and/or linked to alternate processes. Some files such as `/etc/rc.local` or `/home/$USER/.bashrc` can contain commands to execute upon booting to the disk or logging into a user account respectively. Analyzing the newest trends of threat actors can useful to determine indicators of compromise (IOC). Kinsing[^50] and other threat actors that leverage new vulnerabilities to compromise internet-facing systems and embed crypto-miners provide insight into the world of persistence, along with a competitive nature that stunts competition. The sub-sections listed below identify remnant items that could signal a past compromise to forensic analysts.

### Cron example
`echo "*/30 * * * * sh /etc/.newinit.sh >/dev/null 2>&1" > /etc/$crondir`

### Service Creation
Make a file under `/etc/systemd/system/$service_name.service`

If using a runit service manager, create a file under `/etc/sv/$service_name`.

### Executions from temporary directories
Many hardened systems append the mount the `/tmp/` and `/dev/shm/` partitions with `noexec` to prevent malicious code from being executed in those partitions. For the sake of compromise, consider creating files that appear to be reference points from a past compromise. Some files in crypto-mining cases have names such as `.zsh`, `.zshs`, `kdevtmpfsi`, `libsystem.so` under the `/tmp/` or `/dev/shm/` directory.

### Placing SSH keys under the root user
Unexpected SSH keys can be a sign of compromise, and they typically do not belong under `/root/.ssh/` directory as they are primarily controlled by a less-privileged user account.

## Traceless Procurement
There are a few concepts to touch on this topic.
1. Avoid main vendors such as Amazon. Either go directly to the vendor or order through an IT Ma' & Pop shop.
2. Order by proxy - Offer to pay someone in cash or cryptocurrency
3. Order with an alias - There are plenty of defined methods of "dead drops" that exist. Consider ordering to a hotel with an alias, paying with a prepaid card that was paid for with cash.

There is no perfect solution here, and procurement can quickly become intricate. This landscape undergoes constant change, therefore I have refrained for diving into minute detail. The traditional cash route, preload cards, and cryptocurrencies with strong cryptography and privacy features stand to be the best options to date.

### Cryptocurrency
Similar to how cryptography is a monolith of a concept to tackle, cryptography with blockchain-based payment methods also becomes intricate. Many associate cryptocurrency as untraceable forms of money, when in reality most cryptocurrencies that exist today are more susceptible to correlation than cash. Most alternative coin (altcoin) derivatives, including Bitcoin, have public ledgers (viewable to any party). This appeared to be the simplest method to maintain integrity of the chain. There are a few cryptocurrencies that fall in line with privacy: Monero (XMR), Zcash (ZEC), and Pirate Chain (ARRR).

Zcash (ZEC) was ground-breaking in the implementation of a protocol known as Succint Non-Interactive Zero-Knowledge Proofs (zk-SNARKs). The protocol enabled the use of what they refer to as shielded "sapling" addresses. This facilitates anonymous payment from one party to the other. The pitfall to Zcash is that it also allows the use of transparent addresses. The vast majority of Zcash is held in a completely transparent blockchain. When amounts are exchanged via the shielded private addresses, the scope is narrowed on those making the transactions. Money going in and out of the private sapling addresses becomes trivial to correlate.

Monero is often hailed as the privacy king of cryptocurrency. While it has commendable features with its RingCT protocol, the overarching theme is obscurity rather than traceless transactions.

"The fundamental problem of coin mixing methods though is that transaction data is not being hidden through encryption. RingCT is a system of disassociation where information is still visible in the blockchain. Mind that a vulnerability might be discovered at some point in the future which allows traceability since Monero’s blockchain provides a record of every transaction that has taken place."

This operates similar to a mixnet where it is difficult to discern the originating address from a transaction. One of Monero's developers publicly admits that "zk-SNARKs provides much stronger untraceability characteristics than Monero (but a much smaller privacy set and much higher systemic risks)." Intelligence agencies have placed their eyes on Monero for some time. The United States has even brought in a private firm called CipherTrace who claims to have built tools capable of tracing transactions.[^51] At the time of writing, these are unsubstantiated claims; there is no evidence to suggest that Monero has been de-obfuscated.

Pirate Chain's ARRR addresses the fungibility problem of Zcash by removing the transparent address schema (t-tx) and forcing all transactions to use Sapling shielded transactions (z-tx). "By consistently utilizing zk-SNARKs technology, Pirate leaves no usable metadata of user’s transactions on its blockchain." This means that even if the blockchain was compromised down the line, the adversary would obtain little to no useful metadata. The transactions contain no visible amount to no visible address from no visible address. The underlying cryptography would have to be broken or the viewing/spending keys would have to be intercepted in order to peer into the transactions. For an adversary without key possession, the trace is baseless. "A little bit of math can accomplish what all the guns and barbed wire can’t: a little bit of math can keep a secret." - Edward Snowden

While I could write mounds of literature diving into the depths of cryptocurrency, I have brought forth only what is useful to the aims of anti-forensics. There is no real purpose in regurgitating quotations from various whitepapers and protocol designs. Any further research into the matter is up to you. If this has peaked your interest, consider diving into the various communities, protocol specifications, and whitepapers.

- Further information pertaining to zk-SNARKs - [^52]
- Monero (XMR) Whitepaper - [^53]
- Pirate Chain Whitepaper - [^54]


## Defensive Mechanisms
System security or hardening is vital for successful operations. Lack of hardening could result in your machines being cut through like hot butter. Center for Internet Security (CIS)[^55]  and Defense Information Systems Agency (DISA) with Standard Technical Implementation Guides[^56] both have decent system hardening standards that are to be applied to all DoD contractor, government, and affiliated nodes. For Linux and Unix systems, Kernel Self-Protection Project (KSPP)[^57] is a great resource for kernel configuration settings.

Hardening procedures fall in line with the concept of minimizing architecture and running processes on a system. This makes each system easier to audit with less noise/clutter, and reduces the attack surface for exploitation. Hardening should encompass patches, scans with most recent virus definitions, restrictive permissions, kernel hardening, purging unnecessary software, and disabling physical ports, unnecessary users, filesystems, firmware modules, compilers, and network protocols.

System hardening is far from a quick and easy process, unless you have preconfigured images for systems. For small operations lacking technical prowess, preconfigured operating systems such as TAILS or Whonix mentioned in the Operating System section assure the greatest security and the least hassle.

If the goal is to run a more persistent lightweight OS with minimal functionality, I suggest running a variant of Arch Linux that does not use SystemD (Consider runit, OpenRC, or s6). If wide community support is needed, Arch with a hardened configuration will be your best bet. For the tech-savvy, hardened variants of Gentoo are ideal.

The more persistence desired for the operation increases the complexity of the hardening. Some projects have been introduced to rival Xen-based hypervisors with minimalist GNU/Linux systems. Some development towards Whonix Host[^58] was started but has not yet come to fruition. PlagueOS[^59] is based on the Void musl build with numerous hardening mechanisms. This is designed to act strictly as a locked down hypervisor with all system activities conducted inside of Kicksecure/Whonix VMs. The VMs also are restricted by AppArmor profiles and are ran inside a `bwrap`[^60] sandboxed container. See the PARSEC repository for examples of how to implement bubblewrap profiles.[^61]. Do note that the listed hardening is incomplete and will not fit all operations and GNU/Linux systems. This is not meant to be a book on methods for defensive cybersecurity. For those concerned with exploitation of GNU/Linux systems, see the reference to Madaidan's hardening guide.[^62]


## Physical Precautions

This wouldn't be a complete work on anti-forensics without some mention of physical precautions. While wireless transmitters are ill-advised, wireless technology can prove useful when larger proximity is needed. Directional antennas could allow you to stay hidden from cameras and remotely authenticate to a network.

With nuances added from the modern surveillance state, traffic cameras force your hand by revealing every intersection which you have passed through. There are a few methods to circumventing this privacy infringement. Darkened weather covers for your license plate (Warning: This method could result in a fine with the wrong officer) or a well-rigged bicycle rack could prevent cameras from picking up your plate number. Alternatively, if a destination is within a few miles of proximity you could either ride a bicycle (with a disguise), or decide to become a motorcyclist. With motorcycles, the plate numbers are significantly smaller and could even be blocked by your feet on particular bikes. The helmet would stand to mask facial features, and the jacket would cover any identifiable features such as tattoos. While on the subject of tattoos, it is worth mentioning that Palantir has been involved in "predictive policing" leveraging footage obtained from traffic cameras to profile individuals.[^63]

Vehicles and privacy are starting to become a wicked problem ushered in by manufacturers. Almost every vehicle following 1996 has embedded systems, Onstar or the more modern Starlink, that have a default opt-in policy. They proceed to parade this "convenience" as a feature. Nearly all modern vehicles have multiple cameras, sensors, and Data Communications Modules (DCM) that accept/transmit GPS and cellular signals. Many vehicles report back your odometer reading in real-time. If you opt-out of their service, the data collection does not stop. There are only a few avenues out of nightmare. The first option is obtain the source code (assuming it's not black box code), gut the telematics, and proceed to flash the firmware to your vehicle via USB. Unlike flashing a cellphone where you run the risk of bricking the device and losing a menial 300-500 USD, here you are playing with an object that could run you anywhere from 10-40k USD. The second option is to disconnect the DCM and run the risk of losing base functionality to radio and speakers. This could also create certain hazards for your vehicle as many of the sensors tie in with the DCM. The third option is to become your own mechanic and maintain old vehicles from the 80's and 90's.

Vehicles aside, it should go without saying that any tech devices that you purchase will have some identifier that could lead back to you. Make this a moot point and procure every device (even USBs) anonymously with cash. If you're out on a distant road trip, make some of your purchases. Wear a hat accompanied with some baggy clothes. Perform a slight change in your gait as you walk (uncomfortable shoes could help with this). Alternatively, pay that bum off the street to do your bidding.


## Use Cases
There is no way to address every threat model, therefore I have opted to provide mitigations to some of the justifiably paranoid cases.

### Anonymous Activism

Anonymous activism may be seem counter-intuitive as activism typically implies attracting an audience in large numbers to support your cause. Unless you have a specific niche that lies in the darkest recesses of the internet such as forums on onion/i2p addresses, likely you will have to conform to expand your ideas to a larger audience. This involves communication with social media platforms that are more or less espionage outfits for intelligence agencies. Not only is the communication hostile, but anonymity is constantly challenged by the forced verification of phone numbers. Voice-over Internet Protocol (VoIP) numbers are dynamic internet numbers that can be provided via applications. For some time, this was a decent alternative to the privacy-invasive practice of SIM correlation. Unfortunately, the espionage outfits are beginning to filter out any VoIP-based phone numbers. To be more blunt, this is not for the purpose of security; the core is surveillance. If security was the primary goal, they would provide you with a key for setting up a time-based one time password (TOTP).

Unfortunately all workarounds for this require money and time. Many legacy accounts have bypassed these practices by being fathered in. If these platforms must be used, your options stand to either purchase a legacy account from someone anonymously with cryptocurrency, or buy a burner SIM card and phone for the purpose of verification. If the goal is anonymity, based on where the traffic is coming in from alone, you will likely be flagged as suspicious, and a code will be sent to your number for verification. If they offer TOTP for accounts, turn it on. Likely if there is a flag for suspicious activity, you can leverage an offline password database for TOTP and the hassle with constant phone verification will be reduced. If phone verification is enforced solely, your options are to store the dumb phone without the battery and inside of an EMF shield faraday bag. Only use this in public locations (you can see why key-generated TOTP can save a lot of time). That addresses phone activation.

Another problem you may run into is that certain platforms do not provide a way of access without a mobile application (i.e. Instagram). While stronger permission controls have been imposed on applications in more recent mobile builds, correlation can still be made in a number of ways, even if on a segmented device. The best solution to mitigating correlation is to run an emulated Android on a hardened Linux base. Consider finding the APK file to install the platform from the mobile device's browser to avoid the use of Google. If Google framework is not required to make the application run properly, do not flash it.

If the emulated Android system is too close to home operating from your host, there is the option to stand up the emulation on a Virtual Private Server (VPS) hosted by another organization that you pay in cryptocurrency. When evaluating VPS providers, make sure to consider country of origin, payment methods, and their logging policy. It is easier to conceal the origin of traffic by using the VPS as a makeshift proxy rather than running the virtualized Android system on your host device. Your host can then use torrified traffic to interact with the VPS unimpeded by suspicious flags that are invited by the use of TOR.

Anonymity and activism are difficult to go hand-in-hand, albeit their balance is consequential. Playing on a platform of the adversary means conforming to their rules, and circumvention can be costly. Decentralization can mitigate issues with SIM correlation, hostile communication, and the need for an emulated Android system. However, adoption rates and exposure will significantly decrease.

### Journalist

For all intents, the use-case of journalism varies widely, therefore I will isolate this to a more "paranoid" threat model. Let's make a few key assumptions:
1. You are investigating a nation-state.
2. Freedom of speech / lawful protection does not apply.
3. Being caught could land you anywhere from imprisonment to death.

It's evident that poking powerful players could result in irreversible consequences. Therefore many of the concepts described in this book should be applied with the emphasis on encryption, signal restriction, and minimal infrastructure.

The OS selection should be oriented towards amnesia. TAILS could be leveraged with a USB, and the drive in the system could simply be a dummy (filled with insignificant data, vacation pictures, etc). The physical wireless chipset should be removed and replaced with a wireless dongle and attached only when needed. While I prefer hardware over software mitigations, you may not wish to fry the USB ports or de-solder the SATA ports. The BIOS should be password-protected, and the USB ports at the very least can be disabled from the menu. If you will be operating from public locations, consider running a blank keyboard with a privacy screen covering the LED.

Fortunately, amnesiac solutions are growing. One can run TAILS with the HiddenVM project.[^64] HiddenVM is precompiled VirtualBox binaries to allow running virtual machines without an installation directly on TAILS. HiddenVM leverages the TAILS amnesiac system with Veracrypt's hidden partitions for plausible deniability. In this way, Whonix can be ran from TAILs and there will not be an overlapping use of TOR.

If a live USB with minimal processing power is not your niche, consider running a hardened base OS such as PlagueOS, to act as a hypervisor that runs amnesiac virtual machines such as Whonix. If the option is taken to avoid live boot, the hardware specification becomes more important. First off, it would be in your best interest to use at least 16GB of RAM. Secondly, consider using one SSD and one HDD. The HDD will be used to hold files, while the SSD is used for facilitating performance for the host OS. As previously stated, HDDs can be wiped by degaussing or overwriting physical sectors while this should be assumed an impossibility for an SSD. Each VM on the host should have a primary function; separate cases and even processes should have separate VMs. For the more technical, sandboxing applications can be used to add nested layers of security. Consider using a sandboxed profile[^60] for your virtualization software, whether it be KVM[^65] or VirtualBox[^66]. Inside the VM, use sandboxing to isolate your processes.

>Note: Amnesiac computing is highly advised for journalists with state targets on their back. Most malware will not be able to persist through different sessions, and often they will have to interact with hostile platforms and networks.

If a mobile device is deemed a necessity, leverage GrapheneOS on a Google Pixel. Encrypt all communications through trusted services or peer-to-peer (P2P) applications like Briar.[^67] Route all device traffic through TOR with the use of Orbot. Keep the cameras blacked out with electrical or gorilla tape. The concept of treating all signals as hostile should be emphasized here as the hardware wireless chipset cannot be de-soldered. Sensors and microphones can successfully be disabled, but the trend with smaller devices is that they run as a System on a Chip (SoC). In short, multiple functions necessary for the system to work are tied together in a single chip. Even if you managed not to fry the device from the de-soldering process, you would have gutted the core mechanisms of the system, resulting in the newfound possession of a paperweight.

### Market Vendor
Let's assume the vendor is selling some sort of vice found on the DEA's list of schedule 1 narcotics. Fortunately in this use-case, unlike that of the anonymous activist (or the journalist in some cases), OPSEC is welcomed with open arms. In fact, vendors are even rated with their stealth (both from shipping and processing) as one of the highest criteria in consideration, along with the markets being TOR friendly, leveraging PGP, and ensuring full functionality without JavaScript. Given the ongoing nature of these operations, and that they are tailored towards privacy and security, a more persistent system will likely be the best fit.

The same recommendation for the journalist with a persistent setup using VMs for isolated processes on a hardened hypervisor is ideal. A completely amnesiac system is less necessary when you are not forced to interact with hostile sites that can arbitrarily run code via the use of JavaScript. While I would give a nod to those that take such precaution and exist solely in volatile memory, it is likely unnecessary and more of a hassle than the degraded performance is worth.

## Conclusion
As stated earlier, relevancy in the tech industry is difficult to maintain in perpetuity. The proposed concepts applied with adequate discipline and mapping stand to render investigations ineffective at peering into operations. Most mistakes take place in the beginning and come back later to haunt an operation. The success stories are never highlighted. For instance, there are plenty of vendors across marketplaces that have gone under the radar for years. OPSEC properly exercised would not leave a trail for the intelligence community; thus obscure and cryptographic implementations like steganography or FDE would not have to be relied on. I hope to learn that some of this material aids dissidents and journalists to combat regimes rooted in authoritarianism, coupled with privacy-minded individuals who have the desire to be left alone. Freedom and privacy have never been permitted by the state, nor are they achieved through legislature, protests, petitions; they are reclaimed by blatant non-compliance, loopholes, and violence. Every man possesses the right of revolution, and every revolution is rooted in treason, non-conformity, and ultimately to escape from subservience. In a world where they proclaim that you should have nothing to hide, respond with "I have nothing to show."

For the dissidents:

*"In a nation of frightened dullards, there is a shortage of outlaws, and those few who make the grade are always welcome."* - Hunter S. Thompson

For the hollow men (federal agents or contractors) who stumbled upon my work by investigation or happenstance:

*"If ye love wealth better than liberty, the tranquility of servitude better than the animating contest of freedom, go home from us in peace. We ask not your counsels or arms. Crouch down and lick the hands which feed you. May your chains set lightly upon you, and may posterity forget that ye were our countrymen."* - Samuel Adams

## Appendix A
```
    #!/bin/bash
    # Simple Cryptographic container script
    function mount_partition() {
        veracrypt -k </path/to/keyfile> --pim=<#> </path/to/mount/file/>
    }

    function close_partitions() {
        veracrypt -d
    }

    function gone_nuclear() {
        shred -n 32 -z -u -v <key file>
        shred -n 32 -z -u -v <mount file>
        shred -n 32 -z -u -v <source of entropy for mount creation>
        sdmem -v
        sfill -v -z </path/to/files>
    }

    options=("mount_partition" "close_partitions" "gone_nuclear" "Quit")
    select opt in "${options[@]}"
    do
    case $opt in
        "mount_partition")
            mount_partition
            ;;
        "close_partitions")
            close_partitions
            ;;
        "gone_nuclear")
            gone_nuclear
            ;;
        "Quit")
            break
            ;;
        *) echo "Select a valid option";;
    esac
    done
```

## Contact Us
Feel free to reach out with any critiques, alterations, questions, or consulting opportunities.

Email: `x0ptoutx@protonmail.ch`

> Do note that there is end-to-end encryption (e2ee) implemented between ProtonMail users. The keys can be adjusted in settings to use Elliptic Curve Cryptography (ECC) or RSA-4096.

```
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQINBGDVDoABEACx3gVRau9t3dOS2mRxRVXmqHnLR1UTXyHR3WrB2vMnMyHQ6y5r
F/S6V6o+lH0Ar49AqQrClbdoig1peAHxRjCd02SnSwPmr7KFjLirHE+fyAvnkh6E
ExhK+Rf8ABH701SrBKDk05o/3w2fieJGo0pxPrBP/QoflmDvoTWeckw8zAmCK+uz
15o86RGSBqVoRaXPdxNLfw/2Dw2XtyA4WJNqreDfmMdPcyg5zD/OihQ2nnBCjxu9
p3HhpX7/Z9nHoqteZ71Zik7kkeVh3x9/7kNRMc9qXVB8URNboX2GZEEoqJ6+AuOL
Y1qQdee0LnJ8F/CcqEx7ZMAAlz3EZLV2hOLSTwI4fA0Z8W73So0q8rlI44of98rv
acdyYh2d7trhA7r5lYFS9gkKcsmX5+MmACOx7SBI33d+CYN1Kcya+imsjLThLNl/
MG5kOLbb3D807nPQ6welf8WQH0vR28KXFcLCJS7Cn+nim14vFkm2nJiL8Kcbn9BP
BBm2XwR32EnqbziqpP4lf8TL6w0miptGlCyf9uGF1BRDXzA/0jZoFpAScHAeiRJn
o+7aFzt9orTx8QzFTY2gSW9NcJD52/xeLha+fF+LdWp6doRautazlnw3Vd8yNVjb
p0dM+jKOJtG6ugTzWQVcIEB9XMoiaFqtXYYZ23Tqp0lBESqeTlA4knr2DQARAQAB
tCNhcmNhbmUgZGV2IDxnaXRAYXJjaGFpYy4zM21haWwuY29tPokCVAQTAQgAPhYh
BLh3i1wGz41eaeTU6xO6S9TBQXDABQJg1Q6AAhsDBQkHhM4ABQsJCAcCBhUKCQgL
AgQWAgMBAh4BAheAAAoJEBO6S9TBQXDA4Z8P/i97qhgC3WuBTCGn947WWqZtSZTr
EQK+Ta7pNdZetDu8KlwlAXQB5OdM9sZlOY1p3LgopcJNR07L8pnsCCGYiuI1iwfJ
7jxyHv8wpaCLFbtdjoD55JYzsXuoFEfILMa387CLMO3aWmQXOrCOti3C7fPs4g12
77orQ8xqYlW02r5gO+CeAzdAgeEzi/v1RlJV1V+iLuLf3fme5rB3xVQgyzwM92mc
d6M90cXypBzl2cIb73VeRPzrGlJGcz/WRoekcsXw0w0CZLfsBDNl4SP3GOU4kgRU
DTh7Cq8nMZKSlqtgMLhDllTGmZ1IRLTvDuQqFlcPdrIX/byxcrWPaDSk5HNOpUjt
K9MCHBjA8oJbvYGm96ItId+bxwbTnElTJvgbWrPa/Q9/zMk8NlxHEEzRH1Y6SZIg
YBLdh+4eIZZijVYeoQbhC33BR464n4NfRIslWRyGdCcY6HGC497XhNTyOSyKpbqb
TCTmPXyZyJJrx7Mh8sK3U3rYWV9t6GHTrtj8kdmxPYz3NEmCZCvnrthdCuqCh2+F
jOVnfVnkuJApc+brb+ZXVu63bh8kjWmDT9H5M36ti/E6a99o9h+OZc5BKRhfeP4J
CYki4vb+1cHR8UxZkSkxGmy7LF4/grh4S+5BG9rVnILtsqrnUGacl7os+tBxnU3F
wFz95pcTjdeHrCHkuQINBGDVDoABEADfSLDrJObW1fFd0vxQYujNjTbDLJa2pJz0
HSVXTGd8vpJEo+4KdV+p89EnSWuiHKu628nC9ziU1xPcy4F/AXfMRGpzoNl7YHZk
JZ1UAxw/kF16d8c0rJgE5bnnP/6qksBeaeAhtiZSYOvCBWaBUo1GWtanNwSUADjX
UWs/zxJq/6hJNQRfRL4WoLpr4Ke/ng9JjZiXpjaa3oxdD28g+idsv9VwvUP51kem
/GaHw+ihirzXMJqfocGYBM1imzACZchgF8kN0CzNKItsCN3qCC31ZHe/MuKB+gjd
IvkpSBba3M6PrkyNOz0AiyAR4z3mdHLRUUu3LmztUbICZkmCchrDBovSP3Ad+/S4
q5yZUnoiwwu0lKTjRj+gl+RSiTYAoC8OwjQMNacB46Ssluvd3ZpSBBkzgCdvPFfo
G+enhBN8dtDp3dFyD4wEOGpWaFWIel88HRJ+6zc4tk0GsVazV6rceH4tZHzHAFOK
GyVLvrH1JMMw7rqgzsG05YtWH1tWSFVsw6aL4CY05GWxtOi+7c8kDoJbKuhdZRXY
IxlqEPYo614mzOfwo47zXvgi8r7Qo7ZoLAySOwAIvBGpgDHgH0oUmPbw8BnRyEAs
/WZJR7JB4rCkI/rL96iif7QM0rD/8aKswOwpGi4XSozTTScYiwobO56peZz4g+NR
4ZVcaeeKWQARAQABiQI8BBgBCAAmFiEEuHeLXAbPjV5p5NTrE7pL1MFBcMAFAmDV
DoACGwwFCQeEzgAACgkQE7pL1MFBcMCeRA//SkwAZYBidQVf5IUVWT8HWamv3RAY
hbxLxZQi0LqkxGw/OOb4OrAg/7Wjr8RUZVGOA2nydX2DuuvY6BYtvb4pCX0zybcm
nyOpO0zdFJzr28twTHkfxCQo0UuQuljnyeKfMPQ6gkydPo/5fVEIABnGF+vpbwch
1aALjhoURC32LeEB+OcqKo79vUpEDUL9HhZcVVJNr3YZ7jLJWjmNSNu2yFOFUUt0
4IJ0u6T72iC+sWQVJqinOdSKoDrHZKJcsD29wOkgt8j9vc2nhcx+nG0bClQuHqeX
jXL7Ww7p22l/SJkI/i1jS9eQHigBdGXD5qK1RvKlcBt3GWrZ0c7GUVuwCsObNz/Y
Ci0FNd6Q5be1Xqof/E3JD3mdRCvY62QpXhZqj7qLSEo0aOOBaAU9FrylTzWqKxIa
VfTK0Io7l3Ti4/dg8Wq+uIdUOx/i1w9fINmKwJJ9kEAsKXsRt//1rAq0bN970f+X
OTef+o9UCKCXqSdcdZa5jA8EmM8YklelxsMvV6lQHuPgioqiC1BNqv1/PagFmUsj
DgdWQnlMo4I8/4JKpnYoAq33kOdchfB63+kRI2S7kEfCnxmosoKZuNVCUVmPKme1
XYHLOf4hqvs1hLn2p35X8seXiwK1sKsNBSopKVw2vyX3tBEFnXbKIISWMORsJW4L
IOxa+y6OYfAfltw=
=S+7J
-----END PGP PUBLIC KEY BLOCK-----
```

## Donations
Donations to support projects under https://git.arrr.cloud/WhichDoc are welcome with Monero (XMR) and Pirate Chain (ARRR) in the spirit of anti-forensics.
- Pirate Chain (ARRR): `zs1wjw05nmfc0x8l0wd75ug0xj8q9fjta4ch0kak0ulnvnt2y8j3hevq0q8f62ma62kk5pd6z4h8zr`
- Monero (XMR): `47w2kanKMnzFkRGnSvbYjjPYac9TAsAm2GzmPBprdqM41zVXHSgkkSmVJMrY6o1qoYLdVJabcBupnJbABMxu4ejrMArAEue`


## References
[^1]: The Palantir apology - https://www.forbes.com/sites/andygreenberg/2011/02/11/palantir-apologizes-for-wikileaks-attack-proposal-cuts-ties-with-hbgary/
[^2]: Social Media Ban - https://www.newsweek.com/trump-has-now-been-suspended-four-six-most-popular-social-media-platforms-1559830
[^3]: NSO targets journalists - https://threatpost.com/apple-emergency-fix-nso-zero-click-zero-day/169416/
[^4]: Purism technical writeup for IME - https://puri.sm/posts/deep-dive-into-intel-me-disablement/
[^5]: Tool for partial deblob of Intel ME/TXE firmware images - https://github.com/corna/me_cleaner
[^6]: Coreboot - https://www.coreboot.org
[^7]: AMD PSP Vulnerability - https://hackaday.com/2021/10/01/flaw-in-amd-platform-security-processor-affects-millions-of-computers/
[^8]: Site detailing reasons against SystemD usage - https://nosystemd.org/
[^9]: Artix Linux - https://artixlinux.org
[^10]: Void Linux - https://voidlinux.org
[^11]: Alpine Linux - https://alpinelinux.org/
[^12]: Smartphone Data Collection - https://www.statista.com/chart/15207/smartphone-data-collection-by-google-and-apple/
[^13]: GrapheneOS - https://grapheneos.org
[^14]: Pine64 Pinephone - https://www.pine64.org/pinephone/
[^15]: Purism Librem 5 - https://puri.sm/products/librem-5/
[^16]: Cover your track on UNIX systems - https://github.com/sundowndev/covermyass
[^17]: Bleachbit software - https://www.bleachbit.org/
[^18]: Sysinternals - https://docs.microsoft.com/en-us/sysinternals/
[^19]: OSI Model - https://en.wikipedia.org/wiki/OSI_model
[^20]: ProtonVPN threat model - https://proton.me/blog/threat-model/
[^21]: Whonix VPN leakage - https://www.whonix.org/wiki/Tunnels/Connecting_to_Tor_before_a_VPN
[^22]: Tails VPN article - https://gitlab.tails.boum.org/tails/blueprints/-/wikis/vpn_support
[^23]: I2P - https://geti2p.net/en/
[^24]: URLScan of anom[.]io - https://urlscan.io/result/f7b4c5ae-3864-4b3f-be0e-ad10e39276bc/#summary
[^25]: Orbot - https://guardianproject.info/apps/org.torproject.android/
[^26]: Whonix leak protection - https://www.whonix.org/wiki/Protocol-Leak-Protection_and_Fingerprinting-Protection
[^27]: Ungoogled Chromium binaries - https://ungoogled-software.github.io/ungoogled-chromium-binaries/
[^28]: Bromite Browser - https://www.bromite.org
[^29]: Brave Browser - https://brave.com
[^30]: The Hitchhikers Guide to Online Anonymity (Browser Hardening) - https://anonymousplanet-ng.org/guide.html#appendix-v1-hardening-your-browsers
[^31]: DuckDuckGo - https://duckduckgo.com
[^32]: Searx instances - https://searx.space/
[^33]: TAILS - https://tails.boum.org
[^34]: Drive Destruction - https://anonymousplanet-ng.org/guide.html#how-to-securely-wipe-your-whole-laptopdrives-if-you-want-to-erase-everything
[^35]: Singh, S. (2000). The Code Book: The Secret History of Codes and Code-Breaking - https://3lib.net/dl/1314297/2c09dd
[^36]: Linux Entropy - https://madaidans-insecurities.github.io/guides/linux-hardening.html#entropy
[^37]: GNU Privacy Assistant - https://gnupg.org/related_software/gpa/
[^38]: Minisign - https://github.com/jedisct1/minisign/
[^39]: Veracrypt - https://www.veracrypt.fr/code/VeraCrypt/
[^40]: KeepassXC - https://keepassxc.org
[^41]: USB dead man's switch - https://tech.michaelaltfield.net/2020/01/02/buskill-laptop-kill-cord-dead-man-switch/
[^42]: USBKill - https://github.com/hephaest0s/usbkill/blob/master/usbkill/usbkill.py
[^43]: Silk Guardian - https://github.com/NateBrune/silk-guardian
[^44]: Centry Panic Button - https://github.com/AnonymousPlanet/Centry
[^45]: USBCTL - https://github.com/anthraxx/usbctl
[^46]: Elcomsoft Forensics - https://blog.elcomsoft.com/2020/03/breaking-veracrypt-containers/
[^47]: Jumping Airgaps - https://arxiv.org/pdf/2012.06884.pdf
[^48]: Geofence Requests - https://assets.documentcloud.org/documents/6747427/2.pdf
[^49]: Jung, C. G. (1955). Modern Man in Search of a Soul - https://p302.zlibcdn.com/dtoken/aeb0b1ef15cc3ecac1f6febcf966248a
[^50]: Kinsing Crypto-Miner - https://blog.aquasec.com/threat-alert-kinsing-malware-container-vulnerability
[^51]: CipherTrace - https://ciphertrace.com/ciphertrace-announces-worlds-first-monero-tracing-capabilities/
[^52]: ZkSnarks - https://z.cash/technology/zksnarks
[^53]: Monero Whitepaper - https://www.getmonero.org/resources/research-lab/pubs/whitepaper_annotated.pdf
[^54]: Pirate Chain Whitepaper - https://pirate.black/files/whitepaper/The_Pirate_Code_V2.0.pdf
[^55]: CIS - https://www.cisecurity.org
[^56]: DISA STIGs - https://public.cyber.mil/stigs
[^57]: KSPP - https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings
[^58]: Whonix Host - https://www.whonix.org/wiki/Whonix-Host
[^59]: PlagueOS- https://0xacab.org/whichdoc/plagueos
[^60]: BubbleWrap Sandbox - https://github.com/containers/bubblewrap
[^61]: SalamanderSecurity's PARSEC repository - https://codeberg.org/SalamanderSecurity/PARSEC
[^62]: Linux Hardening -  https://madaidans-insecurities.github.io/guides/linux-hardening.html
[^63]: FOIA request for Palantir operations - https://www.documentcloud.org/search/projectid:51061-Palantir-September-2020
[^64]: HiddenVM - https://github.com/aforensics/HiddenVM
[^65]: KVM - https://www.linux-kvm.org/
[^66]: Oracle VirtualBox -  https://virtualbox.org
[^67]: Briar P2P Messenger - https://briarproject.org
