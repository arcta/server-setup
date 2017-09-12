#!/bin/bash

echo "
Setting Jupyter-Notbook service ..."
tee ~/.jupyter/notebook-server <<EOF
#!/bin/bash

########################################################################
### systemctl notebook.service
########################################################################
source $HOME/.local.cnf
cd $PROJECTS_HOME
$HOME/.env/bin/jupyter-notebook
EOF
chmod +x ~/.jupyter/notebook-server

sudo tee /etc/systemd/system/notebook.service <<EOF
[Unit]
Description=Jupyter Notebook Server
After=network.target

[Service]
ExecStart=$HOME/.jupyter/notebook-server
ExecStartPost=/bin/sleep 1
User=$USER
Type=simple

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable notebook.service
sudo systemctl start notebook
sudo systemctl status notebook
