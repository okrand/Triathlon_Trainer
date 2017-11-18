from Tri_Functions import *
import pandas
from sys import argv
import os
import csv

training_file=argv[1]
classification=argv[2].rstrip()

with open(training_file, 'r') as infile:
    read = csv.reader(infile)
    A_list = list(read)

A_list = sorted(A_list, key=lambda x: x[0])

print('processing file')

P_list = Process_Features(A_list, 30)

path = './training_data'
filename=classification + '.csv'
filepath=os.path.join(path, filename)

with open(filepath, 'a') as outfile:
    write = csv.writer(outfile)
    for item in P_list:
        write.writerow(item)

