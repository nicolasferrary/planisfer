$(document).ready(function(){

  if($(window).width() <= 1024){
    $('.lg').removeClass('lg');
    $('.sticky-form').removeClass('sticky-form');
  }

  $(".sticky-form").sticky({topSpacing:40});
});

$.fn.followTo = function (pos) {
    var $this = this,
        $window = $(window);

    $window.scroll(function (e) {
        if ($window.scrollTop() > pos) {
            $this.css({
                position: 'absolute',
                top: pos
            });
        }    });
};

$('.sticky-form').followTo(1620);
