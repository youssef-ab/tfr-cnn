function [ err,model_name ] = test_rf_rep_cnn( tfr_s,  model_name )

filemat = 'test_real_audio.mat';

if ~exist('model_name', 'var')
   model_name = 'tmp_model';
end

save(filemat, 'tfr_s', 'model_name');

err = system('python test_tf_rep_cnn.py');

delete(filemat);

end

