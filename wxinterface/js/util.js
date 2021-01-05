var dlg=null;
function openDialog(title,url,type,eid,width,height,ismax,ismaxiumnable) {
	dlg = new CoDialog();
	dlg.currentWindow = window;
	dlg.Model=true;
	if(typeof(width)=="undefined"||width=="0"){
		dlg.Width=500;//定义长度
	}else{
		dlg.Width=width;//定义长度
	}
	if(typeof(height)=="undefined"||height=="0"){
		dlg.Height=400;
	}else{
		dlg.Height=height;
	}
	if(type==0){
		dlg.URL=url;
	}else{
		dlg.InvokeElementId=eid;
	}
	dlg.Title=title;
	if(typeof(ismaxiumnable)=="undefined"){
		dlg.maxiumnable=true;
	}else{
		dlg.maxiumnable=ismaxiumnable;
	}
	if(typeof(ismax)=="undefined"){
		dlg.DefaultMax=false;
	}else{
		dlg.DefaultMax=true;
	}
	
	dlg.checkDataChange=true;
	dlg.show();
}
$(document).ready(function(){
	$("#closeDialog").click(function(){
		dlg.closeByHand();
	});
});