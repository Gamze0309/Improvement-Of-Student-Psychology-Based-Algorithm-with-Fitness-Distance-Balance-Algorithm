function X=initialization(student,variable,maxi,mini)

Boundary_no= size(maxi,2); % numnber of boundaries

% If the boundaries of all variables are equal and user enter a single number for both maxi and mini
if Boundary_no==1
    X=mini+rand(student,variable).*(maxi-mini);
end
%%display(X);

% If each variable has a different mini and maxi
if Boundary_no>1
    for i=1:1:variable
        maxi_i=maxi(i);
        mini_i=mini(i);
        X(:,i)=mini_i+rand(student,1).*(maxi_i-mini_i);
    end
end