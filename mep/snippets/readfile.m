% reset environment
clear 'all';
close 'all';

% constants
filename = 'output.txt';

% open file
file = fopen(filename, 'r');

% read from file
content = fscanf(file, '%s');

fprintf(content);

% close file
fclose(file);