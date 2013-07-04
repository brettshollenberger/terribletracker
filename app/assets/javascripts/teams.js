$(function() {
  $('.project_sidebar').hide();
});

jQuery.fn.submitTeamOnCheck = function() {
  this.find('input[type=submit]').remove();
  this.find('input[type=checkbox]').click(function() {
    $(this).closest('form').submit();
  });
  return this;
};

jQuery.fn.submitProjectOnCheck = function() {
  this.find('input[type=submit]').remove();
  this.find('input[type=checkbox]').click(function() {
    $(this).closest('form').submit();
  });
  return this;
};

$(function() {
  $('.team_sidebar').submitTeamOnCheck()
});

$(function() {
  $('.project_sidebar').submitProjectOnCheck();
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
