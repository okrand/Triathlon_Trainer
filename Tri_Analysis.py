#from Tri_Functions import *
#from sklearn import svm
import csv
from datetime import datetime

bike_list=[]

with open('Bike.csv', 'r') as infile:
    read = csv.reader(infile)
    bike_list = list(read)
    
sort_list = sorted(bike_list, key=lambda x: datetime.strptime(x[0], "%Y-%m-%d %H:%M:%S +%f"))
                   
with open('sortedBike.csv', 'w') as outfile:
    write = csv.writer(outfile)
    for item in sort_list:
        write.writerow(item)
    
