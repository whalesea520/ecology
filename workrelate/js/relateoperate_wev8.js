function openTaskList(parm){
	openWin("/workrelate/task/data/TaskList.jsp?"+parm);
}
function doCreateTask(parm){
	openWin("/workrelate/task/data/Add.jsp?"+parm);
}
function openWin(url,showw,showh){
	if(showw==null || typeof(showw)=="undefined") showw = 900;
	if(showh==null || typeof(showh)=="undefined") showh = 520;
	var redirectUrl = url ;
	var height = screen.height;
	var width = screen.width;
	var top = (height-showh)/2;
	var left = (width-showw)/2;
	var szFeatures = "top="+top+"," ; 
	szFeatures +="left="+left+"," ;
	szFeatures +="width="+showw+"," ;
	szFeatures +="height="+showh+"," ; 
	szFeatures +="directories=no," ;
	szFeatures +="status=yes," ;
	szFeatures +="menubar=no," ;
  	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
 	window.open(redirectUrl,"",szFeatures) ;
}