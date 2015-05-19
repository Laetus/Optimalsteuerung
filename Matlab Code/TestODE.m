function stop = TestODE(x,optimValues,state)

global global_iterationCount global_testingODE

if(optimValues.iteration ~= global_iterationCount)
    global_iterationCount = global_iterationCount+1;
    global_testingODE = 1;
end

stop = 0;

end