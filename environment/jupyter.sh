#!/bin/bash

source ~/.local.cnf

### configuration ######################################################
echo "
Setting Jupyter configuration ... "
jupyter notebook --generate-config
CONFIG=$"$HOME/.jupyter/jupyter_notebook_config.py"
if [ -f "$CONFIG" ]; then
	sed -i -E "s/#\s?c.IPKernelApp.pylab = None/c.IPKernelApp.pylab = 'inline'/1" $CONFIG
	echo "c.IPKernelApp.pylab = 'inline'"

	sed -i -E "s/#\s?c.NotebookApp.open_browser = True/c.NotebookApp.open_browser = False/1" $CONFIG
	echo "c.NotebookApp.open_browser = False"

	sed -i -E "s/#\s?c.NotebookApp.trust_xheaders = False/c.NotebookApp.trust_xheaders = True/1" $CONFIG
	echo "c.NotebookApp.trust_xheaders = True"

	sed -i -E "s/#\s?c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = 'localhost'/1" $CONFIG
	echo "c.NotebookApp.ip = 'localhost'"

	sed -i -E "s/#\s?c.NotebookApp.port = 8888/c.NotebookApp.port = ${NOTEBOOK_PORT}/1" $CONFIG
	echo "c.NotebookApp.port = ${NOTEBOOK_PORT}"

	sed -i -E "s/#\s?c.NotebookApp.password = ''/c.NotebookApp.password = '${NOTEBOOK_PASS}'/1" $CONFIG
	echo "c.NotebookApp.password = '${NOTEBOOK_PASS}'"

	sed -i -E "s/#\s?c.NotebookApp.base_url = '\/'/c.NotebookApp.base_url = '\/notebook\/'/1" $CONFIG
	echo "c.NotebookApp.base_url = '/notebook/'"

	sed -i "s/c.NotebookApp.tornado_settings = {}/c.NotebookApp.tornado_settings = {'static_url_prefix':'\/notebook\/static\/'}/1" $CONFIG
	sed -i -E "s/#\s?c.NotebookApp.tornado_settings/c.NotebookApp.tornado_settings/1" $CONFIG
	echo "c.NotebookApp.tornado_settings = {'static_url_prefix':'/notebook/static/'}"
fi

### kernels ############################################################
if [ "$(which scala)" != "" ]; then
    git clone https://github.com/alexarchambault/jupyter-scala.git
    cd jupyter-scala
    sbt cli/packArchive
    source jupyter-scala
    cd ../
    rm -rf jupyter-scala
fi
echo "Done"
