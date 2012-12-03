$(document).ready(function(){
	/* For the usage of test jquery loading 
	$("#logo").mouseenter(function(){
		$("a").fadeOut('slow');
	});  */

	var availableTags = [
		"ActionScript",
		"AppleScript",
		"Asp",
		"BASIC",
		"C",
		"C++",
		"Clojure",
		"COBOL",
		"ColdFusion",
		"Erlang",
		"Fortran",
		"Groovy",
		"Haskell",
		"Java",
		"JavaScript",
		"Lisp",
		"Perl",
		"PHP",
		"Python",
		"Ruby",
		"Scala",
		"Scheme"
	];
	
	$("#coursenames").autocomplete({
		source: availableTags
	});
});