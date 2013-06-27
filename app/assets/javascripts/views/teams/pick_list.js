window.TerribleTracker = {};
window.TerribleTracker.Views = {};
window.TerribleTracker.Views.Teams = {};
window.TerribleTracker.Views.Teams.PickList = function(options){
  this.$el = $(options.el);
  this.collection = options.collection;

  this.render = function(){
    for(var i = 0; i < this.collection.length; i++){
      var listItem = new TerribleTracker.Views.Teams.PickListItem({
        model: this.collection[i]
      });
      $(this.$el).append(listItem.render().$el);
    }
    return this;
  }
};
