function [ str ] = getName( input,bit )
%getName 
%   ��һ����������ֱ�ǩת��Ϊ��0000ǰ׺���ַ���
str = int2str(input);
num_zero = bit - length(str);
if num_zero>0
    for i=1:num_zero
        str = ['0',str];
    end
end
end

