# irstlm-regression-testing
A suite for running regression tests for IRSTLM

CONTENT:

- scripts: contains scripts for running the tests
- tests: contains the actual tests
- data: contains shared data and models used by the tests
- README.md: this file
- README.md: this file

DOCUMENTATION

1) Before Starting
Before starting, you have to do the following operations: 

1.a) Getting data and models [this action should be done just once]
Data and models required to run regression tests are available in the archive "data/irstlm-reg-test-data-2.0.tgz".
Before running your test, please untar the archive into the directory "data", as follows
  pushd data && tar xzf irstlm-reg-test-data-2.0.tgz && popd

Note that data specific to a single regression test are stored in the corresponding directory under "tests"

1.b) Identifying the version of IRSTLM to test
In order to identify which version of the IRSTLM you are going to test, please set the variable IRSTLM equal to the path where 
such a version was installed, as follows:
  . IRSTLM=/path/to/irstlm

2) Running the whole suite of regressions tests
./script/run-test-suite [--data-dir=_path_to_data_] [--test-dir=_path_to_tests_] [--results-dir=_path_to_result_]

Optionally with parameter "--data-dir", you can specify where data and models are located; by default they are located in "data".
Optionally with parameter "--test-dir", you can specify where tests are located; by default they are located in "tests".
Optionally with parameter "--results-dir", you can specify where results of the regression tests will be stored; by default they will be stored in "results".

Please, look at below in case of failure of any test.

Please, do not care too much on the time statistics.


3) Running a single regressions test
./script/run-single-test.pl --test _test_name_ [--data-dir=_path_to_data_] [--test-dir=_path_to_tests_] [--results-dir=_path_to_result_]

Optionally with parameter "--data-dir", you can specify where data and models are located; by default they are located in "data".
Optionally with parameter "--test-dir", you can specify where tests are located; by default they are located in "tests".
Optionally with parameter "--results-dir", you can specify where results of the regression tests will be stored; by default they will be stored in "results".

Please, look at below in case of failure of the test.

To get the list of available regression tests, please run the following command
scripts/run-test-suite --list

4) Checking what went wrong
[to be completed]

5) Final notes
