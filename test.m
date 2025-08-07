clc;
clear;

% Define the translation and orientation
trans = [0, 0, 0];
orient = [0, 0, 0];

% Define the search space (x, y, z ranges)
x_range = -100:0.5:100; % Example range for x (in mm)
y_range = -100:1:100; % Example range for y (in mm)
z_range = -50:1:50;   % Example range for z (in mm)

reachable_points = []; % Initialize array to store reachable points

% Iterate over all points in the search space
for x = x_range
    for y = y_range
        for z = z_range
            % Set the translation vector to the current point
            trans = [x; y; z];
            
            % Calculate the angles for the current point
            angles = calculate_stewart_platform(11, ...
                                               11, ...
                                               8, ...
                                               8, ...
                                               30 * pi / 180, ...
                                               30 * pi / 180, ...
                                               trans, ...
                                               orient);
            
            % Check if all angles are real
            if all(imag(angles) == 0)
                reachable_points = [reachable_points; x, y, z]; % Add to reachable points
            end
        end
    end
end

% Plot the reachable workspace
if ~isempty(reachable_points)
    % Create a new figure with high resolution and white background
    figure('Position', [100, 100, 800, 600], 'Color', 'w');
    
    % Plot the reachable points with a different marker style and color
    s = scatter3(reachable_points(:, 1), reachable_points(:, 2), reachable_points(:, 3), 80, 'd', 'filled', 'MarkerFaceColor', [0.8, 0.2, 0.2], 'MarkerEdgeColor', 'k');
    
    % Set axis labels with larger font size
    xlabel('X (mm)', 'FontSize', 14);
    ylabel('Y (mm)', 'FontSize', 14);
    zlabel('Z (mm)', 'FontSize', 14);
    
    % Set axis limits
    xlim([-15, 15]);
    ylim([-15, 15]);
    zlim([-30, 15]);
    
    % Set title with larger font size and bold style
    title('Reachable Workspace of Stewart Platform', 'FontSize', 16, 'FontWeight', 'bold');
    
    % Adjust grid properties
    grid on;
    set(gca, 'GridLineStyle', '--', 'GridColor', [0.5, 0.5, 0.5], 'GridAlpha', 0.5);
    
    % Set default 3D view
    view(3);
    
    % Enable interactive rotation
    rotate3d on;
    
    % Add a legend
    legend(s, 'Reachable Points', 'Location', 'best', 'FontSize', 12);
   
    
    
else
    disp('No reachable points found.');
end