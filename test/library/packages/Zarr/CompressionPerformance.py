import pandas as pd
import numpy as np
from plotnine import *
import sys

df = pd.read_csv(sys.argv[1])
print(df)

p = ggplot(df,aes(x="Compression", y="ReadTime", fill="Compressor", color="Compressor")) + geom_point(size=4) + geom_line()
p.save("read_performance.pdf")
p = ggplot(df,aes(x="Compression", y="WriteTime", fill="Compressor", color="Compressor")) + geom_point(size=4) + geom_line()
p.save("write_performance.pdf")
