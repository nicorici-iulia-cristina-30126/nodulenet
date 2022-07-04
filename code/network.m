%path where the images are:
pathtoimage = "C:\Users\sigar\Downloads\Imagini_in_functie_de_tirads1";

%include images in imagedatastore and the labels will be the name of folders:
imgs = imageDatastore(pathtoimage, "IncludeSubfolders", true, "labelSource", "foldernames");

%see the labels:
noduleTirads = imgs.Labels;

%split random in images for training(65%) and images for testing(35%): 
[trainImgs, testImgs] = splitEachLabel(imgs, 0.65, 'randomized');

%split random in images for training(80%) and images for validation(40%)
[trainImg, validationImg] = splitEachLabel(trainImgs, 0.8, "randomized");

%see the name of categories:
numClasses = categories(imgs.Labels);

%taking a pretrain network(VGG-16):
net = layers_1;

%resize the images:
audsimgVlidation = augmentedImageDatastore([224 224 3], validationImg);
audsimgTrain = augmentedImageDatastore([224 224 3], trainImg);
audsimgTest = augmentedImageDatastore([224 224 3], testImgs);

%chosed options:
options = trainingOptions("sgdm","InitialLearnRate", 0.0001, "Plots","training-progress", "ValidationData",audsimgVlidation, "MiniBatchSize", 20);

%start the training
[nodulenet,info] = trainNetwork(audsimgTrain, net, options)

%classify the test images
testpreds = classify(nodulenet,audsimgTest);

%see the accurancy:
accuracy_without_machinelearning = nnz(testpreds == testImgs.Labels)/numel(testpreds)

%vizualizate the confusion matrix:
confusionchart(testImgs.Labels,testpreds);

%%

%resize traing images without validation images:
audsimgTrainAll = augmentedImageDatastore([224 224 3], trainImgs);

%the layer from where I get the features:
featureLayer = 'fc7';

%get the features for training images:
trainingFeatures = activations(nodulenet, audsimgTrainAll, featureLayer, 'MiniBatchSize', 32, 'OutputAs','channels');

%convert from 4-D single to 2-D:
trainingFeatures1 = (squeeze(trainingFeatures))';

%automatically tries a selection of classification model types with
%different hyperparameter value:
classifier = fitcauto(trainingFeatures1, trainImgs.Labels);

%get the features for testing images:
testfeatures = activations(nodulenet, audsimgTest, featureLayer, "MiniBatchSize",32);

%convert from 4-D single to 2-D:
testfeatures = squeeze(testfeatures)';

%Pass CNN features to trained classifier:
predictedLabels = predict(classifier, testfeatures);

%Claculate the accurancy with machine leraning:
accuracy_with_machineLearning = nnz(predictedLabels == testImgs.Labels)/numel(predictedLabels)

%vizualizate the confusion matrix:
figure,
confusionchart(testImgs.Labels,predictedLabels);


%Test on one images:
maxCount = size(testImgs.Files, 1);
randomNumber = randi(maxCount);
newImage = testImgs.Files{randomNumber};
img = readAndPreprocessImage(newImage);
imageFeature = activations(nodulenet, img, featureLayer);
imageFeature1 = squeeze(imageFeature)';
label = predict(classifier, imageFeature1);
testImgs.Labels(randomNumber);

imshow(newImage);
if strcmp(char(label), char(testImgs.Labels(randomNumber)))
    titleColor = [0 0.8 0];
else
    titleColor = 'r';
end

title(sprintf('Best Guess: %s --> Actual: %s', char(label), testImgs.Labels(randomNumber)), 'color', titleColor)


%%

save nodulenet
save trainImgs
save testImgs
save classifier

