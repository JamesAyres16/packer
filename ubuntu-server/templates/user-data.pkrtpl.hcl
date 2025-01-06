#cloud-config
autoinstall:
  version: 1

  source:
    id: ubuntu-server-minimal

  identity:
    hostname: ${hostname}
    username: ${username}
    # password: <mkpasswd james>
    # password: $y$j9T$DhaQRKSsrVPxBSW1U0kz21$9IaF8LoeFWxqAjRwqlLowS0wI4oDCJtyBE7jK7z7t35
    password: ${encrypted_password}

  ssh:
    install-server: true
    allow-pw: true
    authorized-keys:
      # - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2AlamCkNNx75nFepcEjLMC/+JS46X+pZm0hztWfrCyLEJqdQT0qaSTczDFXhrBocmXXI++a9zpxAmGRDst/U/edKnY8NuZJPdKO3ktgCEmO9RukAOuYAprz73cnlUqKSXYLjwIaeUuANXfAj9PCvgFbBkVR8o1yODWChb8nhh/l6e0v6OUewdz+4Do6761vCIFl6/o1Pqqt4qcbqWiEPCZ3Ok7oM3Rp6VU07Y/eY1oK5Vs93PaqbeKIPIdBGNxcXPnKUB/U1fBbs+zEp5ipytIOEA82Czs09cuiGL98j2Za3jc1S5JzaeRtFzhcRrgjlAroNFB5WTiu4DqgTJFl34gIvYR+PMWRMlYXQFjsHnUJM/o3e5Eq3Ea/NXiZLavJO1QW10fXckbG6W1M+e6IhOjXUIq8xwOGi21mJrc0bIBvqbtX/bwd/V+oll2QIp2qlQF+Efu8QZGiX1UTdVDsXqKnDbK1cG2Lg5yWCLVN3aCbbc6bhOTJfrJbUqlIB2yMs= james@laptop
      - ${ssh_key}
