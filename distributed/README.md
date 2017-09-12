
# Step 3: Distributed Computing
Script install.sh downloads and installs Apache Spark and Flint with **Hadoop 2.7** and **Scala 2.11**.

### Apache Spark 2.2
Installs SBT for development since it can provide much faster iterative compilation.

If **IPv6** has host verification issue:
<pre>
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
</pre>

With Jupiter notebook we prefer **findspark** over integrated pyspark notebook driver for the better system resources management: pyspark shell instance created only as needed.


```python
import findspark
import pyspark

from random import random

findspark.init()

sc = pyspark.SparkContext(appName = "Pi")
num_samples = 1000000

def inside(p):     
    x, y = random(), random()
    return x * x + y * y < 1

count = sc.parallelize(range(0, num_samples)).filter(inside).count()
pi = 4 * count / num_samples
print(pi)

sc.stop()
```

    3.142056


### Apache Flink 1.3
While Apache Spark stays must-have for micro-batches; for streaming we've got a new favorite here: 
[Apache Flink](https://ci.apache.org/projects/flink/flink-docs-release-1.3/index.html).
