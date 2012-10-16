RES=3600
END=$((`date +%s`/$RES*$RES))
OUTFILE=kibo_`date +%F_%H%M%S`.png

rrdtool graph $OUTFILE --end $END --start end-7d --width=600 \
	-x HOUR:6:DAY:1:DAY:1:86400:%F -u 100 \
	DEF:23_user0=kibo/23/cpu_usage_user.rrd:cpu0:MAX \
	DEF:23_user1=kibo/23/cpu_usage_user.rrd:cpu1:MAX \
	DEF:23_sys0=kibo/23/cpu_usage_sys.rrd:cpu0:MAX \
	DEF:23_sys1=kibo/23/cpu_usage_sys.rrd:cpu1:MAX \
	DEF:24_user0=kibo/24/cpu_usage_user.rrd:cpu0:MAX \
	DEF:24_user1=kibo/24/cpu_usage_user.rrd:cpu1:MAX \
	DEF:24_sys0=kibo/24/cpu_usage_sys.rrd:cpu0:MAX \
	DEF:24_sys1=kibo/24/cpu_usage_sys.rrd:cpu1:MAX \
	CDEF:23_cpu0=23_user0,23_sys0,+ \
	CDEF:23_cpu1=23_user1,23_sys1,+ \
	CDEF:23_usage_user_max=23_user0,23_user1,2,AVG \
	CDEF:23_usage_sys_max=23_sys0,23_sys1,2,AVG \
	CDEF:24_cpu0=24_user0,24_sys0,+ \
	CDEF:24_cpu1=24_user1,24_sys1,+ \
	CDEF:24_usage_user_max=24_user0,24_user1,2,AVG \
	CDEF:24_usage_sys_max=24_sys0,24_sys1,2,AVG \
	"LINE1:23_usage_user_max#4572A7:23_usage_user_max\l" \
	"LINE1:23_usage_sys_max#5582b7:23_usage_sys_max\l" \
	"LINE1:24_usage_user_max#AA4643:24_usage_user_max\l" \
	"LINE1:24_usage_sys_max#bA5653:24_usage_sys_max\l"

if [ "$?" -eq 0 ]; then 
	echo $OUTFILE
fi
