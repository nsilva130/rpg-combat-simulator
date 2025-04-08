function d100 = D100(mod7,n7)

mod7 = round(mod7);
n7 = abs(round(n7));

fprintf('Rolling %i D100''s with %i modifier. \n',n7,mod7)

d100 = sum(round(rand(1,n7).*99)+1)+mod7;

load('roll.mat')
for i = 1:n7
    pause(1/n7)
    sound(y,Fs)
end

end