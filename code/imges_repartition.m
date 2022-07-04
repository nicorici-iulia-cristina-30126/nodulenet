%Get file where are the xmls files: 
fnm = fullfile("C:\Users\sigar\Downloads\archive", '*.xml');

%Get director:
S = dir(fnm);

%Put the contents of each filse in a structure
for i = 1:length(S)
    img{i} = S(i).name;
    C2 = readstruct(img{i});
    tb(i) = C2;
end

%Convert structure to table:
T = struct2table(tb);

%Sort table depending on number:
T = sortrows(T,'number');

%Delete row where are no tirads score:
toDelete = T.tirads == "";
T(toDelete,:) = [];

%Get categories of tirads score:
Elements = ["2"; "5"]; 

%creat folders with the names of elements(tirads score) from table:
for k = 1 : length(Elements)
    nameFolder =fullfile("C:\Users\sigar\Downloads\Imagini_in_functie_de_tirads1", Elements(k));
    if not(exist(nameFolder,'dir'))
        mkdir(nameFolder)
    end
end

%I croped all the images a little bit to get more accurancy and I put the imagines in files depending on the tirads score:
%Here is images who have "_1" at the end:
for k = 1 : length(T.number)
    if exist(T{k,1} + "_1.jpg", 'file')
        I1 = im2double(imread(T{k,1} + "_1.jpg"));
        baseFileName = sprintf("%d_1.jpg", T{k,1})
        I1thresh = I1 >= (10/255); 
        sizeI = size(I1);
        zeros = floor((sizeI(2) -  min(sum(any(I1thresh))))/2); 
        I2 = I1(:, zeros : sizeI(2)-zeros, :); 
        I2thresh = I1thresh(:, zeros : sizeI(2)-zeros, :);  

        sizeI2 = size(I2);
        zerosRows1 = floor((sizeI(1) -  min(sum(any(I2thresh, 2))))/2); 
        if(zerosRows1 == 0)
            zerosRows1 = 1;
        end
        I3 = I2(zerosRows1 : sizeI2(1)-zerosRows1, :, :);
        
        if(T{k,8} == "3" || T{k,8} == "4a" || T{k,8} == "4b" || T{k,8} == "2")
            fullFileName = fullfile("C:\Users\sigar\Downloads\Imagini_in_functie_de_tirads1", "2", baseFileName);
        elseif(T{k,8} == "4c" || T{k,8} == "5")
            fullFileName = fullfile("C:\Users\sigar\Downloads\Imagini_in_functie_de_tirads1", "5", baseFileName);
        end
        imwrite(I3, fullFileName);
    end
end
%Here is images who have "_2" at the end:
for k = 1 : length(T.number)
    if exist(T{k,1} + "_2.jpg", 'file')
        I1 = im2double(imread(T{k,1} + "_2.jpg"));
        baseFileName = sprintf("%d_2.jpg", T{k,1})
        I1thresh = I1 >= (10/255); 
        sizeI = size(I1);
        zeros = floor((sizeI(2) -  min(sum(any(I1thresh))))/2);
        I2 = I1(:, zeros : sizeI(2)-zeros, :); 
        I2thresh = I1thresh(:, zeros : sizeI(2)-zeros, :);   

        sizeI2 = size(I2);
        zerosRows1 = floor((sizeI(1) -  min(sum(any(I2thresh, 2))))/2); 
        if(zerosRows1 == 0)
            zerosRows1 = 1;
        end
        I3 = I2(zerosRows1 : sizeI2(1)-zerosRows1, :, :);
        
        I3thresh = I3 >= (10/255); 
        sizeI1 = size(I3);
        zeros1 = floor((sizeI1(2) -  min(sum(any(I3thresh))))/2); 
        I4 = I3(:, zeros1 : sizeI1(2)-zeros1, :); 
        I4thresh = I3thresh(:, zeros1 : sizeI1(2)-zeros1, :); 

        sizeI4 = size(I4);
        zerosRows = floor((sizeI1(1) -  min(sum(any(I4thresh, 2))))/2); 
        if(zerosRows == 0)
            zerosRows = 1;
        end
        I5 = I4(zerosRows : sizeI4(1)-zerosRows, :, :);

        if(T{k,8} == "3" || T{k,8} == "4a" || T{k,8} == "4b" || T{k,8} == "2")
            fullFileName = fullfile("C:\Users\sigar\Downloads\Imagini_in_functie_de_tirads1", "2", baseFileName);
        elseif(T{k,8} == "4c" || T{k,8} == "5")
            fullFileName = fullfile("C:\Users\sigar\Downloads\Imagini_in_functie_de_tirads1", "5", baseFileName);
        end
        imwrite(I5, fullFileName);
    end
end

%Here is images who have "_3" at the end:
for k = 1 : length(T.number)
    if exist(T{k,1} + "_3.jpg", 'file')
        baseFileName = sprintf("%d_3.jpg", T{k,1});
        I1thresh = I1 >= (10/255); 
        sizeI = size(I1);
        zeros = floor((sizeI(2) -  min(sum(any(I1thresh))))/2); 
        I2 = I1(:, zeros : sizeI(2)-zeros, :); 
        I2thresh = I1thresh(:, zeros : sizeI(2)-zeros, :); 

        sizeI2 = size(I2);
        zerosRows1 = floor((sizeI(1) -  min(sum(any(I2thresh, 2))))/2);
        if(zerosRows1 == 0)
            zerosRows1 = 1;
        end
        I3 = I2(zerosRows1 : sizeI2(1)-zerosRows1, :, :);
        
        I3thresh = I3 >= (10/255); 
        sizeI1 = size(I3);
        zeros1 = floor((sizeI1(2) -  min(sum(any(I3thresh))))/2); 
        I4 = I3(:, zeros1 : sizeI1(2)-zeros1, :); 
        I4thresh = I3thresh(:, zeros1 : sizeI1(2)-zeros1, :); 
        nonZero = sum(any(I3thresh,2)); 

        sizeI4 = size(I4);
        zerosRows = floor((sizeI1(1) -  min(sum(any(I4thresh, 2))))/2);
        if(zerosRows == 0)
            zerosRows = 1;
        end
        I5 = I4(zerosRows : sizeI4(1)-zerosRows, :, :);

        if(T{k,8} == "3" || T{k,8} == "4a" || T{k,8} == "4b" || T{k,8} == "2")
            fullFileName = fullfile("C:\Users\sigar\Downloads\Imagini_in_functie_de_tirads1", "2", baseFileName);
        elseif(T{k,8} == "4c" || T{k,8} == "5")
            fullFileName = fullfile("C:\Users\sigar\Downloads\Imagini_in_functie_de_tirads1", "5", baseFileName);
        end
        imwrite(I5, fullFileName);
    end
end