function paths = find_paths_without_subpaths (G, v_s, v_t)

% this function finds all the paths that don't contain any subpaths from
% vertex v_s to vertex v_t, in the directed graph G.
%
% G is given as a matrix: G(i,j)=1 iff there is an edge i->j, and 0 otherwise. 
% v_s and v_t are given as location indices in the matrix of G.
%
% path a is considered a subpath of path b, if the set of vertices that a
% uses is a subset of the set of vertices that b uses.
% for example:
% 1->2->3->5 is a subpath of 1->2->3->4->5,
% and is also a subpath of: 1->3->2->4->5 , 1->2->4->3->5 , 
% 1->3->4->2->5 , 1->4->3->2->5 and 1->4->2->3->5.
% in cases where there are a few cycles such that each is a subpath of the
% others, yet they don't have any other subpaths, the function will
% arbitrarily return only one of them.



% initialization
paths = cell(0);

% finding shortest path
[cost, route] = dijkstra_edge_count(G, v_s, v_t);

if cost == 1
    paths{end+1} = [v_s, v_t];
elseif isinf(cost)
    paths = cell(0);
else
    routes_cell = cell(1);
    routes_cell{1} = route;
    first_steps = route(2);
    while true
        [n,~] = size(G);
        no_first_steps_indices = ones(1,n);
        no_first_steps_indices(first_steps) = 0;
        no_first_steps_indices = find(no_first_steps_indices);
        new_G = G(no_first_steps_indices , no_first_steps_indices);
        [cost, route] = dijkstra_edge_count(new_G, find(no_first_steps_indices == v_s, 1), find(no_first_steps_indices == v_t, 1));
        if isinf(cost)
            break
        end
        first_steps = [first_steps, no_first_steps_indices(route(2))]; %#ok<AGROW>
        routes_cell{end+1} = no_first_steps_indices(route); %#ok<AGROW>
    end
    
    len = length(first_steps);
    for i=1:len
        vertices_to_remove = first_steps([1:(i-1) , (i+1):len]);
        vertices_to_remain = ones(1,n);
        vertices_to_remain(vertices_to_remove) = 0;
        vertices_to_remain = find(vertices_to_remain);
        next_G = G(vertices_to_remain , vertices_to_remain);
        partial_paths = find_paths_without_subpaths (next_G, find(vertices_to_remain == first_steps(i), 1), find(vertices_to_remain == v_t, 1));
        if ~isempty(partial_paths)
            num_paths = length(paths);
            paths{end+length(partial_paths)} = 0;
            for j=1:length(partial_paths)
                current_path = partial_paths{j};
                paths{num_paths + j} = [v_s, vertices_to_remain(current_path)];
            end
        end
    end
end



end



