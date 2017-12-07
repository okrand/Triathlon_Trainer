from Tri_Functions import *
import pandas
from sys import argv
import csv
from sklearn import svm, preprocessing
import re
import os

Activity_file=argv[1]
A_list=[]
P_list=[]
stamps=[]
s_list=[]
p=re.compile(r'\d+\.\d+')



with open(Activity_file, 'r') as infile:
    read = csv.reader(infile)
    A_list = list(read)

A_list = sorted(A_list, key=lambda x: x[0])

A_list = adjustTime(A_list)



print('processing file')

P_list = list(Process_Features(A_list, 150))

#G_list=getGroundTruth(P_list)

filename='processed_'.rstrip() + Activity_file

with open(filename, 'w') as outfile:
    write = csv.writer(outfile)
    for item in P_list:
        write.writerow(item)
for row in P_list:
    stamps.append([row.pop(0)])

for item in stamps:
    s_list.append([float(i) for i in p.findall(str(item))])

stampa=[i[0] for i in s_list]
stampb=[i[1] for i in s_list]
    

path = './training_data'
actual, t_list = getTrainingData(path)
print('\nnormalizing data')
scaler=preprocessing.StandardScaler().fit(t_list)
t_list=scaler.transform(t_list)
P_list=scaler.transform(P_list)

model = svm.SVC(kernel='linear', C=1).fit(t_list, actual)

Pc_list=model.predict(P_list)

R_list=list(zip(Pc_list,stampa, stampb))

filename='results_'.rstrip() +Activity_file

with open(filename, 'w') as outfile:
    write = csv.writer(outfile)
    for item in R_list:
        write.writerow(item)

##with open(filename, 'r') as infile:
##    read = csv.reader(infile)
##    R_list=list(read)

E_list = Process_Activity(R_list, Activity_file)
print('Completed')

##with open('A_list.csv', 'r') as infile:
##    read = csv.reader(infile)
##    E_list=list(read)

plotResults(E_list, A_list)

#os.system('say "All Done"')
