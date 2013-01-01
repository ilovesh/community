$(document).ready(function(){
    /* Don't Delete: Test code to see if jquery is included */
	/*$("#logo").mouseenter(function(){
		$("a").fadeOut('slow');
	});   */
	
	//print courses in the console window
	//console.log(gon.global.courses);
	//console.log(gon.global.courses_with_path);
	
	//call jQuery UI's auto-complete function
	$( "#course_name" ).autocomplete({
		//indicate that minimum input length should be 2
		minLength: 2,
		//the source of data
		source: gon.global.courses
	});

  // make input field in bootstrap-modal focused
	$('.modal').on('shown', function() {
    var input = $(this).find('form').find('.modal-body').find('input');
    input.focus();
	});

  $('.modal').ready(function() {
    // check if the tag is already used to toggle the btn color
    var modal = $(this).find('.modal');
    var input = modal.find('form').find('.modal-body').find('input');
    var currentValue = input.val();
    var currentTags = currentValue.split(',');
    var spans = input.next().next().find('span');
    spans.each(function(){
      var span = $(this);
      var tag = span.text().trim();
      for (var i = 0; i < currentTags.length; i++) {
        if(tag == currentTags[i].trim()){
          span.removeClass('btn-info');
          return;
        };
      };
    });
  });


  // tag selection
	$('.btn-tag').click(function() {
	  var text = $(this).text();
	  var input = $(this).closest('dd').closest('dl').prev().prev('input');
    if($(this).hasClass('btn-info')){
      $(this).removeClass('btn-info');
		  input.val(function(i, val) {
        return val + (val ? ', ' : '') + text;
		  });
    } else {
      $(this).addClass('btn-info');
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

  $('.best_in_place').best_in_place();

});