function dn = DN(modn,n,size) %function rolls 'n' 'size'-sided dice with a 'modn' modifier

modn = round(modn); %Initialize supplied variables to a usable state
size = abs(round(size));
n = abs(round(n));

    
fprintf('Rolling %i D%i''s with %i modifier. \n',n,size,modn) %display how many dice of each type are being rolled alongside the modifier for each set

dn = sum(round(rand(1,n).*(size-1))+1)+modn; %perform random calculation of dice being rolled, with a minimum roll of 1 on each die roll. Doesn't use randi function in order to receive more randomized results.

load('roll.mat')
for i = 1:n %Play sound for each die dropped
    pause(1/n) %Sound will last a time inversely proportional to the number of dice
    sound(y,Fs)
end

end