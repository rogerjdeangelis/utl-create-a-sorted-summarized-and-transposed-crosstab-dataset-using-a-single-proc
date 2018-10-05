Create a sorted summarized and transposed crosstab dataset using a single proc

  Two Solutions

      1. proc corresp
      2. proc report

github
https://tinyurl.com/ycxosns8
https://github.com/rogerjdeangelis/utl-create-a-sorted-summarized-and-transposed-crosstab-dataset-using-a-single-proc

SAS Forum
https://communities.sas.com/t5/SAS-Programming/Proc-freq-output/m-p/501935


INPUT
=====

 WORK.HAVE total obs=8

   Y    X

   A    6
   A    6
   A    2
   B    2
   B    3
   C    2
   C    3
   C    5


EXAMPLE OUTPUTS
---------------

 1. proc corresp

   WORK.WANT_COR total obs=4

   LABEL    _2    _3    _5    _6    SUM

    A        1     0     0     2     3
    B        1     1     0     0     2
    C        1     1     1     0     3
    Sum      3     2     1     2     8

 2. proc report

    WORK.WANT_RPT total obs=4

    Y    _2    _3    _5    _6    TOTAL

    A     1     .     .     2      3
    B     1     1     .     .      2
    C     1     1     1     .      3
          3     2     1     2      8

PROCESS
=======

   1. proc corresp

      ods exclude all;
      ods output observed=want_cor;
      proc corresp data=have observed dim=1 ;
      table y, x;
      run;quit;
      ods select all;

   2. proc report

      proc report data=have missing
            /* vars are always in apphabetical order */
            out=want_rpt(rename=(
             _C2_=_2 _C3_=_3 _C4_=_5 _C5_=_6));
      cols y x total;
      define y / group;
      define x / sum across;
      define total / computed;
      rbreak after / summarize;
      compute total;
        total=sum(_c2_,_c3_,_c4_,_c5_);
      endcomp;
      run;quit;

OUTPUTS
=======

see above

 *                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

data have ;

  input y$ x;

cards4;
A 6
A 6
A 2
B 2
B 3
C 2
C 3
C 5
;;;;
run;quit;


