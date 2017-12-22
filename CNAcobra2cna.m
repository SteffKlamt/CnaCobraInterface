 
function cnap= CNAcobra2cna(cbmodel)
% CellNetAnalyzer API function 'CNAcobra2cna'
%
% Usage:  cnap = CNAcobra2cna(cbmodel)
%
% Input:  cbmodel is a COBRA Toolbox model.
%
% Output: cnap is a CNA mass-flow project structure
%
% Creates a CNA project from a COBRA model.


cnap= struct();

cnap.specID = [char(cbmodel.mets{:})];
cnap.specLongName = [char(cbmodel.metNames{:})];
cnap.stoichMat = full(cbmodel.S);
cnap.reacMin = cbmodel.lb;
cnap.reacMax = cbmodel.ub;
cnap.reacID = [char(cbmodel.rxns{:})];
cnap.objFunc = cbmodel.osense * cbmodel.c;

for i=1:size(cnap.specLongName,2)
	zw=deblank(cnap.specLongName(i,:));
	if(numel(findstr(' ',zw)))
		 newstr= strrep(zw,' ','_');
		 disp(['Warning: Metabolite name with whitespace. Replacing ''',zw,''' with ''',newstr,'''.']);
		 cnap.specLongName(i,1:numel(zw))=newstr;
	end
end

cnap = CNAgenerateMFNetwork(cnap);

if(any(cbmodel.b))
	disp(' ');
	disp('Warning: the b-vector of the COBRA model is non-zero. Will translate it as zero-vector (i.e., as homogenoeous system). Use reacMin and reacMax to set inhomogeneous constraints!');
end




