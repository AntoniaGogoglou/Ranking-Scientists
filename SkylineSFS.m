function [ S ] = Skyline( T, flag1 )
%   Utilizing Sort-Filtering Skyline algorithm that preseorts the data
%   according to the sum of attributes keeping in mind that no point can be
%   dominated by the ones that are below it if the points are put in
%   descending order. Table T is a table with rows as points and columns as
%   attributes. The returned set S is the maximum skyline meaning that the
%   dominance is based on higher attributes (the higher the value of a
%   point in a dimension the better the point is considered) it could be
%   done with minimum as well.
%   The first column of T contains the indexes of the data points (each row 
%   corresponds to a data point and the columns are the attributes)

% flag1 corresponds to whether the higher the values the better or the
% lower the values the better (e.g rank data)
% if flag1 is set to 1 then the higher the values the better 
% if flag1 is set to 0 then the lower value the better


if flag1==0
    T=[T sum(T(:,2:end),2)];
    T=sortrows(T,size(T,2));
 else
    T=sortrows(T,-size(T,2)); 
S=[];
for i=1:1:size(T,1)
    flag=0;
    if i==1
        S(1,:)=T(1,1:end-1);
    else
        
        for j=1:1:size(S,1)
            if flag1==1
                dom_temp2=T(i,2:end-1)<S(j,2:end); 
            else
                dom_temp2=T(i,2:end-1)>=S(j,2:end); 
            
            if all(dom_temp2)==1  
                flag=1;% S(j) has been dominated and T(i) takes its place. 
                % Afterwards T(i) must be compared with the remaining
                % points to check if it dominates them or not
                S(j,:)=T(i,1:end-1);
            elseif any(dom_temp2)==0 
                flag=2; % T(i) has been dominated by S(j) so it does not enter
                % the skyline set. No further checks are required so the
                % function breaks and proceeds to T(i+1)
                break
            else
                flag=3; % T(i) is better than S(j) concerning some attributes
                % while in other it is worse. As a result, it could
                % possibly belong to the skyline set but it needs to be
                % compared with all the other skyline points. 
            end
        end
     end
     if flag==3 % if T(i) was found to be a possible skyline point and it has not
         % been dominated by any of the other skyline points then it is
         % added to the skyline
        S=[S;T(i,1:end-1)];
     end
end


end

