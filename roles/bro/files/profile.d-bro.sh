# Helpers
alias bro-column="sed \"s/fields.//;s/types.//\" | column -s $'\t' -t"
alias bro-awk='awk -F" "'
bro-grep() { grep -E "(^#)|$1" $2; }
bro-zgrep() { zgrep -E "(^#)|$1" $2; }
topcount() { sort | uniq -c | sort -rn | head -n ${1:-10}; }
colorize() { sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[%sm %s \x1b[0m",(i%7)+31,$i);print ""}'; }
cm() { cat $1 | sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[%sm %s \x1b[0m",(i%7)+31,$i);print ""}'; }
lesscolor() { cat $1 | sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[%sm %s \x1b[0m",(i%7)+31,$i);print ""}' | less -RS; }
topconn() { if [ $# -lt 2 ]; then echo "Usage: topconn {resp|orig} {proto|service} {tcp|udp|icmp|http|dns|ssl|smtp|\"-\"}"; else cat conn.log | bro-cut id.$1_h $2 | grep $3 | topcount; fi; }
fields() { grep -m 1 -E "^#fields" $1 | awk -vRS='\t' '/^[^#]/ { print $1 }' | cat -n ; }
toptalk() { for i in *.log; do echo -e "$i\n================="; cat $i | bro-cut id.orig_h id.resp_h | topcount 20; done; }
talkers() { for j in tcp udp icmp; do echo -e "\t=============\n\t     $j\n\t============="; for i in resp orig; do echo -e "====\n$i\n===="; topconn $i proto $j | column -t; done; done; }

toptotal() { if [ $# -lt 3 ]; then echo "Usage: toptotal {resp|orig} {orig_bytes|resp_bytes|duration} conn.log"; else
      zcat $3 | bro-cut id.$1_h $2                  \
    | sort                                          \
    | awk '{ if (host != $1) {                      \
                 if (size != 0)                     \
                     print $1, size;                \
                  host=$1;                          \
                  size=0                            \
              } else                                \
                  size += $2                        \
            }                                       \
            END {                                   \
                if (size != 0)                      \
                     print $1, size                 \
                }'                                  \
    | sort -rnk 2                                   \
    | head -n 20; fi; }

topconvo() { if [ $# -lt 1 ]; then echo "Usage: topconvo conn.log"; else
      zcat $1 | bro-cut  id.orig_h id.resp_h orig_bytes resp_bytes  \
    | sort                                                          \
    | awk '{ if (host != $1 || host2 != $2) {                       \
                 if (size != 0)                                     \
                     print $1, $2, size;                            \
                  host=$1;                                          \
                  host2=$2;                                         \
                  size=0                                            \
              } else                                                \
                  size += $3;                                       \
                  size += $4                                        \
            }                                                       \
            END {                                                   \
                if (size != 0)                                      \
                     print $1, $2, size                             \
                }'                                                  \
    | sort -rnk 3                                                   \
    | head -n 20; fi; }
