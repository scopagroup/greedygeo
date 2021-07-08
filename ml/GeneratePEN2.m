function [Penulti] = GeneratePEN2(PEN,G,F,m,Q,mesh,quan)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
pen=PEN;
Penulti=[];
for h1=PEN(1,1):mesh:PEN(1,2)
    pen(1,1)=h1;
    pen(1,2)=h1;
    for h2=PEN(2,1):mesh:PEN(2,2)
        pen(2,1)=h2;
        pen(2,2)=h2;
        for h3=PEN(3,1):mesh:PEN(3,2)
            pen(3,1)=h3;
            pen(3,2)=h3;
            
            SET= PENset(pen,mesh);
            QPEN = GeneratePEN1(SET, G, F,m,Q, quan);
            Penulti=[Penulti;QPEN];
        end
    end
end
                
end

