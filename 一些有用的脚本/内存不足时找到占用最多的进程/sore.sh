#!/bin/sh

# 查看系统内存不够时，最可能会kill的进程
dir=`ls -l /proc |awk '/^d/ {print $NF}'`
result_process=0
result_score=0
 
for i in $dir
do
	oom_score=0
	oom_score_adj=0
 
	if [ -f "/proc/$i/oom_score" ]
		then
			oom_score=`cat /proc/$i/oom_score`
	fi
 
	if [ -f "/proc/$i/oom_score_adj" ]
		then
			oom_score_adj=`cat /proc/$i/oom_score_adj`
	fi
 
	process_score=`expr $oom_score + $oom_score_adj`
 
	if [ $i != "1" ] && [ $process_score -gt $result_score ]
		then
			result_score=$process_score
			result_process=$i
	fi
done
 
echo $result_process,$result_score
