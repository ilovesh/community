$(document).ready(function(){
    /* Don't Delete: Test code to see if jquery is included */
	/*$("#logo").mouseenter(function(){
		$("a").fadeOut('slow');
	});   */
	
	//print courses in the console window
	//console.log(gon.global.courses);
	//console.log(gon.global.courses_with_path);
	
	//call jQuery UI's auto-complete function
	$("#q").autocomplete({
		minLength: 2,
		source: gon.global.courses
	});

  // make input field in bootstrap-modal focused
	$('.modal').on('shown', function() {
    input = $(this).find('form').find('.modal-body').find('input');
    input.focus();
    textarea = $(this).find('form').find('.modal-body').find('textarea');
    textarea.focus();
	});

  $('.enrollment-modal').ready(function() {
    // check if the tag is already used to toggle the btn color
    var modal = $(this).find('.modal');
    var input = modal.find('form').find('.modal-body').find('input');
    if (input) {
      var currentValue = input.val();
      if (currentValue) {
        var currentTags = currentValue.split(',');
        var spans = input.next().next().find('span');
        if (spans) {
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
        }; 
      };    
    };
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

  // best_in_place gem
  $('.best_in_place').best_in_place();

  // bootstrap tooltip
  $("[rel=tooltip]").tooltip();


  // submit form when select option is selected w/o a submit button
  $('select').change(function() {
    $(this).closest('form').submit();
  });

  $('.view-select').change(function() {
    $(this).closest('form').submit();
  });

  $('.btn-notification').click(function() {
    $(this).find('.icon-notify').removeClass('icon-notify');
    $(this).prev('form').submit();
  })

/*
$('.topnav-search-query').focus(function(){
  $(this).animate({
    width: '400px'
  }, 400 )
}); 

$('.topnav-search-query').blur(function(){
  $(this).animate({
    width: '206px'
  }, 500 )
});*/


});