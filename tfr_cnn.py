# -*- coding: utf-8 -*-
"""tfr-cnn.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1PukulZRSsC1SMutJqtba-KrqZJlMXstd
"""

#load and save functions of the NN model
import keras;
from __future__ import print_function
from keras.models import Sequential
from keras.layers import Conv2D, Dense, Dropout, BatchNormalization, Activation
from keras.optimizers import RMSprop 
from keras.layers import Embedding
import numpy as np
import scipy.io as sio
#import my_kerasloader as kl
import tensorflow as tf
def load_keras_model(json_file, weight_file=None):
  json_file = open(json_file, 'r');
  loaded_model_json = json_file.read();
  json_file.close();
  model = keras.models.model_from_json(loaded_model_json);
  
  if weight_file is not None:
    model.load_weights(weight_file);
    
  return model;
   
def save_keras_model(model, json_file, weight_file=None):
  model_json = model.to_json()
  with open(json_file, "w") as json_file:
    json_file.write(model_json);
    json_file.close();
    
  if weight_file is not None:
    # serialize weights to HDF5
    model.save_weights(weight_file)
    print("Saved model to disk")



## Architecture and training of the model

# reduce tensorflow verbosity
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
filemat = '/content/drive/My Drive/tfr-cnn/dataset_Iv_imp_pv_SNRv.mat';
epochs=50;
batch_size=50;
# load data 
fp = sio.loadmat(filemat);
tfr_train=fp['tfr_train'];
itfr_train=fp['itfr_train'];
tfr_valid=fp['tfr_valid'];
itfr_valid=fp['itfr_valid'];
model_name = fp['model_name'];

optimizer = RMSprop();
dpout_v = 0.1; #0.1; #0.1
tfr_train=tfr_train.reshape(3000,500,100,1);
itfr_train=itfr_train.reshape(3000,500,100,1);
tfr_valid=tfr_valid.reshape(500,500,100,1);
itfr_valid=itfr_valid.reshape(500,500,100,1);
#model = load_keras_model('/content/drive/My Drive/tfr-cnn/Iv_imp_pv_SNRv_model.json', '/content/drive/My Drive/tfr-cnn/Iv_imp_pv_SNRv_model.h5')
#create model
model = Sequential();
#add model layers
model.add(Conv2D(32, kernel_size=5, padding='same', activation='relu', input_shape=(None, None, 1)));
model.add(Dropout(0.1))
model.add(BatchNormalization(momentum=0.1))
model.add(Conv2D(64, kernel_size=5, padding='same', activation='relu'));
model.add(Dropout(0.1))
model.add(BatchNormalization(momentum=0.1))
model.add(Conv2D(32, kernel_size=5, padding='same', activation='relu'));
model.add(Dropout(0.1))
model.add(BatchNormalization(momentum=0.1))
model.add(Conv2D(1, kernel_size=5, padding='same'));
model.add(Dropout(0.1))
model.add(BatchNormalization(momentum=0.1));
#model.add(Flatten())
#model.add(Dense(10, activation=’softmax’))

#compile model using accuracy to measure model performance
model.compile(optimizer=optimizer, loss='mean_squared_error', metrics=['accuracy']);

#train the model
history = model.fit(tfr_train, itfr_train, batch_size=batch_size, validation_data=(tfr_valid, itfr_valid), epochs=epochs);
itfr_test0=model.predict(tfr_valid[:1]);
#save the model
save_keras_model(model, '/content/drive/My Drive/tfr-cnn/'+model_name[0]+'.json', '/content/drive/My Drive/tfr-cnn/'+model_name[0]+'.h5');
#Loss and accuracy curve plot
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt

plt.figure(0)
plt.plot(history.history['acc'])
plt.title('training accuracy')
plt.ylabel('accuracy')
plt.xlabel('epoch')
plt.savefig('/content/drive/My Drive/tfr-cnn/'+model_name[0]+'_acc.png')
plt.close();

plt.figure(1)
plt.plot(history.history['loss'])
plt.title('training loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.savefig('/content/drive/My Drive/tfr-cnn/'+model_name[0]+'_loss.png')
plt.close();

from google.colab import drive
drive.mount('/content/drive')

## script for calculating the average error on the test set
# load data
from keras import backend as K
filemat = '/content/drive/My Drive/tfr-cnn/dataset_I2_p2_SNR45.mat';

fp = sio.loadmat(filemat);
tfr_test=fp['tfr_test'];
itfr_test=fp['itfr_test'];
model_name = fp['model_name'];
json_file='/content/drive/My Drive/tfr-cnn/I2_p2_SNR5_model.json';
weight_file='/content/drive/My Drive/tfr-cnn/I2_p2_SNR5_model.h5';
#json_file='/content/drive/My Drive/tfr-cnn/'+model_name[0]+'.json';
#weight_file='/content/drive/My Drive/tfr-cnn/'+model_name[0]+'.h5';
tfr_test=tfr_test.reshape(100,500,100,1);
itfr_test=itfr_test.reshape(100,500,100,1);
model=load_keras_model(json_file, weight_file);
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
itfr_pred=model.predict(tfr_test);
loss=tf.keras.backend.eval(keras.losses.mean_squared_error(itfr_test,itfr_pred))
#print(loss)
loss_avg=np.mean(loss)
print(loss_avg)
sio.savemat('/content/drive/My Drive/tfr-cnn/'+model_name[0]+'_pred_loss_avg', {'itfr_pred': itfr_pred,'loss_avg': loss_avg})

## script for testing the model of sinus on different types of signals
filemat_mix_imp_sinus = '/content/drive/My Drive/tfr-cnn/test_mix_imp3_sinus3_SNR5.mat';
ra=sio.loadmat(filemat_mix_imp_sinus);
tfr_s=ra['tfr_s'];
json_file='/content/drive/My Drive/tfr-cnn/Iv_pv_SNRv_model.json';
weight_file='/content/drive/My Drive/tfr-cnn/Iv_pv_SNRv_model.h5';
#json_file='/content/drive/My Drive/tfr-cnn/'+model_name[0]+'.json';
#weight_file='/content/drive/My Drive/tfr-cnn/'+model_name[0]+'.h5';
tfr_s=tfr_s.reshape(8,500,100,1);
model=load_keras_model(json_file, weight_file);
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
tfr_s_pred=model.predict(tfr_s);
sio.savemat('/content/drive/My Drive/tfr-cnn/test_sinus3_SNR5_pred', {'tfr_s_pred': tfr_s_pred})

## script for testing the model of pulses on different types of signals
filemat_mix_imp_sinus = '/content/drive/My Drive/tfr-cnn/test_mix_imp3_sinus3_SNR5.mat';
ra=sio.loadmat(filemat_mix_imp_sinus);
tfr_s=ra['tfr_s'];
json_file='/content/drive/My Drive/tfr-cnn/Iv_imp_SNRv_model.json';
weight_file='/content/drive/My Drive/tfr-cnn/Iv_imp_SNRv_model.h5';
#json_file='/content/drive/My Drive/tfr-cnn/'+model_name[0]+'.json';
#weight_file='/content/drive/My Drive/tfr-cnn/'+model_name[0]+'.h5';
tfr_s=tfr_s.reshape(8,500,100,1);
model=load_keras_model(json_file, weight_file);
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
tfr_s_pred=model.predict(tfr_s);
sio.savemat('/content/drive/My Drive/tfr-cnn/test_imp3_SNR5_pred', {'tfr_s_pred': tfr_s_pred})

## script for testing the model of pulses and sinus on different types of signals
filemat_mix_imp_sinus = '/content/drive/My Drive/tfr-cnn/test_mix_imp3_sinus3_SNR5.mat';
ra=sio.loadmat(filemat_mix_imp_sinus);
tfr_s=ra['tfr_s'];
json_file='/content/drive/My Drive/tfr-cnn/Iv_imp_pv_SNRv_model.json';
weight_file='/content/drive/My Drive/tfr-cnn/Iv_imp_pv_SNRv_model.h5';
#json_file='/content/drive/My Drive/tfr-cnn/'+model_name[0]+'.json';
#weight_file='/content/drive/My Drive/tfr-cnn/'+model_name[0]+'.h5';
tfr_s=tfr_s.reshape(8,500,100,1);
model=load_keras_model(json_file, weight_file);
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
tfr_s_pred=model.predict(tfr_s);
sio.savemat('/content/drive/My Drive/tfr-cnn/test_mix_imp3_sinus3_SNR5_pred', {'tfr_s_pred': tfr_s_pred})



