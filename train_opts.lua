local M = { }

function M.parse(arg)

  cmd = torch.CmdLine()
  cmd:text()
  cmd:text('Train a DenseCap model.')
  cmd:text()
  cmd:text('Options')

  -- Core ConvNet settings
  cmd:option('-backend', 'cudnn', 'nn|cudnn')
 
  -- jh: garbage collecting iteration for evaluation
  cmd:option('-gciter', 10, 'Prevent luajit not enough memory.')

  -- Model settings
  cmd:option('-rpn_hidden_dim', 512,
    'Hidden size for the extra convolution in the RPN')
  cmd:option('-rpn_batch_size', 256,
    'Batch size to use in the rpn')
  cmd:option('-sampler_batch_size', 128,
    'Batch size to use in the box sampler')
  cmd:option('-rpn_high_thresh', 0.7,
    'Boxes with IoU greater than this with a GT box are considered positives')
  cmd:option('-rpn_low_thresh', 0.3,
    'Boxes with IoU less than this with all GT boxes are considered negatives')
  cmd:option('-train_remove_outbounds_boxes', 1,
    'Whether to ignore out-of-bounds boxes for sampling at training time')
  cmd:option('-sampler_nms_thresh', 1,
    'Number of top scoring boxes to keep before apply NMS to RPN proposals') -- TRAIN.RPN_NMS_THRESH
  cmd:option('-sampler_num_proposals', 2000,
    'Number of region proposal to use at training time') -- TRAIN.RPN_POST_NMS_TOP_N in py-faster-rcnn

  cmd:option('-reset_classifier', 0,
    'Whether to reset the classfier, to avoid overfitting') -- Found overfitting in classfication val loss
  cmd:option('-anchor_type', 'densecap',
    '\"densecap\", \"voc\", \"coco\"')

  -- Loss function weights
  cmd:option('-mid_box_reg_weight', 1,
    'Weight for box regression in the RPN')
  cmd:option('-mid_objectness_weight', 1,
    'Weight for box classification in the RPN')
  cmd:option('-end_box_reg_weight', 1,
    'Weight for box regression in the recognition network')
  --[[cmd:option('-end_objectness_weight', 0.1,
    'Weight for box classification in the recognition network')]]--
  cmd:option('-classification_weight',1.0, 'Weight for classification loss')
  cmd:option('-weight_decay', 5e-4, 'L2 weight decay penalty strength')
  cmd:option('-box_reg_decay', 5e-5,
    'Strength of pull that boxes experience towards their anchor')

  -- Data input settings
  cmd:option('-data_h5', 'data/voc12-regions.h5', 
    'HDF5 file containing the preprocessed dataset (from proprocess.py)')
  cmd:option('-data_json', 'data/voc12-regions-dicts.json',
    'JSON file containing additional dataset info (from preprocess.py)')
  cmd:option('-proposal_regions_h5', '',
    'override RPN boxes with boxes from this h5 file (empty = don\'t override)')
  cmd:option('-debug_max_train_images', -1,
    'Use this many training images (for debugging); -1 to use all images')
  cmd:option('-image_size', "720",
    '\"720\" means longer side to be 720, \"^600\" means shorter side to be 600.')

  -- Optimization
  cmd:option('-optim', 'adam', 'what update to use? rmsprop|sgd|sgdmom|adagrad|adam')
  cmd:option('-learning_rate', 1e-5, 'learning rate to use')
  cmd:option('-optim_alpha', 0.9, 'alpha for adagrad/rmsprop/momentum/adam')
  cmd:option('-optim_beta', 0.999, 'beta used for adam')
  cmd:option('-optim_epsilon', 1e-8, 'epsilon for smoothing')
  cmd:option('-cnn_optim','adam', 'optimization to use for CNN')
  cmd:option('-cnn_optim_alpha', 0.9,' alpha for momentum of CNN')
  cmd:option('-cnn_optim_beta', 0.999, 'alpha for momentum of CNN')
  cmd:option('-cnn_learning_rate', 1e-5, 'learning rate for the CNN')

  cmd:option('-drop_prob', 0.5, 'Dropout strength throughout the model.')
  cmd:option('-max_iters', -1, 'Number of iterations to run; -1 to run forever')
  cmd:option('-checkpoint_start_from', '',
    'Load model from a checkpoint instead of random initialization.')
  cmd:option('-finetune_cnn_after', -1,
    'Start finetuning CNN after this many iterations (-1 = never finetune)')
  cmd:option('-val_images_use', -1,
    'Number of validation images to use for evaluation; -1 to use all')

  -- Model checkpointing
  cmd:option('-save_checkpoint_every', 5000,
    'How often to save model checkpoints')
  cmd:option('-checkpoint_path', 'checkpoint.t7',
    'Name of the checkpoint file to use')
  cmd:option('-load_best_score', 0, 
    'Do we load previous best score when resuming training.')

  -- Test-time model options (for evaluation)
  cmd:option('-test_rpn_nms_thresh', 0.7,
    'Test-time NMS threshold to use in the RPN')
  cmd:option('-test_final_nms_thresh', 0.3,
    'Test-time NMS threshold to use for final outputs')
  cmd:option('-test_num_proposals', 300,
    'Number of region proposal to use at test-time')

  -- Visualization
  cmd:option('-progress_dump_every', 100,
    'Every how many iterations do we write a progress report to vis/out ?. 0 = disable.')
  cmd:option('-losses_log_every', 10,
    'How often do we save losses, for inclusion in the progress dump? (0 = disable)')

  -- Misc
  cmd:option('-id', '',
    'an id identifying this run/job; useful for cross-validation')
  cmd:option('-seed', 123, 'random number generator seed to use')
  cmd:option('-gpu', 0, 'which gpu to use. -1 = use CPU')
  cmd:option('-timing', false, 'whether to time parts of the net')
  cmd:option('-clip_final_boxes', 1,
             'Whether to clip final boxes to image boundar')
  cmd:option('-eval_first_iteration',0,
    'evaluate on first iteration? 1 = do, 0 = dont.')

  cmd:text()
  local opt = cmd:parse(arg or {})
  return opt
end

return M
