
# Project Development and Deployment Framework
The **~/projects/bin** folder contains a collection of automation scripts for common steps in project development. 
The **~/projects/lib** folder contains local common libraries. BIN and LIB are projects of their own and come from the separate repositories (starter content for BIN is included with server-setup). New projects sre created in subfolders which are project-service root directories. The **~/projects** folder is a root directory for local network Jupyter notebook and Rstudio.

### Initialize a new project
Project can be initialized with NodeJS app or / and python Flask API:
<pre>
~/projects/bin/init PROJECT --node-app --python-api --rstudio
</pre>
Command above creates the project subdirectory named PROJECT with basic app and api setup.
<br/>
Or, just initialize the project:
<pre>
~/projects/bin/init PROJECT
</pre>
then later if needed:
<pre>
~/projects/bin/init-app PROJECT
~/projects/bin/init-api PROJECT
~/projects/bin/init-r PROJECT
</pre>
Node-App and Python-API are the projects of their own, residing in the **~/projects** folder.

### Web UI
After being created the project notebook server can be accessed via local network:
* Jupyter: http:// WORKSTATION-IP /**notebook**/tree/ PROJECT /
* Rsudio:  http:// WORKSTATION-IP /**rstudio**/ PROJECT /
* NodeJS:  http:// WORKSTATION-IP /**projects**/ PROJECT /
* Python:  http:// WORKSTATION-IP /**api**/ PROJECT /

Start a single project web-service:
<pre>
~/projects/bin/start PROJECT
</pre>

Stop a single project web-service:
<pre>
~/projects/bin/stop PROJECT
</pre>

Start all web-services:
<pre>
~/projects/bin/start-notebook ### Jupyter
~/projects/bin/start-rstudio  ### R-Shiny
~/projects/bin/start-service  ### NodeJS + Python
</pre>

Stop all web-services:
<pre>
~/projects/bin/start-notebook ### Jupyter
~/projects/bin/start-rstudio  ### R-Shiny
~/projects/bin/start-service  ### NodeJS + Python
</pre>



### Jupyter Notebooks
If there's a public domain (**~/.local.cnf** DOMAIN) project notebooks can be published as static html/pdf documents to **www**.
Publish project notebook:
<pre>
~/projects/bin/publish PROJECT NOTEBOOK
</pre>
Command above will result in a static document accessible at http:// DOMAIN /projects/ PROJECT / NOTEBOOK.html
<pre></pre>

Convert **notebook to markdown** :
<pre>
~/projects/bin/publish PROJECT NOTEBOOK
</pre>

Convert **python to notebook** :
<pre>
~/projects/bin/publish PROJECT NOTEBOOK
</pre>

### Docker
For project portability consideration **Dockerfile** and **.dokerignore** created in the project root directory.
