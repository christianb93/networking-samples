# On box A, we add rules for the output and input chains only
chain=OUTPUT
for table in raw mangle nat filter; do
  ip netns exec boxA iptables -t $table  -A $chain  -j LOG --log-prefix "boxA:$chain:$table:" --log-level info
done
chain=INPUT
for table in mangle filter; do
  ip netns exec boxA iptables -t $table  -A $chain  -j LOG --log-prefix "boxA:$chain:$table:" --log-level info
done
# Log all established connections in the input and output chain 
ip netns exec boxA iptables -t mangle  -A OUTPUT -m state --state ESTABLISHED -j LOG --log-prefix "boxA:OUTPUT:established:" --log-level info
ip netns exec boxA iptables -t mangle  -A INPUT -m state --state ESTABLISHED -j LOG --log-prefix "boxA:OUTPUT:established:" --log-level info

# For the router, we do the same for the input and output chains 
chain=OUTPUT
for table in raw mangle nat filter; do
  ip netns exec router iptables -t $table  -A $chain  -j LOG --log-prefix "router:$chain:$table:" --log-level info
done
chain=INPUT
for table in mangle filter; do
  ip netns exec router iptables -t $table  -A $chain  -j LOG --log-prefix "router:$chain:$table:" --log-level info
done
ip netns exec router iptables -t mangle  -A OUTPUT -m state --state ESTABLISHED -j LOG --log-prefix "router:ROUTER:established:" --log-level info
ip netns exec router iptables -t mangle  -A INPUT -m state --state ESTABLISHED -j LOG --log-prefix "router:ROUTER:established:" --log-level info
# and in addition add logging rules for postrouting, prerouting and forward chain 
chain=POSTROUTING
for table in mangle nat ; do
  ip netns exec router iptables -t $table  -A $chain  -j LOG --log-prefix "router:$chain:$table:" --log-level info
done
chain=PREROUTING
for table in raw mangle nat ; do
  ip netns exec router iptables -t $table  -A $chain  -j LOG --log-prefix "router:$chain:$table:" --log-level info
done
chain=FORWARD
for table in mangle filter ; do
  ip netns exec router iptables -t $table  -A $chain  -j LOG --log-prefix "router:$chain:$table:" --log-level info
done






