function openMap(lng,lat,addr){
	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.Model=true;
	dlg.Width=900;//定义长度
	dlg.Height=600;
	dlg.URL="/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/ruleDesign/showLocateOnline.jsp?useType=2&lng=" + lng +"&lat=" + lat + "&addr=" + encodeURI(addr) );
	dlg.Title=SystemEnv.getHtmlNoteName(4083,readCookie("languageidweaver"));
	dlg.callback=function(data){
	}
	dlg.show();	
}