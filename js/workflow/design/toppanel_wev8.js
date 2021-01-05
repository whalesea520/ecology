var _ToolBoxManager = [];
function TToolBox(id, caption, l, t, w, h, content, dir, expanded, mw, mh){
  this.ID = id;
  this.Caption = caption;
  this.Left = l;
  this.Top = t;
  this.Width = w;
  this.MinWidth = mw?mw:w;
  this.Height = h;
  this.MinHeight = mh?mh:h;
  this.Content = content;
  this.TitleHeight = 20;
  this.Dir = dir;
  this.TitleBtn = dir == "down"?new Array("down","up"):new Array("up","down");
  this.InnerObject = null;
  document.write(this);
  this.InnerObject = document.all(this.ID);
  this.Visible = true;
  this.VisibleEx = true;
  if(expanded == false) this.hideBox();
  _ToolBoxManager[_ToolBoxManager.length] = this;
}

TToolBox.prototype.hideBox = function(){
  var oTitle = document.all(this.ID+"_title");
  var oContent = document.all(this.ID+"_content");
  var oBottom = document.all(this.ID+"_bottom");
  var oImg = document.all(this.ID+"_img");
  this.InnerObject.style.height = this.TitleHeight;
  oImg.src = "image/" + this.TitleBtn[0] + "_wev8.gif";
  oImg.title = "单击展开工具栏";
  oContent.style.display = "none";
  oBottom.style.display = "none";
  oTitle.style.background = "#D4D0C8";
  if(this.Dir == "up") this.InnerObject.style.top = this.Top;
  this.Visible = false;
  setToolBoxTopMost(this);
}

TToolBox.prototype.showBox = function(){
  var oTitle = document.all(this.ID+"_title");
  var oContent = document.all(this.ID+"_content");
  var oBottom = document.all(this.ID+"_bottom");
  var oImg = document.all(this.ID+"_img");
  this.InnerObject.style.height = this.Height;
  oImg.src = "image/" + this.TitleBtn[1] + "_wev8.gif";
  oImg.title = "单击收缩工具栏";
  oContent.style.display = "block";
  oBottom.style.display = "block";
  oTitle.style.background = "#0066FF";
  if(this.Dir == "up") this.InnerObject.style.top = this.Top - this.Height + this.TitleHeight;
  this.Visible = true;
  setToolBoxTopMost(this);
}

TToolBox.prototype.showHideTool = function(){
  if(this.Visible)
    this.hideBox();
  else
    this.showBox();
}

TToolBox.prototype.setZIndex = function(i){
  this.InnerObject.style.zIndex = i;
}

TToolBox.prototype.mouseDown = function(){
  if(event.button != 1) return;
  var obj = event.srcElement;
  setToolBoxTopMost(this);
  if(!obj.moveType) return;
  this.moveType = obj.moveType;
  this.InnerObject.setCapture();
  this.CurrentX = event.x - this.InnerObject.offsetLeft;
  this.CurrentY = event.y - this.InnerObject.offsetTop;
}

TToolBox.prototype.mouseMove = function(){
  switch(this.moveType){
    case "m":
      this.Left = event.x - this.CurrentX;
      this.Top = event.y - this.CurrentY
      this.InnerObject.style.left = this.Left;
      this.InnerObject.style.top = this.Top;
      break;
    case "s":
      this.Height = event.y - this.Top;
      if(this.Height < this.MinHeight) this.Height = this.MinHeight;
      this.InnerObject.style.height = this.Height;
      break;
    case "n":
      var bOffset = this.InnerObject.offsetTop + this.Height;
      this.Height = bOffset - event.y;
      if(this.Height < this.MinHeight) this.Height = this.MinHeight;
      this.Top = bOffset - this.Height;
      this.InnerObject.style.top = this.Top;
      this.InnerObject.style.height = this.Height;
      break;
    case "e":
      this.Width = event.x - this.Left;
      if(this.Width < this.MinWidth) this.Width = this.MinWidth;
      this.InnerObject.style.width = this.Width;
      break;
    case "nw":
      this.Width = event.x - this.Left;
      this.Height = event.y - this.Top;
      if(this.Height < this.MinHeight) this.Height = this.MinHeight;
      if(this.Width < this.MinWidth) this.Width = this.MinWidth;
      this.InnerObject.style.width = this.Width;
      this.InnerObject.style.height = this.Height;
      break;
  }
}

TToolBox.prototype.mouseUp = function(){
  this.moveType = "";
  this.InnerObject.releaseCapture();
  if(parseInt(this.InnerObject.style.top)<-10){
    alert("工具栏上边界超出边界，将自动调整.");
    this.InnerObject.style.top=30;
  }
}

TToolBox.prototype.toString = function(){
  S = '<table id="'+this.ID+'" class="toolbox" style="position:absolute;left:' + this.Left + 'px;top:' + this.Top + 'px;width:' + 
    this.Width + 'px;height:' + this.Height + 'px;z-index:3000" cellspacing="0" cellpadding="0" border="0" onmousedown="'+this.ID+'.mouseDown();" '+
    'onmousemove="'+this.ID+'.mouseMove();" onmouseup="'+this.ID+'.mouseUp();">';
  if(this.Dir == "down"){
    S += '<tr id="'+this.ID+'_title" height="'+this.TitleHeight+'" bgcolor="#0066FF" style="cursor:move;"><td colspan="2" title="双击可以展开/收缩工具栏，按住左键移动位置" '+
    'ondblclick="'+this.ID+'.showHideTool();"><table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0"><tr><td width="99%" moveType="m">&nbsp;<font color="#FFFFFF" moveType="m">' + this.Caption + '</font></td><td width="1%"><img id="'+this.ID+'_img" title="单击收缩工具栏" src="image/' + this.TitleBtn[1] + '_wev8.gif" style="cursor:hand;" onclick="'+this.ID+'.showHideTool();" height="14" width="14" border="0"></td></tr></table></td></tr>' +
    '<tr id="'+this.ID+'_content"><td valign="top">' + this.Content + '&nbsp;</td><td width="2" style="cursor:E-resize;" moveType="e"></td></tr>' +
    '<tr id="'+this.ID+'_bottom" height="2"><td style="cursor:S-resize;" moveType="s"></td><td style="cursor:NW-resize;" moveType="nw"></td</tr>';
  }
  else
    S += '<tr id="'+this.ID+'_bottom" height="2"><td style="cursor:N-resize;" moveType="n"></td><td></td</tr>' +
    '<tr id="'+this.ID+'_content"><td valign="top">' + this.Content + '&nbsp;</td><td width="2" style="cursor:E-resize;" moveType="e"></td></tr>' +
    '<tr id="'+this.ID+'_title" height="'+this.TitleHeight+'" bgcolor="#0066FF" style="cursor:move;"><td colspan="2" title="双击可以展开/收缩工具栏，按住左键移动位置" '+
    'ondblclick="'+this.ID+'.showHideTool();"><table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0"><tr><td width="99%" moveType="m">&nbsp;<font color="#FFFFFF" moveType="m">' + this.Caption + '</font></td><td width="1%"><img id="'+this.ID+'_img" title="单击收缩工具栏" src="image/' + this.TitleBtn[1] + '_wev8.gif" style="cursor:hand;" onclick="'+this.ID+'.showHideTool();" height="14" width="14" border="0"></td></tr></table></td></tr>';
  S += '</table>';
  return S;
}

function TToolPanel(id, l, t, w, h, content, mw){
  this.ID = id;
  this.Left = l;
  this.Top = t;
  this.Width = w;
  this.MinWidth = mw?mw:w;
  this.Height = h;
  this.Content = content;
  this.InnerObject = null;
  document.write(this);
  this.InnerObject = document.all(this.ID);
  _ToolBoxManager[_ToolBoxManager.length] = this;
}

TToolPanel.prototype.setZIndex = function(i){
  this.InnerObject.style.zIndex = i;
}

TToolPanel.prototype.toString = function(){
  S = '<table id="'+this.ID+'" class="toolbox" style="position:absolute;left:' + this.Left + 'px;top:' + this.Top + 'px;width:' + 
    this.Width + 'px;height:' + this.Height + 'px;z-index:3000" cellspacing="0" cellpadding="0" border="0" onmousedown="'+this.ID+'.mouseDown();" '+
    'onmousemove="'+this.ID+'.mouseMove();" onmouseup="'+this.ID+'.mouseUp();">' +
    '<tr><td width="8" style="cursor:move;" moveType="m"><img moveType="m" src="image/tb_title_wev8.gif" height="25" width="5" border="0"></td><td>' + this.Content + '</td</tr>' +
    '</table>';
  return S;
}

TToolPanel.prototype.mouseDown = function(){
  if(event.button != 1) return;
  var obj = event.srcElement;
  if(!obj.moveType) return;
  this.moveType = obj.moveType;
  this.InnerObject.setCapture();
  this.CurrentX = event.x - this.InnerObject.offsetLeft;
  this.CurrentY = event.y - this.InnerObject.offsetTop;
  setToolBoxTopMost(this);
}

TToolPanel.prototype.mouseMove = function(){
  switch(this.moveType){
    case "m":
      this.Left = event.x - this.CurrentX;
      this.Top = event.y - this.CurrentY
      this.InnerObject.style.left = this.Left;
      this.InnerObject.style.top = this.Top;
      break;
  }
}

TToolPanel.prototype.mouseUp = function(){
  this.moveType = "";
  this.InnerObject.releaseCapture();
  if(parseInt(this.InnerObject.style.top)<-10){
    alert("工具栏上边界超出边界，将自动调整.");
    this.InnerObject.style.top=0;
  }
}

function setToolBoxTopMost(AToolBox){
  for(var i = 0; i< _ToolBoxManager.length; i++)
    _ToolBoxManager[i].setZIndex(3000);
  AToolBox.setZIndex(3001);
}
