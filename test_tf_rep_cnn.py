#!/usr/bin/env python
# coding: utf-8

# In[ ]:

import numpy as np
import scipy.io as sio
import my_kerasloader as kl


# In[ ]:


filemat = 'test_dataset.mat';

# load data 
fp = sio.loadmat(filemat);
tfr_test=fp['tfr_test'];
itfr_test=fp['itfr_test'];
model_name = fp['model_name'];
json_file=model_name[0]+'.json';
weight_file=model_name[0]+'.h5';
tfr_test=tfr_test.reshape(20,100,100,1);
itfr_test=itfr_test.reshape(20,100,100,1);
model=kl.load_keras_model(json_file, weight_file);

import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
itfr_test_0=model.predict(tfr_test[:6]);
for i in range(6):
	plt.figure(i)
	plt.imshow(np.squeeze(itfr_test_0[i]))
	plt.savefig('itfr_test_'+str(i)+'.png')
	plt.figure(i+1)
	plt.imshow(np.squeeze(itfr_test[i]))
	plt.savefig('itfr_gt_'+str(i)+'.png')
	plt.figure(i+2)
	plt.imshow(np.squeeze(tfr_test[i]))
	plt.savefig('tfr_'+str(i)+'.png')


# In[ ]:




