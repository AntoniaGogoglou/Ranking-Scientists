function [ ccMat ] = CellIntoMat( cc )
%% the following script helps bring the cell arrays containing citations, years and numbers of authors into acceptable matrix form to be processed
%% by the rest of the functions 
    maxSize=max(size(cc(:,1)));
    for i=1:1:size(cc,1)
        temp1=size(cc{i,1},2);
        tt=zeros(1,maxSize-temp1);
        tt(find(tt==0))=-1;
        cc{i,1}=[cc{i,1} tt];
    end
    ccMat=cell2mat(cc);
    %% now each cell of the cell array has been padded with -1 at the end so that they are all of size equal to largest cell of the array
end

