vop_count_total = 0;
files = dir('./emodbdata/wav/*.wav');
for i = 1: length(files)
    vop_per_file = vop(files(i).name);
    vop_count_total = vop_count_total + vop_per_file;
end

%Total number of VOP for all the files
%disp(vop_count_total)
