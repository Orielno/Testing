function Testing_HM

% G = [0,0,1;
%     1,0,0;
%     0,0,0]
% paths = find_paths_without_subpaths (G, 2, 3);
% paths{1}


% G = [0,1,0;
%     1,0,1;
%     1,1,0]
% G = [0,1,0;
%     1,0,0;
%     0,0,0];
% G = [0,0,1,1,0;
%     0,0,1,0,1;
%     1,0,0,1,0;
%     0,0,0,1,0;
%     0,0,0,0,1]
% G = [0,0,0,0,1;
%     0,0,0,0,1;
%     0,0,0,0,0;
%     0,0,0,0,0;
%     1,1,0,0,0]
% G = [0,0,1,0,1;
%     0,0,0,1,1;
%     1,0,0,0,1;
%     0,1,0,0,0;
%     1,1,0,0,0]

% G = [0,0,1,1,0;
%     1,0,1,0,0;
%     0,1,0,0,0;
%     0,1,0,1,1;
%     0,0,1,0,0]

% G = [0,0,0,0,1;
%     0,0,1,0,0;
%     0,0,0,0,0;
%     1,0,0,1,0;
%     0,0,0,0,0]

% G = floor(rand(25)*1.2);
% 
% %cycles = find_2_cycles (G);
% cycles = find_cycles_without_subcycles (G);
% for i=1:length(cycles)
%     cycles{i}
% end



% --- Testing "dijkstra_edge_count" ---
%
% G = [0,0,1;
%     1,0,0;
%     0,0,0];
% 
% G = [0,1,1,0,0;
%     1,0,0,0,0;
%     0,0,0,1,0;
%     1,1,0,0,1;
%     0,0,0,0,0];
% 
% G = [0,0,1,0,0;
%     1,1,0,0,0;
%     0,0,0,0,1;
%     0,0,0,0,1;
%     0,0,0,0,0];
% 
% G = floor(rand(20)*1.3)
% 
% %[cost, route] = dijkstra(G, 2, 3);
% [cost, route] = dijkstra_edge_count(G, 7, 8);
% cost
% route




% G = [0,1,1,0,0;
%     1,0,0,1,1;
%     1,0,0,1,1;
%     1,0,0,0,0;
%     1,0,0,0,0];

G = floor(rand(8)*1.3);
for i=1:length(G)
    G(i,i) = 0;
end
G

%V = 1;
%cycles = find_cycles_without_subcycles_with_vertex (G, V);
cycles = find_cycles_without_subcycles_2 (G);
for i=1:length(cycles)
    cycles{i}
end






end
