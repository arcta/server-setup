
# Step 1: Setting Configuration

### Security Considerations
Setup defaults to local network 192.168.1.0/24, though, it could be any list of IPs (all HOST variables either localhost or IP address).

Our R&D **workstations are the servers**:


```python
!cat secure.sh
```

    #!/bin/bash
    
    ########################################################################
    ### set owner of projects as a server
    ########################################################################
    SERVER=$USER
    
    sudo useradd -d /home/$SERVER -m $SERVER
    sudo usermod -g sudo $SERVER
    sudo usermod -s /bin/bash $SERVER
    sudo passwd $SERVER
    
    ### disable root-login
    sudo sed -i "s/PermitRootLogin yes/PermitRootLogin no/1" /etc/ssh/sshd_config
    service sshd reload
    
    ### remove init-users from sudoers (cloud)
    rm /etc/sudoers.d/*
    echo "$SERVER ALL=(ALL) PASSWD:ALL" | sudo tee /etc/sudoers.d/$SERVER
    
    ### set firewall
    sudo ufw allow 'nginx HTTP'
    sudo ufw allow 'nginx HTTPS'
    sudo ufw allow 'ssh'
    sudo ufw allow from 192.168.1.0/24
    sudo ufw enable
    sudo ufw status


### Environment
Script **init.sh** creates configuration file **~/.local.cnf** which will be used by installation: fill the blanks before proceeding with Step 2 (System).
