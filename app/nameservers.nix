{ipv6_only, ...}:
let
  nat64 = [
    "2001:67c:2b0::4"
    "2001:67c:2b0::6"
    "2a01:4f9:c010:3f02::1"
    "2a00:1098:32c:1"
    "2001:4860:4860::64"
    "2001:4860:4860::6464"
    "2001:4860:4860:0:0:0:0:6464"
    "2001:4860:4860:0:0:0:0:64"
    "2606:4700:4700::64"
    "2606:4700:4700::6400"
    "2606:4700:4700:0:0:0:0:64"
    "2606:4700:4700:0:0:0:0:6400"
    "2a01:4f9:c010:3f02::1"
    "2a00:1098:2b::1"
    "2a01:4f8:c2c:123f::1"
    "2001:67c:27e4::64"
    "2001:67c:27e4:15::6411"
    "2001:67c:27e4:15::64"
    "2001:67c:27e4::60"
    "2a03:7900:2:0:31:3:104:161"
    "2602:fc23:18::7"
    "2a00:1098:2c::1"
    "2001:67c:2960::64"
    "2001:67c:2960::6464"
    "2001:67c:2b0::4"
    "2001:67c:2b0::6"
    "2a01:4f8:c2c:123f:69::1"
    "2a00:1098:2b:0:69::1"
    "2a01:4f9:c010:3f02:69::1"
  ];

  ipv4_only = [
    "8.8.8.8"
    "8.8.4.4"
    "2001:4860:4860::8888"
    "2001:4860:4860::8844"
    "2001:4860:4860:0:0:0:0:8888"
    "2001:4860:4860:0:0:0:0:8844"
    "1.1.1.1"
    "2606:4700:4700::1111"
    "1.0.0.1"
    "2606:4700:4700::1001"
    "1.1.1.2"
    "1.0.0.2"
    "2606:4700:4700::1112"
    "2606:4700:4700::1002"
    "1.1.1.3"
    "1.0.0.3"
    "2606:4700:4700::1113"
    "2606:4700:4700::1003"
  ];

  nameservers = if ipv6_only then nat64 else ipv4_only;
in
{
  networking.nameservers = nameservers;
}