# global variable for search form autocomplete
Gon.global.courses = Course.all.map(&:full_name)
Gon.global.courses_with_path = Course.all.to_json(only:[:id], methods:[:full_name, :course_path])