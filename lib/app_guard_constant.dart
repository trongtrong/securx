final List<String> commonVpnInterfaceNamePatterns = [
  'tun', // Linux/Unix TUN interface
  'tap', // Linux/Unix TAP interface
  'ppp', // Point-to-Point Protocol
  'pptp', // PPTP VPN
  'l2tp', // L2TP VPN
  'ipsec', // IPsec VPN
  'vpn', // Generic "VPN" keyword
  'wireguard', // WireGuard VPN
  'openvpn', // OpenVPN VPN
  'softether', // SoftEther VPN
];
