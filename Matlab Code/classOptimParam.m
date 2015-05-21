classdef classOptimParam < handle
    % classOptimParam providing parameters for the optimization
    
    properties
        n = 5;         % number of intervals
        tf = 120;       % time to run from 0 to tf
        c1 = 2;         % optimizing consumption
        c2 = 1;       % optimizing street
        v0 = 1;
    end
end