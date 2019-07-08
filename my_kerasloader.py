import keras;
  
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