
# Step 4: Setting User Projects

### Python Virtual Environment
Ubuntu Xenial comes with Python 3.5 which we make default and activated on login.

### Jupyter Notebook
Jupiter Notebook is very convenient for prototyping and documentation, but, due to security and system resources usage concerns, should not be replacing IDE. User can execute shell commands and view content of restricted directories, sure user can read local access credentials in the server home directory.


```python
!ls -l /etc/sudoers.d
```

    total 4
    -r--r----- 1 root root 958 Feb 10  2014 README


User can create many (virtually unlimited) notebook instances in a single notebook server client which consumes system  resources.


```python
!ps aux | grep jupyter
```

    betelgeuse  1237  0.0  1.4 316120 58628 ?        Ssl  Sep06   0:43 /home/betelgeuse/.env/bin/python3 /home/betelgeuse/.env/bin/jupyter-notebook --no-browser
    betelgeuse 14484  0.1  1.0 596556 43124 ?        Ssl  10:19   0:00 /home/betelgeuse/.env/bin/python3 -m ipykernel_launcher -f /home/betelgeuse/.local/share/jupyter/runtime/kernel-675c14b3-81a0-4412-9213-204cbccb5151.json
    betelgeuse 15493  0.0  1.0 596536 41044 ?        Ssl  Sep06   0:03 /home/betelgeuse/.env/bin/python3 -m ipykernel_launcher -f /home/betelgeuse/.local/share/jupyter/runtime/kernel-13e8c0a5-17bb-41fe-a098-069f16bad9f3.json
    betelgeuse 25143  0.0  1.0 596532 41180 ?        Ssl  10:03   0:00 /home/betelgeuse/.env/bin/python3 -m ipykernel_launcher -f /home/betelgeuse/.local/share/jupyter/runtime/kernel-49564023-a4f6-4c6b-85ca-18e63e9c598f.json
    betelgeuse 25424 85.0  0.9 596688 39520 ?        Ssl  10:27   0:00 /home/betelgeuse/.env/bin/python3 -m ipykernel_launcher -f /home/betelgeuse/.local/share/jupyter/runtime/kernel-988328b0-8336-4b06-ade1-f76507ade95e.json
    betelgeuse 25461  0.0  0.0   4452   652 pts/25   Ss+  10:27   0:00 /bin/sh -c ps aux | grep jupyter
    betelgeuse 25463  0.0  0.0   8876   656 pts/25   S+   10:27   0:00 grep jupyter
    betelgeuse 29562  0.0  1.0 596948 41996 ?        Ssl  Sep06   0:05 /home/betelgeuse/.env/bin/python3 -m ipykernel_launcher -f /home/betelgeuse/.local/share/jupyter/runtime/kernel-0b75f321-00d4-44ea-86e4-ef5811812707.json


Default installation restricts access to notebook server to the localhost or list of local network IPs (workstation, laptop). Either way, consider setting password:


```python
from notebook.auth import passwd
passwd()
```

    Enter password: ········
    Verify password: ········





    'sha1:15dde0ac1aea:80c389c0f93758d695de6f3cc65f387a66274f96'



Update **~/.local.cnf** 
<pre>
NOTEBOOK_PASS='sha1:15dde0ac1aea:80c389c0f93758d695de6f3cc65f387a66274f96'
</pre>

Jupyter configuration will be set (targeting persistent local-network server):
<pre>
c.IPKernelApp.pylab = 'inline'
c.NotebookApp.open_browser = False
c.NotebookApp.trust_xheaders = True
c.NotebookApp.ip = 'localhost'
c.NotebookApp.port = ${NOTEBOOK_PORT}
c.NotebookApp.password = '${NOTEBOOK_PASS}'
c.NotebookApp.base_url = '/notebook/'"
c.NotebookApp.tornado_settings = {'static_url_prefix':'/notebook/static/'}
</pre>

Kernels **Python 3** and [Scala](https://github.com/alexarchambault/jupyter-scala) will be installed; **R** is on hold till [IRkernel](https://github.com/IRkernel/IRkernel) is fixed and up to date with version 3.4.1 and submitted to CRAN.

Script **setup.sh** creates **~/projects** directory, sets databases (DATABASE, DATAUSER) and local project development / deployment framework.
