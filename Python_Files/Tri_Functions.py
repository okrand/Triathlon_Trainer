import sklearn
import pandas as pd
import numpy as np
import statistics as stat
import peakutils
import os
import csv
import codecs
import matplotlib.pyplot as plt

def plotResults(E_list, R_list):
    start=np.array([float(i[1]) for i in E_list])
    stop=np.array([float(i[2]) for i in E_list])
    activity=np.array([i[0] for i in E_list])
    plt.barh(range(len(start)), stop-start, left=start, color=['red','blue'])
    plt.yticks(range(len(activity)), activity)
    plt.show()

def Process_Features(l, n):
    Rheaders=['time','Ax','Ay','Az','Gx','Gy','Gz']
    Pheaders=['b_time','e_time','RMS']
    # For item i in a range that is a length of l,
    n=150
    for i in range(0, len(l), n):
        RawChunk = pd.DataFrame(l[i:i+n],columns=Rheaders)
        #record beginning and end time
        b_time= RawChunk['time'].iloc[0]
        e_time = RawChunk['time'].iloc[-1]
        row=[[b_time,e_time]]
        #drop time stamps from data
        RawChunk=RawChunk.drop('time',1)
        cols=RawChunk.columns
        #convert data to float
        for col in cols:
            RawChunk[col]=RawChunk[col].astype(float)
        #extract features
        row.extend(getRMS(RawChunk))
        row.extend(getMean(RawChunk))
        row.extend(getStanDev(RawChunk))
        row.extend(getMedian(RawChunk))
        #row.extend(getMode(RawChunk))
        row.extend(getAvgPeakDistAmp(RawChunk))
        yield row

def getRMS(df):
    row=[]
    temp=df**2
    for column in temp:
        rms=stat.mean(temp[column])
        rms=rms**(.5)
        row.append(rms)
    return row

def getMean(df):
    row=[]
    for column in df:
        mean=stat.mean(df[column])
        row.append(mean)
    return row
    
def getStanDev(df):
    row=[]
    for column in df:
        std=stat.stdev(df[column])
        row.append(std)
    return row

def getMedian(df):
    row=[]
    for column in df:
        median=stat.median(df[column])
        row.append(median)
    return row

def getMode(df):
    row=[]
    for column in df:
        mode=stat.mode(df[column])
        row.append(mode)
    return row

def getAvgPeakDistAmp(df):
    row=[]
    for column in df:
        indexes=peakutils.indexes(df[column], thres=0.02/max(df[column]), min_dist=2)
        
        if(len(indexes)>1):
            dist=[j-i for i, j in zip(indexes[:-1], indexes[1:])]
            avgDist=stat.mean(dist)
        else:
            avgDist=-1
        if(len(indexes)>2):
            stdDist=stat.stdev(dist)
        else:
            stdDist=-1

        Amp=[]
        for point in indexes:
            Amp.append(df[column].iloc[point])
        if(len(Amp)>=1):
            avgAmp=stat.mean(Amp)
        else:
            avgAmp=-1
        if(len(Amp)>1):
            stdAmp=stat.stdev(Amp)
        else:
            stdAmp=-1
        row.extend([avgDist,stdDist,avgAmp,stdAmp])
        
    return row

def getTrainingData(path):
    T_list=[]
    Actual=[]
    for file in os.listdir(path):
        filepath=os.path.join(path, file)
        if(os.path.splitext(file)[1]=='.csv'):
            classification= os.path.splitext(file)[0]
            with open(filepath, 'r') as infile:
                read=csv.reader(infile)
                T_list.extend(list(read))
                count=len(T_list)-len(Actual)
                for i in range(count):
                    Actual.append(classification)
    for row in T_list:
        del row[0]
    
    with open('./test.csv', 'w') as testfile:
        test_list=list(zip(Actual,T_list))
        write=csv.writer(testfile)
        for item in test_list:
            write.writerow(item)       

    return Actual, T_list

def Process_Activity(R_list, Activity_file):
    firstStart=0
    firstStop=0
    secondStart=0
    secondStop=0
    #thirdStart=0
    #thirdStop=0
    first=''
    second=''
    #third=''
    activities=['run','bike']## add 'swim'
    RR_list=R_list[::-1]
    Ccounter=0 #current counter
    Tcounter=0
    for row in R_list:
        if first == '':
            if row[0] in activities:
                first=row[0]
                firstStart=row[1]
                print(first, firstStart)
        elif second == '':
            if row[0] == first:
                if Tcounter<3:
                    firstStop=row[2]
                if Ccounter>2:
                    firstStop=row[2]
                    Tcounter=0                   
                Ccounter= Ccounter+1
            elif row[0] in activities:
                second=row[0]
                secondStart=row[1]
                print(first, firstStop)
                print(second, secondStart)
            else:
                Ccounter=0
                Tcounter= Tcounter+1
        else: ##elif third == '':
            if row[0] == second:
                if Tcounter<3:
                    secondStop=row[2]
                if Ccounter>2:
                    secondStop=row[2]
                    Tcounter=0                   
                Ccounter= Ccounter+1
##            elif row[0] in activities:
##                third=row[0]
##                thirdStart=row[1]
##                print(second, secondStop)                               
##                print(third, thirdStart)
            elif row[0] not in activities: ##else:
                Ccounter=0
                Tcounter= Tcounter+1               
                
##        else: 
##            if row[0] == third:
##                if Ccounter>0 and Tcounter<3:
##                    thirdStop=row[2]
##                if Ccounter>3:
##                    thirdStop=row[2]
##                    Tcounter=0                   
##                Ccounter= Ccounter+1
##            elif row[0] not in activities:
##                Ccounter=0
##                Tcounter= Tcounter+1            

    print(second, secondStop)
    return[[first, firstStart, firstStop],[second, secondStart, secondStop]] 
