<<EOF
#!/bin/bash
for i in 0 1 2; do
"name=worker-${i}|pod-cidr=10.200.${i}.0/24"
done
EOF