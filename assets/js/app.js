(function($) {
    $.fn.uniformHeight = function() {
        var maxHeight   = 0,
            max         = Math.max;
        return this.each(function() {
            maxHeight = max(maxHeight, $(this).height());
        }).height(maxHeight);
    }
})(jQuery);

$(function () {
    $('[data-toggle="tooltip"]').tooltip();
    $(".thumbnails").find(".thumbnail").uniformHeight();
    $('.fancybox').fancybox();    
});
