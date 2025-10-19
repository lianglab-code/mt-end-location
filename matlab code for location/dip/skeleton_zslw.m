function skel = skeleton_zslw (bwimg)

% reference:
% "A fast parallel algorithm for thining ditital patterns"
% "A comment on 'A fast parallel algorithm for thining ditital patterns'"

[h w] = size(bwimg);
it = padarray(bwimg,[1,1]); % to make sure that not obj pixel is at the border
it(it>=1) = 1; % convert values larger than 1 to 1
C = 1;

while(1)
    % iteration 1
    C = 0;
    m = zeros(h+2,w+2);
    for i=1:h
        for j=1:w
            if(it(i+1,j+1)==1)
                if(cond1(it(i:i+2,j:j+2))==1)
                    m(i+1,j+1) = 1;
                    C = C+1;
                end
            end
        end
    end
    it = it - m;
    if(C==0)
        break;
    end
    % iteration 2
    C = 0;
    m = zeros(h+2,w+2);
    for i=1:h
        for j=1:w
            if(it(i+1,j+1)==1)
                if(cond2(it(i:i+2,j:j+2))==1)
                    m(i+1,j+1) = 1;
                    C = C+1;
                end
            end
        end
    end
    it = it - m;
    if(C==0)
        break;
    end
end

skel = it(2:h+1,2:w+1);



%%%%%%%%%%%%%%%%%% inner function %%%%%%%%%%%%%%%%%%%%%

function b1 = cond1(s) % s: submatrix, 3x3
b1 = 0;
p = [s(2,2),s(1,2),s(1,3),s(2,3),s(3,3),s(3,2),s(3,1),s(2,1),s(1,1)];
B = sum(p) - p(1);
A = 0;
for i=2:8
    if(p(i)==0 && p(i+1)==1)
        A = A + 1;
    end
end
if(p(9)==0 && p(2)==1)
    A = A + 1;
end
if(B>2 &&...
        B<7 &&...
        A==1 &&...
        (p(2)*p(4)*p(6))==0 &&...
        (p(4)*p(6)*p(8))==0)
    b1 = 1;
end

function b2 = cond2(s) % s: submatrix, 3x3
b2 = 0;
p = [s(2,2),s(1,2),s(1,3),s(2,3),s(3,3),s(3,2),s(3,1),s(2,1),s(1,1)];
B = sum(p) - p(1);
A = 0;
for i=2:8
    if(p(i)==0 && p(i+1)==1)
        A = A + 1;
    end
end
if(p(9)==0 && p(2)==1)
    A = A + 1;
end
if(B>2 &&...
        B<7 &&...
        A==1 &&...
        (p(2)*p(4)*p(8))==0 &&...
        (p(2)*p(6)*p(8))==0)
    b2 = 1;
end