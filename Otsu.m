function [level] = Otsu(x)
 
x1=im2single(x);
 
[m n]=size(x);
 
Err = 1;
 
T0=(max(max(x1))+min(min(x1)))/2;
 
while Err > 0.0001,
 
u1=0;
 
u2=0;
 
cnt1=0;
 
cnt2=0;
 
for i=1:m;
 
 for j=1:n;
 
  if x1(i,j)<= T0;
 
u1=u1+x1(i,j);
 
cnt1=cnt1+1;
 
  else
 
u2=u2+x1(i,j);
 
cnt2=cnt2+1;
 
  end
 
 end
 
end

 
u1=u1/cnt1;
 
u2=u2/cnt2;
 
T=(u1+u2)/2;
 
Err=abs(T-T0);
 
if Err > 0.0001
 
T0=T;
 
end
 
end

level=T0;