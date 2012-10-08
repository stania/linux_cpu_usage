while true; do 
	php -q -f /usr/sslplus/cpu_usage.php 2>&1 < /dev/null > /dev/null
	sleep 4
done
