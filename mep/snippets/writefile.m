% reset environment
clear 'all';
close 'all';

% constants
filename = 'output.txt';

% do some calculations
A = 6; B = A^2;
C = A + B;

%%%%%%%%%% new file

% open file
file = fopen(filename, 'w');

% write to file
fprintf(file, 'Calculation:\n\t%i + %i = %i\n', A, B, C);

% close file
fclose(file);

%%%%%%%%%% existing file (append)

% open file
file = fopen(filename, 'a');

% write to file
fprintf(file, '\n----- END OF ENTRY\n');

% close file
fclose(file);