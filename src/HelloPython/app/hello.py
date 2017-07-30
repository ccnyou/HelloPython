import sys
import os

with open("output.txt", "w") as f:
    sys.stdout = f
    print("Hello World in file")
print("Hello World in where ?")
