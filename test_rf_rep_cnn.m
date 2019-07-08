function [ err,model_name ] = test_rf_rep_cnn( tfr_test, itfr_test,  model_name )

filemat = 'test_dataset.mat';

if ~exist('model_name', 'var')
   model_name = 'tmp_model';
end

save(filemat, 'tfr_test', 'itfr_test', 'model_name');

err = system('python test_tf_rep_cnn.py');

delete(filemat);

end

