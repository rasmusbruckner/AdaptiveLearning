% al_runAllTests: This script runs all tests at once

% Run all tests
% -------------

% Ref for timing
ref = GetSecs();

% Tests
resultUnitTests = runtests("al_unittests");
resultTaskDataMain = runtests("al_testTaskDataMain");
resultsCommonConfetti = runtests("al_commonConfettiIntegrationTest");
resultsSleep = runtests("al_sleepIntegrationTest");

% Show test results
disp(resultUnitTests)
disp(resultTaskDataMain)
disp(resultsCommonConfetti)
disp(resultsSleep)

% Inform user about timing
% ------------------------

testLength = GetSecs() - ref;
t = seconds(testLength);
t.Format = 'hh:mm:ss.SSS';
fprintf('Total test time: %s', evalc('disp(t)'))
