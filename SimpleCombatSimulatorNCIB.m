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
% counting how many each creature won. 

% This latest version adds a reference document that creatures can be
% loaded from based on a name or index number. Additionally, it allows for
% custom creatures to be saved to the reference document after entry.

%--------------------------------------------------------------------------%
%---------------------------- BEASTIARY ----------------------------------%
%--------------------------------------------------------------------------%
% Some suggested creatures for use with this simulator are listed below, and are also included in the beastiary storage cell array 
% (Scroll down to line 112 for actual program start):

% Ape
% HP (Hit Points): 19
% AC (Armor Class): 12
% Initiative Modifier: 2
% Number of attacks per round: 2
% Attack roll modifier: 5
% Damage die size: 6
% Number of damage dice: 1
% Damage modifier: 3

% Awakened_Tree
% HP (Hit Points): 59
% AC (Armor Class): 13
% Initiative Modifier: -2
% Number of attacks per round: 1
% Attack roll modifier: 6
% Damage die size: 6
% Number of damage dice: 3
% Damage modifier: 4

% Commoner
% HP (Hit Points): 4
% AC (Armor Class): 10
% Initiative Modifier: 0
% Number of attacks per round: 1
% Attack roll modifier: 2
% Damage die size: 4
% Number of damage dice: 1
% Damage modifier: 0

% Goblin
% HP (Hit Points): 7
% AC (Armor Class): 15
% Initiative Modifier: 2
% Number of attacks per round: 1
% Attack roll modifier: 4
% Damage die size: 6
% Number of damage dice: 1
% Damage modifier: 2

% Hill_Giant
% HP (Hit Points): 105
% AC (Armor Class): 13
% Initiative Modifier: -1
% Number of attacks per round: 2
% Attack roll modifier: 8
% Damage die size: 8
% Number of damage dice: 3
% Damage modifier: 5

% Kenku
% HP (Hit Points): 13
% AC (Armor Class): 13
% Initiative Modifier: 3
% Number of attacks per round: 1
% Attack roll modifier: 5
% Damage die size: 6
% Number of damage dice: 1
% Damage modifier: 3

% Knight
% HP (Hit Points): 52
% AC (Armor Class): 18
% Initiative Modifier: 0
% Number of attacks per round: 2
% Attack roll modifier: 5
% Damage die size: 6
% Number of damage dice: 2
% Damage modifier: 3

% Zombie
% HP (Hit Points): 22
% AC (Armor Class): 8
% Initiative Modifier: -2
% Number of attacks per round: 1
% Attack roll modifier: 3
% Damage die size: 6
% Number of damage dice: 1
% Damage modifier: 1

%--------------------------------------------------------------------------%

clear all
close all
clc

load('beastiary.mat') % Load creature reference dictionary


c1index = lower(input('Load creature 1 from beastiary (y/n): ','s'));
if c1index == 'y'
    c1nindex = input('Input name/index# of creature to load: ','s');
    c1nindex = upper(c1nindex);
    c1call = 0; %initialize locator
    c1call = find(strcmp(beastiary, c1nindex)); %attempt to locate specified creature
    c1call = ceil(c1call/10); %Divide value by number of rows in array and round up
    if size(c1call) > 0
        fprintf('Successfully located creature "%s". Now loading as first creature. \n',c1nindex)
        pause(1)
        c1name = beastiary{2,c1call};
        c1hp = beastiary{3,c1call};
        c1ac = beastiary{4,c1call};
        c1imod = beastiary{5,c1call};
        c1attn = beastiary{6,c1call};
        c1amod = beastiary{7,c1call};
        c1ddie = beastiary{8,c1call};
        c1ddien = beastiary{9,c1call};
        c1dmod = beastiary{10,c1call};
        fprintf('Creature 1 name: %s \n',c1name)
        fprintf('Creature 1 HP (hit points): %i \n',c1hp)
        fprintf('Creature 1 AC (armor class): %i \n',c1ac)
        fprintf('Creature 1 initiative modifier: %i \n',c1imod)
        fprintf('Creature 1 number of attacks: %i \n',c1attn)
        fprintf('Creature 1 attack modifier: %i \n',c1amod)
        fprintf('Creature 1 damage die size: %i \n',c1ddie)
        fprintf('Creature 1 number of damage dice: %i \n',c1ddien)
        fprintf('Creature 1 damage modifier: %i \n',c1dmod)
        pause(3)
    else
        fprintf('Error finding creature "%s". Defaulting to manual entry. \n',c1nindex)
        pause(1)
        c1name = upper(input('Input first creature''s name: ','s')); %Input creature 1 name
        c1hp = input('Input first creature''s HP (hit points): '); %|| creature 1 HP, how durable it is
        c1ac = input('Input first creature''s AC (armor class): '); %|| creature 1 AC, how resistant to damage it is
        c1imod = input('Input first creature''s initiative modifier: '); %|| creature 1 initiative modifier, how fast it is
        c1attn = input('Input number of first creature''s attacks per round: '); %|| creature 1 number of attacks per round, how skilled it is
        c1amod = input('Input first creature''s attack modifier: '); %|| creature 1 attack roll modifier, how accurate it is
        clddie = input('Input first creature''s damage die size: '); %|| creature 1 damage die size, how strong it is
        clddien = input('Input number of first creature''s damage dice: '); %|| creature 1 number of damage dice per attack, how brutal it is
        c1dmod = input('Input first creature''s damage modifier: '); %|| creature 1 damage roll modifier, how consistent its attack is
        c1save = input('Save custom beastiary entry (y/n): ','s');
        
        if c1save == 'y' % If yes, update and save beastiary
            beastiary{1,end+1} = strcat('I',num2str((max(size(beastiary))))); %Create new column in beastiary and label with index number
            beastiary{2,end} = upper(c1name);
            beastiary{3,end} = c1hp;
            beastiary{4,end} = c1ac;
            beastiary{5,end} = c1imod;
            beastiary{6,end} = c1attn;
            beastiary{7,end} = c1amod;
            beastiary{8,end} = clddie;
            beastiary{9,end} = clddien;
            beastiary{10,end} = c1dmod;
            save('beastiary.mat',beastiary)
        end
    end
else %Get custom creature information
    c1name = upper(input('Input first creature''s name: ','s')); %Input creature 1 name
    c1hp = input('Input first creature''s HP (hit points): '); %|| creature 1 HP, how durable it is
    c1ac = input('Input first creature''s AC (armor class): '); %|| creature 1 AC, how resistant to damage it is
    c1imod = input('Input first creature''s initiative modifier: '); %|| creature 1 initiative modifier, how fast it is
    c1attn = input('Input number of first creature''s attacks per round: '); %|| creature 1 number of attacks per round, how skilled it is
    c1amod = input('Input first creature''s attack modifier: '); %|| creature 1 attack roll modifier, how accurate it is
    clddie = input('Input first creature''s damage die size: '); %|| creature 1 damage die size, how strong it is
    clddien = input('Input number of first creature''s damage dice: '); %|| creature 1 number of damage dice per attack, how brutal it is
    c1dmod = input('Input first creature''s damage modifier: '); %|| creature 1 damage roll modifier, how consistent its attack is
    c1save = input('Save custom beastiary entry (y/n): ','s');
        
    if c1save == 'y' % If yes, update and save beastiary
        beastiary{1,end+1} = strcat('I',num2str((max(size(beastiary))))); %Create new column in beastiary and label with index number
        beastiary{2,end} = upper(c1name);
        beastiary{3,end} = c1hp;
        beastiary{4,end} = c1ac;
        beastiary{5,end} = c1imod;
        beastiary{6,end} = c1attn;
        beastiary{7,end} = c1amod;
        beastiary{8,end} = clddie;
        beastiary{9,end} = clddien;
        beastiary{10,end} = c1dmod;
        save('beastiary.mat',beastiary)
    end

end

pause(2) % Split up creature 1 and creature 2 stat input
clc % Clear window for creature 2 input

c2index = lower(input('Load creature 2 from beastiary (y/n): ','s'));
if c2index == 'y'
    c2nindex = input('Input name/index# of creature to load: ','s');
    c2nindex = upper(c2nindex);
    c2call = 0; %initialize locator
    c2call = find(strcmp(beastiary, c2nindex)); %attempt to locate specified creature
    c2call = ceil(c2call/10); %Divide value by number of rows in array and round up
    if size(c2call) > 0
        fprintf('Successfully located creature "%s". Now loading as second creature. \n',c2nindex)
        pause(1)
        c2name = beastiary{2,c2call};
        c2hp = beastiary{3,c2call};
        c2ac = beastiary{4,c2call};
        c2imod = beastiary{5,c2call};
        c2attn = beastiary{6,c2call};
        c2amod = beastiary{7,c2call};
        c2ddie = beastiary{8,c2call};
        c2ddien = beastiary{9,c2call};
        c2dmod = beastiary{10,c2call};
        fprintf('Creature 2 name: %s \n',c2name)
        fprintf('Creature 2 HP (hit points): %i \n',c2hp)
        fprintf('Creature 2 AC (armor class): %i \n',c2ac)
        fprintf('Creature 2 initiative modifier: %i \n',c2imod)
        fprintf('Creature 2 number of attacks: %i \n',c2attn)
        fprintf('Creature 2 attack modifier: %i \n',c2amod)
        fprintf('Creature 2 damage die size: %i \n',c2ddie)
        fprintf('Creature 2 number of damage dice: %i \n',c2ddien)
        fprintf('Creature 2 damage modifier: %i \n',c2dmod)
        pause(3)
    else
        fprintf('Error finding creature "%s". Defaulting to manual entry. \n',c2nindex)
        pause(1)
        c2name = upper(input('Input second creature''s name: ','s')); %Input creature 2 name
        c2hp = input('Input second creature''s HP (hit points): '); %|| creature 2 HP, how durable it is
        c2ac = input('Input second creature''s AC (armor class): '); %|| creature 2 AC, how resistant to damage it is
        c2imod = input('Input second creature''s initiative modifier: '); %|| creature 2 initiative modifier, how fast it is
        c2attn = input('Input number of second creature''s attacks per round: '); %|| creature 2 number of attacks per round, how skilled it is
        c2amod = input('Input second creature''s attack modifier: '); %|| creature 2 attack roll modifier, how accurate it is
        c2ddie = input('Input second creature''s damage die size: '); %|| creature 2 damaged die size, how strong it is
        c2ddien = input('Input number of second creature''s damage dice: '); %|| creature 2 number of damage dice, how brutal it is
        c2dmod = input('Input second creature''s damage modifier: '); %|| creature 2 damage roll modifier, how consistent its attack is
    end
else %Get custom creature information
    c2name = upper(input('Input second creature''s name: ','s')); %Input creature 2 name
    c2hp = input('Input second creature''s HP (hit points): '); %|| creature 2 HP, how durable it is
    c2ac = input('Input second creature''s AC (armor class): '); %|| creature 2 AC, how resistant to damage it is
    c2imod = input('Input second creature''s initiative modifier: '); %|| creature 2 initiative modifier, how fast it is
    c2attn = input('Input number of second creature''s attacks per round: '); %|| creature 2 number of attacks per round, how skilled it is
    c2amod = input('Input second creature''s attack modifier: '); %|| creature 2 attack roll modifier, how accurate it is
    c2ddie = input('Input second creature''s damage die size: '); %|| creature 2 damaged die size, how strong it is
    c2ddien = input('Input number of second creature''s damage dice: '); %|| creature 2 number of damage dice, how brutal it is
    c2dmod = input('Input second creature''s damage modifier: '); %|| creature 2 damage roll modifier, how consistent its attack is
end

pause(2)
clc

disp('Initializing starting values.')

% Initialize script and request inputs
reset1 = c1hp; %Set a reset value for creature 1 HP
reset2 = c2hp;

w1 = 0; % Track number of wins for each
w2 = 0;

cis = '0'; % Initialize string variable for number of combats

pause(1)

c = input('Input number of simulations to run for these two creatures: '); % Request number of combats to run
clog = input('Log combat simulations (y/n): ','s'); % Request if log files are desired for simulations. WARNING: THIS WILL LOG EVERY COMBAT.

for ci = 1:c % Run C combats between creature 1 and creature 2

tic % Begin timing
    
init1 = 0; % Initialize initiatve tracker
init2 = 0;

r = 1; % Initialize number of rounds and turns
turns = 0;

t = 1; % Initialize turn number


if clog == 'y' % Check if set to log combat
cis = num2str(ci); % Begin logging combat in new file
name = strcat(c1name,'_VS_',c2name,'_Combat_',cis,'.log'); % Name log file based on names of creatures fighting and combat set number
diary(name)
diary on % Begin logging
else
end

c1hp = reset1; %Reset HP of creature 1 and creature 2
c2hp = reset2;

attack = 0; % Initialize attack and damage tracker
damage = 0;
damage1 = 0; % Damage done by creature 1
damage2 = 0; % Damage done by creature 2
attack1 = 0; % Attacks hit by creature 1
attack2 = 0; % Attacks hit by creature 2

tracker = 1; % Track if combat is still going on, initialized at 1

clc % Clear command window for combat

fprintf('%s VS %s, Set %i, Combat commence! \n',c1name,c2name,ci) % Display combatant names and which set of combat they are fighting in.
pause(0.5)

% Roll for initiative, to see who goes first
disp('ROLL FOR INITIATIVE!')
pause(1)
init1 = D20(c1imod,1); % Roll 1d20 + creature 1 initiative modifier
init2 = D20(c2imod,1); % Roll 1d20 + creature 2 initiative modifier

if init1 > init2 % If creature 1 wins roll-off
    t = 1; % Creature 1 goes first
    fprintf('%s won the initiative with a %i against %s''s %i. \n',c1name,init1,c2name,init2) % Display that creature 1 won roll-off
elseif init1 == init2 % If they tie roll-off
    if c1imod > c2imod % Check if creature 1 initiative modifier is greater than creature 2 initiative modifier
        t = 1; % Creature 1 goes first
        fprintf('%s and %s tied for initiative at %i, but %s won because they have the higher initiative modifier of %i against %s''s %i. \n',c1name,c2name,init1,c1name,c1imod,c2name,c2imod) % Display contested passive check and result of creature 1 going first
    elseif c1imod < c2imod % Check if creature 2 initiative modifier is greater than creature 1 initiative modifier
        t = 2; % Creature 2 goes first
        fprintf('%s and %s tied for initiative at %i, but %s won because they have the higher initiative modifier of %i against %s''s %i. \n',c1name,c2name,init2,c2name,c2imod,c1name,c1imod) % Display contested passive check and result of creature 2 going first
    elseif c1imod == c2imod %If both creatures are perfectly tied in roll and modifier
        t = 1; % Default to creature 1 as winner, creature 1 goes first
        disp('A perfect tie for initiative.')
        fprintf('Defaulting to %s as winner.',c1name) 
    end
elseif init1 < init2 % If creature 2 wins roll-off
    t = 2; % Creature 2 goes first
    fprintf('%s won the initiative with a %i against %s''s %i. \n',c2name,init2,c1name,init1) % Display that creature 2 won roll-off
end

while tracker == 1 % While combat is ongoing
    if c1hp <= 0 || c2hp <= 0 % If either creature reaches an HP value equal to or less than 0, end the combat. Else, continue fighting.
        tracker = 0; % Stop combat loop
        disp('Combat over.')
        pause(1)
    else    
    fprintf('Round %i. \n',1+floor(turns/2)) %Display combat time information
    pause(1)
    
% Begin creature 1 turn
    if t == 1 % If it's creature 1's turn
        fprintf('%s''s turn. \n',c1name) % Announce turn
        pause(0.5)
        for i = 1:c1attn % Loop attack sequence for creature 1 a number of times equal to their number of attacks
            fprintf('%s makes attack number %i. \n',c1name,i) % Anounce attack number in sequence
            attack = D20(c1amod,1); % Roll attack roll, 1d20 + creature 1 attack modifier
            pause(1)
           if attack-c1amod == 20 % If the attack roll was a 20 without the modifier
               disp('Natural 20, automatic critical hit! Double damage dice.') % Automatic hit, critical damage
               damage = DN(c1dmod,c1ddien*2,c1ddie); % Roll critical damage roll, creature 1 doubled number damage dice + creature 1 damage modifier
               damage1 = damage1+damage; % Increase damage tracker 1 by amount of damage dealt
               attack1 = attack1+1; % Increase hit tracker 1 by 1
               c2hp = c2hp-damage; % Deal damage to creature 2
               pause(0.5)
               fprintf('They dealt %i damage. \n',damage) % Relay amount of damage dealt
           else
               if attack-c1amod == 1 % If the attack roll was 1 without the modifier
               disp('Natural 1, automatic miss!') % Attack automatically misses
               else
                   if attack >= c2ac % If the attack roll with the modifier is greater than or equal to creature 2's AC
                       fprintf('%s rolled %i to hit %s. They make contact! \n',c1name,attack,c2name) % Attack hits
                       damage = DN(c1dmod,c1ddien,c1ddie); % Roll damage roll, creature 1 number of damage dice + creature 1 damage modifier
                       damage1 = damage1+damage; % Increase damage tracker 1 by amount of damage dealt
                       attack1 = attack1+1; % Increase hit tracker 1 by 1
                       c2hp = c2hp-damage; % Deal damage to creature 2
                       pause(0.5)
                       fprintf('They dealt %i damage. \n',damage) % Relay amount of damage dealt
                   else
                       fprintf('%s rolled %i to hit %s. They miss. \n',c1name,attack,c2name) % If no other requirements are met, attack roll misses
                   end
               end
               
           end
            
        end
        t = 2; % Set turn to creature 2
        turns = turns+1; % Add 1 to turn total counter
        pause(0.5)
        
% Begin creature 2 turn
    elseif t == 2 % If it's creature 2's turn
        fprintf('%s''s turn. \n',c2name) % Anounce turn
        pause(0.5)
        for i = 1:c2attn % Loop attack sequence for creature 2 a number of times equal to their number of attacks
            fprintf('%s makes attack number %i. \n',c2name,i) % Anounce attack number in sequence
            attack = D20(c2amod,1); % Roll attack roll, 1d20 + creature 2 attack modifier
            pause(1)
           if attack-c2amod == 20 % If the attack roll was a 20 without the modifier
               disp('Natural 20, automatic critical hit! Double damage dice') % Automatic hit, critical damage
               damage = DN(c2dmod,c2ddien*2,c2ddie); % Roll critical damage roll, creature 2 doubled number damage dice + creature 2 damage modifier
               damage2 = damage2+damage; % Increase damage tracker 2 by amount of damage dealt
               attack2 = attack2+1; % Increase hit tracker 2 by 1
               c1hp = c1hp-damage; % Deal damage to creature 1
               pause(0.5)
               fprintf('They dealt %i damage. \n',damage) % Relay amount of damage dealt
           else
               if attack-c2amod == 1 % If the attack roll was 1 without the modifier
               disp('Natural 1, automatic miss!') % Attack automatically misses
               else
                   if attack >= c1ac % If the attack roll with the modifier is greater than or equal to creature 2's AC
                       fprintf('%s rolled %i to hit %s. They make contact! \n',c2name,attack,c1name) % Attack hits
                       damage = DN(c2dmod,c2ddien,c2ddie); % Roll damage roll, creature 2 number of damage dice + creature 2 damage modifier
                       damage2 = damage2+damage; % Increase damage tracker 2 by amount of damage dealt
                       attack2 = attack2+1; % Increase hit tracker 2 by 1
                       c1hp = c1hp-damage; % Deal damage to creature 1
                       pause(0.5)
                       fprintf('They dealt %i damage. \n',damage) % Relay amount of damage dealt
                   else
                       fprintf('%s rolled %i to hit %s. They miss. \n',c2name,attack,c1name) % If no other requirements are met, attack roll misses
                   end
               end
               
           end
            
        end
          
        
        
        t = 1; % Set turn to creature 1
        turns = turns+1; % Add 1 to turn total counter
        pause(0.5)
    
    end
    
    end
    
end
if c1hp <= 0 % If creature 1 death was the reason the fight ended
        fprintf('%s wins the fight! \n',c2name) % Display creature 2 as winner
        pause(1)
        w2 = w2+1; % Increase win tracker 2 by 1
        fprintf('It survived with %i HP left. \n',c2hp) % Display amount of health creature 2 ended with
elseif c2hp <= 0 % If creature 2 death was the reason the fight ended
        fprintf('%s wins the fight! \n',c1name) % Display creature 1 as winner
        pause(1)
        w1 = w1+1; % Increase win tracker 1 by 1
        fprintf('It survived with %i HP left. \n',c1hp) % Display amount of health creature 1 ended with
end
r = 1 + floor(turns/2); % Get amount of total rounds passed. Amount is equal to 1 + half the number of turns played rounded down.
pause(1)

fprintf('This result took %i rounds of combat (total of %i turns) to approach. \n',r,turns) % Display number of rounds and turns taken to reach result
pause(1)
fprintf('%s dealt a total of %i damage across %i attacks hit. \n',c1name,damage1,attack1) % Display attacks hit and damage dealt by creature 1
pause(1)
fprintf('%s dealt a total of %i damage across %i attacks hit. \n',c2name,damage2,attack2) % Display attacks hit and damage dealt by creature 2
pause(1)
toc % Stop timing
diary off % Stop logging combat

% Announce end of loop
fprintf('Saving and initializing')  % Activate "..." sequence
pause(1)
fprintf('.')
pause(1)
fprintf('.')
pause(1)
fprintf('.')
pause(2)
fprintf('\n') %line break

end

fprintf('Of %i combat simulations, %s won %i and %s won %i. \n',c,c1name,w1,c2name,w2) % Display number of wins for both creatures during the number of combats simulated.