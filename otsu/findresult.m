function findresult()
global maxgen threshold m n C  
result=floor(threshold(1,maxgen)) %resultΪ�����ֵ
%C=imresize(A,0.3);
% % imshow(A);
% title('ԭʼͼ��')
% figure;
subplot(1,2,1)
imshow(C);
title('ԭʼͼ��ĻҶ�ͼ')
[m,n]=size(C);
%�����ҵ�����ֵ�ָ�ͼ��
for i=1:m
    for j=1:n
        if C(i,j)<=result
            C(i,j)=0;
        else
            C(i,j)=200;
        end
    end
end
subplot(1,2,2)
imshow(C);
title('��ֵ�ָ���ͼ��');