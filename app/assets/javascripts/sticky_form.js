$(document).ready(function(){
  $(".sticky-form").sticky({topSpacing:40});
  $("#why").on("scroll", function(){
    $(".sticky-form").unstick();
  });
});
