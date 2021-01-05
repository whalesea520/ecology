/**
* 显示上传文件地址
* fileinput   上传文件按钮
* filepathtxt 显示文件路径框
*/
function changefilePath(fileinput,filepathtxt){
	jQuery("#"+filepathtxt).val(jQuery("#"+fileinput).val());
}
/**
* 显示上传文件地址
* fileinput   上传文件按钮
* filepathtxt 显示文件路径框
* imgpath   浏览系统图库文件路径
*/
function changeImgPath(fileinput,filepathtxt,imgpath){
	jQuery("#"+imgpath).val('');
	jQuery("#"+filepathtxt).val(jQuery("#"+fileinput).val());
}

/**
* 显示上传文件地址
* fileinput   上传文件按钮
* filepathtxt 显示文件路径框
* imgpath   浏览系统图库文件路径
*/
function showImgBrowser(fileinput,filepathtxt,imgpath){
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	var data = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/page/maint/common/CustomResourceMaint.jsp","","addressbar=no;status=0;dialogHeight=550px;dialogWidth=550px;dialogLeft="+iLeft+";dialogTop="+iTop+";resizable=0;center=1;");
	if(data){
		jQuery("#"+fileinput).val('');
		jQuery("#"+imgpath).val(data);
		jQuery("#"+filepathtxt).val(data);
	}else{
		jQuery("#"+imgpath).val('');
		jQuery("#"+filepathtxt).val('');
	}
}