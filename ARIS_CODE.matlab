
#Break down video into individual frames 
function num_images = single_frame( ptemp )

info = imfinfo(ptemp);
num_images = numel(info);
outDir = strcat('ptemp(1:end-4)', '\');
for k = 1:num_images
    img  = imread(temp, k);
    outName = strcat(outDir, 'image_', num2str(k), '.tif');
    imwrite(img, outName);
end

end

###function/for-loop to extract images from frames and get information on each file 
###also here you are choosing nice names to process the images 
 
sourcepath = 'D:\Benthic_image\';
outputpath = 'D:\Benthic_image\output\';

files = dir( fullfile(sourcepath,'*.avi') );   %# list all *.xyz files
filename = {files.name}';                      %'# file names

 
for i=1:numel(filename)
    fname = fullfile(sourcepath,filename{i});     %# full path to file
    readerobj = VideoReader(fname);
    %eval(['readerobj=mmreader(' '''' fname '''' ');'])
    numFrames = readerobj.NumberOfFrame;
    idx1 = 0;
    for a=1:numFrames;
        idx = idx1 + a;
        if mod(idx, 10) == 0;
            vid = read(readerobj, a);
            stemp = [num2str(a,'%07d'),'.png']; 
            outputFile = strcat(outputpath, '\', filename{i}, '_', stemp );
            imwrite(vid, outputFile, 'png');
            %eval(['cd ' '''' sourcepath '''']); 
            disp(a)
        end;
    end
   
    idx1 = idx1 + numFrames;
end;

#########enhancing images with a roller for segmentation 
function img = enhance_image( I )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
se = strel('disk', 3);
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
Iobrd = imdilate(Iobr, se);
img = imreconstruct(Iobrd, Iobr);

end

######segmenting images
