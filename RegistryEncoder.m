
n = input('Number of names being added: ');
for i=1:n
    name{2,end+1} = lower(input('Creature name: ','s'));
end

call = input('Input name to call: ','s');

index = find(strcmp(name, call)); % This calls the requested column location from the registry for the name being called