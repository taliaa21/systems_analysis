% Problem 8
% x = [T_paint, t_1, t_2, d_12]
intcon_8 = 4;

% Variables
M_8 = 100;
a_11_8 = 8;
b_11_8 = 11;
a_21_8 = 13;
b_21_8 = 15;

% C Matrix
c_8 = [-1 0 0 0];

% A Matrix
A_8 = [% worker 1 time constraints
     0 -1 0 0;
     0 1 0 0;
     % worker 2 time constraints
     0 0 -1 0;
     0 0 1 0;
     % d_12 integer constraints
     0 0 0 -1;
     0 0 0 1;
     % t_1 - t_2 application constraints
     1 -1 1 -M_8;
     1 1 -1 M_8];
 
% B matrix
b_8 = [-a_11_8 b_11_8 -a_21_8 b_21_8 0 1 0 M_8];
 
% Optimal x = [T_paint*, t_1*, t_2*, d_12*]
x_8 = intlinprog(c_8, intcon_8, A_8, b_8);
 
% --------------------------------------------------------
% Problem 9
% x = [T_paint, t_1, t_2, t_3, d_12, d_23]
intcon_9 = [5 6 7];

% Variables
M_9 = 100;
a_11_9 = 9;
b_11_9 = 12;
a_21_9 = 7;
b_21_9 = 21;
a_31_9 = 16;
b_31_9 = 18;

% C Matrix
c_9 = [-1 0 0 0 0 0 0];

% A Matrix
A_9 = [% worker 1 time constraints
     0 -1 0 0 0 0 0;
     0 1 0 0 0 0 0;
     % worker 2 time constraints
     0 0 -1 0 0 0 0;
     0 0 1 0 0 0 0;
     % worker 3 time constraints
     0 0 0 -1 0 0 0;
     0 0 0 1 0 0 0;
     % d_12 interger constraints
     0 0 0 0 -1 0 0;
     0 0 0 0 1 0 0;
     % d_23 integer constraints
     0 0 0 0 0 -1 0;
     0 0 0 0 0 1 0;
     % d_13 integer constraints
     0 0 0 0 0 0 -1;
     0 0 0 0 0 0 1;
     % t_1 - t_2 application constraints
     1 -1 1 0 -M_9 0 0;
     1 1 -1 0 M_9 0 0;
     % t_2 - t_3 application constraints
     1 0 -1 1 0 -M_9 0;
     1 0 1 -1 0 M_9 0;
     % t_1 - t_3 application constraints
     1 -1 0 1 0 0 -M_9;
     1 1 0 -1 0 0 M_9];
 
 % B matrix
 b_9 = [-a_11_9 b_11_9 -a_21_9 b_21_9 -a_31_9 b_31_9 0 1 0 1 0 1 0 M_9 0 M_9 0 M_9];
 
 % Optimal x = [T_paint*, t_1*, t_2*, t_3*, d_12*, d_23*]
 x_9 = intlinprog(c_9, intcon_9, A_9, b_9);
     