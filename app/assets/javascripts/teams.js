$(function() {
  $('.project_sidebar').hide();
});

jQuery.fn.submitOnCheck = function() {
  this.find('input[type=submit]').remove();
  this.find('input[type=checkbox]').click(function() {
    $(this).closest('form').submit();
    $('#body-main').html('<img src="/assets/25.gif" id="team-loader">');
  });
  return this;
};

$(function() {
  $('.team_sidebar').submitOnCheck();
});

$(function() {
  $('.project_sidebar').submitOnCheck();
});

// Click toggle between two states
(function($) {
  $.fn.clickToggle = function(func1, func2) {
    var funcs = [func1, func2];
    this.data('toggleclicked', 0);
    this.click(function() {
      var data = $(this).data();
      var tc = data.toggleclicked;
      $.proxy(funcs[tc], this)();
      data.toggleclicked = (tc + 1) % 2;
    });
    return this;
  };
}(jQuery));
