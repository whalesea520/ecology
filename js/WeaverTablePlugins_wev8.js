Ext.namespace('Ext.ux.plugins');
Ext.ux.plugins.CheckBoxMemory = Ext.extend(Object,
{
   constructor: function(config)
   {
      //if (!config)
      //   config = {};
      this.hdID = config.hdID;
      this.prefix = 'id_';
      this.items = {};
      this.idProperty = config.idProperty || 'id';
   },

   init: function(grid)
   {
      this.grid = grid;
      this.view = grid.getView()
      this.store = null;
      this.sm = grid.getSelectionModel();
      this.sm.on('rowselect', this.onSelect, this);
      this.sm.on('rowdeselect', this.onDeselect, this);
      this.view.on('refresh', this.reConfigure, this);
   },
   
   reConfigure: function() {
      this.store = this.grid.getStore();
      var hd = Ext.fly(Ext.getDom(this.hdID).parentNode)
      hd.removeClass('x-grid3-hd-checker-on');
      this.store.on('clear', this.onClear, this); 
      this.store.on('datachanged', this.restoreState, this);
   },

   onSelect: function(sm, idx, rec)
   {
      this.items[this.getId(rec)] = true;
   },

   onDeselect: function(sm, idx, rec)
   {
      delete this.items[this.getId(rec)];
   },

   restoreState: function()
   {
      if (this.store != null) {
          var i = 0;
          var sel = [];
          this.store.each(function(rec)
          {
             var id = this.getId(rec);
             if (this.items[id] === true)
                sel.push(i);

             ++i;
          }, this);
          if (sel.length > 0)
             this.sm.selectRows(sel);
       }
   },
   
   onClear: function()
   {
      var sel = [];
      this.items = {};
   },

   getId: function(rec)
   {
   	  return rec.id;
   },
   
   getSelection:function(){
   	  var selecton='';
   	  for(var key in this.items){
   	  	 selecton+=key+','
   	  }
   	  return selecton;
   }
});