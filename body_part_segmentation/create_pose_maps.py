#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Created on Feb 26 15:15:37 2018

@author: Gabriel Oliveira, Mohammadreza Zolfaghari
"""

import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
from fnmatch import fnmatch
import sys
import os
import matplotlib.image as mpimg
import scipy

# Make sure that caffe is on the python path:
#set the caffe_FAST path
CAFFE_ROOT = '../path_to/caffe_FAST/'
sys.path.insert(0, CAFFE_ROOT + 'python')

import caffe

caffe.set_mode_gpu()
caffe.set_device(0)
#Set the path of deploy and trained model in the following line:
net = caffe.Net('/path_to/models_pose/model2_MPII_JHMDB/fcn-8s-pascal-deploy_300.prototxt', '/path_to/models_pose/model2_MPII_JHMDB/FCN_8S_snapshot_iter_300000.caffemodel', caffe.TEST)


def get_files_in_dir(DIR, pattern = None):
    all_files = []    
    if os.path.isdir(DIR):
        for path, subdirs, files in os.walk(DIR):
            for name in files:
                if pattern is not None:
                    if fnmatch(name, pattern):
                        all_files.append(os.path.join(path, name))
                else:
                    all_files.append(os.path.join(path, name))
    else:
         print("{} DOES NOT EXIST!!".format(DIR))
    
    return all_files

#
# redo later to properly do using mem_data_layer
#
def segment(in_file,path):
    # load image, switch to BGR, subtract mean
    im = Image.open(in_file)
    #im = im.resize(( 240,320),Image.ANTIALIAS)
    in_ = np.array(im, dtype=np.float32)
    in_ = in_[:,:,::-1]
        #in_ -= np.array((126.8420, 134.2887, 123.7515)) #NTU mean BGR values 
    in_ -= np.array((103.28, 105.99, 92.54))  #JHMDB mean BGR values 
    in_ = in_.transpose((2,0,1))
 
   
    # load net
    #net = caffe.Net('fcn-2s-pascal-DEPLOY.prototxt', 'fcn_2s_snapshot_iter_1400000.caffemodel', caffe.TEST)
    #NEW NET ARCH
    #net = caffe.Net('fcn-16s-pascal-deploy_300.prototxt', 'FCN_16S_snapshot_iter_300000.caffemodel', caffe.TEST)

    # shape for input (data blob is N x C x H x W), set data
    net.blobs['data'].reshape(1, 3, 240, 320)
    net.blobs['data'].data[...] = in_
    # run net and take argmax for prediction
    net.forward()
    out = net.blobs['upscore'].data[0].argmax(axis=0)


    for i in range(0, 240):
       for j in range(0, 320):
          if out[i,j] == 0:
              new_color = im.getpixel( (j,i))
              D=list(new_color)
              D[0]=0
              D[1]=0
              D[2]=0
              new_color=tuple(D)
              im.putpixel( (j,i), new_color)
          if out[i,j] == 1:
                 new_color = im.getpixel( (j,i))
                 D=list(new_color)
                 D[0]=219
                 D[1]=112
                 D[2]=147
                 new_color=tuple(D)
                 im.putpixel( (j,i), new_color)
          if out[i,j] == 2:
                  new_color = im.getpixel( (j,i))
                  D=list(new_color)
                  D[0]=32
                  D[1]=178
                  D[2]=170
                  new_color=tuple(D)
                  im.putpixel( (j,i), new_color)
          if out[i,j] == 3:
                  new_color = im.getpixel( (j,i))
                  D=list(new_color)
                  D[0]=255
                  D[1]=182
                  D[2]=193
                  new_color=tuple(D)
                  im.putpixel( (j,i), new_color)
          if out[i,j] == 4:
                  new_color = im.getpixel( (j,i))
                  D=list(new_color)
                  D[0]=148
                  D[1]=0
                  D[2]=211
                  new_color=tuple(D)
                  im.putpixel( (j,i), new_color)
          if out[i,j] == 5:
                  new_color = im.getpixel( (j,i))
                  D=list(new_color)
                  D[0]=139
                  D[1]=0
                  D[2]=139
                  new_color=tuple(D)
                  im.putpixel( (j,i), new_color)
          if out[i,j] == 6:
                  new_color = im.getpixel( (j,i))
                  D=list(new_color)
                  D[0]=46
                  D[1]=139
                  D[2]=87
                  new_color=tuple(D)
                  im.putpixel( (j,i), new_color)
          if out[i,j] == 7:
                  new_color = im.getpixel( (j,i))
                  D=list(new_color)
                  D[0]=60
                  D[1]=179
                  D[2]=113
                  new_color=tuple(D)
                  im.putpixel( (j,i), new_color)
          if out[i,j] == 8:
                  new_color = im.getpixel( (j,i))
                  D=list(new_color)
                  D[0]=218
                  D[1]=112
                  D[2]=214
                  new_color=tuple(D)
                  im.putpixel( (j,i), new_color)
          if out[i,j] == 9:
                  new_color = im.getpixel( (j,i))
                  D=list(new_color)
                  D[0]=186
                  D[1]=85
                  D[2]=211
                  new_color=tuple(D)
                  im.putpixel( (j,i), new_color)
          if out[i,j] == 10:
                  new_color = im.getpixel( (j,i))
                  D=list(new_color)
                  D[0]=50
                  D[1]=205
                  D[2]=50
                  new_color=tuple(D)
                  im.putpixel( (j,i), new_color)
          if out[i,j] == 11:
                  new_color = im.getpixel( (j,i))
                  D=list(new_color)
                  D[0]=127
                  D[1]=255
                  D[2]=0
                  new_color=tuple(D)
                  im.putpixel( (j,i), new_color)
          if out[i,j] == 12:
                  new_color = im.getpixel( (j,i))
                  D=list(new_color)
                  D[0]=255
                  D[1]=69
                  D[2]=0
                  new_color=tuple(D)
                  im.putpixel( (j,i), new_color)
          if out[i,j] == 13:
                  new_color = im.getpixel( (j,i))
                  D=list(new_color)
                  D[0]=255
                  D[1]=127
                  D[2]=80
                  new_color=tuple(D)
                  im.putpixel( (j,i), new_color)
          if out[i,j] == 14:
                  new_color = im.getpixel( (j,i))
                  D=list(new_color)
                  D[0]=255
                  D[1]=215
                  D[2]=0
                  new_color=tuple(D)
                  im.putpixel( (j,i), new_color)
          if out[i,j] == 15:
                  new_color = im.getpixel( (j,i))
                  D=list(new_color)
                  D[0]=218
                  D[1]=165
                  D[2]=32
                  new_color=tuple(D)
                  im.putpixel( (j,i), new_color)
     
    SEGMENTED_DIR = path
    #Set the path for saving results
    ddBase='/path_to_save/test_d/'
    #SEGMENTED_DIR=SEGMENTED_DIR
     

        
    FILE = (in_file.rsplit('/', 1))[1]
    FILE = FILE.replace(" ", "")
    FILE = (FILE.rsplit(".",1))[0]
    
    FILE1 = (in_file.rsplit('/', 2))[1]
    FILE1 = FILE1.replace(" ", "")
    
    FILE2 = (in_file.rsplit('/', 3))[1]
    FILE2 = FILE2.replace(" ", "")
    
    FILE3 = (in_file.rsplit('/', 4))[1]
    FILE3 = FILE3.replace(" ", "")
    
    Seg_save_Dir=ddBase + "/" + FILE3 + "/" + FILE2+ "/" + FILE1
    
    if not os.path.exists(Seg_save_Dir):
        os.makedirs(Seg_save_Dir)
        
    save_file = Seg_save_Dir+ "/" + FILE + ".jpg"      
    #print "path %s." % (save_file)
    #save_file = SEGMENTED_DIR + "/" + FILE + "_seg.png"           
    
    #fig = plt.figure()
    #a=fig.add_subplot(121,aspect='equal')
    #plt.axis('off')
    ##img = mpimg.imread(im)
    #imgplot = plt.imshow(im)
    #a=fig.add_subplot(122,aspect='equal')
    #plt.axis('off')
    #imgplot = plt.imshow(out)
    #fig.savefig(save_file)
    #plt.close(fig)
	#Uncertainty

    #scipy.misc.imsave(save_file, out)
    scipy.misc.imsave(save_file, im)
    #im = im.resize((1242,375),Image.ANTIALIAS)
    #save_file = SEGMENTED_DIR + "/" + FILE + "_seg2.png"           
    #scipy.misc.imsave(save_file, out2)
    



if __name__ == '__main__': 
    tt=1
    #read lines and remove \n
    #lines = [line.rstrip('\r') for line in open('ntu_videos_crossSubject_woMissedSamples_train.txt')]
    #print lines
    # Open the file for reading.
    #set the path of data list. each line in the list is the location of video frames.
    with open('/path_to_list/data_list.txt', 'r') as infile:
      data = infile.read()  # Read the contents of the file into memory.
    # Return a list of the lines, breaking at line boundaries.
    my_list = data.splitlines()

    for path in my_list:
      #print path

      DATASET_DIR = path

      in_files = get_files_in_dir(DATASET_DIR, "*.jpg")
      print(tt,"/",len(my_list))
      tt=tt+1
      #print in_files
      for in_f in range(len(in_files)):
         segment(in_files[in_f],path)



