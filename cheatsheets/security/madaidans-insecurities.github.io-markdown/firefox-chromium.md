     Firefox and Chromium | Madaidan's Insecurities 🌓

Firefox and Chromium
====================

_Last edited: March 19th, 2022_

Firefox is sometimes recommended as a supposedly more secure browser because of its parent company's privacy practices. This article explains why this notion is not true and enumerates a number of security weaknesses in Firefox's security model when compared to Chromium. In particular, it covers the less granular process model, weaker sandboxing and lack of modern exploit mitigations. It is important to decouple privacy from security — this article does not attempt to compare the privacy practices of each browser but rather their resistance to exploitation.  
  
Section 1 explains the weaker process model and sandboxing architecture. Section 2 examines and compares a number of important exploit mitigations. Section 3 discusses some miscellaneous topics. Finally, section 4 provides links to what other security researchers have said about this topic.

Contents
--------

[1\. Sandboxing](#sandboxing) [1.1 Site Isolation](#site-isolation)  
[1.2 Windows](#windows-sandbox) [1.3 Linux](#linux-sandbox) [1.3.1 Linux Sandbox Escapes](#linux-sandbox-escapes)  
[1.3.2 seccomp-bpf](#seccomp-bpf) [1.4 Android](#android-sandbox)  
[1.5 Missing Processes](#missing-processes) [2\. Exploit Mitigations](#exploit-mitigations) [2.1 Arbitrary Code Guard and Code Integrity Guard](#acg-cig)  
[2.2 Control Flow Integrity](#cfi) [2.2.1 Forward-edge CFI](#forward-edge-cfi)  
[2.2.2 Backward-edge CFI](#backward-edge-cfi)  
[2.3 Untrusted Fonts Blocking](#untrusted-fonts-blocking)  
[2.4 JIT Hardening](#jit-hardening)  
[2.5 Memory Allocator Hardening](#memory-allocator-hardening) [2.5.1 Memory Partitioning](#memory-partitioning)  
[2.5.2 Out-of-line Metadata](#out-of-line-metadata)  
[2.5.3 Other](#partitionalloc-other)  
[2.6 Automatic Variable Initialisation](#auto-var-init)  
[3\. Miscellaneous](#miscellaneous)  
[4\. Other Security Researchers' Views on Firefox](#security-researcher-views)

[1\. Sandboxing](#sandboxing)
-----------------------------

Sandboxing is a technique used to isolate certain programs to prevent a vulnerability in them from compromising the rest of the system by restricting access to unnecessary resources. All common browsers nowadays include a sandbox and utilise a multi-process architecture. The browser splits itself up into different processes (e.g. the content process, GPU process, RDD process, etc.) and sandboxes them individually, strictly adhering to the [principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege). It is very important that a browser uses a sandbox, as it processes untrusted input by design, poses enormous attack surface and is one of the most used applications on the system. Without a sandbox, any exploit in the browser can be used to take over the rest of the system. Whereas with a sandbox, the attacker would need to chain their exploit with an additional sandbox escape vulnerability.  
  
However, sandboxes are not black and white. Just having a sandbox doesn't do much if it's full of holes. [Firefox's sandbox](https://wiki.mozilla.org/Security/Sandbox) is quite weak for the reasons documented below. Note that this is a non-exhaustive list, and the issues below are only a few examples of such weaknesses.

### [1.1 Site Isolation](#site-isolation)

[Site isolation](https://www.chromium.org/Home/chromium-security/site-isolation) is a security feature which was [introduced in Chromium in 2018](https://security.googleblog.com/2018/07/mitigating-spectre-with-site-isolation.html). This involved an overhaul in Chromium's multi-process architecture — rather than all websites running within the same process, this feature now separated each website into its own sandboxed renderer process. [This ensures that a renderer exploit from one website still cannot access the data from another](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/security/compromised-renderers.md). In addition, [site isolation is necessary for complete protection against side-channel attacks like Spectre](https://www.usenix.org/conference/usenixsecurity19/presentation/reis). Operating system mitigations against such attacks only guarantee isolation at the process boundary; therefore, separating websites into different processes is the only way to fully make use of them. Furthermore, current browser mitigations, such as [reducing JavaScript timer accuracy](https://developers.google.com/web/updates/2018/02/meltdown-spectre#high-resolution_timers), are insufficient and do not address the root issue. As such, [the only proper mitigation is through site isolation](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/security/side-channel-threat-model.md).  
  
Firefox fully rolled out their Fission project in [Firefox 95](https://www.mozilla.org/en-US/firefox/95.0/releasenotes/). However, Fission in its current state is not as mature as Chromium's site isolation, and it will take many more years for it to reach that point. Fission still suffers from all the security issues of the baseline content process sandbox, as documented below, and it is not a panacea for all sandboxing issues. However, more specific to Fission itself, there are [numerous](https://bugzilla.mozilla.org/show_bug.cgi?id=1505832) [cross-site](https://bugzilla.mozilla.org/show_bug.cgi?id=1484019) [leaks](https://bugzilla.mozilla.org/show_bug.cgi?id=1707955), allowing a compromised content process to access the data of another and bypass site isolation.

### [1.2 Windows](#windows-sandbox)

Excluding the issue of site isolation, only the Firefox sandbox on Windows is even comparable to the [Chromium sandbox](https://chromium.googlesource.com/chromium/src/+/master/docs/design/sandbox.md); however, [it still lacks](https://bugzilla.mozilla.org/buglist.cgi?quicksearch=win32k) [win32k lockdown](https://chromium.googlesource.com/chromium/src/+/master/docs/design/sandbox.md#win32k_sys-lockdown). Win32k is a set of dangerous system calls in the NT kernel that expose a lot of attack surface and [has historically been the result of numerous vulnerabilities](https://github.com/microsoft/MSRC-Security-Research/blob/master/presentations/2018_10_DerbyCon/2018_10_DerbyCon_State_of%20_Win32k_Security.pdf), making it a frequent target for sandbox escapes. Microsoft aimed to lessen this risk by introducing a feature that [allows a process to block access to these syscalls](https://docs.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-process_mitigation_system_call_disable_policy), therefore massively reducing attack surface. [Chromium implemented this feature in 2016](https://googleprojectzero.blogspot.com/2016/11/breaking-chain.html) to strengthen the sandbox, but Firefox has yet to follow suit — [Firefox currently only enables this in the socket process](https://searchfox.org/mozilla-central/rev/a5bf5d0720f9454687f500513ac82b0c8abce5a4/modules/libpref/init/StaticPrefList.yaml#10133) ([which isn't enabled yet](#missing-processes)).

### [1.3 Linux](#linux-sandbox)

#### [1.3.1 Sandbox Escapes](#linux-sandbox-escapes)

Firefox's sandboxing on other platforms, such as Linux, is significantly worse. The restrictions are generally quite permissive, and it is even susceptible to various trivial sandbox escape vulnerabilities that span back years, as well as exposing sizable attack surface from within the sandbox.

*   One example of such sandbox escape flaws is X11 — [X11 doesn't implement any GUI isolation](https://theinvisiblethings.blogspot.com/2011/04/linux-security-circus-on-gui-isolation.html), which makes it [very easy to escape sandboxes with it](https://mjg59.dreamwidth.org/42320.html). Chromium resolves this issue by only permitting access to X11 from within the GPU process so that the renderer process (the process in which websites are loaded) cannot access it, whereas on Firefox, [it is exposed directly to the content process](https://bugzilla.mozilla.org/show_bug.cgi?id=1129492).
*   [PulseAudio](https://www.freedesktop.org/wiki/Software/PulseAudio/) is a common sound server on Linux. However, [it was not written with isolation in mind](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/Developer/AccessControl/), making it possible to escape sandboxes with it. Like X11, [Firefox exposes this directly to the content process](https://searchfox.org/mozilla-central/search?q=pulseaudio&path=security%2Fsandbox%2Flinux), permitting another trivial sandbox escape, while [Chromium only exposes it to a dedicated audio service](https://github.com/chromium/chromium/blob/master/services/audio/audio_sandbox_hook_linux.cc).

#### [1.3.2 seccomp-bpf](#seccomp-bpf)

[seccomp-bpf](https://www.kernel.org/doc/html/latest/userspace-api/seccomp_filter.html) is a sandboxing technology on Linux that allows one to restrict the syscalls accessible by a process, which can greatly reduce kernel attack surface and is a core part of most Linux sandboxes. However, Firefox's seccomp filter is substantially less restrictive than the one imposed by Chromium's sandbox and does not restrict anywhere near the same amount of syscalls and their arguments. One example of this is that [there is very little filtering of ioctl calls](https://bugzilla.mozilla.org/show_bug.cgi?id=1302711) — [only TTY-related ioctls are blocked in the content process](https://searchfox.org/mozilla-central/rev/9ae77e4ce3378bd683ac9a86b729ea6b6bd22cb8/security/sandbox/linux/SandboxFilter.cpp#1291). This is problematic because ioctl is a particularly powerful syscall that presents a massive kernel attack surface, as it comprises of hundreds of different syscalls, somewhat similar to NT's Win32k. Unlike Firefox, [Chromium permits only the few ioctls that are necessary in its sandbox](https://github.com/chromium/chromium/search?q=path%3A%2Fsandbox+RestrictIoctl), which reduces kernel attack surface by a considerable amount. In a similar fashion, [Android implemented ioctl filtering in its application sandbox](https://kernsec.org/files/lss2015/vanderstoep.pdf) for the same reasons, alongside various other projects with a focus on sandboxing.

### [1.4 Android](#android-sandbox)

On Android, [Firefox has implemented a multi-process architecture since 2021](https://bugzilla.mozilla.org/show_bug.cgi?id=1530770); however, this is still severely limited, and [no sandboxing is enabled](https://bugzilla.mozilla.org/show_bug.cgi?id=1565196). Whereas Chromium uses the [`isolatedProcess` feature](https://developer.android.com/guide/topics/manifest/service-element#isolated), along with [a more restrictive seccomp-bpf filter](https://github.com/chromium/chromium/blob/master/sandbox/linux/seccomp-bpf-helpers/baseline_policy_android.cc).

### [1.5 Missing Processes](#missing-processes)

In general, Chromium's multi-process architecture is significantly more mature and granular than that of Firefox, allowing it to impose tighter restrictions upon each part of the browser. Examples of processes that are missing from Firefox are listed below. On Firefox, such functionality will be merged into another process, such as the parent or content process, making it considerably harder to enforce strong restrictions.

*   On Linux, [Firefox has no separate GPU process](https://bugzilla.mozilla.org/show_bug.cgi?id=1653444), meaning it cannot be independently sandboxed. [This process exists on Windows](https://wiki.mozilla.org/Security/Sandbox/Process_model#GPU_Process), although [the sandboxing for it is still not enabled](https://bugzilla.mozilla.org/show_bug.cgi?id=1347710).
*   [Firefox does not yet have a separate socket process for network operations](https://bugzilla.mozilla.org/show_bug.cgi?id=1322426) — this process [only exists in Nightly and doesn't include anything other than WebRTC code](https://wiki.mozilla.org/Security/Sandbox#Socket_Process), unlike [Chromium's dedicated network service](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/services/network/README.md).
*   Firefox also does not have an audio process, whereas [Chromium has a dedicated audio service](https://docs.google.com/document/d/1s_Fd1WRDdpb5n6C2MSJjeC3fis6hULZwfKMeDd4K5tI/). The lack of such a process in Firefox means that audio functionality is merged into the content process, which is the cause of the [PulseAudio sandbox escape vector on Linux systems](#linux-sandbox-escapes).
*   Further examples include text-to-speech, printing backend and compositor, speech recognition, proxy resolver and [more](https://github.com/chromium/chromium/blob/master/sandbox/policy/sandbox_type.cc).

Later in this article, tables are presented which directly compare some of the mitigations used in Chromium processes to their Firefox equivalents. However, they do not list every single process because they would become huge and Firefox would only have a small fraction of processes to be compared with. Instead, only a subset of particularly important processes are included.

[2\. Exploit Mitigations](#exploit-mitigations)
-----------------------------------------------

Exploit mitigations eliminate entire classes of common vulnerabilities / exploit techniques to prevent or severely hinder exploitation. Firefox lacks many important mitigations, while Chromium generally excels in this area.  
  
As with the sandboxing, there are many more issues than the ones listed below, but this article does not attempt to be an exhaustive list. Readers can look through [Mozilla's own bug tracker](https://bugzilla.mozilla.org/home) for further examples.

### [2.1 Arbitrary Code Guard and Code Integrity Guard](#acg-cig)

A very common exploit technique is that during exploitation of a [buffer overflow](https://en.wikipedia.org/wiki/Buffer_overflow) vulnerability, an attacker injects their own malicious code (known as [shellcode](https://en.wikipedia.org/wiki/Shellcode)) into a part of memory and causes the program to execute it by overwriting critical data, such as [return addresses](https://en.wikipedia.org/wiki/Return_statement) and [function pointers](https://en.wikipedia.org/wiki/Function_pointer), to hijack the control flow and point to the aforementioned shellcode, thereby gaining control over the program.  
  
The industry eventually evolved to mitigate this style of attacks by [marking writable areas of memory as non-executable](https://en.wikipedia.org/wiki/Executable_space_protection) and executable areas as non-writable, preventing an attacker from injecting and executing their shellcode. However, an attacker can bypass this by reusing bits of code already present within the program (known as gadgets) outside of the order in which they were originally intended to be used. An attacker can form a chain of such gadgets to achieve near-arbitrary code execution despite the aforementioned protections, utilising techniques such as [Return-Oriented Programming](https://en.wikipedia.org/wiki/Return-oriented_programming) (ROP) or [Jump-Oriented Programming](https://www.csc2.ncsu.edu/faculty/xjiang4/pubs/ASIACCS11.pdf) (JOP).  
  
Attackers often inject their shellcode into writable memory pages and then use these code reuse techniques to transition memory pages to executable (using syscalls such as `mprotect` or `VirtualAlloc`), consequently allowing it to be executed. [Windows 10 implemented a mitigation](https://blogs.windows.com/msedgedev/2017/02/23/mitigating-arbitrary-native-code-execution/) known as [Arbitrary Code Guard](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exploit-protection-reference?view=o365-worldwide#arbitrary-code-guard) (ACG), which mitigates this by ensuring that all executable memory pages are immutable and can never be made writable.  
  
Another mitigation known as [Code Integrity Guard](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exploit-protection-reference?view=o365-worldwide#code-integrity-guard) (CIG) is similar to ACG, but it applies to the filesystem instead of memory, ensuring that an attacker cannot execute a malicious program or library on disk by guaranteeing that all binaries loaded into a process must be signed. Together, ACG and CIG enforce a strict W^X policy in both memory and the filesystem.  
  
In 2017, [Chromium implemented support for ACG and CIG](https://github.com/chromium/chromium/commit/21a5ba4cfdbafc3b0908f9af75c0de30b03d47ec) as `MITIGATION_DYNAMIC_CODE_DISABLE` and `MITIGATION_FORCE_MS_SIGNED_BINS`, but Firefox has yet to implement comparable support for either [ACG](https://bugzilla.mozilla.org/show_bug.cgi?id=1381050) or [CIG](https://bugzilla.mozilla.org/show_bug.cgi?id=1378417). Currently, [Firefox only enables ACG and CIG in the socket process](https://searchfox.org/mozilla-central/rev/a5bf5d0720f9454687f500513ac82b0c8abce5a4/security/sandbox/win/src/sandboxbroker/sandboxBroker.cpp#1146) ([which isn't enabled yet](#missing-processes)) and [CIG in the RDD process](https://bugzilla.mozilla.org/show_bug.cgi?id=1620114).  
  
However, Chromium's application of ACG is still currently limited due to the inherent incompatibility with JIT engines, which dynamically generate code ([JIT is explained in further detail below](#jit-hardening)). [ACG is primarily enabled in relatively minor processes](https://github.com/chromium/chromium/search?q=MITIGATION_DYNAMIC_CODE_DISABLE), such as the proxy resolver and icon reader processes; however, some notable ones, such as the audio process, also have it enabled. Additionally, if V8's [JITless mode](https://v8.dev/blog/jitless) is enabled, then Chromium also [enables ACG in the renderer process](https://github.com/chromium/chromium/commit/9475a21dd27b4a487f410e62a167ff86b4d35287); Firefox does not enable ACG in the renderer regardless of JIT.

ACG

Chromium

Firefox

Renderer/Content

 N\*

N

GPU

N

N

RDD

N

N

Extensions

N

N

Network/Socket

 N\*

[N/A](#missing-processes)

Audio

Y

[N/A](#missing-processes)

\* [Chromium enables ACG in the renderer process when running in JITless mode](https://github.com/chromium/chromium/commit/9475a21dd27b4a487f410e62a167ff86b4d35287).  
\* [Chromium enables ACG in the network process if the `NetworkServiceSandbox` feature is enabled.](https://github.com/chromium/chromium/blob/fd8a8914ca0183f0add65ae55f04e287543c7d4a/sandbox/policy/win/sandbox_win.cc#L1084)

CIG

Chromium

Firefox

Renderer/Content

Y

N

GPU

Y

N

RDD

Y

Y

Extensions

Y

N

Network/Socket

 N\*

[N/A](#missing-processes)

Audio

Y

[N/A](#missing-processes)

\* [Chromium can optionally enable CIG in the network process if the `NetworkServiceCodeIntegrity` feature is enabled](https://github.com/chromium/chromium/commit/3249aa3c8dce41fdbcf3093bdd08a1793113c0fd).

### [2.2 Control Flow Integrity](#cfi)

As briefly mentioned before, code reuse attacks can be used to achieve near-arbitrary code execution by chaining together snippets of code that already exist in the program. ACG and CIG only mitigate one potential attack vector — creating a ROP/JOP chain to transition mappings to executable. However, an attacker can still use a pure ROP/JOP chain, relying wholly on the pre-existing gadgets without needing to introduce their own code. This can be mitigated with [Control Flow Integrity](https://blog.trailofbits.com/2016/10/17/lets-talk-about-cfi-clang-edition/) (CFI), which severely restricts the gadgets an attacker is able to make use of, thus disrupting their chain.  
  
CFI usually has 2 parts: forward-edge protection (covering JOP, COP, etc.) and backward-edge protection (covering ROP). CFI implementations can vary significantly. Some CFI implementations only cover either forward-edges or backward-edges. Some are coarse-grained (the attacker has more freeway to execute a larger amount of gadgets) rather than fine-grained. Some are probabilistic (they rely on a secret being held and the security properties are not guaranteed) rather than deterministic.

#### [2.2.1 Forward-edge CFI](#forward-edge-cfi)

On Linux, Android and ChromeOS, [Chromium enables Clang's fine-grained, forward-edge CFI](https://www.chromium.org/developers/testing/control-flow-integrity). On Windows, it [enables the weaker, coarse-grained, forward-edge Control Flow Guard](https://chromium.googlesource.com/chromium/src/+/master/docs/design/sandbox.md#Process-mitigation-policies) (CFG), although [Chromium has been investigating deploying Clang CFI on Windows](https://bugs.chromium.org/p/chromium/issues/detail?id=507755).  
  
Mozilla has been [planning to implement forward-edge CFI for a while](https://bugzilla.mozilla.org/show_bug.cgi?id=510629) but has yet to make significant progress. [Firefox only enables CFG on Windows](https://bugzilla.mozilla.org/show_bug.cgi?id=1438868); this is not as effective as Clang's CFI because it is coarse-grained rather than fine-grained, and this does not apply to other platforms, which are currently devoid of any protection.

#### [2.2.2 Backward-edge CFI](#backward-edge-cfi)

As for backward-edge protection, in 2021, [Chrome implemented shadow stacks using Intel's Control-flow Enforcement Technology (CET)](https://security.googleblog.com/2021/05/enabling-hardware-enforced-stack.html). [Shadow stacks](https://en.wikipedia.org/wiki/Shadow_stack) protect a program's return address by replicating it in a different, hidden stack. The return addresses in the main stack and the shadow stack are then compared in the function epilogue to see if either differ. If so, this would indicate an attack and the program will abort, therefore mitigating ROP attacks. [Chromium automatically enables this for all processes](https://github.com/chromium/chromium/blob/12c232c43ce7324d308afab5349b38b7707d8226/content/public/common/sandboxed_process_launcher_delegate.cc#L38) with a flag to opt out of it on a case-by-case basis. The only notable process that does opt out of CET is the renderer process. However, [CET is enabled in the renderer when V8 is running in JITless mode](https://github.com/chromium/chromium/blob/12c232c43ce7324d308afab5349b38b7707d8226/content/browser/renderer_host/renderer_sandboxed_process_launcher_delegate.cc#L107), similar to ACG, as mentioned above.  
  
Stable releases of Firefox currently lack any backward-edge protection. [CET support has only been implemented in Firefox Nightly](https://bugzilla.mozilla.org/show_bug.cgi?id=1626950), but [this still has incomplete coverage](https://searchfox.org/mozilla-central/rev/c3894603d85d2e45dbebf9697f1951ab998b22cb/modules/libpref/init/StaticPrefList.yaml#11673), and there is no protection for the renderer/content process regardless of the JIT engine's status.

### [2.3 Untrusted Fonts Blocking](#untrusted-fonts-blocking)

Untrusted fonts have historically been a common source of vulnerabilities within Windows. As such, Windows includes a mitigation to [block untrusted fonts from specific processes to reduce attack surface](https://docs.microsoft.com/en-us/troubleshoot/windows-client/shell-experience/feature-to-block-untrusted-fonts). [Chromium added support for this in 2016](https://github.com/chromium/chromium/commit/441d852dbcb7b9b31328393c7e31562b1e268399) in the form of `MITIGATION_NONSYSTEM_FONT_DISABLE` and enabled it for most child processes; however, [Firefox has yet to enable this in any](https://bugzilla.mozilla.org/show_bug.cgi?id=1689128).

Untrusted Font Blocking

Chromium

Firefox

Renderer/Content

Y

N

GPU

Y

N

RDD

Y

N

Extensions

Y

N

Network/Socket

N

[N/A](#missing-processes)

Audio

Y

[N/A](#missing-processes)

### [2.4 JIT Hardening](#jit-hardening)

All mainstream browsers include a [JIT compiler](https://en.wikipedia.org/wiki/Just-in-time_compilation) to improve performance. This involves dynamically compiling and executing JavaScript as native code; however, there is an inherent security hole in JIT, and that is the possibility of an attacker injecting arbitrary code as a result of JIT being an innate [W^X](https://en.wikipedia.org/wiki/W%5EX) violation, [as discussed above](#acg-cig). In an attempt to lessen the security risks posed by this feature without sacrificing the performance gains, [browsers have adopted JIT hardening techniques](https://www.ndss-symposium.org/wp-content/uploads/2017/09/ndss2017_10-4_Lian_paper.pdf) to make exploiting the JIT compiler more difficult. [In a study on attacking JIT compilers published by Chris Rohlf](https://github.com/struct/research/blob/master/Attacking_Clientside_JIT_Compilers_Paper.pdf), the hardening techniques implemented in various JIT engines were analysed and compared. This study demonstrated that the JIT engine used in Chromium ([V8](https://v8.dev/)) applies substantially better protections than the engine used in Firefox ([JaegerMonkey](https://wiki.mozilla.org/JaegerMonkey)). In particular, the mitigations which Chromium implemented that Firefox did not use include:

*   Guard pages.
*   Page randomization.
*   Constant blinding.
*   Allocation restrictions.
*   NOP insertions.
*   Random code base offset.

Since the publication of the paper, [Firefox has made limited progress on adopting these techniques](https://bugzilla.mozilla.org/show_bug.cgi?id=677272). Examples of lacking mitigations include [constant blinding](https://bugzilla.mozilla.org/show_bug.cgi?id=1376819) and [NOP insertion](https://bugzilla.mozilla.org/show_bug.cgi?id=729824). On the other hand, [JIT hardening mitigations are not particularly strong](https://www.usenix.org/system/files/conference/woot18/woot18-paper-gawlik.pdf) and can often be bypassed, so these may not be as consequential as other security features.  
  
Firefox did attempt to harden the JIT engine by adding a so-called ["W^X JIT"](https://jandemooij.nl/blog/wx-jit-code-enabled-in-firefox/), but this fails to hinder actual exploits, as [it is vulnerable to a race window](https://www.ndss-symposium.org/wp-content/uploads/2017/09/09_2_2.pdf) in which an attacker can write their shellcode to the memory mapping when it's writable and wait for the engine to transition it to executable. Additionally, due to the lack of CFI in Firefox, there are also many gadgets available for an attacker to force transition the mapping to executable, such as `ExecutableAllocator::makeExecutable` or `mprotect` / `VirtualAlloc` in the C library. Furthermore, [V8 has also adopted a similar, equally futile mitigation](https://github.com/v8/v8/blob/fb39eec368c1433d01ec38775be5fbdd7ba8c015/src/flags/flag-definitions.h#L1260), so even if this were useful, it's not an advantage over Chromium.  
  
Something similar to Safari's ["Bulletproof JIT"](https://googleprojectzero.blogspot.com/2020/09/jitsploitation-three.html) would have been a better approach, utilising two separate mappings — one writable and one executable, with the writable mapping being placed at a secret location in memory, concealed via execute-only memory. Similarly, [secure dynamic code generation](https://www.ndss-symposium.org/wp-content/uploads/2017/09/09_2_2.pdf) (SDCG) would also be a better approach — SDCG works by dynamically generating code inside a separate, trusted process. This means that it's not easily exploitable from within an untrusted renderer because the code is always read-only under all circumstances.  
  
[As PaX Team noted in 2015](https://archive.fo/9aBLk):  
  

\> but for this to be safe, the RW mapping should be in a separate process.  
  
note that this is a weakness in the current mprotect based method as well as there's still a nice race window for overwriting the JIT generated code. the only safe way i know of for JIT codegen is to basically fall back to what amounts to AOT codegen, i.e., a separate process (this would make it compatible with MPROTECT in PaX). there's prior art for the V8 engine btw, check out the SDCG work presented at NDSS'15: http://wenke.gtisc.gatech.edu/papers/sdcg.pdf and https://github.com/ChengyuSong/v8-sdcg .  
\[...\]  
second, since there's no control-flow integrity employed by Firefox (and it can't have one until certain bad code constructs get rewritten) those 'few code paths' you mention are abusable by redirecting control flow there (ExecutableAllocator::makeExecutable is an obvious ROP target if one's lazy to find mprotect itself in libc).  
  
as for the size of the race window, there're two problems with it: first, there're many such windows as there're a lot of users of AutoWritableJitCode (including embeddings) that execute lots of code during those windows (have you actually measured how long those windows are?). second, the window can effectively be extended to arbitrary lengths by first overwriting ExecutableAllocator::nonWritableJitCode to false.  
  
in summary, this is a half-baked security measure that is DOA.

### [2.5 Memory Allocator Hardening](#memory-allocator-hardening)

Furthermore, Firefox lacks a hardened memory allocator. Firefox currently uses [mozjemalloc](https://searchfox.org/mozilla-central/source/memory/build/mozjemalloc.cpp), which is a fork of [jemalloc](https://github.com/jemalloc/jemalloc). Jemalloc is a performance-oriented memory allocator — it does not have a focus on security, which makes it [very prone to exploitation](https://media.blackhat.com/bh-us-12/Briefings/Argyoudis/BH_US_12_Argyroudis_Exploiting_the_%20jemalloc_Memory_%20Allocator_Slides.pdf). Mozjemalloc does add on a few security features to jemalloc which are useful, but [they are not enough to fix the issues present in the overall architecture of the allocator](https://lists.torproject.org/pipermail/tor-dev/2019-August/013990.html). Chromium instead uses [PartitionAlloc](https://chromium.googlesource.com/chromium/src/+/master/base/allocator/partition_allocator/PartitionAlloc.md) (throughout the entire codebase due to [PartitionAlloc-Everywhere](https://blog.chromium.org/2021/04/efficient-and-safe-allocations-everywhere.html)), which is substantially more hardened than mozjemalloc is.  
  
In comparison to mozjemalloc, a few examples of [the security features present in PartitionAlloc](https://struct.github.io/partition_alloc.html) which do not exist in mozjemalloc are detailed below.

#### [2.5.1 Memory Partitioning](#memory-partitioning)

[Memory partitioning](https://labs.f-secure.com/archive/isolated-heap-friends-object-allocation-hardening-in-web-browsers/) is an exploit mitigation in which the memory allocator segregates different objects into their own separate, isolated heap, based on their type and size so that, for example, a heap overflow would not be able corrupt an object from another heap.  
  
Chromium's PartitionAlloc was explicitly designed with this mitigation in mind (hence the name); [strong memory partitioning with no reused memory between partitions is one of PartitionAlloc's core goals](https://chromium.googlesource.com/chromium/src/+/master/base/allocator/partition_allocator/PartitionAlloc.md#security).  
  
[Firefox's mozjemalloc also eventually implemented some support for partitioning](https://bugzilla.mozilla.org/show_bug.cgi?id=1052575). However, [memory is reused across partitions](https://bugzilla.mozilla.org/show_bug.cgi?id=1446046), thus severely weakening this feature and allowing it to be bypassed. Therefore, mozjemalloc's implementation of memory partitioning does not guarantee strong isolation to the same extent as PartitionAlloc. In fact, a real-world exploit used by the FBI to unmask users of the Tor Browser [was possible due to the lack of memory partitioning](https://twitter.com/dguido/status/803838692645335040).

#### [2.5.2 Out-of-line Metadata](#out-of-line-metadata)

[Traditional heap exploitation techniques often rely on corrupting the memory allocator metadata](https://scarybeastsecurity.blogspot.com/2017/05/further-hardening-glibc-malloc-against.html). [PartitionAlloc stores most metadata out-of-line in a dedicated region](https://chromium.googlesource.com/chromium/src/+/master/base/allocator/partition_allocator/PartitionAlloc.md#security) (with the exception of freelist pointers, although they have other protections) rather than having it adjacent to the allocations, thereby significantly increasing the difficulty of performing such techniques.  
  
Unlike PartitionAlloc, [mozjemalloc currently places heap metadata in-line with allocations](https://bugzilla.mozilla.org/show_bug.cgi?id=1446045). As such, the aforementioned techniques are still possible and allocator metadata is easier to corrupt.  
  
Moreover, PartitionAlloc also makes use of guard pages — inaccessible areas of memory that cause an error upon any attempts at accessing it — to surround the metadata, as well as various other allocations to protect them from linear overflows; [this is another security feature that mozjemalloc lacks](https://bugzilla.mozilla.org/show_bug.cgi?id=1446040).

#### [2.5.3 Other](#partitionalloc-other)

PartitionAlloc has a [naive check for double frees](https://github.com/chromium/chromium/blob/44b86c998d26d0072bc48d63b3d0f5570ee50f31/base/allocator/partition_allocator/partition_page.h#L688-L689), but [it isn't difficult to bypass](https://blog.infosectcbr.com.au/2020/05/double-frees-in-chromes-partition-alloc.html), so it's not a major feature.  
  
More importantly, PartitionAlloc is working on many promising upcoming security features, such as their [MiraclePtr and \*Scan](https://docs.google.com/presentation/d/1QvfZXx5HdUl0IdkBcrx-NM0ua-PVcTi2jNx0Sf-n8Fo/) projects to effectively mitigate most use-after-free exploits.

### [2.6 Automatic Variable Initialisation](#auto-var-init)

One of the most common classes of memory corruption vulnerabilities is [uninitialised memory](https://en.wikipedia.org/wiki/Uninitialized_variable). Clang has an option to [automatically initialise stack variables](https://reviews.llvm.org/D54604) with either zero or a specific pattern, thus mitigating this class of vulnerabilities for the stack. [Chromium enables this by default on all platforms except Android](https://chromium.googlesource.com/chromium/src.git/+/7d38bae3ef691d5091b6d4d7973a9b4d2cd85eb2/build/config/compiler/BUILD.gn#125), whereas [Firefox only enables it in debugging builds](https://bugzilla.mozilla.org/show_bug.cgi?id=1546873) for uncovering bugs and is not used in production to mitigate exploits.  
  
As for the heap, both PartitionAlloc and mozjemalloc zero-fill allocations, so they are equivalent in that regard.

[3\. Miscellaneous](#miscellaneous)
-----------------------------------

Firefox [does have some parts written in Rust, a memory safe language](https://wiki.mozilla.org/Oxidation), but the majority of the browser is still written in memory unsafe languages, and the parts that are memory safe do not include important attack surfaces, so this isn't anything substantial, and [Chromium is working on switching to memory safe languages too](https://www.chromium.org/Home/chromium-security/memory-safety).  
  
Additionally, writing parts in a memory safe language does not necessarily improve security and may even _degrade_ security by allowing for bypasses of exploit mitigations. Some security features are geared towards a particular language, and in an environment where different languages are mixed, [those features may be bypassed by abusing the other language](https://www.cs.ucy.ac.cy/~eliasathan/papers/tops20.pdf). For example, when mixing C and Rust code in the same binary with CFI enabled, the integrity of the control flow will be guaranteed in the C code, but the Rust code will remain unchanged because buffer overflows are impossible in Rust anyway. However, this allows an attacker to bypass CFI by exploiting a buffer overflow in the C code and then abusing the lack of protection in the Rust code to hijack the control flow. Mixed binaries can be secure but only if those security features are applied for all languages. Currently, [compilers generally don't support this](https://opensrcsec.com/open_source_security_announces_rust_gcc_funding), excluding [Windows' Control Flow Guard support in Clang](https://msrc-blog.microsoft.com/2020/08/17/control-flow-guard-for-clang-llvm-and-rust/).  
  
Firefox also uses [RLBox](https://hacks.mozilla.org/2020/02/securing-firefox-with-webassembly/), but [this is currently only used to sandbox five libraries](https://searchfox.org/mozilla-central/rev/e3ac5a25db15a6ec1636a1bb317b304b75a0bc95/security/rlbox/moz.build), which again, is not anything substantial and is not a replacement for a fine-grained sandboxing architecture covering the browser as a whole.

[4\. Other Security Researchers' Views on Firefox](#security-researcher-views)
------------------------------------------------------------------------------

Many security experts also share these views about Firefox, and a few examples are listed below:

*   thegrugq, information security researcher:  
    [Tor and its Discontents](https://medium.com/@thegrugq/tor-and-its-discontents-ef5164845908)
*   Kenn White, security researcher:  
    [https://twitter.com/kennwhite/status/804142071133126656](https://twitter.com/kennwhite/status/804142071133126656)
*   PaXTeam, developer of PaX:  
    [https://archive.fo/9aBLk](https://archive.fo/9aBLk)
*   Daniel Micay, lead developer of GrapheneOS:  
    [https://grapheneos.org/usage#web-browsing](https://grapheneos.org/usage#web-browsing)
*   Matthew Garrett, Linux developer:  
    [https://news.ycombinator.com/item?id=13800323](https://news.ycombinator.com/item?id=13800323)
*   Dan Guido, CEO of Trail of Bits:  
    [https://news.ycombinator.com/item?id=13623735](https://news.ycombinator.com/item?id=13623735)
*   Theo de Raadt, lead developer of OpenBsd:  
    [https://marc.info/?l=openbsd-misc&m=152872551609819&w=2](https://marc.info/?l=openbsd-misc&m=152872551609819&w=2)
*   Thomas Ptacek, co-founder of Latacora and Matasano Security:  
    [https://twitter.com/tqbf/status/930807512609296384](https://twitter.com/tqbf/status/930807512609296384),  
    [https://twitter.com/tqbf/status/930860544927649792](https://twitter.com/tqbf/status/930860544927649792),  
    [https://twitter.com/tqbf/status/830511154950766595](https://twitter.com/tqbf/status/830511154950766595)
*   qwertyoruiopz, iOS exploit developer:  
    [https://twitter.com/qwertyoruiopz/status/805887567493271556](https://twitter.com/qwertyoruiopz/status/805887567493271556),  
    [https://twitter.com/qwertyoruiopz/status/730704655748075520](https://twitter.com/qwertyoruiopz/status/730704655748075520)
*   John Wu, Android security engineer:  
    [https://twitter.com/topjohnwu/status/1105739918444253184](https://twitter.com/topjohnwu/status/1105739918444253184),  
    [https://twitter.com/topjohnwu/status/1455606288419733505](https://twitter.com/topjohnwu/status/1455606288419733505)
*   Chris Rohlf, security engineer:  
    [https://twitter.com/chrisrohlf/status/1455549993536966671](https://twitter.com/chrisrohlf/status/1455549993536966671)
*   Matthew Green, cryptographer at Johns Hopkins University:  
    [https://twitter.com/matthew\_d\_green/status/830488564672626690](https://twitter.com/matthew_d_green/status/830488564672626690)
*   Bruno Keith, security researcher at Dataflow Security:  
    [https://twitter.com/bkth\_/status/1265971734777380865](https://twitter.com/bkth_/status/1265971734777380865)
*   Niklas Baumstark, security researcher at Dataflow Security:  
    [https://twitter.com/\_niklasb/status/1131129708073107456](https://twitter.com/_niklasb/status/1131129708073107456)
*   The Tor Project investigating ways to harden the Tor Browser; in particular, they conclude that Firefox is too poorly written for them to apply PaX's Reuse Attack Protector (in comparison, [RAP can be applied to Chromium with relatively little effort](https://twitter.com/paxteam/status/730902448018231300)):  
    [https://gitlab.torproject.org/tpo/applications/tor-browser/-/wikis/Hardening](https://gitlab.torproject.org/tpo/applications/tor-browser/-/wikis/Hardening)
*   Alex Gaynor, former Firefox security engineer and sandboxing lead:  
    [https://news.ycombinator.com/item?id=22342352](https://news.ycombinator.com/item?id=22342352)

[Go back](/index.html)