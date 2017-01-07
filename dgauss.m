function derivGaussG = dgauss(sig)
% First Gaussian Derivative 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The function does Derivative of Gaussian to create the Gaussian Derivative Mask for Edge Detection
% sig       : sigma
% floor()   : round toward negative infinity
% ceil()    : round toward positive infinity
%
% theory and formulas:
% http://www.cs.cornell.edu/courses/cs6670/2011sp/lectures/lec02_filter.pdf (Slide 42)
% http://www.cedar.buffalo.edu/~srihari/CSE555/Normal2.pdf (Slide 1)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = floor(-2*sig):ceil(2*sig);
G = exp(-(x.^2+x.^2)/(2*sig^2))/(2*pi*(sig^2)); % y in the formula has the same range as x here thats why double x
G = G/sum(G); % normalize
derivGaussG = -x.*G/sig^2;
