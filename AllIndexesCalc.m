function [ AllIndexes ] = AllIndexesCalc(ids,citations,years,number_authors )
%AllIndexesCalc takes as input the matrices of years, citations,
%number_authors based on the configuaration requirements (see ReadMe) and
%calculates a matrix with 39 bibliometric indexes

AllIndexes=zeros(size(ids,1),40); %39 indexes + id
% calculate number of years since every publication
Ny=(str2double(datestr(now,'yyyy'))-years(:,2:end));
Ny(Ny==2015) = [0];
Ny(Ny==2016) = [-1];
my=[ids max(Ny,[],2)];
for i=1:1:size(AllIndexes,1)
    AllIndexes(i,1)=ids(i);
    temp=citations(i,2:end);
    temp2=years(i,2:end);
    temp3=number_authors(i,2:end);
    I=find(temp==-1);
    if isempty(I)
        C=temp;
    else
        C=temp(1:I(1)-1); 
    end
    if isempty(I)
        Y=temp2;
    else
       Y=temp2(1:I(1)-1);
    end
    if isempty(I)
        Authors=temp3;
    else
       Authors=temp3(1:I(1)-1);
    end
    AllIndexes(i,2)=sum(C);   % citations total
    AllIndexes(i,3)=length(C);  % papers total
    AllIndexes(i,4)=AllIndexes(i,2)/AllIndexes(i,3);  % cits/paper
    [Csorted idx]=sort(C);
    Csorted=fliplr(Csorted);
    idx=fliplr(idx);
    x=1:1:length(C);
    Hidx=sum(Csorted>=x);
    AllIndexes(i,5)=Hidx;
    H2=Hidx^2;
    AllIndexes(i,6)=AllIndexes(i,2)/H2; % aHirsch Ctot/H2
    x2=x.^2;
    cC=cumsum(Csorted);
    Gidx=sum(cC>=x2);
    AllIndexes(i,7)=Gidx;
    % the citations of the papers included in the h core
    core=Csorted(1:Hidx);
    tail=Csorted((Hidx+1):end);
    Ch=sum(core);
    Ce=Ch-Hidx^2;
    Ct=sum(tail);
    Ctc=(Hidx*(length(C))-Ct);
    PI=Hidx^2+Ce-Ctc;
    AllIndexes(i,8)=PI/length(C);
    AllIndexes(i,9)=Hidx/my(i,2);  %m of Hirsch for scientists with different career lengths
    % excess citations
    e=sqrt(sum(core-Hidx));
    AllIndexes(i,10)=e;
    % average number of citations in the h core
    % A and R and AR of Jin
    AJin=sum(core)/Hidx;
    AllIndexes(i,11)=AJin;
    RJin=sqrt(sum(core));
    AllIndexes(i,12)=RJin;
    % sort years based on publications publications
    Ysorted=Y(idx);
    Ycore=Ysorted(1:length(core));
    % estimation for the years corresponding to citations, 
    % if there are missing years provide an estimate based on the rest of
    % the publications of the same author
    YMissingHandled=round(mean(Y(Y>0))).*(Y==0)+Y.*(Y~=0);
    YsincePubMissingHandled=(str2double(datestr(now,'yyyy'))-YMissingHandled);
    YsincePubMissHandlsorted=YsincePubMissingHandled(idx);
    % years since published for papers in the h core
    ysincePubCore=YsincePubMissHandlsorted(1:length(core));
%     % mean of years since published gia tis dhmosieuseis pou den
%     % kseroume year (dld years since published=2015-0=2015)
%     meanyears=mean(ysincePubCore(ysincePubCore~=2015));
%     % logical indexing gia na kanw replace ta 2015 (dld unknown years of
%     % publication) me to meanyears (estimation!!)
%     ysincePubCore2=meanyears.*(ysincePubCore==2015)+ysincePubCore.*(ysincePubCore~=2015);
    % to kathe paper tou core diairw me to years since published
    ARJin=sqrt(sum(core./ysincePubCore));
    AllIndexes(i,13)=ARJin;
    
    % AWCR (Age Weighted Citation Rate) of Jin
    JAWCR=sum(Csorted(1:Hidx)./YsincePubMissHandlsorted(1:Hidx));
    AllIndexes(i,14)=JAWCR;
    % contemporary index Hc, we give a score to every paper and then we do the
    % same as with h index
    conteScore=(4.*C)./((str2double(datestr(now,'yyyy'))-YMissingHandled)+1);
    [conteScoreSorted idxconte]=sort(conteScore);
    conteScoreSorted=fliplr(conteScoreSorted);
    idxconte=fliplr(idxconte);
    xconte=1:1:length(conteScoreSorted);
    Hc=sum(conteScoreSorted>=xconte);
    AllIndexes(i,15)=Hc;
    H2idx=sum(Csorted>=x2);
    % h(2) Kosmulski, M. (2006)
    AllIndexes(i,16)=H2idx;
    % m of Bornmann
    mBornmann=median(Csorted);
    AllIndexes(i,17)=mBornmann;
    % vriskw to hI tou Batista=individual index
    Ausorted=Authors(idx);
    Aucore=Ausorted(1:length(core));
    HIidx=Hidx/mean(Aucore(1:Hidx));
    AllIndexes(i,18)=HIidx;
    % hI norm Harzings variation
    %normalizes the number of citations for each paper by
    %dividing the number of citations by the number of authors for that paper,
    SAH=sort(C./Authors,'descend');
    HInorm=sum(SAH>=x);
    AllIndexes(i,19)=HInorm;
    %Schreiber's method uses fractional paper counts instead of reduced
    %citation counts to account for shared authorship of papers, and then
    %determines the multi-authored hm  index based on the resulting effective
    %rank of the papers using undiluted citation counts.
    xS=x./Ausorted;
    Hmidx=sum(Csorted>=xS);
    AllIndexes(i,20)=Hmidx;
    %Gidx=sum(cC>=x2);
    % f and t of Tol (vlepe kwdika bibliometrics se R
    countf=1;
    fidx=0;
    tidx=0;
    while (countf<length(Csorted) & harmmean(Csorted(1:countf))>countf)
      fidx=fidx+1;
      countf=countf+1;
    end
    countt=1;
    while (countt<length(Csorted) & geomean(Csorted(1:countt))>countt)
      tidx=tidx+1;
      countt=countt+1;
    end
    AllIndexes(i,21)=fidx;
    AllIndexes(i,22)=tidx;
    testt=[24 18 12 8 6 5 5 4 4 3 2 2 1 1 1 0 0 0];
    % weighted h index (h[w]; Egghe & Rousseau, 2008):  h index weighted by citation impact
    r0=0;
    while (r0 < length(Csorted) & (sum(Csorted(1:(r0 + 1)))/Hidx) <= Csorted(r0 + 1))
        r0=r0 + 1; 
    end
    hw=sqrt(sum(Csorted(1:(r0-1))));
    AllIndexes(i,23)=hw;
    % x index: maxprod index (mp; Kosmulski, 2007)  maximum product of article number by citations
    Xidx=max(Csorted.*[1:length(Csorted)]);
    AllIndexes(i,24)=Xidx;
    % hg index (Alonso, Cabrerizo, Herrera-Viedma, & Herrera, 2010):  geometric mean of h and g
    hg=sqrt(Hidx * Gidx);
    AllIndexes(i,25)=hg;
    % q2 index (Cabrerizo, Alonso, Herrera-Viedma, & Herrera, 2010):  geometric mean of h and m[i]
    q2=sqrt(Hidx * mBornmann);
    AllIndexes(i,26)=q2;
    % tapered h index (h[t]; Anderson, Hankin, & Killworth, 2008):  fractional credit for all citations
    % pali vlepe R script bibliometrics.R http://www.tcnj.edu/~ruscio/Metrics.R
    Ht=0;
    for j=1:1:length(Csorted)
      d=1:Csorted(j);
      Ht=Ht+sum(1./(2.*max(j,d)-1));
    end
    AllIndexes(i,27)=Ht;
    % normalized h index by Sidriopoulos et al
    Hnor=Hidx/length(Csorted);
    AllIndexes(i,28)=Hnor;
    %negative metrics
    AllIndexes(i,29)=(sqrt(AllIndexes(i,2))-Hidx)/(sqrt(AllIndexes(i,2)));
    AllIndexes(i,30)=(AllIndexes(i,3)-Hidx)/AllIndexes(i,3);
    AllIndexes(i,31)=Ct/AllIndexes(i,2);
    %power law
    %[plaw,~]=fitpowerlaw(Csorted);
    AllIndexes(i,32)=1;
    %dH measures the minimum number of citations missing in order to increment
    %the current h-index by 1.
    if Hidx<length(Csorted)
        dH=Hidx+1-Csorted(Hidx+1); 
    else
        dH=0; % dld exei ftasei to megisto Hidx                
    end
    %use dH to calculate hrat
    Hrat=Hidx+1-dH/(2*Hidx+1);
    AllIndexes(i,33)=Hrat;
    % v index tou Vihinen, percentage of articles forming the h core
    Vidx=length(core)/length(Csorted);
    AllIndexes(i,34)=Vidx;
    % w of Winkler, the highest number of articles that has at least 10w
    % citations each
    x10=10*(1:1:length(C));
    Widx=sum(Csorted>=x10);
    AllIndexes(i,35)=Widx;
    % h tou miller is the square root of half the total number of citations
    hmiller=sqrt(length(Csorted)/2);
    AllIndexes(i,36)=hmiller;
    % s of Silagadze based on entropy
    Csortednozeros=Csorted.*(Csorted>0)+1.*(Csorted==0);
%     tempsidx=[t8.*length(t8)/sum(t8)];
    Skl=sum((Csorted./(sum(Csorted))).*log(Csortednozeros*length(Csorted)/sum(Csorted)));
    Sidx=(2/3)*sqrt(sum(Csorted))*exp(-Skl/log(length(Csorted)));
    AllIndexes(i,37)=Sidx;
    % mock h index (Prathap) Corrected Quality Ratio (C/P *
    % geommean(C,P))=> CQ->CQ^(0.4) ara (C^2/P)^(1/3)
    % h mock/h shows sensitivity to the citation numbers in the tall core
    % and long tail
    Hmock=((sum(Csorted)^2)/length(Csorted))^(1/3);
    AllIndexes(i,38)=Hmock;
    %w of Wohlin taking into account the whole citation curve
    citClass=[5 10 20 40 80 160 320 640];
    ClassLowerLimit=[sum(Csorted(Csorted>5)) sum(Csorted(Csorted>10)) sum(Csorted(Csorted>20))...
        sum(Csorted(Csorted>40)) sum(Csorted(Csorted>80))...
        sum(Csorted(Csorted>160)) sum(Csorted(Csorted>320)) sum(Csorted(Csorted>640))];
    Wihlonidx=round(sum(ClassLowerLimit.*log(citClass)));
    AllIndexes(i,39)=Wihlonidx;
    [nbx,rbx] = boxcount(C,'slope');
    df = -diff(log(nbx))./diff(log(rbx));
    if length(C)>5
        st11=mean(df(1:length(df)));
        %st11=df;
        st12=std(df(1:length(df)));
        st13=st11*Hidx;
    else
         st11=0;
         st12=0;
         st13=0;
    end
    AllIndexes(i,40)=st11; % this the farctal dimension based on the boxcount method (see Gogoglou et al "The Fractal Dimension of 
    % a Citation Curve:Quantifying an individual's scientific output using
    % the geometry of the entire curve", Scientometrics, Springer
    
end

end
% DataAwarded=datasample(DataForACMFellowsAllIndexes,400);
% nonAwarded=AllIndexes(datasample(find(q2==0),600,'Replace',false),:);
% DataAuthors=[nonAwarded(:,[1:39 41]);DataAwarded(:,[1:39 41])];
% save('DataAuthors.mat','DataAuthors');

