function [ err,model_name ] = train_rf_rep_cnn( tfr_train, itfr_train, tfr_valid, itfr_valid,  model_name )

filemat = 'train_dataset.mat';

if ~exist('model_name', 'var')
   model_name = 'tmp_model';
end

save(filemat, 'tfr_train', 'itfr_train', 'tfr_valid', 'itfr_valid', 'model_name');

err = system('python train_tf_rep_cnn.py');

delete(filemat);

end

