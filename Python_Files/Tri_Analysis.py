from Tri_Functions import *
import pandas
from sys import argv
import os
import csv

Activity_file=argv[1]


with open(Activity_file, 'r') as infile:
    read = csv.reader(infile)
    A_list = list(read)

A_list = sorted(A_list, key=lambda x: x[0])

print('processing file')

P_list = Process_Features(A_list, 30)


filename='processed_'.rstrip() + Activity_file


with open(filename, 'w') as outfile:
    write = csv.writer(outfile)
    for item in P_list:
        write.writerow(item)
