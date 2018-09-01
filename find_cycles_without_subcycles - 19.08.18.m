function cycles = find_cycles_without_subcycles (G)



[num_vertices, ~] = size(G); 

% making sure there are no edges from a vertex to itself
for i=1:num_vertices
    G(i,i) = 0;
end





% Part I - for each vertex i, find all cycles that are paths without 
% subpaths from a vertex i to itself (after we find these for i, we delete
% it so the next cycles won't contain i as well)

% initialization
cycles = cell(0);

for i=num_vertices:-1:2
    % creating a copy of G, with a duplicate of i,
    % such that the original i will have only outgoing edges,
    % and the duplicated i will have only incoming edges.
    G_i = zeros(num_vertices+1 , num_vertices+1);
    G_i(1:num_vertices , 1:num_vertices) = G(:,:);
    G_i(1:num_vertices, num_vertices+1) = G(1:num_vertices, i);
    G_i(1:num_vertices, i) = 0; %zeros(num_vertices, 1);
    
    % finding the cycles (with no subcycles) involving i
    paths = find_paths_without_subpaths (G_i, i, num_vertices+1);
    
    % assigning the cycles found to the cycles cell
    len = length(paths);
    if len > 0
        num_cycles = length(cycles);
        cycles{end+len} = 0;
        for j=1:len
            current_cycle = paths{j};
            current_cycle(end) = i;
            cycles{num_cycles + j} = current_cycle;
        end
    end
    
    % we delete the last (the i'th) vertex from the graph, since we already
    % found all relevant cycles that include vertex i
    num_vertices = num_vertices - 1;
    G = G(1:num_vertices , 1:num_vertices);
end





% Part II - sorting the cycles we found, and deleting those that have subcycles 

% sorting each cycle
for i=1:length(cycles)
    cycles{i} = sort(cycles{i}(1:(end-1)));
end

% sorting the cycles by a lexicographic-like order
cycles = mergesort_cycles(cycles);

% now we can efficiently check for cycles with subcycles
to_delete = [];
for i=2:length(cycles)
    if length(cycles{i-1}) <= length(cycles{i})
        if compare_cycles(cycles{i-1}(1:end) , cycles{i}(1:length(cycles{i-1}))) == 0
            to_delete = [to_delete , i]; %#ok<AGROW>
        end
    end
end
% now we delete those we have found
to_remain = ones(1, length(cycles));
to_remain(to_delete) = 0;
to_remain = find(to_remain);
cycles = cycles(to_remain); %#ok<FNDSB>



    % comparing cycles
    function cmp = compare_cycles (cycle1, cycle2)
        % returns 1 if cycle1 is "smaller", -1 if "bigger", and 0 if identical 
        cmp = 0;
        le1 = length(cycle1);
        le2 = length(cycle2);
        le = min(le1 , le2);
        current = 1;
        while cmp == 0 && current <= le
            if cycle1(current) < cycle2(current)
                cmp = 1;
            elseif cycle1(current) > cycle2(current)
                cmp = -1;
            end
            current = current + 1;
        end
        if cmp == 0
            if le1 < le2
                cmp = 1;
            elseif le1 < le2
                cmp = -1;
            end
        end
    end

    % sorting cycles
    function sorted_cycles = mergesort_cycles(unsorted_cycles)
        
        num = length(unsorted_cycles);
        
        switch num
            case 1
                sorted_cycles = unsorted_cycles;
            case 2
                if compare_cycles(unsorted_cycles{1}, unsorted_cycles{2}) == 1
                    sorted_cycles = unsorted_cycles;
                else
                    sorted_cycles = unsorted_cycles(2:1);
                end
            otherwise
                sorted_cycles1 = mergesort_cycles(unsorted_cycles(1:floor(num/2)));
                sorted_cycles2 = mergesort_cycles(unsorted_cycles((floor(num/2)+1):end));
                % now we merge them
                sorted_cycles = cell(1, num);   % initialization
                pointer1 = 1;
                pointer2 = 1;
                length1 = length(sorted_cycles1);
                length2 = length(sorted_cycles2);
                counter = 1;
                while pointer1 <= length1 && pointer2 <= length2
                    if compare_cycles(sorted_cycles1{pointer1}, sorted_cycles2{pointer2}) == 1
                        sorted_cycles{counter} = sorted_cycles1{pointer1};
                        pointer1 = pointer1 + 1;
                    else
                        sorted_cycles{counter} = sorted_cycles2{pointer2};
                        pointer2 = pointer2 + 1;
                    end
                    counter = counter + 1;
                end
                % assigning the remaining
                if pointer1 <= length1
                    for k=pointer1:length1
                        sorted_cycles{counter} = sorted_cycles1{k};
                        counter = counter + 1;
                    end
                elseif pointer2 <= length2
                    for k=pointer2:length2
                        sorted_cycles{counter} = sorted_cycles2{k};
                        counter = counter + 1;
                    end
                end
        end
        
    end





end