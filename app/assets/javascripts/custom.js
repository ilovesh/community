$(document).ready(function(){
    /* Don't Delete: Test code to see if jquery is included */
	/*$("#logo").mouseenter(function(){
		$("a").fadeOut('slow');
	});   */
	
	//print courses in the console window
	console.log(gon.global.courses);
	console.log(gon.global.courses_with_path);
	
	//call jQuery UI's auto-complete function
	$( "#course_name" ).autocomplete({
		//indicate that minimum input length should be 2
		minLength: 2,
		//the source of data
		source: gon.global.courses
	});

    // make input field in bootstrap-modal focused
	$('.modal').on('shown', function() {
      $(this).find('form').find('.modal-body').find('input').focus();
	});

   // tag selection
	$('.btn-tag').click(function() {
	  var text = $(this).text();
	  var input = $(this).closest('dd').closest('dl').prev('input');
      if($(this).hasClass('btn-info btn-tag')){
        $(this).removeClass('btn-info btn-tag').addClass('btn-tag-disabled');
		input.val(function(i, val) {
          return val + (val ? ', ' : '') + text;
		});
      } else {
        $(this).removeClass('btn-tag-disabled').addClass('btn-info btn-tag');
        var value = input.val();
        var valueArray = value.split(',');
        var result = "";
        for (var i = 0; i < valueArray.length; i++){
          tag = valueArray[i].trim();
          if(tag != text) {
          	if(result == '') { result += tag; }
          	else { result += (', ' + tag); };
          };
        };
        input.val(result);
	  };
	});
    

});