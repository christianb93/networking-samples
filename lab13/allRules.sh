# Add a route to boxA to be able to reach the "public network"
ip netns exec boxA \
   ip route add default via 172.16.100.1


# Add source NATing for all packets going to the public interface
ip netns exec router \
   iptables -t nat \
   -A POSTROUTING \
   -o veth2 \
   -j SNAT --to 172.16.200.1

# By default drop all incoming packets
ip netns exec router \
   iptables -t filter \
   -P INPUT DROP
ip netns exec router \
   iptables -t filter \
   -P FORWARD DROP

# Accept all traffic from the private network
ip netns exec router \
   iptables -t filter \
   -A FORWARD \
   -i veth1 -j ACCEPT

# Accept traffic for all established connections
ip netns exec router \
   iptables -t filter \
   -A FORWARD \
   -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
