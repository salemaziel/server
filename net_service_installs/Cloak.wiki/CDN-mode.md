Cloak supports two modes of _Transport_: `direct` and `CDN`. Under `direct` mode, Cloak clients communicates directly with the host running Cloak server. This is the most straightforward method of connection, but it inevitably exposes the actual IP address of Cloak server. If, through whatever means, the censor identifies the Cloak server as Cloak (instead of a normal website the server is trying to appear as), it's trivial to block the IP address and prevent any future connections. With `CDN` mode, the Cloak client instead connects to the edge server of a CDN network (preferably located outside of the firewall). The edge server's IP may also be used by numerous other legitimate websites which makes it impossible to block due to the potential collateral damage.

It used to be possible to employ domain fronting technique with CDN servers, such is how the Tor pluggable transport [meek](https://trac.torproject.org/projects/tor/wiki/doc/meek) works. However, in the last 2 years CDN service providers started cracking down on the use of domain fronting which makes it no longer possible with most major CDN service. That being said, it is still possible to use Cloak through CDN without domaing fronting.

# Cloudfront
Here we use Amazon's Cloudfront as an example to show how to set up a CDN server. It's very similar to the process in [meek's wiki page](https://trac.torproject.org/projects/tor/wiki/doc/meek). These are the only fields you need to change, everything else can be left as default:

* **Origin Domain Name**: the domain on which Cloak server is running. Note that if Cloak server is running on an EC2 instance, you can use the "domain" shown in the instance's "Public DNS (IPv4)" field. It looks like `ec2-12-34-56-78.eu-north-1.compute.amazonaws.com`.
* **Origin SSL Protocols**: TLSv1.2 only
* **Origin Protocol Policy**: HTTP Only. If this is set to HTTPS, Amazon's server will attempt to make a genuine TLS handshake with Cloak server, which will not be recognised as Cloak traffic.
* **HTTP Port**: 80
* **Viewer Protocol Policy**: HTTP and HTTPS (or HTTPS only)
* **SSL Certificate**: Default CloudFront Certificate (*.cloudfront.net)
* **Supported HTTP Versions**: HTTP/2, HTTP/1.1, HTTP/1.0

Once the _distribution_ is set up, a domain name will be given in the form of `31fkenipuud13d.cloudfront.net`. This needs to be given to Cloak client users

**Then go to your Cloak server config**, and add `":80"` to the list of `BindAddr`, if it wasn't already there.

**On the client side**, in the config file, set `ServerName` as the domain of the CDN server (which is in the from of `31fkenipuud13d.cloudfront.net`. You cannot use an arbitrary domain name because unfortunately Cloudfront doesn't allow domain fronting), set `CDNOriginHost` to `Origin Domain Name` you gave to CloudFront above.

When launching the client, supply the domain name of the CDN server as the remote address. This can be done either through commandline argument `-s`, or in plugin mode, Shadowsocks' server should be set to this domain.