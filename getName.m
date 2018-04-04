function [ str ] = getName( input,bit )
%getName 
%   把一个输入的数字标签转化为带0000前缀的字符串
str = int2str(input);
num_zero = bit - length(str);
if num_zero>0
    for i=1:num_zero
        str = ['0',str];
    end
end
end

