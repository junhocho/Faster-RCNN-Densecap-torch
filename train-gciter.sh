th train.lua -gciter 50 -anchor_type voc -image_size ^600 -data_h5 data/voc12.h5 -data_json data/voc12.json -learning_rate 1e-4 -optim adam 2>&1 | tee log/train-gciter50.log 
th train.lua -gciter 30 -anchor_type voc -image_size ^600 -data_h5 data/voc12.h5 -data_json data/voc12.json -learning_rate 1e-4 -optim adam 2>&1 | tee log/train-gciter30.log 
th train.lua -gciter 20 -anchor_type voc -image_size ^600 -data_h5 data/voc12.h5 -data_json data/voc12.json -learning_rate 1e-4 -optim adam 2>&1 | tee log/train-gciter20.log 
th train.lua -gciter 10 -anchor_type voc -image_size ^600 -data_h5 data/voc12.h5 -data_json data/voc12.json -learning_rate 1e-4 -optim adam 2>&1 | tee log/train-gciter10.log 
th train.lua -gciter 5 -anchor_type voc -image_size ^600 -data_h5 data/voc12.h5 -data_json data/voc12.json -learning_rate 1e-4 -optim adam 2>&1 | tee log/train-gciter5.log 
