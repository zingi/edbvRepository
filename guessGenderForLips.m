function [gender] = guessGenderForLips(x,y)
% Guesses Gender
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assumes the gender of the person based on the lips size 
% x,y = upper and lower found white pixels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
length = abs(y-x);
if length > 17
    gender = 'w';
else
    gender = 'm';
end
    
end