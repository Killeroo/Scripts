
public static function debug_log($msg, $caller = false, $var = null)
{
	$entry = "";
	
	// Add date time with milliseconds
	$t = microtime(true);
	$micro = sprintf("%06d",($t - floor($t)) * 1000000);
	$d = new DateTime( date('Y-m-d H:i:s.'.$micro, $t) );
	$entry .= "[".$d->format("Y-m-d H:i:s.u")."] "; 

	print $d->format("Y-m-d H:i:s.u"); // note at point on "u"

	// Work out caller of method
	if ($caller == true) {
		$trace = debug_backtrace();
		$caller = $trace[1];

		if (isset($caller['class'])) {
			$entry .= "[{$caller['class']}::{$caller['function']}()] ";		
		} else {
			$entry .= "[{$caller['function']}()] ";
		}
	}

	// Add message
	$entry .= $msg;

	// Dump variable if its there
	if ($var != null) {
		$entry .= "\n";

		ob_start();
		var_dump($var);
		$entry .= ob_get_clean();
	} else {
		// Add new line
		$entry .= "\n";
	}

	// Determine log location
	// TODO: Autoclear log
	// HACK ALERT ! HACK ALERT ! HACK ALERT !
	// Make this dynamic dynamic boi
	// Requires chown on directory as well... :/
	$fileHandler = fopen('/var/log/apache2/debug_log', 'a');
	fwrite($fileHandler, $entry);
	fclose($fileHandler);

}