import sklearn
import pandas as pd
import numpy as np
import statistics as stat
import peakutils



def Process_Features(l, n):
    Rheaders=['time','Ax','Ay','Az','Gx','Gy','Gz']
    Pheaders=['b_time','e_time','RMS']
    # For item i in a range that is a length of l,
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
        avgAmp=stat.mean(Amp)
        if(len(Amp)>1):
            stdAmp=stat.stdev(Amp)
        else:
            stdAmp=-1
        row.extend([avgDist,stdDist,avgAmp,stdAmp])
        
    return row

def getTraningData(path):
    T_list=[]
    Actual=[]
    for file in os.listdir(path):
        filepath=os.path.join(path, file)
        classification= os.path.splittext(file)[0]
        with open(filepath, 'r') as infile:
            read=csv.reader
            T_list.extend(list(read))
            for i in list(read):
                Actual.append(classification)

    return zip(Actual, T_list)
            
        

