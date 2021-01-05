function setVariables() {
if (navigator.appName == "Netscape") {
		horz=".left";
		vert=".top";
		docStyle="document.";
		styleDoc="";
		innerW="window.innerWidth";
		innerH="window.innerHeight";
		offsetX="window.pageXOffset";
		offsetY="window.pageYOffset";
	}
	else {
		horz=".pixelLeft";
		vert=".pixelTop";
		docStyle="";
		styleDoc=".style";
		innerW="document.body.clientWidth";
		innerH="document.body.clientHeight";
		offsetX="document.body.scrollLeft";
		offsetY="document.body.scrollTop";
	}
}
function checkLocation(fid,fw,fh,bw) {
	divwidth=fw; 
	divheight=fh;  
	objectXY=fid;
	var availableX=eval(innerW);
	var availableY=eval(innerH);
	var currentX=eval(offsetX);
	var currentY=eval(offsetY);
	if(bw==1){
		x=currentX;
		y=currentY;
	}
	else{
		x=availableX-(divwidth)+currentX;
		y=currentY;
	}
	evalMove();
	setTimeout("checkLocation('"+fid+"',"+fw+","+fh+","+bw+")",10);
}
function evalMove() {
	eval(docStyle + objectXY + styleDoc + horz + "=" + x);
	eval(docStyle + objectXY + styleDoc + vert + "=" + y);
}