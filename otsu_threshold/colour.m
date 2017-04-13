X=imread('2.jpg');
imshow(X)
X(1,1,:)

XR=X(:,:,1);
XG=X(:,:,2);
XB=X(:,:,3);

XR_B=otsu(X,2);
XR_B(find(XR_B==1))=255;

XG_B=otsu(XG,2);
XG_B(find(XG_B==1))=255;

XB_B=otsu(XB,2);
XB_B(find(XB_B==1))=255;

X(:,:,1)=XR_B;
X(:,:,2)=XG_B;
X(:,:,3)=XB_B;

imshow(X)

