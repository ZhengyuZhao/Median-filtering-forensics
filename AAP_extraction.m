%Extract AAP feature vector for each image from the dataset.%

close all;clc;clear all;
n=5; %size of the median filter
Nd=20; %dimension of the proposed feature vector, which can be adjusted by yourself
im_size=384;
delta=floor((min(im_size,im_size)/2)^2/Nd);
low_size=floor(im_size/4);
circle_area=zeros(1,Nd);
circle_dots_ori=zeros(1,Nd);
circle_pixels=zeros(1,Nd);
annular_area=zeros(1,Nd);
annular_pixels=zeros(1,Nd);
annular_dots_ori=zeros(1,Nd);
dataset_folder='D:\master\ucid';%loading images
for a=1:Nd
    circle_area(a)=a*delta;
end
annular_area(1)=pi*circle_area(1);
annular_area(2:end)=pi*(circle_area(2:end)-circle_area(1:end-1));
fnames= dir([dataset_folder,sprintf('%d',im_size)]);
row=floor(size(fnames,1)/1);
fea_ori=zeros(row,Nd);
% resultsg=zeros(row,col);
for nam=3:row
    namr=nam-2;
    image_ori= imread([dataset_folder,sprintf('%d',im_size),'\',fnames(nam).name]);
    [M,N,D]=size(image_ori);
    if D==3
        image_ori=rgb2gray(image_ori);
    end
    %     image_med = medfilt2(image_ori, [n n], 'symmetric'); %median filter
    %  hg= fspecial('gaussian',[5 5],0.5); %gaussian filter
    %   gfiltered_image= filter2(hg,image_original);
    %   ha= fspecial('average',[5 5]); %average filter
    %   image_original= filter2(ha,image_original);
    temp_F = fft2(image_ori);
    image_original_F = fftshift(temp_F);
    Y_ori=log(abs(image_original_F)+1); 
    cen_ori=Y_ori(im_size/2-low_size/2:im_size/2-1+low_size/2,im_size/2-low_size/2:im_size/2-1+low_size/2);
    k=2/3;
    T_ori=k*mean(cen_ori(:));%Threshold
    
    for i=1:M
        for j=1:N
            if (Y_ori(i,j)<T_ori)
                Y_ori(i,j)=1;
            else
                Y_ori(i,j)=0;
            end
        end
    end
    
    for k=1:Nd
        circle_dots_ori(1,k)=0;
        circle_pixels(1,k)=0;
        for i=1:M
            for j=1:N
                if ((i-M/2)^2+(j-N/2)^2)<=(k*delta)
                    circle_pixels(k)=circle_pixels(k)+1;
                    if Y_ori(i,j)==1
                        circle_dots_ori(k)=circle_dots_ori(k)+1;
                    end
                end
            end
        end
    end
    annular_dots_ori(1)=circle_dots_ori(1);
    annular_dots_ori(2:end)=circle_dots_ori(2:end)-circle_dots_ori(1:end-1);
    annular_pixels(1)=circle_pixels(1);
    annular_pixels(2:end)=circle_pixels(2:end)-circle_pixels(1:end-1);
    fea_ori(namr,:)=annular_dots_ori./annular_pixels;%20-d AAP feature vector
    disp(namr)
end






