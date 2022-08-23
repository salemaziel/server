Cloak requires its underlying proxy software to route its traffic to and from Cloak client and server; this generally requires a minor reconfiguration to existing setups. This page covers OpenVPN, Shadowsocks and Tor. Any other proxy can be configured in similar fashions.

# OpenVPN
Since OpenVPN's configuration is quite complicated, it's preferable to first make sure OpenVPN is already working as intended before reconfiguring for Cloak
## Server
Make sure the following lines are in your .conf file
```
# So that OpenVPN is listening to ck-server
local 127.0.0.1
# UDP support is experimental at the moment. Change the line below to proto tcp if it's not working well
proto udp
dev tun
```
Take note of `port`, and set the same port number in openvpn's entry in Cloak server's `ProxyBook`. Depending on if you used `proto udp` or `tcp`, the `ProxyBook` entry needs to correspond to it.

You'll need to start ck-server with `ck-server -c <path to Cloak server's config>`

## Client
**You must not leave `EncryptionMethod` as `plain` in Cloak client's configuration file because OpenVPN gives out fingerprint. Change it to `aes-gcm` or `chacha20-poly1305`**

In your client side .ovpn (or .conf on Linux) file:

Make sure dev is set to tun, the same as the server side configuration

`dev tun`

Change the remote server to 127.0.0.1:1984 (unless you have changed the ck-client listening port to another port) like this

`remote 127.0.0.1 1984`

Then add a line so that the underlying connections between ck-client and ck-server can be sent through the physical interface, instead of being looped back by OpenVPN

`route <actual IP of the remote server> 255.255.255.255 net_gateway`

You'll need to start ck-client with `ck-client -u -c <path to Cloak client's config>` if you are using `proto udp`. Otherwise remove the `-u` flag: `ck-client -c <path to Cloak client's config>`

# Shadowsocks
Cloak is compliant to the Shadowsocks SIP003 protocol. If the Shadowsocks version you are using supports plugin natively (such as shadowsocks-libev and Shadowsocks Windows), you can follow the plugin mode section; if it doesn't, you can follow the standalone section
## Plugin mode
### Server
In *Shadowsocks'* configuration file (located at /etc/shadowsocks-libev/config.json if you are using shadowsocks-libev), add the following entry:

```
"plugin": "<path to ck-server>",
"plugin_opts": "<path to ckserver.json>"
```

You only need to run ss-server. ck-server will be started automatically.
### Client
Do the same thing as server in the configuration file, except it's for ck-client. If you are using the Windows GUI client, set the `Plugin Program` to be the path to ck-client, and `Plugin Options` to be the path to ckclient.json.

ck-client will be started automatically by Shadowsocks. You can leave `EncryptionMethod` as plain since Shadowsocks already hides fingerprints.
## Standalone mode
### Server
In *Shadowsocks'* config.json, set `server` to `"127.0.0.1"`. Take note of `server_port` and set the same port number in shadowsocks' entry in `ProxyBook` of Cloak server's config. Start shadowsocks server, then start ck-server separately with `ck-server -c <path to Cloak server's config>`
### Client
Set server's IP to `127.0.0.1`, port to `1984` (unless you will changed this when you start ck-client with -l parameter). Start ck-client first with `ck-client -c <path to Cloak client's config>`, then start Shadowsocks.

You can leave `EncryptionMethod` as plain since Shadowsocks already hides fingerprints.

# Tor
In the context of Tor, Cloak acts like a Tor bridge
## Server
Edit `/etc/tor/torrc` and add in the following lines:
```
SocksPort 0  # Optional. This just makes Tor stop listening as a local SOCKS proxy
BridgeRelay 1
ORPort 127.0.0.1:<port of choice> 
# You may notice that you can put "NoAdvertise" after the ORPort entry thinking that this will stop tor from advertising your bridge; however if you do that, tor will refuse to start. Some how by design tor has to advertise itself when running as a relay. Though if you specify the listening address as 127.0.0.1, external machines can't connect to it.
```
Edit the `ProxyBook` entry for tor in Cloak server's config file so that the port you entered as `ORPort` is reflected in Cloak's config as well.

You'll need to start ck-server with `ck-server -c <path to Cloak server's config>`
## Client
**You must not leave `EncryptionMethod` as `plain` in Cloak client's configuration file because Tor gives out fingerprint. Change it to `aes-gcm` or `chacha20-poly1305`**

First you need to start ck-client with `ck-client -c <path to Cloak client's config>`

Open up and configure TorBrowser, tick "Tor is censored in my country" and then tick "Provide a bridge I know", type in 127.0.0.1:1984 (or another port if you have change the listening port with -l flag), and then connect.