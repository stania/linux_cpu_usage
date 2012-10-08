RES=3600
END=$((`date +%s`/$RES*$RES))

rrdtool graph test.png --end $END --start end-4d --width=600 \
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
	CDEF:23_usage_avg=23_cpu0,23_cpu1,2,AVG \
	CDEF:24_cpu0=24_user0,24_sys0,+ \
	CDEF:24_cpu1=24_user1,24_sys1,+ \
	CDEF:24_usage_avg=24_cpu0,24_cpu1,2,AVG \
	"LINE1:23_usage_avg#4572A7:23_usage_avg\l" \
	"LINE1:24_usage_avg#AA4643:24_usage_avg\l"
