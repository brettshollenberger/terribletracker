$('#project_title').keydown(function(e) {
  if (e.keyCode === 9) {
    e.preventDefault();
      $('#project_title').submit();
  }
});
