<?php
define('PROGRAM_NAME', 'primes');
define('RUN_COUNT', 5);

$allTime = 0;
for ($i=0; $i<RUN_COUNT; ++$i) {
	$beginTime = microtime(TRUE);
	doTestsSuite();
	$allTime += microtime(TRUE) - $beginTime;
	sleep(1);
}

$avgSeconds = $allTime/RUN_COUNT;
echo 'Average time: ', round($avgSeconds, 5), "\n";


function doTestsSuite()
{
	$testsList = array(
		array('max_num' => '10', 'primes_sum' => '17'),
		array('max_num' => '100000', 'primes_sum' => '454396537'),
		array('max_num' => '1051174931', 'primes_sum' => '27269025983026043'),
	);
	
	$res = TRUE;
	$testsCount = sizeof($testsList);
	for ($i=0; $i<$testsCount; ++$i) {
		$testData = $testsList[$i];
		$res = $res && doTest($testData['max_num'], $testData['primes_sum']);
	}
	
	echo ($res ? 'Ok' : 'Fail'), "\n";
}

function doTest($maxNum, $expectedOutput)
{
    exec("echo $maxNum | ".PROGRAM_NAME, $output);
    if (empty($output))
		return FALSE;
	return (strcmp($output[0], $expectedOutput) == 0);
}
