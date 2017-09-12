
# Step 2: System Dependencies Installation
Script **install-all.sh** installs the whole stack. Script **install-selected.sh** prompts for **Y|n** input to run/skip some installation.

* Python, Java, Scala, R
* MySQL, PostgreSQL, ElasticSearch, MongoDB, Redis
* GDAL, GIS
* TensorFlow +GPU
* NodeJS, Nginx
* Docker
* Git

### Python 3
Python 3 comes with Xenial as default. Script will install **dev, pip3** and **virtual environment**.

### Java 8
Required: installed by either script without prompt.

### Scala 2.11
Required: installed by either script without prompt.

### R 3.4
For the workstation [RStudio](https://www.rstudio.com/products/RStudio/) will be installed on the prompt along with R-base and [R-Shiny](https://www.rstudio.com/products/shiny/).

### TensorFlow 1.3 with GPU support (Cuda 8.0 - Cudnn 6.0) 
If the system has a CUDA-Capable GPU (nvidia) tensorflow + gpu will be installed:


```python
!lspci | grep VGA | grep -i nvidia
```

    04:00.0 VGA compatible controller: NVIDIA Corporation GK106 [GeForce GTX 650 Ti Boost] (rev a1)


### GDAL 2.1
Open source [Geospatial Data Abstraction Library](http://www.gdal.org/).

### MySQL 5.7 <a name="mysql"></a>
Copy to clipboard MYSQL_ROOT_PASS from **~/.local.cnf** as **secure-installation** will prompt for it.

### PostgreSQL 9.6 + PostGIS 2.3

### ElasticSearch 5.5

### Redis 3.0
High performance hash-table, cache and message broker.

### Mongo 3.4

### NodeJS 8
Application server. Some projects will include web-apps.

### Docker
[Docker addresses projects portability](https://www.docker.com/what-docker).

### Nginx
Main server (reverse proxy, high performance, non-blocking). Required: installed by either script without prompt.

### Git
Version control and deployment. Required: installed by either script without prompt.
