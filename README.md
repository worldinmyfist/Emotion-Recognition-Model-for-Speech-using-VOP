# Emotion-Recognition-Model-for-Speech-using-VOP
An Emotion Recognition Model for Speech that detects emotions using the features extracted from the speech and the vowel regions of speech.

## Instructions to run the code
### Introduction
The [vop_model](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model) folder contains codes that use wav files along with their corresponding vowel regions for training the model. The [non_vop_model](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/non_vop_model) folder contains code that only uses wav files for training. The [vop_model/emodbdata/wav](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/emodbdata/wav) folder contains the training set and [vop_model/emodbdata_test/wav](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/emodbdata_test/wav) folder contains the testing set. 

### Downloading EmoDB database
* Download the Database from [EmoDB](https://drive.google.com/drive/folders/1UyZSdCm1UWE1tsD8wyVDrQNSL-45DbFg?usp=sharing&fbclid=IwAR0dW933fDCG9SUagiLoHyF2IodESbmyeOUfs476O3ntuD95gWWEZ7ZrsIY).

**NOTE** : I have already downloaded the database and split the files into training and testing sets in the folders [vop_model/emodbdata/wav](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/emodbdata/wav)  and [vop_model/emodbdata_test/wav](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/emodbdata_test/wav).

### Detecting VOPs
* Run the [vop_model/ex_vop.m](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/ex_vop.m) file in matlab to create text files from wav files in the [vop_model/emodbdata/wav](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/emodbdata/wav) folder. I have already done that for all the files and stored all the text files in the [vop_model/vop_txt](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/vop_txt) folder. The text files contain Vowel Onset Point (VOP) timestamps for corresponding wav files.

**NOTE** : I have done this for all the files so that if the user wishes to shuffle the training and testing data, he can do that easily and will not have to run the [vop_model/ex_vop.m](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/ex_vop.m) file again for a different training set.

### Labelling Data 
* Run the files : [vop_model/readdataemodb.ipynb](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/readdataemodb.ipynb), [vop_model/readdataemodb_train.ipynb](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/readdataemodb_train.ipynb) and [vop_model/readdataemodb_test.ipynb](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/readdataemodb_test.ipynb). You can run these files in a jupyter notebook or the google colab. These files create [vop_model/emodb.pkl](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/emodb.pkl), [vop_model/emodb_train.pkl](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/emodb_train.pkl) and [vop_model/emodb_test.pkl](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/emodb_test.pkl) respectively. These **.pkl** files contain data and corresponding labels. We have already created them.

### Running the model 
* Run the file [vop_model/speech_emotion_model.ipynb](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/speech_emotion_model.ipynb) in jupyter notebook or google
colab. This will give the final accuracy and confusion matrix.

### Getting comparative results
* Run the code for the [non_vop_model](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/non_vop_model) folder following the above steps. This folder is for the model trained without VOPs, only using the wav files.
* Vary the number of MFCC features used to get other comparative results. Set **mfc** = 21, **dell** = 21 and **filtt** = 21 for the files :
[non_vop_model/readdataemodb.ipynb](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/non_vop_model/readdataemodb.ipynb), [vop_model/readdataemodb.ipynb](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/readdataemodb.ipynb), [vop_model/readdataemodb_train.ipynb](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/readdataemodb_train.ipynb) and [vop_model/readdataemodb_test.ipynb](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/readdataemodb_test.ipynb) to get the comparative results.
* The current codes use both, the wav files and vowel regions, to train the model. To see
the result where only vowel regions are used to train the model, comment out the
following lines in [vop_model/speech_emotion_model.ipynb](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/tree/main/Emotion%20Recognition%20Model/vop_model/speech_emotion_model.ipynb) :

![](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/blob/main/p1.png) <br />
![](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/blob/main/p2.png) <br />
![](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/blob/main/p3.png) <br />
![](https://github.com/worldinmyfist/Emotion-Recognition-Model-for-Speech-using-VOP/blob/main/p4.png) <br />

## AUTHOR
[ARYAN AGARWAL](https://github.com/worldinmyfist/)

## CONTRIBUTION
Pull requests are welcome. For major changes, please open an issue to discuss what you would like to change.



