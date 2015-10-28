# irstlm-regression-testing
A suite for running regression tests for IRSTLM

CONTENT:

- code: contains scripts for running the tests
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
./src/run-test-suite
[to be completed]

3) Running a single regressions test
[to be completed]

4) Checking what went wrong
[to be completed]

5) Final notes
