<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="java.util.Map,java.util.HashMap"%>
<!DOCTYPE html>
<html lang="en">

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.List,java.util.ArrayList,net.sf.json.JSONArray" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify,weaver.hrm.User,weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.docs.networkdisk.server.NetworkFileLogServer"%>
<%@ page import="weaver.docs.pdf.docpreview.ConvertPDFUtil"%>

<head>
  <meta charset="UTF-8">
  <title>云盘</title>
 <script type="text/javascript" src="/cloudstore/resource/mobile/react/react-with-addons.min.js" charset="utf-8"></script>
 <script type="text/javascript" src="/cloudstore/resource/mobile/react/react-dom.min.js" charset="utf-8"></script>
 
 <script type="text/javascript" src="/mobile/plugin/fullsearch/js/promise.min.js" charset="utf-8"></script>
 <script type="text/javascript" src="/mobile/plugin/fullsearch/js/fetch.min.js" charset="utf-8"></script>
  
  <script>
    (function (baseFontSize, fontscale) {
      var _baseFontSize = baseFontSize || 100;
      var _fontscale = fontscale || 1;
      var win = window;
      var doc = win.document;
      var ua = navigator.userAgent;
      var matches = ua.match(/Android[\S\s]+AppleWebkit\/(\d{3})/i);
      var UCversion = ua.match(/U3\/((\d+|\.){5,})/i);
      var isUCHd = UCversion && parseInt(UCversion[1].split('.').join(''), 10) >= 80;
      var isIos = navigator.appVersion.match(/(iphone|ipad|ipod)/gi);
      var dpr = win.devicePixelRatio || 1;
      if (!isIos && !(matches && matches[1] > 534) && !isUCHd) {
        // 如果非iOS, 非Android4.3以上, 非UC内核, 就不执行高清, dpr设为1;
        dpr = 1;
      }
	   dpr = 1;	
	  window._androidX5 = window.innerWidth <= 600 ? true : false;
	 dpr = window._androidX5 ? 1 : dpr;
		

      var scale = 1 / dpr;

      var metaEl = doc.querySelector('meta[name="viewport"]');
      if (!metaEl) {
        metaEl = doc.createElement('meta');
        metaEl.setAttribute('name', 'viewport');
        doc.head.appendChild(metaEl);
      }
      metaEl.setAttribute('content', 'width=device-width,user-scalable=no,initial-scale=' + scale + ',maximum-scale=' + scale + ',minimum-scale=' + scale);
      doc.documentElement.style.fontSize = _baseFontSize / 2 * dpr * _fontscale + 'px';
      window.viewportScale = dpr;
    })();
  </script>
  <link rel="stylesheet" href="/mobile/plugin/networkdisk/css/index.css?version=1"/>
  
  <script>
		if(window._androidX5){
			document.write('<link rel="stylesheet" href="/mobile/plugin/networkdisk/css/android_x5.css"/>');
		}
  </script>
  
  <%
    String sessionkey = Util.null2String(request.getParameter("sessionkey"));
  	User user = HrmUserVarify.getUser(request,response);
   // Map<String,String> params = new HashMap<String,String>();
  //	PrivateSeccategoryManager seccategoryManager = new PrivateSeccategoryManager();
  //	String folders = seccategoryManager.getCategoryChilds(user,0,"",params);
  //	int pageSize = 5;
  //	int pageNum = 1;
  	
  //	if(!folders.equals("[]")){
//	  	List<Map<String,String>> folderList = seccategoryManager.formatMoblieFoldersByMap(folders);
//	  	folders = JSONArray.fromObject(folderList).toString();
 // 	}
 // 	String  files = seccategoryManager.getDoctailsBySecId(user,0,pageNum,pageSize,"privateAll","",params);
 // 	if(!files.equals("[]")){
//		pageNum = 2;
//		List<Map<String,String>> fileList = seccategoryManager.formatMobliFiless(files);
//		files = JSONArray.fromObject(fileList).toString();
//  	}
  	boolean isUsePDFViewer = ConvertPDFUtil.isUsePDFViewer();
 	String type = Util.null2String(request.getParameter("type"));
 	String folderid = Util.null2String(request.getParameter("shareid"));
 	String targetid = Util.null2String(request.getParameter("targetid"));
	String module = Util.null2String(request.getParameter("module"));
	String scope = Util.null2String(request.getParameter("scope"));
  	int defaultFolderid = Util.getIntValue(request.getParameter("defaultFolderid"),0);
  	List<String> defaultPath = new ArrayList<String>();
  	List<String> pids = new ArrayList<String>();
  	String sharetime = "";
  	String sharefrom = "";
 	int shareFlag = 0;
  	if(!type.isEmpty()){ //定位到指定分享目录下
  	  type = type.equals("myshare") ? "myShare" : type;
  	  type = type.equals("shareme") ? "shareMy" : type;
  	  RecordSet rs = new RecordSet();
  	  
  	  NetworkFileLogServer networkFileLogServer = new NetworkFileLogServer();
  	  
	  if("myShare".equals(type)){
	  	defaultPath.add(SystemEnv.getHtmlLabelName(33310,user.getLanguage()));
	  	shareFlag = networkFileLogServer.checkShare("folder",user.getUID() + "",targetid,folderid,user);
	  	if(shareFlag == 1){
		  	rs.executeSql("select sharedate,sharetime from Networkfileshare where sharerid=" + user.getUID() + " and tosharerid='" + targetid + "' and fileid=" + folderid + " and filetype=2 order by id desc");
		  	if(rs.next()){
		  	  sharetime = rs.getString("sharedate") + " " + rs.getString("sharetime"); 
		  	}
	  	}else{
	  	    folderid = "0"; //没有权限，跳转到我的分享
	  	}
	  }else if("shareMy".equals(type)){
	  	defaultPath.add(SystemEnv.getHtmlLabelName(129146,user.getLanguage()));
	  	shareFlag = networkFileLogServer.checkShare("folder","",targetid,folderid,user); 
	  	if(shareFlag == 1){
		  	if(targetid.length() > 10){
			  	rs.executeSql("select n.sharedate,n.sharetime,s.targetname from Networkfileshare n,Social_IMConversation s where n.tosharerid=s.targetid n.tosharerid='" + targetid + "' and n.fileid=" + folderid + " and n.filetype=2 order by n.id desc");
			  	if(rs.next()){
			  	   sharetime = rs.getString("sharedate") + " " + rs.getString("sharetime"); 
			  	   sharefrom = rs.getString("targetname");
			  	}
		  	}else{
		  	  	ResourceComInfo resourceComInfo = new ResourceComInfo();
			  	rs.executeSql("select sharedate,sharetime from Networkfileshare where sharerid=" + targetid + " and tosharerid=" + user.getUID() + " and fileid=" + folderid + " and filetype=2 order by id desc");
			  	sharefrom = resourceComInfo.getLastname(targetid);
			  	if(rs.next()){
			  	   sharetime = rs.getString("sharedate") + " " + rs.getString("sharetime"); 
			  	}
		  	}
		  	if(rs.next()){
		  	  sharetime = rs.getString("sharedate") + " " + rs.getString("sharetime"); 
		  	}
	  	}else{
	  	  folderid = "0";//没有权限，跳转到同事的分享
	  	}
	  }else{
	      defaultPath.add(SystemEnv.getHtmlLabelName(129151,user.getLanguage()));  
	  }
	  
	  if(!sharetime.isEmpty()){
	  	  rs.executeSql("select categoryname name from DocPrivateSecCategory where id='" + folderid + "'");
	  	  if(rs.next()){
	  	     //defaultPath += Util.null2String(rs.getString("name")) + "/";
			  defaultPath.add(Util.null2String(Util.null2String(rs.getString("name"))));
	  	  }else{
	  	    defaultFolderid = 0;
	  	  }
	  }else{
	      defaultFolderid = 0;
	  }
  	  
  	}else{
  		if(defaultFolderid > 0){//定位到指定云盘目录下
  		    RecordSet rs = new RecordSet();
	  	    boolean isoracle = (rs.getDBType()).equals("oracle") ;
  			String sql = "";
  		   if(isoracle){
  		     sql = "select id,categoryname name,parentid pid from DocPrivateSecCategory start with id=" + defaultFolderid + " connect by nocycle prior parentid=id";  
  		   }else{
  		     sql = "with alldata as " +
	             "(select * from DocPrivateSecCategory where id=" + defaultFolderid + " union all select d.* " +
	             "from alldata a,DocPrivateSecCategory d where d.id=a.parentid)" +
	             "select id,categoryname name,parentid pid from alldata";
  		   }
  		   rs.executeSql(sql);
  		   Map<String,Map<String,String>> map = new HashMap<String,Map<String,String>>();
  		   while(rs.next()){
  		     Map<String,String> m = new HashMap<String,String>(); 
  		     m.put("id",rs.getString("id"));
  		     m.put("name",rs.getString("name"));
  		     m.put("pid",rs.getString("pid"));
  		     map.put(rs.getString("id"),m);
  		   }
  		   String idFlag = defaultFolderid + "";
  		   List<String> ids = new ArrayList<String>();
  		   while(map.get(idFlag) != null){
  		       ids.add(idFlag);
  		       idFlag = map.get(idFlag).get("pid");
  		   }
  			pids.add("0");
  		   defaultPath.add(SystemEnv.getHtmlLabelName(129151,user.getLanguage()));
  		   if(ids.size() > 1){
	  		   for(int i = ids.size() - 2;i >= 0;i--){
	  		       pids.add(ids.get(i));
	  		       defaultPath.add(map.get(ids.get(i)).get("name"));
	  		   }
  		   }
  		   type = "disk";
  		   
  		}
  	    
  	}
  	
	String viewType = Util.null2String(request.getParameter("viewType"));
  	String imagefileid = Util.null2String(request.getParameter("imagefileid"));
  	String imagefolderid = Util.null2String(request.getParameter("imagefolderid"));
  	String operateType = Util.null2String(request.getParameter("operateType")); //saveFromMsg
  	
  	String chooseFile = Util.null2String(request.getParameter("chooseFile"));
  	
  %>
  <script>
    this.__maxSize = 20;
    this.__xmlSize = 15; 
    this._isUsePDFViewer = "<%=isUsePDFViewer ? 1 : 0%>"; //是否开启pdf转换预览
    this._USER_ID = "<%=user.getUID()%>"; 
  	this._CLOUDY_INDEX = 1; // 用于给子页面判断，是否其父页面是该页面。主要用于文档详情页面的判断
    var DEFAULT_VIEW = "<%=viewType%>";
    var SHARE_FLAG = "<%=shareFlag%>"; //该分享目录当前状态：1、正常，2、删除，3、取消共享，0、其他
    var DEFAULT_PARAMS = {
    	fileids : "<%=imagefileid%>",
    	folderids : "<%=imagefolderid%>",
    	operateType : "<%=!operateType.isEmpty() ? operateType : "upload"%>",
    	shareids : "",
    	
    };
    
    var IS_OPEN_SESSION = 1; //是否开启缓存 1-是，0-否
    
    var CHOOSE_FILE = "<%=chooseFile.equals("1") ? 1 : 0%>";
    
  	var pageSize = 15;
  	var pageNum = 1;
  	var folders = [];
  	var files = [];
  	var DiskObj = null;
  	var SystemObj = null;
  	var sessionkey = "<%=sessionkey%>";
  	var moduleid = "<%=module%>";
  	var scope = "<%=scope%>";
  	var VIEW_TYPE = "<%=type%>";
  	var FOLDER_ID = "<%=folderid%>"; 
  	var TARGET_ID = "<%=targetid%>"; 
  	var DETAULT_PATH = eval('(<%=JSONArray.fromObject(defaultPath).toString()%>)');
	var PIDS = [0];
	var SHARETIME = "<%=sharetime%>";
	var SHAREFROM = "<%=sharefrom%>";
	if(VIEW_TYPE != ""){ 
		if(VIEW_TYPE == "disk"){//定位到云盘指定目录
			PIDS = eval('(<%=JSONArray.fromObject(pids).toString()%>)');
			FOLDER_ID = "<%=defaultFolderid%>";
		}else{//定位到分享指定目录
			if(FOLDER_ID > 0){
				PIDS.push(FOLDER_ID);
			}
		}
	}
	
  	function prevStep(){
  		// alert(1);
  	}
  	
  	function doLeftButton(){
		//var _pid = getPid();
		//if(getPid() == 0){
		if(attrDetail.className == "show"){
			attrDetail.className = "";
			setTimeout(function(){
				attrDetail.childNodes[0].style.display = "none";
			},500);
			return "0";
		}else if(docReply.className == "show"){
			docReply.className = "";
			setTimeout(function(){
				docReply.childNodes[0].style.display = "none";
			},500);
			return "0";
		}
		else if(docDetail.className == "show"){
			docDetail.className = "";
			var metaEl = window.document.querySelector('meta[name="viewport"]');
			metaEl.setAttribute('content', 'width=device-width,user-scalable=no,initial-scale=' + 1/window.viewportScale + ',maximum-scale=' + 1/window.viewportScale + ',minimum-scale=' + 1/window.viewportScale);
			setTimeout(function(){
				docDetail.childNodes[0].style.display = "none";
			},500);
			return "0";
		}
		
  	     return "close";
  	  // }else{
  	   	 //DiskObj.prev();
  	   //	 prevStep()
  	   //  return 1;
  	  // }
  	}
  	
	function showBtn(e){
		location = "emobile:mutableUpload:callbackUpload:1:1520:clearAppendix";
	}
	
	function showBtn2System(e){
		location = "emobile:mutableUpload:callbackUpload2:1:1520:clearAppendix";
	}
	
	function setSendData(usereids,groupids,fileMap,folderMap)
	{
		var fileMes = "";
		var fileids = "";
		var folderMes = "";
		var folderids = "";
		if(fileMap && fileMap.length > 0){
			fileMap = eval("(" + fileMap + ")");
			for(var key in fileMap){
				fileMes += "&file_" + key + "=" + fileMap[key];
				fileids += "," + key;
			}
		}
		if(folderMap && folderMap.length > 0){
			folderMap = eval("(" + folderMap + ")");
			for(var key in folderMap){
				folderMes += "&folder_" + key + "=" + folderMap[key];
				folderids += "," + key;
			}
		}
		
		fileids = fileids.length > 0 ? fileids.substring(1) : fileids;
		folderids = folderids.length > 0 ? folderids.substring(1) : folderids;
		
		var params = "userids=" + usereids + "&groupids=" + groupids + "&fileids=" + fileids + "&folderids=" + folderids;
		params += fileMes + folderMes;
		DiskObj.doShare(params);
	}
	
	function callbackUpload(name,data,index) {
		if(data) uploaddata.value = data;
		if(name) uploadname.value = name;
		folderid.value = DiskObj.state.folderid;
		uploadtype.value = "disk";
		dataForm.submit();
	}
	
	function callbackUpload2(name,data,index){
		if(data) uploaddata.value = data;
		if(name) uploadname.value = name;
		folderid.value = SystemObj.state.categoryid;
		uploadtype.value = "system";
		dataForm.submit();
	}
	
	function clearAppendix(){
	}

	function uploadedCallback()
	{
		DETAULT_PATH = DiskObj.state.path;
		PIDS = DiskObj.state.pids;
		DiskObj.removeSession();
		DiskObj.openFolder(DiskObj.state.folderid,true);
	}
	
	function uploadedCallback2(){
		SystemObj.onRefresh();
	}
	
	var SHARA_MAP = {};
	//分享接口
	function toShare(dataMap){
		SHARA_MAP = dataMap;
		var fileids = dataMap.fileid;
		var folderids = dataMap.folderid;
		location = "emobile:netdiskshare:["+folderids+"]:["+fileids+"]:setSendData";
	}
	
	
	function getnamebyid(_itemid,_itemtype)
	{
		return DiskObj.getnamebyid(_itemid,_itemtype);
	}
	
	function toSelectView(){
		DiskObj.toSelect();
	}
	
	function toOpenFile(param,readOnLine,view){
		location = "/download.do?" + param+"&module=<%=module%>&scope=<%=scope%>" + (readOnLine ? "&file2pdf=1" : "");
		return;
		if(readOnLine){
			if(view == "systemDoc"){
				window.VIEW_TAB = "systemDoc";
				showSystemDocLoading();
			}else if(view == "disk"){
				showDiskDocLoading();
				window.VIEW_TAB = "disk";
			}
			attrDetail.className = "show";
			setTimeout(function(){
				attrDetail.childNodes[0].src = "/mobile/plugin/2/pdfview/mobile-viewer/viewer.jsp?" + param + "&module=<%=module%>&scope=<%=scope%>"
			},500);
		}else{
			location = "/download.do?" + param+"&module=<%=module%>&scope=<%=scope%>";
		}
	}
	
	var timeOutEvent = 0;
	var LONG_TOUCH = 0;
	function touchCancel(){
		LONG_TOUCH = 1;
		DiskObj.touchCancel();
	}

	function toSearch(){
	
	}
	function searchBack(){
	}
	
	//删除系统文档
	function deleteSystemDoc(docid){
		SystemObj.deleteDoc(docid);
	}
	
	//显示loading
	function showSystemDocLoading(){
		SystemObj.showLoad();
	}
	function showDiskDocLoading(){
		DiskObj.showLoad();
	}
	//隐藏loading
	function hideSystemDocLoading(){
		SystemObj.hideLoad();
	}
	function hideDiskLoading(){
		DiskObj.hideLoad();
	}
	
	var timeOutResize = null;
	var windowHeight = 0;
	var currentHeight = 0;
	var resizeCount = 0;
	function windowResize(backFlag){
		var ch = window.innerHeight;
		currentHeight = currentHeight == 0 ? ch : currentHeight;
		if(windowHeight == ch || resizeCount >= 5){
			clearInterval(timeOutResize);
			timeOutResize = null;
			if(backFlag == 1){
				searchBack();
			}else{
				toSearch();
			}
		}else if(currentHeight == ch){
			currentHeight = ch;
			resizeCount++;
		} 
	}
	var _title;
	function getRequestTitle()
	{
		//if(TARGET_ID || TARGET_ID != "")
		//{
			 if(DEFAULT_VIEW == "ChooseSystemDoc"){
		    	return "文档";
		   	}else{
				return "<%=SystemEnv.getHtmlLabelName(129151,user.getLanguage())%>";
			}
		//}
		//else
		//{
		//	if(_title)
		//	{
		//		return _title;
		//	}
		//	else
		//	{
		//		return "云盘";
		//	}
		//}
	}
	
	function showTitle(title){
		// _title = title;
		// location = "emobile:changeTitle:"+title;
	}
	
	function chooseFileFn(data){
		location = "emobile:netdiskshare:[" + data.folderid + "]:[" + data.fileid + "]:setSendData:choose";
	}
	
	function chooseDocFn(data){
		var lists = [];
		for(key in data){
			lists.push(data[key]);
		}
		var dataJson = {
			"func" : "shareSysdoc",
			"params" : lists
		}
		console.info("emobile:" + JSON.stringify(dataJson));
		location = "emobile:" + JSON.stringify(dataJson); 
	}
	
	function saveFromMsgFn(data){
		setTimeout(function(){
			location = "home.do";
		},1000);
	}
	
	function sendCancel2Msg(mesList){
		if(mesList && mesList.length > 0){
			var data = {
				"func" : "netdiskShareCancel",
				"params" : mesList
			}
			location = "emobile:" + JSON.stringify(data);
		}
	}
	
	var FontList = {
		searchStr : '<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>', //搜索
		promptStr : '<%=SystemEnv.getHtmlLabelName(32933,user.getLanguage())%>', //请输入关键字
		shareFontSim : '<%=SystemEnv.getHtmlLabelName(129144,user.getLanguage())%>',//分享
		shareFontMul : '<%=SystemEnv.getHtmlLabelName(129144,user.getLanguage())%>',//分享
		shareTabMyShare : '<%=SystemEnv.getHtmlLabelName(33310,user.getLanguage())%>',//我的分享
		shareTabShareMy : '<%=SystemEnv.getHtmlLabelName(129146,user.getLanguage())%>',//同事的分享
		publicFontSim : '<%=SystemEnv.getHtmlLabelName(129148,user.getLanguage())%>',//发布到系统
		publicFontMul : '<%=SystemEnv.getHtmlLabelName(129148,user.getLanguage())%>',//发布到系统
		deleteFontSim : '<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>',//删除
		deleteFontMul : '<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>',//删除
		moreFont : '<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>',//更多
		diskFont : '<%=SystemEnv.getHtmlLabelName(129151,user.getLanguage())%>',//云盘
		shareFont : '<%=SystemEnv.getHtmlLabelName(129144,user.getLanguage())%>',//分享
		cancelShareFontSim : '<%=SystemEnv.getHtmlLabelName(129158,user.getLanguage())%>',//取消分享
		save2DiskFontSim : '<%=SystemEnv.getHtmlLabelName(129159,user.getLanguage())%>',//保存到云盘
		publicEmptyFont : '<%=SystemEnv.getHtmlLabelName(129157,user.getLanguage())%>',//发布到此目录
		uploadEmptyFont : '<%=SystemEnv.getHtmlLabelName(129160,user.getLanguage())%>',//上传到此目录
		save2DiskEmptyFont : '<%=SystemEnv.getHtmlLabelName(129161,user.getLanguage())%>',//保存到此目录
		moveEmptyFont : '<%=SystemEnv.getHtmlLabelName(129162,user.getLanguage())%>',//移动到此目录
		diskEmptyFont : '<%=SystemEnv.getHtmlLabelName(129163,user.getLanguage())%>～',//云盘还是空的哦
		dataEmptyFont : '<%=SystemEnv.getHtmlLabelName(129164,user.getLanguage())%>',//这个目录还没有文件
		shareMyEmptyFont : '<%=SystemEnv.getHtmlLabelName(129165,user.getLanguage())%>',//在这里可以看到同事分享给你的文件
		myShareEmptyFont : '<%=SystemEnv.getHtmlLabelName(129166,user.getLanguage())%>',//在这里可以看到我分享的文件
		publicComfirmFont : '<%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%>', //发布
		uploadComfirmFont : '<%=SystemEnv.getHtmlLabelName(75,user.getLanguage())%>',//上传
		saveComfirmFont : '<%=SystemEnv.getHtmlLabelName(129155,user.getLanguage())%>',//保存到
		moveComfirmFont : '<%=SystemEnv.getHtmlLabelName(129168,user.getLanguage())%>',//移动到
		publicNoData : '<%=SystemEnv.getHtmlLabelName(129169,user.getLanguage())%>',//请选择要发布的文件或目录
		deleteNoData : '<%=SystemEnv.getHtmlLabelName(129170,user.getLanguage())%>',//请选择要删除的文件或目录
		moveNoData : '<%=SystemEnv.getHtmlLabelName(129172,user.getLanguage())%>',//请选择要移动的文件或目录
		confirmDel : '<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>',//确定要删除吗?
		confirmMove : '<%=SystemEnv.getHtmlLabelName(128187,user.getLanguage())%>?',//确定要移动吗
		ensure : '<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>',//确定
		cancel : '<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>',//取消
		move : '<%=SystemEnv.getHtmlLabelName(129168,user.getLanguage())%>',//移动到
		rename : '<%=SystemEnv.getHtmlLabelName(19827,user.getLanguage())%>',//重命名
		confirmCancelShare : '<%=SystemEnv.getHtmlLabelName(129173,user.getLanguage())%>?',//确定要取消分享吗
		loadingFont : '',
		uploadError : '<%=SystemEnv.getHtmlLabelName(25389,user.getLanguage())%>!',//上传失败
		shareError : '<%=SystemEnv.getHtmlLabelName(129174,user.getLanguage())%>!',//分享失败
		folderNameEmpty : '<%=SystemEnv.getHtmlLabelName(129175,user.getLanguage())%>!',//目录名称不能为空
		nameNotContains : '<%=SystemEnv.getHtmlLabelName(129176,user.getLanguage())%>:',//名称不能包含下列字符
		nameNotEmoj : '<%=SystemEnv.getHtmlLabelName(129177,user.getLanguage())%>!',//名称不能包含表情
		folderNameExist : '<%=SystemEnv.getHtmlLabelName(129178,user.getLanguage())%>!',//该目录名已存在
		nameIsNull : '<%=SystemEnv.getHtmlLabelName(125692,user.getLanguage())%>!',//名称不能为空
		nameExist : '<%=SystemEnv.getHtmlLabelName(129179,user.getLanguage())%>!',//该名称已存在
		renameFaile : '<%=SystemEnv.getHtmlLabelName(129180,user.getLanguage())%>!',//重命名失败
		shareNoSelect : '<%=SystemEnv.getHtmlLabelName(129181,user.getLanguage())%>!',//请选择要分享的文件或目录
		deleteNotEmpty : '<%=SystemEnv.getHtmlLabelName(129182,user.getLanguage())%>!',//所选目录不为空不能被删除
		searchHistory : '<%=SystemEnv.getHtmlLabelName(129183,user.getLanguage())%>',//搜索历史
		searchHistoryNo : '<%=SystemEnv.getHtmlLabelName(129184,user.getLanguage())%>',//无搜索历史
		clearHistory : '<%=SystemEnv.getHtmlLabelName(129185,user.getLanguage())%>',//清空搜索记录
		inputFolderName : '<%=SystemEnv.getHtmlLabelName(129186,user.getLanguage())%>',//请输入目录名称
		inputNewName : '<%=SystemEnv.getHtmlLabelName(129187,user.getLanguage())%>',//请输入新名称
		loadMore : '<%=SystemEnv.getHtmlLabelName(129188,user.getLanguage())%>..',//下拉加载更多
		uploadFile : '<%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%>',//上传文件
		createFolder : '<%=SystemEnv.getHtmlLabelName(20002,user.getLanguage())%>',//新建目录
		shareRightNow : '<%=SystemEnv.getHtmlLabelName(129189,user.getLanguage())%>',//立即分享
		searchNoFile : '<%=SystemEnv.getHtmlLabelName(129191,user.getLanguage())%>!',//没有搜到相关文件
		systemFolder : '<%=SystemEnv.getHtmlLabelName(129192,user.getLanguage())%>',//系统目录
		isSure : '<%=SystemEnv.getHtmlLabelName(129193,user.getLanguage())%>',//是否将
		publicSystem : '<%=SystemEnv.getHtmlLabelName(129194,user.getLanguage())%>:',//发布到系统目录
		publicSuccess : '<%=SystemEnv.getHtmlLabelName(129195,user.getLanguage())%>!',//发布完成
		moveSuccess : '<%=SystemEnv.getHtmlLabelName(129196,user.getLanguage())%>!',//移动成功
		saveSuccess : '<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>!',//保存成功
		uploadSuccess : '<%=SystemEnv.getHtmlLabelName(25388,user.getLanguage())%>!',//上传成功
		upload2Disk : '<%=SystemEnv.getHtmlLabelName(129197,user.getLanguage())%>'//上传至云盘
	}
	
  </script>
    <style>
*{
		color:#6c6c6c;
		font-size:.32rem;
	}
	  .diskContent{
		  padding-left:20px;
		  
	  }
		.am-list-view-scrollview-content{
			width:100%;
		}
		.operateContent font,.diskFoot font{
			font-size:.24rem;
		}
		.diskTime,.diskSize{
			font-size:.28rem;
			color:#6c6c6c;
		}
		iframe{
			border:0;
		}
	  </style>
</head>

<body>

	<iframe name='hidden_frame' id="hidden_frame" style="display:none"></iframe>
	<form id="dataForm" action="/mobile/plugin/networkdisk/uploadFileForMobile.jsp" enctype="multipart/form-data" method="post" target="hidden_frame">
		<input id="uploaddata" type="hidden" name="uploaddata" />
		<input id="uploadname" type="hidden" name="uploadname" />
		<input id="folderid" type="hidden" name="folderid" />
		<input id="uploadtype" type="hidden" name="uploadtype" value=""/>
		<input id="sessionkey" type="hidden" name="sessionkey" value="<%=sessionkey%>" />
	</form>

<div id="root"></div>

<script src="/mobile/plugin/networkdisk/js/index.js?version=1" type="text/javascript"></script>

</body>
</html>
