classdef classOptimParam < handle
    % classOptimParam providing parameters for the optimization
    
    properties
        n = 10;         % number of intervals
        tf = 120;       % time to run from 0 to tf
        c1 = 0;
        c2 = 100;         % parameters for objective function
        v0 = 1;
    end
end