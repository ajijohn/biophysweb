$( document ).ready(function() {
    $('a[href="#collapseZero"]').click(function(){
          $('#collapseOne').collapse('hide')
          $('#collapseTwo').collapse('hide')
     });

     $('a[href="#collapseOne"]').click(function(){
          $('#collapseZero').collapse('hide')
          $('#collapseTwo').collapse('hide')
     });

     $('a[href="#collapseTwo"]').click(function(){
          $('#collapseZero').collapse('hide')
          $('#collapseOne').collapse('hide')
     });
});
