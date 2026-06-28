function delta = my_angdiff(angle1, angle2)
    % ANGLEDIFF Calculates the signed difference between two angles in radians.
    % This version supports scalars, row vectors, and column vectors.
    % The result is wrapped to the interval (-pi, pi].
    
    % MATLAB handles element-wise subtraction and trigonometric functions
    % automatically for arrays of the same size.
    delta = atan2(sin(angle2 - angle1), cos(angle2 - angle1));
end