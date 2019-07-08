#!/usr/bin/env python
# coding: utf-8

# In[1]:


from __future__ import print_function
import keras
from keras.models import Sequential
from keras.layers import Conv2D, Dense, Dropout, BatchNormalization, Activation
from keras.optimizers import RMSprop 
from keras.layers import Embedding
import numpy as np
import scipy.io as sio
import my_kerasloader as kl
import tensorflow as tf

# In[5]:

## reduce tensorflow verbosity
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
filemat = 'train_dataset.mat';
epochs=100;
batch_size=32;
# load data 
fp = sio.loadmat(filemat);
tfr_train=fp['tfr_train'];
itfr_train=fp['itfr_train'];
tfr_valid=fp['tfr_valid'];
itfr_valid=fp['itfr_valid'];
model_name = fp['model_name'];

optimizer = RMSprop();
dpout_v = 0.1; #0.1; #0.1
tfr_train=tfr_train.reshape(250,100,100,1);
itfr_train=itfr_train.reshape(250,100,100,1);
tfr_valid=tfr_valid.reshape(50,100,100,1);
itfr_valid=itfr_valid.reshape(50,100,100,1);
#create model
model = Sequential();
#add model layers
model.add(Conv2D(32, kernel_size=3, padding='same', activation='relu', input_shape=(100,100,1)));
model.add(Dropout(0.1))
model.add(BatchNormalization(momentum=0.9))
model.add(Conv2D(64, kernel_size=3, padding='same', activation='relu'));
model.add(Dropout(0.1))
model.add(BatchNormalization(momentum=0.9))
model.add(Conv2D(32, kernel_size=3, padding='same', activation='relu'));
model.add(Dropout(0.1))
model.add(BatchNormalization(momentum=0.9))
model.add(Conv2D(1, kernel_size=3, padding='same'));
model.add(Dropout(0.1))
model.add(BatchNormalization(momentum=0.9));
#model.add(Flatten())
#model.add(Dense(10, activation=’softmax’))

#compile model using accuracy to measure model performance
model.compile(optimizer=optimizer, loss='mean_squared_error', metrics=['accuracy']);

#train the model
history = model.fit(tfr_train, itfr_train, batch_size=batch_size, validation_data=(tfr_valid, itfr_valid), epochs=epochs);
itfr_test0=model.predict(tfr_valid[:1]);
kl.save_keras_model(model, model_name[0]+'.json', model_name[0]+'.h5');
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt

plt.figure(0)
plt.plot(history.history['acc'])
plt.title('training accuracy')
plt.ylabel('accuracy')
plt.xlabel('epoch')
plt.savefig('acc.png')
plt.close();

plt.figure(1)
plt.plot(history.history['loss'])
plt.title('training loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.show()
plt.savefig('loss.png')
plt.close();




