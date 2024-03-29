

OpenPGP Best Practices

    How to use this guide.
    Use free software, and keep it updated.
    Selecting a keyserver and configuring your machine to refresh your keyring.
        Use the sks keyserver pool, instead of one specific server, with secure connections.
        Ensure that all keys are refreshed through the keyserver you have selected.
        Refresh your keys slowly and one at a time.
        Do not blindly trust keys from keyservers.
        Don’t rely on the Key ID.
        Check key fingerprints before importing.
    Key configuration.
        Use a strong primary key.
        Use an expiration date less than two years.
        Set a calendar event to remind you about your expiration date
        Generate a revocation certificate.
        Only use your primary key for certification (and possibly signing). Have a separate subkey for encryption.
        Have a separate subkey for signing
        Keep your primary key entirely offline
        OpenPGP key checks.
            Make sure your key is OpenPGPv4
            primary keys should be RSA, ideally 3072 bits.
            self-signatures should not use MD5 exclusively
            self-signatures should not use SHA1
            stated digest algorithm preferences must include at least one member of the SHA-2 family at a higher priority than both MD5 and SHA1
            primary keys should have a reasonable expiration date (no more than 2 years in the future)
    Putting it all together.
    Additional suggestions.
        Do you have an encrypted backup of your secret key material?
        Do not include a “Comment” in your User ID.

This guide is deprecated, you only need to use the defaults because GnuPG is doing sane things. Just keep your software up-to-date. That is it, you are done!

If you had previously tweaked your configurations, you should consider starting over with a base configuration, so you do not have outdated recommendations that are less secure than the defaults.
How to use this guide.

We have gathered here a lot of information about configuring GnuPG. There are detailed explanations for each configuration suggestion. Many of these changes require you to make changes to the GnuPG configuration file on your machine located at ~/.gnupg/gpg.conf. For your convenience, all the suggested changes to the gpg.conf file are gathered in one place near the bottom of this page. We strongly encourage you to not blindly copy the file, but read the document and understand what the settings do.

Also note that this guide was written for legacy versions of GnuPG (1.4) and may contain recommendations that are redundant with default settings in newer releases of GnuPG (2.1 and above). A review is in progress to make sure the guide is up to date. You can help by submitting changes yourself.
Use free software, and keep it updated.

Information security is too important to leave to proprietary software. You should use a free OpenPGP implementation, and keep it up-to-date. The canonical free OpenPGP implementation is GnuPG, and it is available for every major modern operating system. It is not enough to install GnuPG and forget about it, though. You must keep it up to date so that critical security flaws are fixed. All software has bugs, and GnuPG is no exception. If you are running:

GNU/Linux (Debian, Ubuntu, Mint, Fedora, etc)
    your operating system will install GnuPG automatically and keep it up to date for you.
Windows
    you can install Gpg4win and subscribe to gpg4win-announce to know when to update.
macOS
    you can install GPG suite from GPGTools. The suite will let you know when there is an update available, or you can follow their twitter.
Building from source for any other operating system
    you should subscribe to gnupg-announce to know when you should update.

Selecting a keyserver and configuring your machine to refresh your keyring.

If you do not regularly refresh your public keys, you do not get timely expirations or revocations, both of which are very important to be aware of! There are two components to receiving key updates. Many users send their key updates to keyservers. In order to receive these updates, you must first ensure that you are using a keyserver that is functioning properly. Then, you have to configure your machine to receive key updates in a regular fashion.
Use the sks keyserver pool, instead of one specific server, with secure connections.

Most OpenPGP clients come configured with a single, specific keyserver. This is not ideal because if the keyserver fails, or even worse, if it appears to work but is not functioning properly, you may not receive critical key updates. Not only is this a single point of failure, it is also a prime source of leaks of relationship information between OpenPGP users, and thus an attack target.

Therefore, we recommend using the sks keyservers pool. The machines in this pool have regular health checks to ensure that they are functioning properly. If a server is not working well, it will be removed automatically from the pool.

https://sks-keyservers.net/overview-of-pools.php

You should also ensure that you are communicating with the keyserver pool over an encrypted channel, using a protocol called hkps. In order to use hkps, you will first need to install gnupg-curl:

sudo apt-get install gnupg-curl

Then, to use this keyserver pool, you will need to download the sks-keyservers.net CA, and save it somewhere on your machine. Please remember the path that you save the file to! Next, you should verify the certificate’s finger print.

https://sks-keyservers.net/sks-keyservers.netCA.pem
https://sks-keyservers.net/verify_tls.php



Now, you will need to use the following parameters in ~/.gnupg/gpg.conf, and specify the full path where you saved the .pem file above:

keyserver hkps://hkps.pool.sks-keyservers.net
keyserver-options ca-cert-file=/path/to/CA/sks-keyservers.netCA.pem

Now your interactions with the keyserver will be encrypted via hkps, which will obscure your social relationship map from anyone who may be snooping on your traffic. For example, if you do a gpg --refresh-keys on a keyserver that is hkp only, then someone snooping your traffic will see every single key you have in your key ring as you request any updates to them. That is pretty interesting information.

Note: hkps://keys.indymedia.org, hkps://keys.mayfirst.org and hkps://keys.riseup.net all offer this (although it is recommended that you use a pool instead).

    Note that this is the default starting with GnuPG 2.1.18 (at least).

Ensure that all keys are refreshed through the keyserver you have selected.

When creating a key, individuals may designate a specific keyserver to use to pull their keys from. It is recommended that you use the following option to ~/.gnupg/gpg.conf, which will ignore such designations:

keyserver-options no-honor-keyserver-url

This is useful because (1) it prevents someone from designating an insecure method for pulling their key and (2) if the server designated uses hkps, the refresh will fail because the ca-cert will not match, so the keys will never be refreshed. Note also that an attacker could designate a keyserver that they control to monitor when or from where you refresh their key.
Refresh your keys slowly and one at a time.

Now that you have configured a good keyserver, you need to make sure that you are regularly refreshing your keys. The best way to do this on Debian and Ubuntu is to use parcimonie:

sudo apt-get install parcimonie

Parcimonie is a daemon that slowly refreshes your keyring from a keyserver over Tor -. It uses a randomized sleep, and fresh Tor circuits for each key. The purpose is to make it hard for an attacker to correlate the key updates with your keyring.
https://gaffer.ptitcanardnoir.org/intrigeri/code/parcimonie/




You should not use gpg --refresh-keys or the refresh keys menu item on your email client because you disclose to anyone listening, and the keyserver operator, the whole set of keys that you are interested in refreshing.
Do not blindly trust keys from keyservers.

Anyone can upload keys to keyservers and there is no reason that you should trust that any key you download actually belongs to the individual listed in the key. You should therefore verify with the individual owner the full key fingerprint of their key. You should do this verification in real life or over the phone.

Once you have verified the key fingerprint that you need, you may download the key from the keyserver pool:

gpg --recv-key '<fingerprint>'

The next step is to confirm that you actually got the correct key from the keyserver. The keyserver might have given you a different key than the one you just asked for. If you have gpg with version less than 2.1, then you must manually confirm the fingerprint after you have downloaded the key (versions 2.1 and later will refuse to accept incorrect keys from the keyserver).

You can confirm the key fingerprint in one of two ways:

Option 1. Check the fingerprint is now in your keyring:

gpg --fingerprint '<fingerprint>'

Option 2. Attempt to (locally) sign a key with that fingerprint:

gpg --lsign-key '<fingerprint>'

If you are confident you have the right fingerprint from the owner of the key, the preferred method is to locally sign the key. If you want to publicly advertise your connection to the person who owns the key, you can do a publicly exportable --sign-key instead.

Note the single quote marks above (’), which should surround your full fingerprint and are necessary to make this command work. Double-quotes (") also work.
Don’t rely on the Key ID.

Short OpenPGP Key IDs, for example 0×2861A790, are 32 bits long. They have been shown to be easily spoofed by another key with the same Key ID. Long OpenPGP Key IDs (for example 0xA1E6148633874A3D) are 64 bits long. They are trivially collidable, which is also a potentially serious problem.

If you want to deal with a cryptographically-strong identifier for a key, you should use the full fingerprint. You should never rely on the short, or even long, Key ID.

You should probably at least set keyid-format 0xlong and with-fingerprint gpg options (put them in ~/.gnupg/gpg.conf) to increase the Key ID display size to 64-bit under regular use, and to always display the fingerprint.

Note that there was a bug in enigmail, which is fixed in version 1.7.0: If you add the option ‘with-fingerprint’ to display full fingerprints when listing keys, the fingerprint that is displayed in the enigmail key management window will be that of a subkey rather than the fingerprint of the primary key. You can always find your primary key’s fingerprint (for example, if you want to give your fingerprint to someone to verify at a keysigning party), you can display the fingerprints of all of your secret keys by running this:

gpg --with-fingerprint --list-secret-key

Check key fingerprints before importing.

If you received or downloaded a key in a , you can and should display its fingerprint before importing it into your keyring, in that way you can verify the fingerprint without possibly spoiling your keyring and adding a compromised key:

gpg --with-fingerprint <keyfile>

Key configuration.

Now that you know how to receive regular key updates from a well-maintained keyserver, you should make sure that your OpenPGP key is optimally configured. Many of these changes may require you to generate a new key.
Use a strong primary key.

Some people still have 1024-bit DSA keys. You really should transition to a stronger bit-length and hashing algo. In 2011, the US government instution NIST has deprecated DSA-1024, since 2013 it is even disallowed. In 2015, NIST also disallowed 1024-bit RSA, and use of SHA-1 for signing.

It is recommend to make a 3072-bit RSA key, with the sha512 hashing algo, making a transition statement that is signed by both keys, and then letting people know. Also have a look at this good document that details exactly the steps that you need to create such a key, making sure that you are getting the right hashing algo (it can be slightly complicated if you are using GnuPG versions less than 1.4.10).

Transitioning can be painful, but it is worth it, and a good opportunity to practice with the tools!
Use an expiration date less than two years.

People think that they don’t want their keys to expire, but you actually do. Why? Because you can always extend your expiration date, even after it has expired! This “expiration” is actually more of a safety valve or “dead-man switch” that will automatically trigger at some point. If you have access to the secret key material, you can untrigger it. The point is to setup something to disable your key in case you lose access to it (and have no revocation certificate).

Setting an expiration date means that you will need to extend that expiration date sometime in the future. That is a small task that you will need to remember to do (see next item about setting a reminder).

You may think that is annoying and you don’t want to deal with it, but it is actually good to be doing this on a regular basis so you keep your OpenPGP skills fresh. It indicates to users that their key is still active, and that the keyholder is using it, and gives you an opportunity to review the current state of your tools, and best practices. Also, many people will not sign a key that has no expiration date!

If you have already generated a key without an expiration date, you can set an expiration date on your key by doing the following:

gpg --edit-key '<fingerprint>'

Now select the subkey for which you want to set an expiration date (e.g. the first one), or none to set the expiration on your primary key and then issue the ‘expire’ command:

gpg> key 1
gpg> expire

Then set the date to a reasonable one, and save the key and exit (e.g. 2 years):

Key is valid for? (0) 2y
gpg> save

Then you may send your key to the keyservers to publish this change:

gpg --send-key '<fingerprint>'

Set a calendar event to remind you about your expiration date

You won’t remember, so its best to ask something to remind you. Set your reminder a month or more before the date so you can do the change with some time. You do not want to be rushed when you are dealing with your keys.

Remember: you can always extend your expiration date (even after it has expired!), so you do not need to make a brand new key, you just need to extend your expiration to a later time. Doing this on a regular basis is good to exercise your OpenPGP muscles, otherwise you will forget things.
Generate a revocation certificate.

If you forget your passphrase or if your private key is compromised or lost, the only hope you have is to wait for the key to expire (this is not a good solution), or to activate your revocation certificate by publishing it to the keyservers. Doing this will notify others that this key has been revoked.

A revoked key can still be used to verify old signatures, or decrypt data (if you still have access to the private key), but it cannot be used to encrypt new messages to you.

gpg --output revoke.asc --gen-revoke '<fingerprint>'

This will create a file called revoke.asc. You may wish to print a hardcopy of the certificate to store somewhere safe (give it to your mom, or put it in your offsite backups). If someone gets access to this, they can revoke your key, which is very inconvenient, but if they also have access to your private key, then this is exactly what you want to happen.

    Note that this is done by default in newer releases of GnuPG (e.g. 2.1 and above).

Only use your primary key for certification (and possibly signing). Have a separate subkey for encryption.

This is done by default in GnuPG 1.4.18 (and maybe earlier) and above. If you created your key with older implementations of OpenPGP, you may need to create new subkeys like you would do for signing, below.
Have a separate subkey for signing

By default GnuPG uses the same subkey for signing (e.g. signing an email message) and certifying (e.g. signing another key). It is useful to separate those purposes as one is way more important than the other.

In this scenario, your primary key is used only for certifications, which happen infrequently.

Creating a new subkey can be done in the --edit-key dialog, using the addkey command. During the dialog, you can choose the “capability” of the key…
Keep your primary key entirely offline

This is tricky to do but helps in protecting the very important primary key. If your primary key is stolen, the attacker can create new identities, revoke existing ones and completely impersonate you. Storing keys “offline” is therefore a good way to protect against such attacks.

Make sure you created a separate signing key before you do this, otherwise you will not be able to sign emails without your offline key.

Extracting the primary key is tricky, but this should get you going:

# extract the primary key
gpg -a --export-secret-key john.doe@example.com > secret_key
# extract the subkeys, which we will reimport later
gpg -a --export-secret-subkeys john.doe@example.com > secret_subkeys.gpg
# *delete* the secret keys from the keyring, so only subkeys are left
$ gpg --delete-secret-keys john.doe@example.com
Delete this key from the keyring? (y/N) y
This is a secret key! - really delete? (y/N) y
# reimport the subkeys
$ gpg --import secret_subkeys.gpg
# verify everything is in order
$ gpg --list-secret-keys
# remove the subkeys from disk
$ rm secret_subkeys.gpg

Then you want to put the secret_key file offline, probably on a thumb drive that you always carry with you, or in a guarded safe. Others will use smartcards to store the key and keep them with their physical keyring. The security of that device will be the security of your key.

Again, make sure you have a revocation certificate.

You can make sure the secret key material is missing by running --list-secret-keys which should make the missing material with a sec# instead of just sec.

Note: in certain exotic situations, --delete-secret-keys may not completely remove the secret key material and --list-secret-keys will still show sec instead of sec#. In this case, you can move the .gnupg directory out of the way instead of running --delete-secret-keys. You will need to reimport your trustdb and public keys of course, which will look something like this:

instead of gpg --delete-secret-keys john.doe@example.com, do this:
$ mv .gnupg .gnupg.bak
# reimport the subkeys
$ gpg --import secret_subkeys.gpg
# verify everything is in order
$ gpg --list-secret-keys
# remove the subkeys from disk
$ rm secret_subkeys.gpg
# reimport public keyring
$ gpg --homedir .gnupg.bak --export | gpg --import
# reimport trust db
$ gpg --homedir .gnupg.bak --export-ownertrust | gpg --import-ownertrust
# remove backup GPG directory, which will clear *all* secret keys
$ rm -rf .gnupg.bak

Finally note that in the above manipulations, secret key material is stored in the clear on disk. You may want to securely delete those files (using, for example, nwipe) instead of using the simple rm to remove private key material. Do consider that modern disks like SSDs run advanced firmware that may not really obey such commands and leave traces of private key material on disk. The best defense, in this case, is to use Full Disk Encryption.

Note that those procedures may change from version to version. See this discussion or this article, or this guide designed for GnuPG 2.x and above.


# OpenPGP key checks.

There is a handy tool that will perform the key checks below for you. You can get it from the source, or if you are running Debian or Ubuntu, you can install the package directly by doing:
http://floss.scru.org/hopenpgp-tools/


sudo apt-get install hopenpgp-tools

Note: hopenpgp-tools currently does not work with GnuPG version 2.1 and up. This is because GnuPG version 2.1 and up store both your public and private key in ~/.gnupg/pubring.kbx. hkt expects to find your public key in ~/.gnupg/pubring.gpg and will give an error message if you are using GnuPG version 2.1 and up.

To run these tests with the tool, you can do the following:

hkt export-pubkeys '<fingerprint>' | hokey lint

The output will display any problems with your key in red text. If everything is green, your key passes each of the tests below. If it is red, your key fails one of the tests listed below and you should fix it or generate a new key after ensuring that your gpg.conf is set up as recommended.
Make sure your key is OpenPGPv4

According to RFC4880: “V3 keys are deprecated. They contain three weaknesses. First, it is relatively easy to construct a V3 key that has the same Key ID as any other key because the Key ID is simply the low 64 bits of the public modulus. Secondly, because the fingerprint of a V3 key hashes the key material, but not its length, there is an increased opportunity for fingerprint collisions. Third, there are weaknesses in the MD5 hash algorithm that make developers prefer other algorithms. See below for a fuller discussion of Key IDs and fingerprints”

To determine if your key is a V3 key you can do the following:

gpg --export-options export-minimal --export '<fingerprint>' | gpg --list-packets |grep version

primary keys should be RSA, ideally 3072 bits.

To check if you are using RSA, you can do this:

gpg --export-options export-minimal --export '<fingerprint>' | gpg --list-packets | grep -A2 '^:public key packet:$' | grep algo

If the reported algorithm is 1, you are using RSA.
If it is 17, then it is DSA and you will need to confirm that the size reported in the next check reports a bit-length key size greater than 1024, otherwise you aren’t using DSA-2.

If the reported algorithm is 19, you are using ECDSA, if it is 18 you are using ECC, and the key bit-length determination check below is not an appropriate criteria for these types of keys as as the key sizes will drop significantly.

To check the bit-length of the primary key you can do this:

gpg --export-options export-minimal --export '<fingerprint>' | gpg --list-packets | grep -A2 'public key' | grep 'pkey\[0\]:'

self-signatures should not use MD5 exclusively

You can check this by doing:

gpg --export-options export-minimal --export '<fingerprint>' | gpg --list-packets | grep -A 2 signature | grep 'digest algo'

If you see any ‘digest algo 1’ results printed, then you have some self-signatures that are using MD5, as digest algo 1 is MD5. See the OpenPGP RFC 4880, section 9.4 for a table that maps hash algorithms to numbers.

To fix this, first, you should set the following in your ~/.gnupg/gpg.conf:

cert-digest-algo SHA512

Second, you should generate a new self-signature on your key (e.g. by changing the key’s expiration date).
self-signatures should not use SHA1

You can check this by doing:

gpg --export-options export-minimal --export '<fingerprint>' | gpg --list-packets | grep -A 2 signature | grep 'digest algo 2,'

If you see any ‘digest algo 2’ results printed, then you have some self-signatures that are using SHA1, as digest algo 2 is SHA1. See the OpenPGP RFC 4880, section 9.4 for a table that maps hash algorithms to numbers.

To fix this, you can generate a new self-signature on your key (e.g. by changing its expiration date) after setting the following in your ~/.gnupg/gpg.conf:

cert-digest-algo SHA512

stated digest algorithm preferences must include at least one member of the SHA-2 family at a higher priority than both MD5 and SHA1

You can check this by doing:

gpg --export-options export-minimal --export '<fingerprint>' | gpg --list-packets | grep 'pref-hash-algos'

and then inspect the results. The preference order is based on which number comes first from left to right. If you see the number ‘3’, ‘2’, or ‘1’ before you see ‘11’, ‘10’, ‘9’ or ‘8’, then you have specified your preferences to favor a weakened digest algorithm

To fix this, first set the following in your ~/.gnupg/gpg.conf:

default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed

then set the preferences on your key like this:

$ gpg --edit-key '<fingerprint>'
gpg> setpref
...
gpg> save

primary keys should have a reasonable expiration date (no more than 2 years in the future)

You can check what your expiration dates are by doing this:

gpg --export-options export-minimal --export '<fingerprint>' | gpg --list-packets | grep 'key expires after'

Then visually inspect what the results are to confirm this — the date listed will be relative to key creation, though, which can be difficult to interpret.

Another way to check expiration is just to do:

gpg --list-keys '<fingerprint>'

which should show the creation and expiration dates of the primary key and each associated subkey. If you don’t see anything that says “expires” in this output, then you have not set an expiration date properly.

To fix this, you can do:

$ gpg --edit-key '<fingerprint>'
gpg> expire
...
gpg> save

Putting it all together.

All the recommended settings discussed on this guide have been combined into one configuration file at Jacob Appelbaum’s duraconf “collection of hardened configuration files.” You may right-click on this link and save the gpg.conf in your ~/.gnupg/gpg.conf (linux and MacOS). For windows users, the gpg.conf file should be saved to AppData\GnuPG\.
https://github.com/ioerror/duraconf/raw/master/configs/gnupg/gpg.conf


You will need to uncomment and/or adjust the following settings to your local preferences: default-key, keyserver-options ca-cert-file and keyserver-options http-proxy.
Additional suggestions.
Do you have an encrypted backup of your secret key material?

Double check on it.
Do not include a “Comment” in your User ID.

If you think you need a “Comment” field in your OpenPGP User ID please think long and hard before deciding that is really the case. You probably don’t need or want it, and having a comment field makes it harder for people to know what they’re certifying.
