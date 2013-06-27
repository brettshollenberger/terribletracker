window.TerribleTracker.Views.Teams.PickListItem = function(options){
  this.model = options.model;
  this.$el = $('<div>');

  this.click = function(e){
    var input = $("input[type=checkbox]",this);
    if($(input).is(':checked')){
      $(input).prop('checked', false);
      $(this).removeClass('checked');
    }
    else {
      $(input).prop('checked', true);
      $(this).parents('form').find('label.checked').removeClass('checked');
      $(this).addClass('checked');
    }

    $(this).trigger('click');
  };

  this.render = function(){
    var checkBox = $('<input>').attr({
      type: 'checkbox',
      value: this.model.id,
      class: 'team_checkbox',
      name: 'team_' + this.model.id
    });

    var span = $('<span>').addClass('icon');
    var span2 = $('<span>').addClass('icon-to-fade');

    var label = $('<label>').attr({
      for: 'team_' + this.model.id,
      class: 'checkbox'
    });

    label.append(span);
    label.append(span2);
    label.append(this.model.name);

    label.append(checkBox);

    $(label).on('click', this.click);

    $(this.$el).append(label);
    return this;
  }
};
