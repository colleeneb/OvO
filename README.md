# OmpVal

[![Build Status](https://travis-ci.org/TApplencourt/OmpVal.svg?branch=master)](https://travis-ci.org/TApplencourt/OmpVal)

## How to run

```
Omphval.sh a OpenMP test generator.
Usage:
  omphval.sh gen [--v5]
  omphval.sh run [<test_folder>...]
  omphval.sh display [--working] [--avoid_long_double] [<result_folder>...]
  omphval.sh clean

  Options:
   gen                 Generate the ./tests directory containting all the tests
     v5                  Generate openmp v5 tests (loop construct for example)

   run                 Will run all the test specifier by <test_folder>.
                       The log are stored in the ./results/${uuid}_$(hostname)/<test_folder>/ directory
                       More information are saved in '{compilation,runtime}.log' files of those result folder
                       Use tradional Flags to control the execusion (CXX, CXXFLAGS, MAKEFLAGS, OMP, OMP_TARGET_OFFLOAD, etc)
     <test_folder>       Folder containing the tests to run (default: ./tests/ )

   display             Display the Error message of failling tests.
     <result_folder>     Folder to display (default: ./results/ )
     working             Print only the tests who are passing
     avoid_long_double   Don't print long_double tests. If used in conjunction with working, will not print the working long double if they exit

Example:
  - hierarchical parallelism tests
      CXX='icx' CXXFLAGS='-fiopenmp -fopenmp-targets=spir64=-fno-exceptions' MAKEFLAGS='-j8 --output-sync=target' ./omphval.sh run ./tests/hp_*
  - Display all the non working c++11 math tests who are not of type long_double
      ./omphval.sh diplay --avoid_long_double  results/*/math_cpp11
```

# How to read logs files.

When running with `run`, two log files will be create for each`test_folder`.
 
Only the code who didn't compile or run are printed when using `./run.sh display`.
The error code repported are the one given by `make`. A quick tranlasion table is:

    - `Aborted` : Wrong value
    - `Killed` : Hanging, killed by `killall -9`
    - `Segmentation  fault` : ???
    - `Error 1 (ignored)` : Something else

For more information see the log file and check for the error.

# Where are the tests?!

Check `tests` folder. They can be re-generated by `gen`.
They are generated using the `.jinja2` templates located at `ompval/config/template/`.
If you don't like one test, just remove it. 

# Optional Requirement
 - python 3
 - jinja2
