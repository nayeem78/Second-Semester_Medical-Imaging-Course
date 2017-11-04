clc, clear all
gt_data = csvread('gt.csv');  % Ground truth data
actual = sortrows(gt_data);   %sorting rows of gt
group1 = csvread('group1.csv'); %team 1 csv file
group2 = csvread('group2.csv'); %team 2 csvb file
predicted = sortrows(group1);   %sorting team 1 data to compare with gt for accuracy

%for group 1
if (length(actual) ~= length(predicted))
    disp('First two inputs need to be vectors with equal size.');
else
    [confmatrix,ModelAccuracy,Precision,Sensitivity,Specificity] = cfmatrix2(actual(:,2),predicted(:,2),[1,2,3,4],0,0)
end

%for group 2
predicted = sortrows(group2);
if (length(actual) ~= length(predicted))
    disp('First two inputs need to be vectors with equal size.');
else
    [confmatrix1,ModelAccuracy1,Precision1,Sensitivity1,Specificity1] = cfmatrix2(actual(:,2),predicted(:,2),[1,2,3,4],0,0)
end
