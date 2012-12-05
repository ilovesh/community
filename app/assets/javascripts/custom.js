$(document).ready(function(){
    /* Don't Delete: Test code to see if jquery is included */
	/*$("#logo").mouseenter(function(){
		$("a").fadeOut('slow');
	});   */
	
	//print courses in the console window
	console.log(gon.courses);
	
	//call jQuery UI's auto-complete function
	$( "#course_name" ).autocomplete({
		//indicate that minimum input length should be 2
		minLength: 2,
		//the source of data
		source: gon.courses
	});
		
});
