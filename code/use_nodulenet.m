%% Just for puting in file the test images:
load testImg.mat
load trainImgs.mat

Elements = ["2"; "5"];
%creat folders with the names of elements(tirads score) from table:
for k = 1 : length(Elements)
    nameFolder =fullfile("C:\Users\sigar\Downloads\testImgs", Elements(k));
    if not(exist(nameFolder,'dir'))
        mkdir(nameFolder)
    end
end

%Write imagines in files depending on the tirads score:
for i = 1:length(testImgs.Files)
    fnm = testImgs.Files{i, 1};
    [filepath,name,ext] = fileparts(fnm);
    [ffp, nam] = fileparts(filepath);
    num = strcat(name, ext);
    myimage = imread(num);
    file = fullfile("C:\Users\sigar\Downloads\testImgs", nam, num);
    imwrite(myimage, file);
end


%% Here I used the network without machine learning:
load classifier.mat 
load nodulenet.mat
load testImgs.mat

%resize test images:
testAuds = augmentedImageDatastore([224 224], testImgs);

%classify the test images with the trained network:
[testpreds1, score] = classify(nodulenet, testAuds);

%Calculate the accuracy without machine learning:
accurancy_without_machineLearning = nnz(testpreds1 == testImgs.Labels)/numel(testpreds1)

%Visualize the confusion matrix:
confusionchart(testImgs.Labels,testpreds1);





%% Here I used the network with machine learning:


%Get the features from the layer right before the classification layer:
testFeatures = activations(nodulenet, testAuds, 'fc7', 'MiniBatchSize',20);

%Convert from 4-D single to 2-D:
imageFeaturess = squeeze(testFeatures)';

% Pass CNN image features to trained classifier
predictedLabels = predict(classifier, imageFeaturess);

%Calculate the accuracy with machine learning:
accurancy_with_machineLearning = nnz(predictedLabels == testImgs.Labels)/numel(predictedLabels)

%Visualize the confusion matrix:
confusionchart(testImgs.Labels,predictedLabels);

%I apply the newly trained classifier to categorize new images:
maxCount = size(testImgs.Files,1);
randNum = randi(maxCount)
newImage = testImgs.Files{randNum};
im = imread(newImage)

% Pre-process the images as required for the CNN
img = imresize(imread(newImage), [224 224 3]);

% Extract image features using the CNN
imageFeatures = activations(nodulenet, img, 'fc7');


%Convert from 4-D single to 2-D:
imageFeatures1 = squeeze(imageFeatures)';

% Make a prediction using the classifier
label = predict(classifier, imageFeatures1);
testImgs.Labels(randNum);

imshow(newImage);
if strcmp(char(label),char(testImgs.Labels(randNum)))
	titleColor = [0 0.8 0];
else
	titleColor = 'r';
end
title(sprintf('Clasificarea cu inteligenta artificila: %s; clasificarea cu rezultatele TIRADS: %s',char(label),testImgs.Labels(randNum)),'color',titleColor);