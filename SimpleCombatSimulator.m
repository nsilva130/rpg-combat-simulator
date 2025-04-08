%This program simulates combat between two creatures for the 5th edition of
%the D&D tabletop RPG. This version of the simulator does not take into
%account any special abilities or distances, advantages or disadvantages.
%It only calculates the probability of hits and the damage dealt each
%round, each only allowed one kind of damage dice. A "slugfest" calculation.

% The basic rules for how combat with this game works is that creatures and
% characters have different numerical values that are abstractions of their
% durability and ability to deal damage. The first
% creature, having the highest "initiative", gets to go first. It makes its attacks by
% rolling a 20-sided die and then adding its attack modifier to the number rolled. If that value
% is equal to or great than the second creature's AC (armor class), then
% the attack hits. The first creature then rolls its damage dice and adds
% its damage modifier. The total of this calculation is
% how much HP (hit points) the second creature loses. The second creature then gets to
% make its attacks. The combat will end when one of the creatures is
% reduced to zero HP.
clear all
close all
clc
tic

% Initialize script and request inputs

c1hp = input('Input first creature''s HP (hit points): '); %Creature 1 stats
c1ac = input('Input first creature''s AC (armor class): ');
c1attn = input('Input number of first creature''s attacks per round: ');
c1amod = input('Input first creature''s attack modifier: ');
clddie = input('Input first creature''s damage die size: ');
clddien = input('Input number of first creature''s damage dice: ');
c1dmod = input('Input first creature''s damage modifier: ');

c2hp = input('Input second creature''s HP (hit points): '); %Creature 2 stats
c2ac = input('Input second creature''s AC (armor class): ');
c2attn = input('Input number of second creature''s attacks per round: ');
c2amod = input('Input second creature''s attack modifier: ');
c2ddie = input('Input second creature''s damage die size: ');
c2ddien = input('Input number of second creature''s damage dice: ');
c2dmod = input('Input second creature''s damage modifier: ');

r = 1; %initialize number of rounds and turns
t = 1; 

attack = 0; %initialize attack and damage tracker
damage = 0;
damage1 = 0; %damage done by creature 1
damage2 = 0; %damage done by creature 2
attack1 = 0; %attacks hit by creature 1
attack2 = 0; %attacks hit by creature 2

tracker = 1; %track if combat is still going on, initialized at 1

clc

disp('Combat commence!')

while tracker == 1
    if c1hp <= 0 || c2hp <= 0
        tracker = 0;
        disp('Combat over.')
        pause(1)
    else    
    fprintf('Round %i, Turn %i. \n',r,t)
    pause(1)
    
% Begin creature 1 turn
    if t == 1
        disp('Creature 1''s turn.')
        for i = 1:c1attn
            fprintf('Creature %i makes attack number %i. \n',t,i)
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
                       fprintf('Creature %i rolled %i to hit. They make contact! \n',t,attack)
                       damage = DN(c1dmod,clddien,clddie);
                       damage1 = damage1+damage;
                       attack1 = attack1+1;
                       c2hp = c2hp-damage;
                       pause(0.5)
                       fprintf('They dealt %i damage. \n',damage)
                   else
                       fprintf('Creature %i rolled %i to hit. They miss. \n',t,attack)
                   end
               end
               
           end
            
        end
        t = 2;
        pause(0.5)
        
% Begin creature 2 turn
    elseif t == 2 
        disp('Creature 2''s turn.')
        for i = 1:c2attn
            fprintf('Creature %i makes attack number %i. \n',t,i)
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
                       fprintf('Creature %i rolled %i to hit. They make contact! \n',t,attack)
                       damage = DN(c2dmod,c2ddien,c2ddie);
                       damage2 = damage2+damage;
                       attack2 = attack2+1;
                       c1hp = c1hp-damage;
                       pause(0.5)
                       fprintf('They dealt %i damage. \n',damage)
                   else
                       fprintf('Creature %i rolled %i to hit. They miss. \n',t,attack)
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
        disp('Creature 2 wins the fight!')
        pause(1)
        fprintf('It survived with %i HP left. \n',c2hp)
elseif c2hp <= 0
        disp('Creature 1 wins the fight!') 
        pause(1)
        fprintf('It survived with %i HP left. \n',c1hp)
end

pause(1)

fprintf('This result took %i rounds of combat (total of %i turns) to approach. \n',r,(r*2)+t)
pause(1)
fprintf('Creature 1 dealt a total of %i damage across %i attacks hit. \n',damage1,attack1)
pause(1)
fprintf('Creature 2 dealt a total of %i damage across %i attacks hit. \n',damage2,attack2)

toc