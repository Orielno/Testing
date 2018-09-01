function cycles = find_cycles_without_subcycles_with_vertex (G, V)

% This function finds all cycles without subcycles in graph G, that include
% vertex V
%
% This function works by recursion, such that when first called upon, V is
% just a single vertex, but during the recursive calls V becomes a path,
% starting with the original V, a path that may or may not end eventually
% in V and thus completing a cycle


% we want to find paths from the source to destination
source = V(end);
destination = V(1);


% Base Case I - we find a cycle
if G(source , destination)
    % then we completed a cycle, and since we don't want cycles with
    % subcycles, we don't look for more cycles in this direction
    cycles = {V};
    return
end


% Base Case II - we determine that this branch will not lead to any cycle
[cost, ~] = dijkstra_edge_count(G, source, destination);
if isinf(cost)
    % if there is no path from source to destination, then there is no hope
    % anymore of completing a cycle
    cycles = cell(0);
    return
end



% Recursion Case - if neither of the base cases have occured
% these are the vertices we can get to from the source vertex
% initialization
cycles = cell(0);
% these will be the next "sources", we get from the current source to them
next_sources = find(G(source , :));
% if it is not the first step of the recursion, we also don't allow it to
% go to any of the vertices that are linked to the current source, it will
% cause finding cycles with subcycles
if length(V) > 1
    to_current_source = G(: , source);
    to_current_source(destination) = 0;   % we don't want to delete the destination vertex (would happen in the second recursive call if it wasn't for this line)
    to_current_source = find(to_current_source);
    G(to_current_source , :) = 0;
    G(: , to_current_source) = 0;
end
for i=1:length(next_sources)
    
    if G(next_sources(i) , source) && length(V) > 1
       % thern we have a subcycle, we don't want to go there
       continue
    end
    
    % we don't allow it to go to any of the sources, it will cause finding
    % cycles with subcycles
    G_i = G;
    G_i(next_sources([1:(i-1) , (i+1):end]) , :) = 0;
    G_i(: , next_sources([1:(i-1) , (i+1):end])) = 0;
    
    % find the cycles without subcycles in this branch
    cycles_s = find_cycles_without_subcycles_with_vertex (G_i, [V , next_sources(i)]);
    % assign them to the cell array
    if ~isempty(cycles_s)
        current_num_cycles = length(cycles);
        cycles{end+length(cycles_s)} = 0;
        for j=1:length(cycles_s)
            cycles{current_num_cycles + j} = cycles_s{j};
        end
    end
    
end



end



