$(function() {
  $('.projects_sidebar').find('div').hide();
});

jQuery.fn.submitOnCheck = function() {
  this.find('input[type=submit]').remove();
  this.find('input[type=checkbox]').click(function() {
    $(this).closest('form').submit();
  });
  return this;
};

$(function() {
  $('.team_sidebar').submitOnCheck();
});

$(function() {
  $('.projects_sidebar').submitOnCheck();
});

