     Android | Madaidan's Insecurities 🌓

Android
=======

_Last edited: March 11th, 2022_

By default, Android has a [strong security model](https://arxiv.org/abs/1904.05572) and incorporates [full system SELinux policies](https://source.android.com/security/selinux/), [strong app sandboxing](https://source.android.com/security/app-sandbox), [full verified boot](https://source.android.com/security/verifiedboot), modern exploit mitigations like [fine-grained, forward-edge Control Flow Integrity](https://source.android.com/devices/tech/debug/cfi) and [ShadowCallStack](https://source.android.com/devices/tech/debug/shadow-call-stack), widespread use of memory-safe languages (Java / Kotlin) and more. As such, this article explains common ways in which people worsen the security model rather than criticisms of the security model itself.

[Unlocking the bootloader](#unlocking-the-bootloader)
-----------------------------------------------------

Unlocking the bootloader in Android is a large security risk. It disables [verified boot](https://source.android.com/security/verifiedboot/), a fundamental part of the security model. Verified boot ensures the integrity of the base system and boot chain to prevent [evil maid attacks](https://en.wikipedia.org/wiki/Evil_maid_attack) and malware persistence.  
  
Contrary to common assumptions, verified boot is not just important for physical security — it prevents the persistence of **any** tampering with your system, be it from a physical attacker or a malicious application that has managed to hook itself into the operating system. For example, if a remote attacker has managed to exploit the system and gain high privileges, verified boot would revert their changes upon reboot and ensure that they cannot persist.

[Rooting your device](#rooting)
-------------------------------

Rooting your device allows an attacker to easily gain extremely high privileges. Android's architecture is built upon the [principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege). By default, [only around 6 processes run as the root user on a typical Android device](https://source.android.com/security/overview/implement#root-processes), and even those are still heavily constrained via the [full system SELinux policy](https://source.android.com/security/selinux). Completely unrestricted root is found nowhere in the operating system; even the init system does not have unrestricted root access. Exposing privileges far greater than any other part of the OS to the application layer is not a good idea.  
  
It does not matter if you have to whitelist apps that have root — an attacker can fake user input by, for example, [clickjacking](https://en.wikipedia.org/wiki/Clickjacking), or they can exploit vulnerabilities in apps that you have granted root to. Rooting turns huge portions of the operating system into root attack surface; vulnerabilities in the UI layer — such as in the display server, among other things — can now be abused to gain complete root access. In addition, root fundamentally breaks verified boot and other security features by placing excessive trust in persistent state. By rooting your device, you are breaking Android's security model and adding further layers of trust where it is inappropriate.  
  
A common argument for rooting is that Linux allows root, but this does not account for the fact that the average desktop Linux system does not have a security model like Android does. On the usual Linux system, [gaining root is extremely easy](linux.html#root), hence Linux hardening procedures often involve restricting access to the root account.

[Custom ROMs](#custom-roms)
---------------------------

The majority of custom ROMs severely weaken the security model by disabling verified boot, using userdebug builds, disabling SELinux and various other issues. Furthermore, you are also usually at the mercy of the maintainer to apply security updates properly. Certain ROMs often apply security patches late, or in some cases, not at all. The latter especially applies to firmware patches.

### [LineageOS](#lineageos)

A common ROM that has many of these issues is [LineageOS](https://lineageos.org/):

*   LineageOS [uses userdebug builds by default](https://github.com/LineageOS/hudson/blob/master/lineage-build-targets). This [adds many debugging features as additional attack surface](https://source.android.com/setup/build/building#choose-a-target). It also [weakens various SELinux polices](https://github.com/LineageOS/android_system_sepolicy/search?q=userdebug&type=code) and exposes root access via ADB, which, [as previously discussed](#rooting), is not a good idea.
*   LineageOS requires an unlocked bootloader, therefore disabling verified boot, [which is essential to verify the integrity of the operating system](#unlocking-the-bootloader).
*   It does not implement [rollback protection](https://source.android.com/security/verifiedboot/verified-boot#rollback-protection). This allows an attacker to downgrade the system to an older version and then exploit already patched vulnerabilities. The default updater even allows you to downgrade versions yourself.
*   Most LineageOS builds also do not include firmware updates, which prevents users from getting new patches to fix vulnerabilities. Instead, it gives a pop-up advising users to flash updates manually that most people will simply ignore.

This is a non-exhaustive list. There are more issues than just those listed above. LineageOS (and most other custom ROMs) are focused on customising the device and not privacy or security. Of course, you could build LineageOS yourself to fix many of these issues, but most users will not be capable of doing so.

[MicroG / Signature Spoofing](#microg-signature-spoofing)
---------------------------------------------------------

[MicroG](https://microg.org/) is a common alternative to Google Play Services. It is often used to get rid of Google's tracking, but most people do not realise that this can potentially worsen security, as [it requires signature spoofing support](https://github.com/microg/android_packages_apps_GmsCore/wiki/Signature-Spoofing), which allows apps to request to bypass signature verification. This subverts the security model and breaks the application sandbox as an app can now masquerade itself as another app to gain access to the app's files. In a system with signature spoofing, it is impossible to know anything — there is no way to trust that an application is genuinely what it claims to be, and it is impossible to build a strong security model upon this.  
  
Although some signature spoofing implementations can restrict access to this functionality to reduce the risk by, for example, allowing only microG to spoof the Play Services signature and nothing else.

[Firewalls](#firewalls)
-----------------------

Firewalls, such as [AFWall+](https://github.com/ukanth/afwall/) or [Netguard](https://www.netguard.me/), are regularly used on Android to attempt blocking network access from a specific app, but these do not reliably work — apps can use IPC to bypass such restrictions. If you cut off network access to an app, it will not prevent the app from sending an [intent](https://developer.android.com/reference/android/content/Intent) to another app (such as the browser) for it to make the same connection. Many apps already do this unintentionally whilst using APIs such as the [download manager](https://developer.android.com/reference/android/app/DownloadManager).  
  
The most effective way to block network access is to revoke the `INTERNET` permission from the app like [GrapheneOS allows you to do](https://github.com/GrapheneOS/platform_frameworks_base/commit/5e2898e9d21dd6802bb0b0139e7e496c41e1cd80). This prevents abusing OS APIs to initiate network connections, as they contain checks for that permission, one example of which is the aforementioned download manager. You should also run the app in its own user or work profile to ensure that it cannot abuse third party apps either.

[Conclusion](#conclusion)
-------------------------

The best option for privacy and security on Android is to get a Pixel 4 or greater and flash [GrapheneOS](https://grapheneos.org/). GrapheneOS does not contain any tracking unlike the stock OS on most devices. Additionally, GrapheneOS retains the baseline security model whilst improving upon it with [substantial hardening enhancements](https://grapheneos.org/features) — examples of which include a [hardened memory allocator](https://github.com/GrapheneOS/hardened_malloc), [hardened C library](https://github.com/GrapheneOS/platform_bionic), [hardened kernel](https://github.com/GrapheneOS/kernel_google_raviole), [stricter SELinux policies](https://github.com/GrapheneOS/platform_system_sepolicy) and more.  
  
Pixel devices are also the best hardware to use, as they implement a significant amount of security hardening that most other devices lack. Examples of this include:

*   [Full verified boot](https://source.android.com/security/verifiedboot/) with [support for custom signing keys](https://android.googlesource.com/platform/external/avb/+/master/README.md#pixel-2-and-later) — certain Android OEMs often fail to implement verified boot properly, or at the very least, neglect to include support for custom keys to be able to flash an alternative operating system without having to lose verified boot. On Pixels, verified boot is implemented securely, and alternative operating systems are often signed with custom keys to keep the security model intact.
*   [The Titan M chip](https://www.blog.google/products/pixel/titan-m-makes-pixel-3-our-most-secure-phone-yet/) — the Titan M is a tamper-resistant hardware security module that provides a number of security properties. It can securely store cryptographic material using the [StrongBox keystore](https://developer.android.com/training/articles/keystore#HardwareSecurityModule) and enforces throttling upon repeated failed login attempts to mitigate bruteforcing attacks. Furthermore, it is integrated into the verified boot process, and due to its [tamper-resistant nature](https://android-developers.googleblog.com/2018/10/building-titan-better-security-through.html), it is [extremely difficult](https://www.google.com/about/appsecurity/android-rewards/) to extract data from the chip or bypass its security features; if any abnormal conditions are detected, such as unnatural changes in temperature, the Titan M will erase all data stored within it, thereby categorically mitigating most side-channel attacks. Even if an attacker gained access to Google's signing keys for the Titan M firmware, they would not be able to flash their own malicious firmware due to [insider attack resistance](https://android-developers.googleblog.com/2018/05/insider-attack-resistance.html), which prevents updating firmware until the valid lockscreen passcode is entered.
*   [Fine-grained, forward-edge kernel Control Flow Integrity](https://android-developers.googleblog.com/2018/10/control-flow-integrity-in-android-kernel.html) (CFI) and [ShadowCallStack](https://security.googleblog.com/2019/10/protecting-against-code-reuse-in-linux_30.html) — the Pixel kernels are compiled with custom hardening patches, which includes [CFI and ShadowCallStack](linux.html#cfi) to mitigate code reuse attacks, among various other mitigations. While such mitigations are commonly deployed throughout user space, as briefly mentioned at the beginning of the article, it is up to the OEM to enable it in the kernel, which is uncommon outside of Pixel devices.
*   Wi-Fi privacy features — devices connected to a Wi-Fi network can be tracked through a variety of different methods. Primarily, this occurs through [MAC addresses](https://en.wikipedia.org/wiki/MAC_address), which are unique identifiers assigned to network interface controllers (NICs). Every time a device connects to a network, its MAC address is exposed. This enables adversaries to track the device and uniquely identify it on the local network. Certain mobile devices have attempted to resolve this issue by randomising the MAC address. However, [many don't do this, and the ones that do often use a faulty implementation](https://arxiv.org/pdf/1703.02874.pdf), resulting in the MAC address still being leaked. Furthermore, other Wi-Fi identifiers exist that can further enable fingerprinting or even be used to infer the MAC address, including [information elements in probe requests and predictable sequence numbers](https://papers.mathyvanhoef.com/asiaccs2016.pdf). In comparison, [Pixels use an effective implementation of MAC address randomisation, minimal probe requests and randomised initial sequence numbers](https://android-developers.googleblog.com/2017/04/changes-to-device-identifiers-in.html).

Remember that GrapheneOS cannot prevent you from ruining your privacy yourself. You still have to be careful regardless of the operating system.

[Go back](/index.html)