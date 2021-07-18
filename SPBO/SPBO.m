

%  Student psychology based optimization (SPBO)algorithm 
%
%  Source codes demo version 1.0                                                                      
%                                                                                                     
%  Developed in MATLAB R2017b                                                                  
%                                                                                                     
%  Author and programmer: Bikash Das, V. Mukherjee, D. Das                                                         
%                                                                                                     
%         e-Mail: bcazdas@gmail.com, vivek_agamani@yahoo.com, ddas@ee.iitkgp.ernet.in                                               
%                                                                                                                                                             
%                                                                                                     
%  Main paper:                                                                                        
%  Bikash Das, V Mukherjee, Debapriya Das, Student psychology based optimization algorithm: A new population based
%   optimization algorithm for solving optimization problems, Advances in Engineering Software, 146 (2020) 102804.
%_______________________________________________________________________________________________
% You can simply define your objective function in a seperate file and load its handle to fobj 
% The initial parameters that you need are:
%__________________________________________
% fobj = @Objective function
% variable = number of your variables
% Max_iteration = maximum number of iterations
% student = number of search agents
% mini=[mini1,mini2,...,minin] where mini is the lower bound of variable n
% maxi=[maxi1,maxi2,...,maxin] where maxi is the upper bound of variable n
% If all the variables have equal lower bound you can just
% define mini and maxi as two single numbers

% To run SPBO: [Best_fitt,Best_student,Convergence_curve]=SPBO(student,Max_iteration,mini,maxi,variable,fobj)
%______________________________________________________________________________________________



%function [Best_fitt,Best_student,Convergence_curve]=SPBO(student,Max_iteration,maxi,mini,variable,fobj)

function [bestSolution, bestFitness, iter]=SPBO(fhd, dimension, maxFEs, fNumber)

%display('SPBO is optimizing your problem');
cec_settings;
student=20; % Number of student (population)
variable = dimension;

maxi = ubArray;
mini = lbArray;
%Initialize the set of random solutions
X=initialization(student,variable,maxi,mini);

sol=zeros(student,variable);
fitt = zeros(student,1);
Max_iteration = maxFEs;  % Maximum number of iterations
Objective_values = zeros(size(X,1), 1);

% Calculate the fitt of the first set and find the Best_fitt one
for i=1:student
    
    
    Objective_values(i,1)= testFunction(X(i,:)', fhd, fNumber);
   
        sol(i,:)=X(i,:);
        
        fitt(i,1)=Objective_values(i,1);
end
% display (sol);
% display (fitt);

Best_fitt = min(fitt);
for ft=1:1:student
    if Best_fitt==fitt(ft,1)
        Best_student=sol(ft,:);
    end;
end;

%Main loop
 t = 1;
while t <= Max_iteration
    
   for do=1:1:variable
        
    sum=zeros(1,variable);
    for gw=1:1:variable
    for fi=1:1:student
        sum(1,gw)=sum(1,gw)+sol(fi,gw);
    end;
    mean(1,gw)=sum(1,gw)/student;
    end;
     par=sol;
     par1=sol;
    
  
    
    check=rand(student,1);
    mid=rand(student,1);
  
    for dw=1:1:student
       % Best Student
        if Best_fitt==fitt(dw,1)
            
             jg=fitt(randperm(numel(fitt),1));
         
         for oi=1:1:student
             if jg==fitt(oi,1)
                 lk=oi;
             end;
         end;

          par1(dw,do)=par(dw,do)+(((-1)^(round(1+rand)))*rand*(par(dw,do)-par(lk,do)));       % Equation (1)
 
          
           
        else
            if check(dw,1)<mid(dw,1)
         % Good Student
                rta=rand;
                if rta>rand
                    par1(dw,do)=Best_student(1,do)+(rand*(Best_student(1,do)-par(dw,do)));      % Equation (2a)
                else
                
                par1(dw,do)=par(dw,do)+(rand*(Best_student(1,do)-par(dw,do)))+((rand*(par(dw,do)-mean(1,do))));         % Equation (2b)
                end;
            else
                an=rand;
          % Average Student
                if rand>an
                    
                    par1(dw,do)=par(dw,do)+(rand*(mean(1,do)-par(dw,do)));      % Equation (3)
                  
                else
           % Students who improves randomly
                        par1(dw,do)=mini(do)+(rand*(maxi(do)-mini(do)));                    % Equation (4)
                   
                end;
            end;
        end;
    end;

   
    % Boundary checking of the improvement of the students
    for z=1:1:student
       
            if par1(z,do)>maxi(do)
                par1(z,do)=maxi(do);
            else
                if par1(z,do)<mini(do)
                    par1(z,do)=mini(do);
                end;
            
            end;
    end;
    
    X=par1;
    
   for i=1:1:size(X,1)
        % Calculate the objective values
        Objective_values(i,1)=testFunction(X(i,:)', fhd, fNumber);
        t = t +1;
   end;
        
        
       fun1=Objective_values;

        % Update the solution if there is a better solution
    for vt=1:1:student
        if fitt(vt,1)>fun1(vt,1)
            fitt(vt,1)=fun1(vt,1);
            sol(vt,:)=par1(vt,:);
        end;
    end;
       
     Best_fitt1=min(fitt);
     for fo=1:1:student
             if Best_fitt1==fitt(fo,1)
                 Best_student1=sol(fo,:);
             end;
     end;
         
         % Update the best student
      if Best_fitt>Best_fitt1
         Best_fitt=Best_fitt1;
         Best_student=Best_student1;
     end;
  end;
    
       
    
end
bestSolution = Best_student;
bestFitness = Best_fitt;
iter = t;
end


function X=initialization(student,variable,maxi,mini)

Boundary_no= size(maxi,2); % numnber of boundaries

% If the boundaries of all variables are equal and user enter a single number for both maxi and mini
if Boundary_no==1
    X=mini+rand(student,variable).*(maxi-mini);
end

% If each variable has a different mini and maxi
if Boundary_no>1
    for i=1:1:variable
        maxi_i=maxi(i);
        mini_i=mini(i);
        X(:,i)=mini_i+rand(student,1).*(maxi_i-mini_i);
    end
end

end