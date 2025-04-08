%This program simulates combat between two creatures for the 5th edition of
%the D&D tabletop RPG. This version of the simulator does not take into
%account any special abilities or distances, advantages or disadvantages.
%It only calculates the probability of hits and the damage dealt each
%round, each only allowed one kind of damage dice. A "slugfest" calculation.

% The basic rules for how combat with this game works is that creatures and
% characters have different numerical values that are abstractions of their
% durability and ability to deal damage. The first creature, having the
% highest "initiative", gets to go first. It makes its attacks by rolling a
% 20-sided die and then adding its attack modifier to the number rolled. If
% that value is equal to or great than the second creature's AC (armor
% class), then the attack hits. The first creature then rolls its damage
% dice and adds its damage modifier. The total of this calculation is how
% much HP (hit points) the second creature loses. The second creature then
% gets to make its attacks. The combat will end when one of the creatures
% is reduced to zero HP.

% The program is capable of simulating multiple sequences of combat and
% counting how many each creature won. It will also log each individual
% combat.

% This latest version marks when more comments were added to the code such
% that anyone may understand what each line is accomplishing. Each creature
% is now labeled by name in the combat.

clear all
close all
clc


% Initialize script and request inputs

c1name = input('Input first creature''s name: ','s'); %Input creature 1 name
c1hp = input('Input first creature''s HP (hit points): '); %|| creature 1 HP
reset1 = c1hp; %Set a reset value for creature 1 HP
c1ac = input('Input first creature''s AC (armor class): '); %|| creature 1 AC
c1attn = input('Input number of first creature''s attacks per round: '); %|| creature 1 number of attacks per round
c1amod = input('Input first creature''s attack modifier: '); %|| creature 1 attack roll modifier
clddie = input('Input first creature''s damage die size: '); %|| creature 1 damage die size
clddien = input('Input number of first creature''s damage dice: '); %|| creature 1 number of damage dice per attack
c1dmod = input('Input first creature''s damage modifier: '); %|| creature 1 damage roll modifier

c2name = input('Input second creature''s name: ','s'); %Input creature 2 name
c2hp = input('Input second creature''s HP (hit points): '); %|| creature 2 HP
reset2 = c2hp; %Set a reset value for creature 2 HP
c2ac = input('Input second creature''s AC (armor class): '); %|| creature 2 AC
c2attn = input('Input number of second creature''s attacks per round: '); %|| creature 2 number of attacks per round
c2amod = input('Input second creature''s attack modifier: '); %|| creature 2 attack roll modifier
c2ddie = input('Input second creature''s damage die size: '); %|| creature 2 damaged die size
c2ddien = input('Input number of second creature''s damage dice: '); %|| creature 2 number of damage dice
c2dmod = input('Input second creature''s damage modifier: '); %|| creature 2 damage roll modifier

w1 = 0; %Track number of wins for each
w2 = 0;

cis = '0'; %Initialize string variable for number of combats

c = input('Input number of simulations to run for these two creatures: '); %Request number of combats to run


for ci = 1:c %Run C combats between creature 1 and creature 2

tic %begin timing
    

r = 1; %initialize number of rounds and turns
t = 1; 

cis = num2str(ci); %Begin logging combat in new file
name = strcat(c1name,'_VS_',c2name,'_Combat_',cis,'.log'); 
diary(name)
diary on

c1hp = reset1; %Reset HP of creature 1 and creature 2
c2hp = reset2;

attack = 0; %initialize attack and damage tracker
damage = 0;
damage1 = 0; %damage done by creature 1
damage2 = 0; %damage done by creature 2
attack1 = 0; %attacks hit by creature 1
attack2 = 0; %attacks hit by creature 2

tracker = 1; %track if combat is still going on, initialized at 1

clc %clear command window for combat

fprintf('%s VS %s, Set %i, Combat commence! \n',c1name,c2name,ci)


while tracker == 1
    if c1hp <= 0 || c2hp <= 0 %if either creature reaches an HP value equal to or less than 0, end the combat. Else, continue fighting.
        tracker = 0; %stop combat loop
        disp('Combat over.')
        pause(1)
    else    
    fprintf('Round %i, Turn %i. \n',r,t) %Display combat time information
    pause(1)
    
% Begin creature 1 turn
    if t == 1
        fprintf('%s''s turn. \n',c1name)
        pause(0.5)
        for i = 1:c1attn
            fprintf('%s makes attack number %i. \n',c1name,i)
            attack = D20(c1amod,1);
            pause(1)
           if attack-c1amod == 20
               disp('Natural 20, automatic critical hit! Double damage dice')
               damage = DN(c1dmod,clddien*2,clddie);
               damage1 = damage1+damage;
               attack1 = attack1+1;
               c2hp = c2hp-damage;
               pause(0.5)
               fprintf('They dealt %i damage. \n',damage)
           else
               if attack-c1amod == 1
               disp('Natural 1, automatic miss!')
               else
                   if attack >= c2ac
                       fprintf('%s rolled %i to hit %s. They make contact! \n',c1name,attack,c2name)
                       damage = DN(c1dmod,clddien,clddie);
                       damage1 = damage1+damage;
                       attack1 = attack1+1;
                       c2hp = c2hp-damage;
                       pause(0.5)
                       fprintf('They dealt %i damage. \n',damage)
                   else
                       fprintf('%s rolled %i to hit %s. They miss. \n',c1name,attack,c2name)
                   end
               end
               
           end
            
        end
        t = 2;
        pause(0.5)
        
% Begin creature 2 turn
    elseif t == 2 
        fprintf('%s''s turn. \n',c2name)
        for i = 1:c2attn
            fprintf('%s makes attack number %i. \n',c2name,i)
            attack = D20(c2amod,1);
            pause(1)
           if attack-c2amod == 20
               disp('Natural 20, automatic critical hit! Double damage dice')
               damage = DN(c2dmod,c2ddien*2,c2ddie);
               damage2 = damage2+damage;
               attack2 = attack2+1;
               c1hp = c1hp-damage;
               pause(0.5)
               fprintf('They dealt %i damage. \n',damage)
           else
               if attack-c2amod == 1
               disp('Natural 1, automatic miss!')
               else
                   if attack >= c1ac
                       fprintf('%s rolled %i to hit %s. They make contact! \n',c2name,attack,c1name)
                       damage = DN(c2dmod,c2ddien,c2ddie);
                       damage2 = damage2+damage;
                       attack2 = attack2+1;
                       c1hp = c1hp-damage;
                       pause(0.5)
                       fprintf('They dealt %i damage. \n',damage)
                   else
                       fprintf('%s rolled %i to hit %s. They miss. \n',c2name,attack,c1name)
                   end
               end
               
           end
            
        end
          
        
        
        t = 1;
        r = r+1;
        pause(0.5)
    
    end
    
    end
end
if c1hp <= 0
        fprintf('%s wins the fight! \n',c2name)
        pause(1)
        w2 = w2+1;
        fprintf('It survived with %i HP left. \n',c2hp)
elseif c2hp <= 0
        fprintf('%s wins the fight! \n',c1name)
        pause(1)
        w1 = w1+1;
        fprintf('It survived with %i HP left. \n',c1hp)
end

pause(1)

fprintf('This result took %i rounds of combat (total of %i turns) to approach. \n',r,(r*2)+t)
pause(1)
fprintf('%s dealt a total of %i damage across %i attacks hit. \n',c1name,damage1,attack1)
pause(1)
fprintf('%s dealt a total of %i damage across %i attacks hit. \n',c2name,damage2,attack2)
pause(1)
toc
diary off
disp('Saving data and restarting...')

pause(5)


end

fprintf('Of %i combat simulations, %s won %i and %s won %i. \n',c,c1name,w1,c2name,w2)

