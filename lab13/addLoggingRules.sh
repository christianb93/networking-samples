# Flush chains for a given  a given namespace ($1) 
flush ()
{ 
  namespace=$1
  tables="raw mangle filter nat"
  for table in $tables; do
    ip netns exec $namespace iptables -t $table -F
  done
} 


# Add logging rules and policies for a given namespace ($1) and chain ($2) 
addRules ()
{ 
  namespace=$1
  chain=$2
  case $chain in
    INPUT)
      tables="mangle filter nat"
    ;;
    OUTPUT)
      tables="raw mangle nat filter"
    ;;
    PREROUTING)
      tables="raw mangle nat"
    ;;
    FORWARD)
      tables="mangle filter"
    ;;
    POSTROUTING)
      tables="mangle nat"
    ;;
  esac
  for table in $tables; do
    ip netns exec $namespace iptables -t $table -A $chain -j LOG --log-prefix "$namespace:$chain:$table:" --log-level info
    ip netns exec $namespace iptables -t $table -P $chain  ACCEPT
  done
} 



for namespace in boxA boxB router; do
  flush $namespace 
  for chain in INPUT OUTPUT PREROUTING POSTROUTING FORWARD; do
    # Add logging rules 
    addRules $namespace $chain
  done
  # Log all established connections in the input and output chain. For some strange reason, the logging rule in the 
  # nat table in the OUTPUT chain is never executed, not even for the seemingly first packet in the stream, e.g. 
  # an ICMP request, but everything works once we add the lines below 
  ip netns exec $namespace iptables -t mangle  -A OUTPUT -m state --state ESTABLISHED -j LOG --log-prefix "$namespace:OUTPUT:established:" --log-level info
  ip netns exec $namespace iptables -t mangle  -A INPUT -m state --state ESTABLISHED -j LOG --log-prefix "$namespace:OUTPUT:established:" --log-level info
done

