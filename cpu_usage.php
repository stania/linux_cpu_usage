<?php

function GetCoreInformation() {
        $data = file('/proc/stat');
        $cores = array();
        foreach( $data as $line ) {
                if ( preg_match('/^cpu[0-9]/', $line) )
                {
                        $info = explode(' ', $line);
                        $cores[] = array(
                                'user' => $info[1],
                                'nice' => $info[2],
                                'sys' => $info[3],
                                'idle' => $info[4]
                        );
                }
        }
        return $cores;
}

function GetCpuPercentages($stat1, $stat2) {
        if( count($stat1) !== count($stat2) ) {
                return;
        }
        $cpus = array();
        for( $i = 0, $l = count($stat1); $i < $l; $i++) {
                $dif = array();
                $dif['user'] = ($stat2[$i]['user'] - $stat1[$i]['user']) + ($stat2[$i]['nice'] - $stat1[$i]['nice']);
                $dif['sys'] = $stat2[$i]['sys'] - $stat1[$i]['sys'];
                $dif['idle'] = $stat2[$i]['idle'] - $stat1[$i]['idle'];
                $total = array_sum($dif);
                $cpu = array();
                foreach($dif as $x=>$y) $cpu[$x] = round($y / $total * 100, 1);
                $cpus['cpu' . $i] = $cpu;
        }
        return $cpus;
}

$stat1 = GetCoreInformation();
/* sleep on server for one second */
sleep(1);
/* take second snapshot */
$stat2 = GetCoreInformation();
/* get the cpu percentage based off two snapshots */
$data = GetCpuPercentages($stat1, $stat2);

if ( !file_exists('/utm/log/cpu_usage_user.rrd') )
{
        //system('rrdtool create /utm/log/cpu_usage_user.rrd -s 10 DS:
        $ds_def = "";
        foreach( $data as $cpuname => $data )
        {
                $ds_def .= "DS:".$cpuname.":GAUGE:30:0:100 ";
        }
        $rra_def = "";
        $rra_def .= "RRA:AVERAGE:0.5:30:3600 ";
        $rra_def .= "RRA:AVERAGE:0.5:90:1200 ";
        $rra_def .= "RRA:AVERAGE:0.5:360:1200 ";
        $rra_def .= "RRA:MAX:0.5:360:1200 ";
        $rra_def .= "RRA:AVERAGE:0.5:8640:600 ";
        $rra_def .= "RRA:MAX:0.5:8640:600 ";

        foreach(array( "user", "sys", "idle" ) as $category)
        {
                $cmd = 'rrdtool create /utm/log/cpu_usage_'.$category.'.rrd -s 10 '
                                .$ds_def." ".$rra_def;
                system($cmd);
        }
}

foreach (array("user", "sys", "idle") as $category)
{
        $cpudata = "N";
        foreach($data as $arr) {
                $cpudata .= ":".$arr[$category];
        }
        $cmd = "rrdtool update /utm/log/cpu_usage_$category.rrd $cpudata";
        print(system($cmd, $retval));
        if ($retval != 0)
        {
                //echo "failed to update $category($retval)\n";
        }
}


?>

