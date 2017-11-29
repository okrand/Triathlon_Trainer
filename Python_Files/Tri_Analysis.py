from Tri_Functions import *
import pandas
from sys import argv
import csv
from sklearn import svm

Activity_file=argv[1]
A_list=[]
P_list=[]
stamps=[]

with open(Activity_file, 'r') as infile:
    read = csv.reader(infile)
    A_list = list(read)

A_list = sorted(A_list, key=lambda x: x[0])

print('processing file')

P_list = list(Process_Features(A_list, 30))

filename='processed_'.rstrip() + Activity_file

with open(filename, 'w') as outfile:
    write = csv.writer(outfile)
    for item in P_list:
        write.writerow(item)
for row in P_list:
    stamps.append(row.pop(0))
    
print("stamps: ")
print(len(stamps))
print("P_list: ")
print(len(P_list))


path = './training_data'
actual, t_list = getTrainingData(path)

model = svm.SVC(kernel='linear', C=1, gamma=10).fit(t_list, actual)

Pc_list=model.predict(P_list)

R_list=list(zip(Pc_list,stamps))

filename='results_'.rstrip() +Activity_file

with open(filename, 'w') as outfile:
    write = csv.writer(outfile)
    for item in R_list:
        write.writerow(item)


