#!/bin/env sh

# Author: BlueMiaomiao
# E-mail: xv2017@outlook.com
# GitHub: bluemiaomiao.github.io
# Desc  : Simple Computer Design

FIR_NUM=`echo $1 | awk -F '+|-|*|/' '{print $1}'`
SEC_NUM=`echo $1 | awk -F '+|-|*|/' '{print $2}'`
OPS_SYM=`echo $1 | sed 's/[0-9]//g'`

if [ "$OPS_SYM" == '+' ]
then
   echo "$FIR_NUM + $SEC_NUM = `expr $FIR_NUM + $SEC_NUM`"
elif [ "$OPS_SYM" == '-' ]
then
   echo "$FIR_NUM - $SEC_NUM = `expr $FIR_NUM - $SEC_NUM`"
elif [ "$OPS_SYM" == '*' ]
then
   echo "$FIR_NUM * $SEC_NUM = `expr $FIR_NUM \* $SEC_NUM`"
elif [ "$OPS_SYM" == '/' ]
then
   if [ "$SEC_NUM" == 0 ]
   then
       echo 'Params error.'
   else
       echo "$FIR_NUM ÷ $SEC_NUM = `expr $FIR_NUM / $SEC_NUM`"
   fi
else
   echo 'Syntax error.'
fi
