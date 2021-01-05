<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv" %>
<%@page import="weaver.hrm.HrmUserVarify,weaver.hrm.resource.ResourceComInfo"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.List,java.util.ArrayList,java.util.Map,java.util.HashMap,net.sf.json.JSONArray" %>
<%@ page import="weaver.rdeploy.doc.PrivateSeccategoryManager" %>



<%
    /*用户验证*/
    User user = HrmUserVarify.getUser(request, response);
    if (user == null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }
    
    String guid = Util.null2String(request.getParameter("guid"));
    String hostname = Util.null2String(request.getParameter("hostname"));
    
    
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

    
  String defaultPosition = Util.null2String(request.getParameter("type")); //直接定位到指定视图（shareMy-同事的分享，myShare-我的分享）
  String viewType = Util.null2String(request.getParameter("viewType"));
  String targetid = Util.null2String(request.getParameter("targetid"));  //人id或者组id（我的分享：被分享人，同事的分享：分享人）
  int defaultCid = 0;
  boolean isSystemDoc = "systemDoc".equals(viewType);
  if(!viewType.isEmpty()){ //我的云盘-文档目录 互相切换视图。将视图定位到我的云盘
      defaultPosition = "privateAll";
  }else if("shareMy".equals(defaultPosition)){ //指定到同事的分享
      //传过来的参数与逻辑判断参数一致
      defaultCid = Util.getIntValue(request.getParameter("categoryid"),0);
  }else if("myShare".equals(defaultPosition)){
      defaultCid = Util.getIntValue(request.getParameter("categoryid"),0);
  }else{ //如果传入的参数是其他值。则统一改为定位到我的云盘
      defaultPosition = "privateAll";
  }
  
  String itemData = "";
  RecordSet rs = new RecordSet();
  if(defaultCid > 0){
	  String sharetime = "";
	  String sharefrom = "";
	  String shareid = "";
	  if("shareMy".equals(defaultPosition)){ 
	    if(targetid.length() > 10){
		  	rs.executeSql("select n.id shareid,n.sharedate,n.sharetime,s.targetname from Networkfileshare n,Social_IMConversation s where n.tosharerid=s.targetid n.tosharerid='" + targetid + "' and n.fileid=" + defaultCid + " and n.filetype=2 order by n.id desc");
		  	if(rs.next()){
		  	   sharetime = rs.getString("sharedate") + " " + rs.getString("sharetime"); 
		  	   sharefrom = rs.getString("targetname");
		  	   shareid = rs.getString("shareid");
		  	}
	  	}else{
	  	  	ResourceComInfo resourceComInfo = new ResourceComInfo();
		  	rs.executeSql("select id shareid,sharedate,sharetime from Networkfileshare where sharerid=" + targetid + " and tosharerid=" + user.getUID() + " and fileid=" + defaultCid + " and filetype=2 order by id desc");
		  	sharefrom = resourceComInfo.getLastname(targetid);
		  	if(rs.next()){
		  	   sharetime = rs.getString("sharedate") + " " + rs.getString("sharetime"); 
		  	   shareid = rs.getString("shareid");
		  	}
	  	}
	  }else if("myShare".equals(defaultPosition)){
	      rs.executeSql("select sharedate,sharetime from Networkfileshare where sharerid=" + user.getUID() + " and tosharerid='" + targetid + "' and fileid=" + defaultCid + " and filetype=2 order by id desc");
		  if(rs.next()){
		  	 sharetime = rs.getString("sharedate") + " " + rs.getString("sharetime"); 
		  }
	  }
	  if("privateAll".equals(defaultPosition) || !sharetime.isEmpty()){
		  rs.executeSql("select parentid pid,categoryname sname from DocPrivateSecCategory where id=" + defaultCid);
	      if(rs.next()){
	          itemData += "{" +
	              			"sid : " +   defaultCid + "," +    
	              			"pid : " +   rs.getString("pid") + "," +    
	              			"sname : '" +   rs.getString("sname") + "'" +   
	              			(sharetime.isEmpty() ? "" : ",sharetime : '" + sharetime + "'") + 
	              			(sharefrom.isEmpty() ? "" : ",username :'" + sharefrom + "'") +
	              			(shareid.isEmpty() ? "" : ",shareid : " + shareid) +
	              		"}";
	      }else{
	          defaultCid = 0;
	      }
	  }else{
	      defaultCid = 0;
	  }
      
  }
  
  rs.executeSql("select * from ImageFileReftemp where createrid = '"+user.getUID()+"' and filesize > 0 and computercode = '"+guid+"' and comefrom=1 and " + (isSystemDoc ? " isSystemDoc=1 " : " (isSystemDoc=0 or isSystemDoc is null) ") + " order by id"); //获取所有手动上传未完成的数据
  List<Map<String,String>> uploadList = new ArrayList<Map<String,String>>();
  PrivateSeccategoryManager seccategoryManager = new PrivateSeccategoryManager();
  while(rs.next()){
      Map<String,String> uploadMap = new HashMap<String,String>();
      uploadList.add(uploadMap);
      String fileName = Util.null2String(rs.getString("fileName"));
      
	  String filePath = Util.null2String(rs.getString("diskpath"));
	  
	  String filemd5 = Util.null2String(rs.getString("filepathmd5"));
	  
	  String fileSize = Util.null2String(rs.getString("filesize"));
	  
	  String uploadSize = Util.null2String(rs.getString("uploadSize"));
	  
	  String uploadfileguid = Util.null2String(rs.getString("uploadfileguid"));
	  
	  
      uploadMap.put("id",Util.null2String(rs.getString("uploadfileguid")));
      uploadMap.put("imagefileid",Util.null2String(rs.getString("imagefileid")));
      uploadMap.put("fileName",fileName);
      uploadMap.put("categoryid",Util.null2String(rs.getString("categoryid")));
      uploadMap.put("uid",filemd5);
      uploadMap.put("fileSize",fileSize);
	  uploadMap.put("uploadSize",uploadSize);
	  uploadMap.put("filePath",filePath.replaceAll("\\\\", "\\\\\\\\"));
      uploadMap.put("fileType",seccategoryManager.getSmallMarkByName(fileName));
  }
  
  
  List<Map<String,String>> downloadList = new ArrayList<Map<String,String>>();
  if(isSystemDoc){
      rs.executeSql("select d.type,f.imagefileid,d.localpath,d.clientguid,d.downloaddate,d.downloadfileguid,f.imagefilename,f.fileSize,dd.seccategory categoryid " +
              "from DownloadFileTemp d,ImageFile f,DocImageFile df,DocDetail dd where d.type=0 and userid = "+user.getUID()+" and d.clientguid = '"+guid+"' and  d.fileid=f.imagefileid and df.imagefileid=d.fileid and df.docid=dd.id"); //获取所有手动下载未完成的数据
  }else{
  	rs.executeSql("select d.type,f.imagefileid,d.localpath,d.clientguid,d.downloaddate,d.downloadfileguid,f.imagefilename,f.fileSize,r.categoryid " +
          "from DownloadFileTemp d,ImageFile f,ImageFileRef r where d.type=0 and userid = "+user.getUID()+" and d.clientguid = '"+guid+"' and  d.fileid=f.imagefileid and r.imagefileid=d.fileid"); //获取所有手动下载未完成的数据
  }
  Map<String,String> loadMap = new HashMap<String,String>();  //去重
  while(rs.next()){
      if(loadMap.get(rs.getString("downloadfileguid")) != null){
          continue;
      }
      loadMap.put(rs.getString("downloadfileguid"),"1");
      Map<String,String> downloadMap = new HashMap<String,String>();
      downloadList.add(downloadMap);
      String fileName = Util.null2String(rs.getString("imagefilename"));
      String filePath = Util.null2String(rs.getString("localpath"));
      
      downloadMap.put("id",Util.null2String(rs.getString("downloadfileguid")));
      downloadMap.put("imagefileid",Util.null2String(rs.getString("imagefileid")));
      downloadMap.put("fileName",fileName);
      downloadMap.put("categoryid",Util.null2String(rs.getString("categoryid")));
      downloadMap.put("uid",Util.null2String(rs.getString("imagefileid")));
      downloadMap.put("fileSize",Util.null2String(rs.getString("fileSize")));
      downloadMap.put("filePath",filePath.replaceAll("\\\\", "\\\\\\\\"));
      downloadMap.put("fileType",seccategoryManager.getSmallMarkByName(fileName));
  }
  
  if(!isSystemDoc){
	  rs.executeSql("select n.*,r.categoryid cid from NetworkfileLog n,imagefileref r where n.imagefileid=r.imagefileid and n.isDelete=0 and n.userid=" + user.getUID() + " and (n.isSystemDoc=0 or n.isSystemDoc is null) order by n.id");
  }else{
	  rs.executeSql("select n.*,d.seccategory cid from NetworkfileLog n,DocImageFile r,DocDetail d where n.imagefileid=r.imagefileid and d.id=r.docid and n.isDelete=0 and n.userid=" + user.getUID() + " and n.isSystemDoc=1 order by n.id");
  }
  List<Map<String,String>> uploadLogList = new ArrayList<Map<String,String>>();
  List<Map<String,String>> downloadLogList = new ArrayList<Map<String,String>>();
  List<Map<String,String>> syncLogList = new ArrayList<Map<String,String>>();
  Map<String,String> loadMap2 = new HashMap<String,String>();  //去重
  while(rs.next()){
      Map<String,String> map = new HashMap<String,String>();  
      String opType = Util.null2String(rs.getString("opType"));
      if("1".equals(opType)){
	  uploadLogList.add(map);
      }else if("2".equals(opType)){
          if(loadMap2.get(Util.null2String(rs.getString("id"))) != null){
              continue;
          }
          loadMap2.put(Util.null2String(rs.getString("id")),"1");
          downloadLogList.add(map);
      }else if("3".equals(opType)){
          syncLogList.add(map);
      }else{
          continue;
      }
	  String fileName = Util.null2String(rs.getString("fileName"));
      
	  map.put("id",Util.null2String(rs.getString("id")));
	  map.put("networklogid",Util.null2String(rs.getString("id")));
	  map.put("imagefileid",Util.null2String(rs.getString("imagefileid")));
	  map.put("filePath",Util.null2String(rs.getString("relativePath")).replaceAll("\\\\", "\\\\\\\\"));
	  map.put("fileName",fileName);
	  map.put("categoryid",Util.null2String(rs.getString("cid")));
	  map.put("uid",Util.null2String(rs.getString("uid")));
	  map.put("fileSize",Util.null2String(rs.getString("fileSize")));
	  map.put("fileType",seccategoryManager.getSmallMarkByName(fileName));
  }
  
  
%>

<script>
	var guid = "<%=guid%>";
	var hostname = "<%=hostname%>";
	var viewType = "<%=viewType%>";
	
	var uploadList = eval("(" + '<%=JSONArray.fromObject(uploadList).toString()%>' + ")"); //未完成的上传列表
	var downloadList = eval("(" + '<%=JSONArray.fromObject(downloadList).toString()%>' + ")");//未完成的下载列表
	var uploadLogList = eval("(" + '<%=JSONArray.fromObject(uploadLogList).toString()%>' + ")");//已完成的未清空的上传列表
	var downloadLogList = eval("(" + '<%=JSONArray.fromObject(downloadLogList).toString()%>' + ")");//已完成的未清空的下载列表
	var syncLogList = eval("(" + '<%=JSONArray.fromObject(syncLogList).toString()%>' + ")");//已完成的未清空的同步列表
	var uploadSizeCount = 0;
	var uploadedSizeCount = 0;
	
	var downloadSizeCount = 0;
	var downloadedSizeCount = 0;
	
	
	var warmFont = {
		diskFont : '<%=SystemEnv.getHtmlLabelName(129151,user.getLanguage())%>',//云盘
		systemFolder : '系统目录',//文档目录
		myDisk : '<%=SystemEnv.getHtmlLabelName(129207,user.getLanguage())%>',//我的云盘
		shareFont : '<%=SystemEnv.getHtmlLabelName(129144,user.getLanguage())%>',//分享
		syncSetting : '<%=SystemEnv.getHtmlLabelName(21952,user.getLanguage())%>',//同步设置
		createDoc : '<%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%>',//新建文档
		downloadMul : '<%=SystemEnv.getHtmlLabelName(27105,user.getLanguage())%>',//附件批量下载
		subscribeDoc  : '<%=SystemEnv.getHtmlLabelName(129209,user.getLanguage())%>',//订阅无权限查看的文档
		markDoc  : '<%=SystemEnv.getHtmlLabelName(129210,user.getLanguage())%>',//标记文档
		markAllDoc  : '<%=SystemEnv.getHtmlLabelName(129211,user.getLanguage())%>',//标记所有文档
		uploadFile : '<%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%>',//上传文件
		createFolder : '<%=SystemEnv.getHtmlLabelName(20002,user.getLanguage())%>',//新建目录
		download : '<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>',//下载
		'public' : '<%=SystemEnv.getHtmlLabelName(129148,user.getLanguage())%>',//发布到系统
		'delete' : '<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>',//删除
		syncLocation : '<%=SystemEnv.getHtmlLabelName(129212,user.getLanguage())%>',//同步本地文档到系统
		systemDoc : '<%=SystemEnv.getHtmlLabelName(129213,user.getLanguage())%>',//查看系统文档
		myShare : '<%=SystemEnv.getHtmlLabelName(33310,user.getLanguage())%>',//我的分享
		shareMy : '<%=SystemEnv.getHtmlLabelName(129146,user.getLanguage())%>',//同事的分享
		cancelShare : '<%=SystemEnv.getHtmlLabelName(129158,user.getLanguage())%>',//取消分享
		save2Disk : '<%=SystemEnv.getHtmlLabelName(129159,user.getLanguage())%>',//保存到云盘
		iconView : '<%=SystemEnv.getHtmlLabelName(129214,user.getLanguage())%>',//图标视图
		listView : '<%=SystemEnv.getHtmlLabelName(82532,user.getLanguage())%>',//列表视图
		searchDoc : '<%=SystemEnv.getHtmlLabelName(126309,user.getLanguage())%>',//搜索文档
		createDate : '<%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%>',//创建日期
		commitSubscribe : '<%=SystemEnv.getHtmlLabelName(129215,user.getLanguage())%>',//提交订阅
		import2Dummy : '<%=SystemEnv.getHtmlLabelName(21826,user.getLanguage())%>',//导入选中文档到虚拟目录
		importAll2Dummy : '<%=SystemEnv.getHtmlLabelName(21827,user.getLanguage())%>',//导入所有文档到虚拟目录
		open : '<%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%>',//打开
		moveTo : '<%=SystemEnv.getHtmlLabelName(129168,user.getLanguage())%>',//移动到
		copy : '<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%>',//复制
		paste : '<%=SystemEnv.getHtmlLabelName(16180,user.getLanguage())%>',//粘贴
		rename : '<%=SystemEnv.getHtmlLabelName(19827,user.getLanguage())%>',//重命名
		view : '<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>',//查看
		refresh : '<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%>',//刷新
		orderWay : '<%=SystemEnv.getHtmlLabelName(129216,user.getLanguage())%>',//排序方式
		fileName : '<%=SystemEnv.getHtmlLabelName(129217,user.getLanguage())%>',//文件名
		updateTime : '<%=SystemEnv.getHtmlLabelName(26805,user.getLanguage())%>',//修改时间
		sendList : '<%=SystemEnv.getHtmlLabelName(129218,user.getLanguage())%>',//传输列表
		uploadingTask : '<%=SystemEnv.getHtmlLabelName(129219,user.getLanguage())%>',//个任务正在上传
		downloadingTask : '<%=SystemEnv.getHtmlLabelName(129220,user.getLanguage())%>',//个任务正在下载
		uploading : '<%=SystemEnv.getHtmlLabelName(126308,user.getLanguage())%>',//正在上传
		downloading : '<%=SystemEnv.getHtmlLabelName(129221,user.getLanguage())%>',//正在下载
		sendComplete : '<%=SystemEnv.getHtmlLabelName(129222,user.getLanguage())%>',//传输完成
		syncComplete : '<%=SystemEnv.getHtmlLabelName(129223,user.getLanguage())%>',//同步完成
		uploadProgress : '<%=SystemEnv.getHtmlLabelName(129224,user.getLanguage())%>',//上传总进度
		allStop : '<%=SystemEnv.getHtmlLabelName(129225,user.getLanguage())%>',//全部暂停
		allCancel : '<%=SystemEnv.getHtmlLabelName(129226,user.getLanguage())%>',//全部取消
		allContinue : '<%=SystemEnv.getHtmlLabelName(129257,user.getLanguage())%>',//全部继续
		noUpload : '<%=SystemEnv.getHtmlLabelName(129227,user.getLanguage())%>',//暂无上传
		downloadProgress : '<%=SystemEnv.getHtmlLabelName(129228,user.getLanguage())%>',//下载总进度
		noDownload : '<%=SystemEnv.getHtmlLabelName(129229,user.getLanguage())%>',//暂无下载
		all : '<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>',//全部
		uploadComplete : '<%=SystemEnv.getHtmlLabelName(83072,user.getLanguage())%>',//上传完成
		downloadComplete : '<%=SystemEnv.getHtmlLabelName(129230,user.getLanguage())%>',//下载完成
		noTransfer : '<%=SystemEnv.getHtmlLabelName(129231,user.getLanguage())%>',//暂无传输
		syncTask : '<%=SystemEnv.getHtmlLabelName(129232,user.getLanguage())%>',//个文件完成同步
		emptySync : '<%=SystemEnv.getHtmlLabelName(129233,user.getLanguage())%>',//清空同步记录
		emptyTransfer : '<%=SystemEnv.getHtmlLabelName(129234,user.getLanguage())%>',//清空传输记录
		noSync : '<%=SystemEnv.getHtmlLabelName(129235,user.getLanguage())%>',//暂无同步
		deleteConfirm : '<%=SystemEnv.getHtmlLabelName(129242,user.getLanguage())%>', //确定删除选中项吗?
		category : '<%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%>', //目录
		notEmpty2Delete : '<%=SystemEnv.getHtmlLabelName(129243,user.getLanguage())%>', //不为空不能被删除
		deleteFail : '<%=SystemEnv.getHtmlLabelName(20462,user.getLanguage())%>!', //删除失败
		choose : '<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>', //请选择
		moveFail : '<%=SystemEnv.getHtmlLabelName(129245,user.getLanguage())%>!', //移动失败
		saveSuccess : '<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>!',//保存成功
		saveFail : '<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>!',//保存失败
		cancelSuccess : '<%=SystemEnv.getHtmlLabelName(129248,user.getLanguage())%>!',//取消成功
		cancelFail : '<%=SystemEnv.getHtmlLabelName(129249,user.getLanguage())%>!',//取消失败
		publicSuccess : '<%=SystemEnv.getHtmlLabelName(129195,user.getLanguage())%>!',//发布完成
		publicFail : '<%=SystemEnv.getHtmlLabelName(129250,user.getLanguage())%>!',//发布失败
		pasteSubCategory : '<%=SystemEnv.getHtmlLabelName(129251,user.getLanguage())%>!',//不能将目录粘贴到源目录的子目录中
		pasteFail : '<%=SystemEnv.getHtmlLabelName(129252,user.getLanguage())%>!',//粘贴失败
		diskShare : '<%=SystemEnv.getHtmlLabelName(129253,user.getLanguage())%>',//云盘分享
		selectWithoutFile : '<%=SystemEnv.getHtmlLabelName(129254,user.getLanguage())%>!',//所选文档无附件,请重新选择
		save : '<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>',//保存
		downloadWithoutFile : '<%=SystemEnv.getHtmlLabelName(126945,user.getLanguage())%>!',//文件不存在，请重新下载
		dummy : '<%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%>',//虚拟目录
		importSuccess : '<%=SystemEnv.getHtmlLabelName(25750,user.getLanguage())%>!',//导入成功
		importFail : '<%=SystemEnv.getHtmlLabelName(24945,user.getLanguage())%>!',//导入失败
		submitScription : '<%=SystemEnv.getHtmlLabelName(129215,user.getLanguage())%>',//提交订阅
		applySuccess : '<%=SystemEnv.getHtmlLabelName(126918,user.getLanguage())%>!',//申请成功
		fileNameExist : '<%=SystemEnv.getHtmlLabelName(129179,user.getLanguage())%>!',//文件名已存在
		sureCancel : '<%=SystemEnv.getHtmlLabelName(129256,user.getLanguage())%>?',//确定要取消吗
		categoryNotExist : '<%=SystemEnv.getHtmlLabelName(129259,user.getLanguage())%>!',//该目录不存在
		operateFail : '<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>!',//操作失败
		netAnomaly : '<%=SystemEnv.getHtmlLabelName(129263,user.getLanguage())%>!',//网络异常
		paused : '<%=SystemEnv.getHtmlLabelName(129265,user.getLanguage())%>',//已暂停
		waitingUpload : '<%=SystemEnv.getHtmlLabelName(129268,user.getLanguage())%>',//等待上传
		uploadFail : '<%=SystemEnv.getHtmlLabelName(25389,user.getLanguage())%>',//上传失败
		downloadFail : '<%=SystemEnv.getHtmlLabelName(129272,user.getLanguage())%>',//下载失败
		cancelling : '<%=SystemEnv.getHtmlLabelName(129273,user.getLanguage())%>',//正在取消
		exist : '<%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>',//已存在
		searchResult : '<%=SystemEnv.getHtmlLabelName(81289,user.getLanguage())%>',//搜索结果
		noData : '<%=SystemEnv.getHtmlLabelName(126307,user.getLanguage())%>',//暂无记录
		systemCategory : '系统目录',//公共目录
		create : '<%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%>',//创建
		cancel : '<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>',//取消
		nameExist2Change : '<%=SystemEnv.getHtmlLabelName(21999,user.getLanguage())%>',// 此名称已经存在，请换用别的名称 
	}
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript"
			src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
		<script type="text/javascript"
			src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
		<link rel="stylesheet"
			href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css"
			type="text/css" />
		<link rel="stylesheet" type="text/css"
			href="/rdeploy/assets/css/common.css">

		<script type='text/javascript'
			src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type="text/javascript"
			src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript"
			src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"
			type=text/css rel=STYLESHEET>
		<script type="text/javascript"
			src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
		<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" rel="stylesheet"
			type="text/css">
		<script type='text/javascript'
			src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<link rel="stylesheet" type="text/css"
			href="/js/jquery-autocomplete/browser_wev8.css" />
		<link rel="stylesheet" type="text/css"
			href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />

		<link rel="stylesheet" type="text/css"
			href="/js/poshytip-1.2/tip-yellowsimple/tip-yellowsimple_wev8.css" />

		<!-- 日历控件 -->
		<link
			href="/wui/common/jquery/plugin/daterangepicker/bootstrap.min.css"
			rel="stylesheet">
		<link rel="stylesheet" type="text/css" media="all"
			href="/wui/common/jquery/plugin/daterangepicker/daterangepicker-bs3.css" />
		<link rel="stylesheet" type="text/css" media="all"
			href="/wui/common/jquery/plugin/daterangepicker/daterangepicker-bs4.css" />
		<script type="text/javascript"
			src="/wui/common/jquery/plugin/daterangepicker/bootstrap.min.js"></script>
		<script type="text/javascript"
			src="/wui/common/jquery/plugin/daterangepicker/moment.js"></script>
		<script type="text/javascript"
			src="/wui/common/jquery/plugin/daterangepicker/daterangepicker.js"></script>

		<script language="javascript"
			src="/rdeploy/assets/js/jquery.easing.1.3.js"></script>
		<link rel="stylesheet" href="/js/jquery/ui/jquery-ui_wev8.css">

		<!-- 高级搜索样式 -->
		<link rel="stylesheet" type="text/css"
			href="/rdeploy/assets/css/chatsearch.css">
		<link rel="stylesheet" type="text/css"
			href="/rdeploy/assets/css/wf/requestshow.css">

		<script type='text/javascript'
			src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script language="javascript" type="text/javascript"
			src="/js/init_wev8.js"></script>

		<!-- swfupload -->
		<%-- 
		<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
		<script type="text/javascript"
			src="/rdeploy/assets/js/doc/chatproject/swfupload.queue_wev8.js"></script>

		<script type="text/javascript"
			src="/rdeploy/assets/js/doc/chatproject/rdeploy_handlers_wev8_new.js"></script>

		<script type="text/javascript"
			src="/rdeploy/assets/js/doc/rdeploy_doc_swfupload_wev8.js"></script>
		<script type="text/javascript"
			src="/rdeploy/assets/js/doc/chatproject/fileprogress_wev8_new.js"></script>

		
		 
		<script type='text/javascript'
			src='/rdeploy/assets/js/doc/chatproject/uploadfile_wev8.js'></script>
		--%>	
		
		<%
		  String jsVersion = "1.0";
		%>
		
		<script type='text/javascript'
			src='/rdeploy/assets/js/doc/chatproject/index_init_wev8.js?<%=jsVersion %>'></script>
			
		<script type='text/javascript'
			src='/rdeploy/assets/js/doc/chatproject/clickEvent.js?<%=jsVersion %>'></script>
			
		<script type='text/javascript'
			src='/rdeploy/assets/js/doc/chatproject/file_process.js?<%=jsVersion %>'></script>	
		
		<script type='text/javascript'
			src='/rdeploy/assets/js/doc/chatproject/uploadfiles_button.js?<%=jsVersion %>'></script>
			
		<script type='text/javascript'
			src='/rdeploy/assets/js/doc/chatproject/downloadfile.js?<%=jsVersion %>'></script>
		
	<script type="text/javascript">
		
		var publicIdMap = {0 : undefined}; // 点击后的公共目录
		var privateIdMap = {0 : undefined}; // 点击后的私人目录
		var myShareIdMap = {0 : undefined}; // 点击后的我的分享
		var shareMyIdMap = {0 : undefined}; // 点击后的同事的分享
		var reqUploadMap = {};
		var reqDownloadMap = {};
		if("<%=defaultPosition%>" == "shareMy" && "<%=itemData%>" != ""){
			shareMyIdMap["<%=defaultCid%>"] = eval("(<%=itemData%>)");
		}else if("<%=defaultPosition%>" == "myShare" && "<%=itemData%>" != ""){
			myShareIdMap["<%=defaultCid%>"] = eval("(<%=itemData%>)");
		}
		
		var uploadfinish = false;
		var userLoginId = "<%=user.getLoginid()%>";
		var languageid = <%=user.getLanguage()%>;
	</script>
		<style type="text/css">
a {
	cursor: pointer;
}


.e8MenuNav .e8Home {
	background-repeat: no-repeat;
	background-position: 50% 5px;
	background-image: url(/images/ecology8/newdoc/home_wev8.png);
	height: 30px;
	width: 30px;
	cursor: pointer;
}

.e8MenuNav .e8Expand {
	background-repeat: no-repeat;
	background-position: 50% 9px;
	background-image: url(/images/ecology8/newdoc/expand_wev8.png);
	height: 100%;
	width: 30px;
	cursor: pointer;
	top: 0px;
	right: 0px;
	position: absolute;
	display: none;
}

.e8MenuNav .e8ParentNav {
	width: 93%;
	height: 100%;
	margin-left: 30px;
	margin-top: -30px;
}

.e8MenuNav .e8ParentNav .e8ParentNavLine {
	background-image: url(/images/ecology8/newdoc/line_wev8.png);
	background-repeat: no-repeat;
	background-position: 50% 50%;
	width: 20px;
	height: 30px;
	float: left;
}

.e8MenuNav .e8ParentNav .e8ParentNavContent {
	height: 30px;
	line-height: 30px;
	float: left;
	max-width: 121px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.opBtn {
	background-color: #f2f2f2;
	text-align: center;
	border-radius: 3px;
}

.newFolder {
	width: 78px;
	height: 25px;
	position: absolute;
	left: -150px;
	top: 2px;
	cursor: pointer;
}

.uploadOpBtn {
	width: 60px;
	height: 25px;
	position: absolute;
	left: -60px;
	top: 2px;
	cursor: pointer;
}

.downloadOpBtn {
	width: 60px;
	height: 25px;
	top: 2px;
	position: absolute;
	left: -58px;
	cursor: pointer;
}

.fimg {
	float: left;
	width: 30%;
	margin-top: 6px;
	margin-left: 3px;
}

.ftext {
	float: left;
	width: 70%;
	margin-left: -6px;
	margin-top: 4px;
}

.uimg {
	float: left;
	width: 20%;
	margin-top: 4px;
	margin-left: 11px;
}

.utext {
	float: left;
	width: 80%;
	margin-left: -11px;
	margin-top: 4px;
}

.dimg {
	float: left;
	width: 20%;
	margin-top: 4px;
	margin-left: 11px;
}

.dtext {
	float: left;
	width: 80%;
	margin-left: -11px;
	margin-top: 4px;
}

.swfUploadBtn {
	float: right;
	width: 59px;
	margin-top: -34px;
	right: 25px;
	position: absolute;
}

.uploadImg {
	float: left;
	margin-top: 5px;
	margin-left: 6px;
}

.downloadImg {
	float: left;
}

.nava {
	color: #8e9598;
}

.nava:hover {
	color: #474f60;
}

.closesearch {
	width: 18px;
	height: 18px;
	float: right;
	margin: 6px 20px 6px 10px;
	cursor: pointer;
	background-image: url("/rdeploy/assets/img/wf/searchclose.png");
	background-repeat: no-repeat;
	background-position: center;
}

.closesearch:hover {
	width: 18px;
	height: 18px;
	float: right;
	margin: 6px 20px 6px 10px;
	cursor: pointer;
	background-image: url("/rdeploy/assets/img/wf/searchclosehot.png");
	background-repeat: no-repeat;
	background-position: center;
}

.upDiv {
	width: 30px;
	height: 30px;
	border: 1px solid #dadada;
	background-image: url("/rdeploy/assets/img/cproj/doc/up.png");
	background-repeat: no-repeat;
	background-position: center;
	float: left;
	cursor: pointer;
}

.upDiv:hover {
	width: 30px;
	height: 30px;
	border: 1px solid #dadada;
	background-image: url("/rdeploy/assets/img/cproj/doc/up_hot.png");
	background-repeat: no-repeat;
	background-position: center;
	float: left;
}

#outdepartmentiddiv {
	margin-right: -38px !important;
}

.e8MenuNav {
	width: 472px;
	height: 30px;
	color: #939d9e;
	vertical-align: middle;
	border: 1px solid #dadada;
	top: 0px;
	float: right;
}

.uploadError {
	text-align: center;
	height: 16px;
	border: 1px solid #e4e4e4;
	background-color: #fff;
	width: 99%;
	z-index: 99;
	top: 50%;
	position: absolute;
	display: none;
}

.progressWrapper {
	height: 45px;
}

.rprogressContainer {
	background: #fff none repeat scroll 0 0;
	overflow: hidden;
}


.rgreen {
	
}

.norecord_uploadDiv {
    position: absolute;
    left: 43%;
    top: 30%;
    width: 75px;
    height: 130px;
}

.fileIconDiv {
	float: left;
	padding-top: 15px;
	padding-left: 19px;
}

.rprogressName {
	float: left;
	padding-top: 15px;
	padding-left: 8px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	width: 230px;
	text-align: left;
}

.fileSize {
	float: left;
	color: #aaaaaa;
	padding-top: 15px;
	padding-left: 15px;
	text-align: left;
	width:50px;
}

.rprogressBarStatus {
	float: left;
	padding-top: 15px;
	padding-left: 70px;
	color: #3fca6a;
	width: 70px;
}

.swfuploadbtn{
	float:left;
}

.cancelDiv {
	float: right;
    margin-right: 20px;
    margin-top: 17px;
    width: 15px;
    height: 15px;
    background: url('/rdeploy/assets/img/cproj/doc/op/cancel_file.png') 0 0 no-repeat !important;
    cursor: pointer;
    display: none;
}
.cancelDiv:hover {
	background: url('/rdeploy/assets/img/cproj/doc/op/cancel_file_hot.png') 0 0 no-repeat !important;
}

/*进度条*/
.rprogressBarInProgress {
	height: 2px;
	background: #4ba9df;
	z-index: 9999;
	width: 0px;
	float:left;
	margin-top:-1px;
}

.rprogressBarInProgressLine {
	height: 1px;
	background: #dadada;
	margin-top: 10px;
	width: 100%;
	float:left;
	// margin-left: 20px;
}

.clearBoth {
	clear: both;
}

.rprogressError {
	float: left;
	padding-top: 15px;
	padding-left: 0px;
	width: 77px;
	text-align: left;
	display: none;
}

.progressBarInProgressWrapper {
	height: 30px;
	border: 1px solid #e4f1fa;
	background: #fff;
	position: relative !important;
}

.progressBarInProgressScale {
	position: absolute;
	left: 5px;
	top: 5px;
	color: #83a85b;
	font-size: 12px;
	font-family: 微软雅黑;
}

.rprogressCancel {
	width: 15px;
	height: 15px;
	background: url('/rdeploy/assets/img/doc/cancel.png') 0 0 no-repeat
		!important;
	display: inline-block;
}

.rprogressSucess {
	width: 15px;
	height: 15px;
	background: url('/rdeploy/assets/img/doc/upload_sucess.png') 0 0
		no-repeat !important;
	display: inline-block;
}

.btstyle01 {
	display: block;
	width: 100px;
	height: 32px;
	font-size: 14px;
	text-align: center;
	line-height: 32px;
	cursor: pointer;
	background: #43b2ff;
	color: #FFFFFF;
	font-family: 微软雅黑;
}

.btstyle02 {
	display: block;
	width: 100px;
	height: 32px;
	font-size: 14px;
	text-align: center;
	line-height: 32px;
	cursor: pointer;
	background: #18a0ff;
	color: #FFFFFF;
	font-family: 微软雅黑;
}

.uploadCImg {
	float: right;
    padding-right: 15px;
    cursor: pointer;
    width: 15px;
    height: 15px;
    background: url('/rdeploy/assets/img/cproj/doc/upload_close.png') 0 0 no-repeat !important;
    display: inline-block;
    margin-top: 15px;
}
.uploadCImg:hover {
    background: url('/rdeploy/assets/img/cproj/doc/upload_close_hot.png') 0 0 no-repeat !important;
}

.uploadMImg {
	float: right;
    padding-right: 10px;
    cursor: pointer;
    width: 15px;
    height: 15px;
    background: url('/rdeploy/assets/img/cproj/doc/upload_min.png') 0 0 no-repeat !important;
    display: inline-block;
    margin-top: 12px;
}
.uploadMImg:hover {
    background: url('/rdeploy/assets/img/cproj/doc/upload_min_hot.png') 0 0 no-repeat !important;
}

.uploadMImg_max {
	float: right;
    padding-right: 10px;
    cursor: pointer;
    width: 15px;
    height: 15px;
    background: url('/rdeploy/assets/img/cproj/doc/upload_max.png') 0 0 no-repeat !important;
    display: inline-block;
    margin-top: 16px;
}
.uploadMImg_max:hover {
    background: url('/rdeploy/assets/img/cproj/doc/upload_max_hot.png') 0 0 no-repeat !important;
}
.calcelAllDiv {
	border: 1px solid #F9F7F9;border-top-style: none;height: 35px;background-color: #F9F7F9;text-align: center;line-height: 35px; cursor: pointer;
}

.nocalcelAllDiv {
	border: 1px solid #d7e2e4;border-top-style: none;height: 35px;background-color: #F9F7F9;text-align: center;line-height: 35px;
}


/*** 样式调整wqs **/
.syncSetting{
	text-align:right;
	float:right;
	cursor:pointer;
}
.syncSetting span{
	height:25px;
	line-height:25px;
	display:inline-block;
	margin-right:5px;
}

table{
	background-color:#ffffff;
}

body{
	min-width:840px;
	overflow-x:hidden;
	padding-top:175px;
}
.input-group{
	position:absolute;
	right:15px;
	top:5px;
	line-height:inherit;
}
.input-group input.searchinput[type="text"]{
	border:0px;
	padding-top:0px;
	padding-bottom:0px;
}
.input-group input.private.searchinput[type="text"]{
	width:215px;
}
.input-group span.adspan{
	line-height:27px;
	height:29px;
}

.e8MenuNav{
	float:left;
	width:100%;
}
.upDiv{
	float:none;
	position:absolute;
	left:0px;
	top:0px;
}
#contentall{
	position:absolute;
	left:0px;
	top:0px;
	width:100%;
}

#viewOpDiv{
	position:absolute;
	right:20px;
	top:10px;
}

.imageViewOpBtn,.listViewOpBtn{
	float:left;
	width:24px;
	height:24px;
	cursor:pointer;
	border:1px solid #f1f1f1;
}
.imageViewOpBtn{
	border-right:0px;
}


.swfuploadbtn{
	width:100px;
	top:10px;
	left:10px;
	margin-top:0px;
	position:absolute;
	cursor:pointer;
}
.swfuploadbtn object{
	width:100px !important;
	height:26px !important;
}
.hiddensearch{
	top:150px;
}
.netDiskMenu.select,.shareMenu.select,.netDiskMenu:hover,.shareMenu:hover{
	color:#3597F1;
}
.size15{
	font-size:15px;
}

.netDiskShare{
	height:30px;
}
.netDiskShare .shareMenuLi{
	float:left;
}
.netDiskShare .shareOperate{
	float:right;
}
.netDiskShare .shareMenuLi li{
	float:left;
	min-width:50px;
	text-align:center;
	padding:5px 15px;
	cursor: pointer;
	font-size:14px;
	list-style:none;
}
.netDiskShare .shareMenuLi li.select{
	color:#3597F1;
}

.shareSelectLine{
	position:absolute;
	top:44px;
	border-bottom:2px solid #1f93f5;
	display:none;
}
.netDiskShare .shareMenuLi li.select .shareSelectLine{
	display:block;
}
.shareSelectLine.myShare{
	left:50px;
	width:85px;
}
.shareSelectLine.shareMy{
	left:135px;
	width:100px;
}

/**右键菜单*/
#rightClickMenu,#rightClickMenu ul{
	display:none;
	position:absolute;
	width:146px;
	border:1px solid #a4a4a4;
	padding:10px 0px;
	z-index:10;
	background:#f9f9f9;
	box-shadow:1px 2px 1px #E0DBDB;
}
#rightClickMenu li{
	list-style:none;
	line-height:25px;
	height:25px;
	cursor:pointer;
	position:relative;
	padding:0px 10px;
}
#rightClickMenu .lineLi{
	border-bottom:1px solid #d8d8d8;
	height:1px;
	padding:0px;
	margin:5px 0;
	cursor:default;
}
#rightClickMenu ul{
	top:0px;
	right:-146px;
}
#menuUploadDiv{
	position:absolute;
	width:100% ;
	height:25px;
	z-index:10;
}
#menuUploadDiv object{
	width:100% !important;
}

.h2{
	height:4px;
}

.rightMenu span.mtext{
	display:inline-block;
	padding-left:24px;
	background-repeat:no-repeat;
	background-position:left center;
	color:#000000;
	text-overflow:ellipsis;
	white-space:nowrap;
	overflow:hidden;
	width:90px;
}

#rightClickMenu .menu_right{
	float:right;
	width:9px;
	height:25px;
	background:url("/rdeploy/assets/img/cproj/operate/menu_r.png") no-repeat left center;
}

#openLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_open.png");
}
#downloadLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_download.png");
}
#syncDownloadLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_sync_download.png");
}
#shareLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_share.png");
}
#publicLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_public.png");
}
#moveLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_move.png");
}
#copyLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_copy.png");
}
#pasteLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_paste.png");
}
#pasteLi.disabled span.mtext{
	color:#aaaaaa;
}
#renameLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_rename.png");
}
#deleteLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_delete.png");
}
#uploadLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_upload.png");
}
#createLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_create.png");
}
#viewLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_view.png");
}
#viewLi_M span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_view_m.png");
}
#viewLi_L span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_view_l.png");
}
#refreshLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_refresh.png");
}
#orderLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_order.png");
}
#orderLi_N span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_order_n.png");
}
#orderLi_T span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_order_t.png");
}
#shareObjLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_share_obj.png");
}
#cancelShareLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_cancel.png");
} 
#save2DistLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_save_disk.png");
} 
#subDocscribeLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_sub_docscribe.png");
}
#askLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_commit_sub.png");
}
#importSelectLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_import_select.png");
}
#importAllLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_import_all.png");
}
#downloadBatchLi span.mtext{
	background-image:url("/rdeploy/assets/img/cproj/operate/menu_mul_down.png");
}


.rightMenu .rightMenu2 span.mtext{
	width:80px;
}

#rightClickMenu li:hover{
	background-color:rgb(230,230,230);
}

/**操作按钮图标*/
.operateDiv{
	background-color:#f1f1f1;
	padding:10px;
	padding-right:90px;
	height:25px;
	position:relative;
}

.requestviewselect,.showrequestline,.createrFolderDiv,.newFolder,.uploadOpBtn,.downloadOpBtn{
	position:static;
}
.requestviewselect,.netDiskShare{
	height:25px;
}
.requestviewselect .opBtn,.netDiskShare .opBtn{
	float:left;
	border:1px solid #f1f1f1;
	width:auto;
	padding:5px 10px;
	cursor:pointer;
	margin-right:10px;
	text-align:center;
}
.requestviewselect .opBtn .dimage,.netDiskShare .opBtn .dimage,.imageViewOpBtn,.listViewOpBtn,.syncSetting .dimage,.operateBgImage{
	background-image:url("/rdeploy/assets/img/cproj/operate/operate.png");
	background-repeat:no-repeat;
}

.opBtn .dimage{
	float:left;
	width:23px;
	height:18px;
	margin-right:5px;
}
.netDiskShare .opBtn{
	min-width:60px;
}
 
.opBtn .fimg,.opBtn .uploadImg{
	display:none;
}
.dtext,.ftext,.utext{
	margin:0;
	width:auto;
}
.uploadOpBtn,.newFolder,.downloadOpBtn{
	height:auto;
}
.requestviewselect .opBtn.btnHover,.requestviewselect .opBtn:hover,
.netDiskShare .opBtn.btnHover,.netDiskShare .opBtn:hover{
	background-color:#ffffff;
	border-color:#dcdcdc;
	cursor:pointer;
}


.opBtn.disabled{
	 color:#aaaaaa !important;
	 background-color:transparent !important;
	 cursor:default !important;
	 border-color:#f1f1f1 !important;
}

#createDoc .dimage{
	background-position:-99px -4px;
}
#createDoc.btnHover .dimage{
	background-position:-124px -4px;
}
#createDoc.disabled .dimage{
	background-position:-56px -202px;
}
#downloadFileMul .dimage{
	background-position:-76px -148px;
}
#downloadFileMul.btnHover .dimage{
	background-position:-100px -148px;
}
#downloadFileMul.disabled .dimage{
	background-position:-52px -148px;
}
#askNoPermission .dimage{
	background-position:-6px -174px;
}
#askNoPermission.btnHover .dimage{
	background-position:-53px -174px;
}
#askNoPermission.disabled .dimage{
	background-position:-29px -174px;
}

#markDoc .dimage{
	background-position:-146px -148px;
}
#markDoc.btnHover .dimage{
	background-position:-168px -148px;
}
#markDoc.disabled .dimage{
	background-position:-124px -148px;
}
#markAllDoc .dimage{
	background-position:-79px -174px;
}
#markAllDoc.btnHover .dimage{
	background-position:-124px -174px;
}
#markAllDoc.disabled .dimage{
	background-position:-102px -174px;
}
#myDiskDiv .dimage{
	background-position:-6px -201px;
}
#myDiskDiv.btnHover .dimage{
	background-position:-29px -201px;
}



#uploadFileDiv .dimage{
	background-position:-51px -3px;
}
#uploadFileDiv.btnHover .dimage{
	background-position:-76px -3px;
}

#createrFolderDiv .dimage{
	background-position:-99px -3px;
}
#createrFolderDiv.btnHover .dimage{
	background-position:-124px -3px;
}

.downloadOpBtn .dimage{
	background-position:-76px -25px;
}
.downloadOpBtn.btnHover .dimage{
	background-position:-99px -25px;
}
.downloadOpBtn.disabled .dimage{
	background-position:-52px -25px;
}

#syncDownloadDiv .dimage{
	background-position:-23px -77px;
}
#syncDownloadDiv.btnHover .dimage{
	background-position:-46px -77px;
}
#syncDownloadDiv.disabled .dimage{
	background-position:0px -77px;
}

#shareDiv .dimage{
	background-position:-145px -26px;
}
#shareDiv.btnHover .dimage{
	background-position:-169px -26px;
}
#shareDiv.disabled .dimage{
	background-position:-121px -26px;
}

#publicDiv .dimage{
	background-position:-144px -52px;
}
#publicDiv.btnHover .dimage{
	background-position:-167px -52px;
}
#publicDiv.disabled .dimage{
	background-position:-120px -52px;
}

#deleteDiv .dimage{
	background-position:-71px -50px;
}
#deleteDiv.btnHover .dimage{
	background-position:-95px -50px;
}
#deleteDiv.disabled .dimage{
	background-position:-47px -50px;
}

#systemDiv .dimage{
	background-position:2px -50px;
}
#systemDiv.btnHover .dimage{
	background-position:-21px -50px;
}

#cancelShareDiv .dimage{
	background-position:-168px -75px;
	height:19px;
}
#cancelShareDiv.btnHover .dimage{
	background-position:-2px -98px;
}
#cancelShareDiv.disabled .dimage{
	background-position:-145px -75px;
}

#saveShareDiv .dimage{
	background-position:-99px -76px;
}
#saveShareDiv.btnHover .dimage{
	background-position:-122px -76px;
}
#saveShareDiv.disabled .dimage{
	background-position:-75px -76px;
}

.listViewOpBtn{
	background-position:1px -24px;
}
.listViewOpBtn.btnHover{
	background-position:-23px -24px;
}
.imageViewOpBtn{
	background-position:-144px 0px;
}
.imageViewOpBtn.btnHover{
	background-position:-169 0px;
}

.imageViewOpBtn.btnHover,.listViewOpBtn.btnHover{
	background-color:#ffffff;
	border-color:#dcdcdc;
}

.syncSetting {
	padding:0px 8px;
	border:1px solid #ffffff;
	margin-top:24px;
}
.syncSetting.btnHover{
	border-color:#dcdcdc;
	background-color:#ffffff;
}
.syncSetting .dimage{
	background-position:-2px 0px;
}
.syncSetting.btnHover .dimage{
	background-position:-27px 0px;
}

.syncSetting .dimage{
	display:inline-block;
	width:18px;
	height:25px;
	text-indent:99999px;
	margin-right:0px;
}

#dataloadingbg,#dataloading{
	display:none;
}
#dataloading{
	text-align: center;
	 position:fixed; 
	 left: 45%; 
	 top: 20%; 
	 z-index:1999;
}
#dataloadingbg{
	position:fixed;
	top:0;
	left:0;
	height:100%;
	width:100%;
	background-color:#ffffff;
	filter:alpha(opacity=0); 
	opacity:0;
	margin-top:40px;
	z-index:1998;
}
html{
	height:100%;
	overflow:hidden;
}

/**进程窗口*/
#uploadList{
	background-color:#FFFFFF;
	width: 650px;
	position: fixed; 
	right: 20px; 
	bottom: 0px; 
	z-index: 999;
}

#uploadDialogBody{
	border-width: 1px; 
	border-style: none solid solid;
	border-color: rgb(215, 226, 228); 
	height: 450px; 
	outline: none; 
	display: none; 
	overflow-y: hidden;
	background-color: rgb(255, 255, 255);
}

#uploadTab ul{
	width:100%;
	height:35px;
	padding:0px;
	margin-bottom:0px;
}
#uploadTab ul li{
	float:left;
	list-style:none;
	height:35px;
	line-height:35px;
	background-color:#e8f6ff;
	width:25%;
	text-align:center;
	cursor:pointer;
	color:#275c7b;
}

.systemUpload #uploadTab ul li{
	width:33.3%;
}

#uploadTab ul li > div{
	border-bottom:1px solid #c3d5df;
}

#uploadTab ul li.select{
	background-color:#FFFFFF;
}
#uploadTab ul li.select > div{
	border-left:1px solid #c3d5df;
	border-right:1px solid #c3d5df;
	border-bottom-color:#FFFFFF;
}
#uploadTab ul li:first-child div{
	border-left:0;
}
#uploadTab ul li:last-child div{
	border-right:0;
}
#uploadTab ul li .numSpan{
	display:none;
}
#uploadBody{
	height: 410px; 
}
#uploadBody ul{
	padding:0px;
	margin-bottom:0px;
}

#uploadBody ul li{
	display:none;
	list-style:none;
}
#uploadBody ul li#uploadingContent{
	display:block;
}
.fullProcess{
	height:24px;
	padding:10px;
	border-bottom:1px solid #c3d5df;
}
.fullProcess label,.fullProcess .fullProcessBarDiv{
	float:left;
	height:24px;
	line-height:24px;
	float:left;
}
.fullProcess label{
	padding-left:5px;
	padding-right:15px;
	font-weight:normal;
}
.fullProcess .fullProcessBarDiv{
	width:295px;
	padding:3px;
	height:17px;
	border:1px solid #4BAADF;
	position:relative;
}
.fullProcess .fullProcessBarDiv .fullProcessBar{
	height:100%;
	width:0%;
	background-color:#4BAADF;
}
.fullProcessBarDiv .fullPrecent{
	position:absolute;
	width:100%;
	height:100%;
	text-align:center;
	left:0px;
	top:0px;
}
.operateBtn{
	padding:8px 25px;
	height:12px;
	line-height:12px;
	display:inline-block;
	border:1px solid #E4E4E4;
	margin-left:10px;
	margin-top:-3px;
	cursor:pointer;
	color:#3c4250;
}
.operateBtn.fl_right{
	float:right;
	margin-right:12px;
}
#fullTab{
	width:100%;
	height:24px;
	padding: 10px 0px;
    line-height: 24px;
    border-bottom: 1px solid #c3d5df;
}
#fullTab > div.tab{
	float:left;
	cursor:pointer;
	padding:0px 10px;
	color:#2c5c7b;
}
#fullTab > div.tab.select{
	color:#3597F1;
}
#fullTab > .tabLine{
	border-left:1px solid #c3d5df;
	float:left;
	width:1px;
	height:14px;
	margin-top:6px;
}
#allProcee{
	margin-left:5px;
}

#fullTab .processSpan{
	display:none;
}
.syncCompleteMsg{
	float:left;
	height: 100%;
    line-height: 24px;
    margin-left: 10px;
    color:#2c5c7b;
}

/**上传、下载、同步窗口*/

#uploadingContent .fullProcess .operateBgImage{
	background-position:-124px -124px;
	margin-top:4px;
}
#downloadingContent .fullProcess .operateBgImage{
	background-position:-148px -124px;
	margin-top:4px;
}
.operateBgImage{
	float:left;
	display:inline-block;
	width:16px;
	height:16px;
	margin-right:3px;
}
.uploadComplete,.downloadComplete{
	color:#275c7b;
}
.uploadComplete .operateBgImage{
	background-position:-6px -148px;
}
.downloadComplete .operateBgImage{
	background-position:-173px -124px;
}
.openFile,.openFolder,.clearFile,.stopFile,.cancelFile,.startFile,.cantDo{
	float:left;
	margin-left:33px;
}
.stopFile,.startFile,.cantDo{
	margin-left:80px;
}
.openFile .operateBgImage,
.openFolder .operateBgImage,
.clearFile .operateBgImage,
.stopFile .operateBgImage,
.cancelFile .operateBgImage,
.startFile .operateBgImage{
	cursor:pointer;
}
.cantDo .operateBgImage{
	background-image:none;
}
.openFile .operateBgImage{
	background-position:-77px -124px;
}
.openFile .operateBgImage:hover{
	background-position:-100px -124px;
}
.openFolder .operateBgImage{
	background-position:-28px -124px;
}
.openFolder .operateBgImage:hover{
	background-position:-52px -124px;
}
.clearFile .operateBgImage{
	background-position:-124px -98px;
}
.clearFile .operateBgImage:hover{
	background-position:-148px -98px;
}
.stopFile .operateBgImage{
	background-position:-28px -100px;
}
.stopFile .operateBgImage:hover{
	background-position:-51px -100px;
}
.cancelFile .operateBgImage{
	background-position:-76px -100px;
}
.cancelFile .operateBgImage:hover{
	background-position:-100px -100px;
}
.startFile .operateBgImage{
	background-position:-170px -99px;
}
.startFile .operateBgImage:hover{
	background-position:-6px -124px;
}

#upload_current,#download_current,#upload_over,#download_over{
	float:left;
	margin-left:10px;
	color:#ffffff;
	font-size:13px;
	display:none;
}

#upload_current .precent_current,#download_current .precent_current{
	display:inline-block;
	padding-left:8px;
}
.empty_data{
	padding-top:210px;
	text-align:center;
	color:gray;
	background:url("/rdeploy/assets/img/cproj/operate/empty.png") no-repeat center 140px;
}
#sendCompleteContent .empty_data{
	padding-top:165px;
	background-position:center 95px;
}
.systemUpload #sendCompleteContent .empty_data{
	padding-top:210px;
	background-position:center 140px;
}

#searchdivNav a.nava,#subDivNav a.nava{
	cursor:default;
}
#searchdivNav a.nava:hover,#subDivNav a.nava:hover{
	color:#8e9598;
}
.e8MenuNav .e8ParentNav #searchdivNav.e8ParentNavContent{
	max-width:220px;
}

#toaskInfo{
	/**width: 135px;**/
	padding-right:17px;
    height: 44px;
    line-height: 44px;
    position: fixed;
    left: 50%;
    top: 50%;
    margin-left: -58px;
    margin-top: -20px;
    z-index: 100000;
    background-color: #FFF;
    border: 1px solid #ccc;
    border-radius: 3px;
    box-shadow: 0 0 6px rgba(0,0,0,0.25);
    display: none;
}
#toaskInfo .msg{
	background: url('/social/images/public/favourite_success_wev8.png') no-repeat left center;
    margin-left: 17px;
    padding-left: 32px;
    color: #7d7c7c;
    font-size: 14px;
}
#toaskInfo .msg.warn{
	background-image:url("/rdeploy/assets/img/cproj/operate/delete_warn.png");
}

.selectDiv{
	display:inline-block;
	width:110px;
	cursor:pointer;
	height:27px;
	position:relative;
}
.optionDiv{
	top:0px;
	width:80px;
	position:absolute;
	overflow:hidden;
	height:25px;
	margin-left:-6px;
}
.selectOption{
	height:25px;
	line-height:25px;
	text-indent:0px;
	cursor:pointer;
	border:1px solid #ffffff;
	padding-left:5px;
}

.selectOption.first{
	background-color:#ffffff;
	background-image:url("/rdeploy/assets/img/cproj/operate/select_icon.png");
	background-position:60px center;
	background-repeat:no-repeat;
}
.optionDiv:hover{
	height:auto;
}
.optionDiv:hover .selectOption{
	border:1px solid #E9E9E9;
	background-color:#f3f3f3;
} 
.optionDiv:hover .selectOption.first{
	cursor:default;
	background-color:#ffffff;
	border-bottom-color:#ffffff;
}

</style>

<%--

	RCMenu += "{打开,javascript:onOpen(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{下载,javascript:onDownload(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{分享,javascript:onShare(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{发布到系统,javascript:onPublic(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{复制到,javascript:onCopy(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{移动到,javascript:onMove(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{重命名,javascript:onRename(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{删除,javascript:onDelete(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{上传文件,javascript:onUpload(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{新建目录,javascript:createrFolder(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{刷新,javascript:onRefresh(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
--%>

<script>
	if(window.__isBrowser){
	   document.write('<LINK href="/rdeploy/assets/css/browser.css?<%=jsVersion %>" type=text/css rel=STYLESHEET \/>');

	   document.write('<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js?<%=jsVersion %>"><\/script>');
	   document.write('<script type="text/javascript" src="/rdeploy/assets/js/doc/chatproject/swfupload.queue_wev8.js?<%=jsVersion %>"><\/script>');
	   document.write('<script type="text/javascript" src="/rdeploy/assets/js/doc/chatproject/rdeploy_handlers_wev8_new.js?<%=jsVersion %>"><\/script>');
	   document.write('<script type="text/javascript" src="/rdeploy/assets/js/doc/rdeploy_doc_swfupload_wev8.js?<%=jsVersion %>"><\/script>');
	   document.write('<script type="text/javascript" src="/rdeploy/assets/js/doc/chatproject/fileprogress_wev8_new.js?<%=jsVersion %>"><\/script>');
	   document.write('<script type="text/javascript" src="/rdeploy/assets/js/doc/chatproject/uploadfile_wev8.js?<%=jsVersion %>"><\/script>');
	}
</script>

	</head>

	<body>
	
		<div id="contentall">
			<div class="width100 title-bg">
				<table width="100%" height="60px" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="60px" />
						<col width="*" />
						<col width="280px" />
					</colgroup>
					<tr>
						<td style="padding:10px;">
							<img src="/rdeploy/assets/img/cproj/doc/icon.png" width="40px"
								height="40px" />
						</td>
						<td>
							<div class="selectDiv">
								<div class="optionDiv no-drag">
									<div class="selectOption first">
										<%=isSystemDoc ? "系统目录" : SystemEnv.getHtmlLabelName(129207,user.getLanguage())%> 
									</div>
									<div class="selectOption">
										<%=isSystemDoc ? SystemEnv.getHtmlLabelName(129207,user.getLanguage()) : "系统目录"%> 
									</div>
								</div>
							</div>
							<div class="h2"></div>
							<div style="height:16px;" id="diskShareTab"> 
							<%if(!isSystemDoc){ %>
                                    <a class="netDiskMenu <%="privateAll".equals(defaultPosition) ? "select" : ""%>"><%=SystemEnv.getHtmlLabelName(129151,user.getLanguage())%></a>
                                    &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <a class="shareMenu <%=!"privateAll".equals(defaultPosition) ? "select" : ""%>"><%=SystemEnv.getHtmlLabelName(129144,user.getLanguage())%></a> 
                            </script>
							<%} %>
							</div>
						</td>
						<td class="padding-right-20">
							<%if(!isSystemDoc){ %>
							
							<script>
								 if(!window.__isBrowser){
									 document.write('<div class="syncSetting" onclick="syncSetting()">' +
									 '	<span class="dimage">1</span>' +
								 '	<span><%=SystemEnv.getHtmlLabelName(21952,user.getLanguage())%></span>' +
									 '</div>');
								 }
							</script>	 
							
							 <%} %>
						</td>
					</tr>
				</table>
			</div>
			<div class="showrequestline"></div>
			
			
			<div class="operateDiv" id="operateDiv">
				<%if(isSystemDoc){ %>
					<div class="requestviewselect" id="requestviewselect"
						style="top: 70px;">
						
						<%--上传文件 --%>
						<div id="createDoc" name="createDocDiv"
							class="opBtn createDocOpBtn disabled">
							<div class="dimage"></div>
							<div class="dtext">
								<%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%>
							</div>
						</div>
						
						<%--附件批量下载 --%>
						<div id="downloadFileMul" name="downloadFileMulDiv"
							class="opBtn downloadFileMulBtn selectBtn disabled">
							<div class="dimage"></div>
							<div class="dtext">
								<%=SystemEnv.getHtmlLabelName(27105,user.getLanguage())%>
							</div>
						</div>
						
						<%--订阅无权限查看的文档 --%>
						<div id="askNoPermission" name="askNoPermissionDiv"
							class="opBtn askNoPermissionBtn disabled">
							<div class="dimage"></div>
							<div class="dtext">
								<%=SystemEnv.getHtmlLabelName(129209,user.getLanguage())%>
							</div>
						</div>
						
						<%--标记文档 --%>
						<div id="markDoc" name="markDocDiv"
							class="opBtn markDocBtn selectBtn disabled">
							<div class="dimage"></div>
							<div class="dtext">
								<%=SystemEnv.getHtmlLabelName(129210,user.getLanguage())%>
							</div>
						</div>
						
						<%--标记所有文档 --%>
						<div id="markAllDoc" name="markAllDocDiv"
							class="opBtn markAllDocBtn disabled">
							<div class="dimage"></div>
							<div class="dtext">
								<%=SystemEnv.getHtmlLabelName(129211,user.getLanguage())%>
							</div>
						</div>
						
						<%-- 我的云盘 --%>
						<%--
						<div id="myDiskDiv" name="myDiskDiv"
							class="opBtn myDiskBtn">
							<div class="dimage"></div>
							<div class="dtext">
								<%=SystemEnv.getHtmlLabelName(129207,user.getLanguage())%>
							</div>
						</div>
						--%>
					</div>	
				<%}else{ %>
					<div class="requestviewselect" id="requestviewselect" 
						style="top: 70px; <%="privateAll".equals(defaultPosition) ? "" : "display:none"%>">
						
						<%--上传文件 --%>
						<div id="uploadFileDiv" name="uploadFileDiv"
							class="opBtn uploadOpBtn">
							<div class="dimage"></div>
							<div class="dtext">
								<%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%>
							</div>
						</div>
						
						<%--新建目录 --%>
						<div id="createrFolderDiv" name="createrFolderDiv"
							class="opBtn newFolder">
							<div class="dimage"></div>
							<div class="dtext">
								<%=SystemEnv.getHtmlLabelName(20002,user.getLanguage())%>
							</div>
						</div>
						
						<%-- 由于批量下载性能问题，在没有解决方案前先隐藏此功能--%>
						<div id="downloadDiv" name="downloadDiv"
							class="opBtn downloadOpBtn selectBtn disabled">
							<div class="dimage"></div>
							<div class="dtext">
								<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>
							</div>
						</div>
						
						<%-- 分享 --%>
						<script>
							if(!window.__isBrowser){
								document.write(
								'<div id="shareDiv" name="shareDiv"' +
								'	class="opBtn shareOpBtn selectBtn disabled">' +
								'	<div class="dimage"></div>' +
								'	<div class="dtext">' +
								'		<%=SystemEnv.getHtmlLabelName(129144,user.getLanguage())%>' +
								'	</div>' +
								'</div>');
							}
						</script>
						<%-- 发布到系统 --%>
						<div id="publicDiv" name="publicDiv"
							class="opBtn publicOpBtn selectBtn disabled">
							<div class="dimage"></div>
							<div class="dtext">
								<%=SystemEnv.getHtmlLabelName(129148,user.getLanguage())%>
							</div>
						</div>
						<%--删除 --%>
						<div id="deleteDiv" name="deleteDiv" 
							class="opBtn systemOpBtn selectBtn disabled">
							<div class="dimage"></div>
							<div class="dtext">
								<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
							</div>
						</div>
						
						<%--<div id="syncDownloadDiv" name="syncDownloadDiv"
							class="opBtn syncDownloadBtn">
							<div class="dimage"></div>
							<div class="dtext">
								<%=SystemEnv.getHtmlLabelName(129212,user.getLanguage())%>
							</div>
						</div>--%>
						
						<%-- 查看系统文档 --%>
						<%--<div id="systemDiv" name="systemDiv"
							class="opBtn systemOpBtn">
							<div class="dimage"></div>
							<div class="dtext">
								<%=SystemEnv.getHtmlLabelName(129213,user.getLanguage())%>
							</div>
						</div>--%>
						
					</div>
					
					<div class="netDiskShare" id="netDiskShare" <%="privateAll".equals(defaultPosition) ? "style='display:none'" : ""%>>
						<div class="shareMenuLi">
							<ul>
								<li <%="myShare".equals(defaultPosition) ? "class='select'" : ""%>><%=SystemEnv.getHtmlLabelName(33310,user.getLanguage())%><div class="shareSelectLine myShare"></div></li>
								<li <%="shareMy".equals(defaultPosition) ? "class='select'" : ""%>><%=SystemEnv.getHtmlLabelName(129146,user.getLanguage())%><div class="shareSelectLine shareMy"></div></li>
							</ul>
						</div>
						
						<div class="shareOperate">
							<%-- 取消分享 --%>
							<div id="cancelShareDiv" name="cancelShareDiv"
								class="opBtn cancelShareOpBtn selectBtn disabled"  <%="myShare".equals(defaultPosition) ? "" : "style='display:none'"%>>
								<div class="dimage"></div>
								<div class="dtext">
									<%=SystemEnv.getHtmlLabelName(129158,user.getLanguage())%>
								</div>
							</div>
							
							<%-- 保存到云盘 --%>
							<div id="saveShareDiv" name="saveShareDiv"
								class="opBtn saveShareOpBtn selectBtn disabled" <%="shareMy".equals(defaultPosition) ? "" : "style='display:none'"%>>
								<div class="dimage"></div>
								<div class="dtext">
									<%=SystemEnv.getHtmlLabelName(129159,user.getLanguage())%>
								</div>
							</div>
							
							<%-- 下载 --%>
							<div id="downloadShareDiv" name="downloadShareDiv"
								class="opBtn downloadOpBtn selectBtn disabled">
								<div class="dimage"></div>
								<div class="dtext">
									<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>
								</div>
							</div>
							
						</div>
						<div style="clear: both;"></div>
					</div>
					
					<%} %>	
						<div id="viewOpDiv">
							<%-- 图标视图 --%>
							<div id="imageViewDiv" name="imageViewDiv" title="<%=SystemEnv.getHtmlLabelName(129214,user.getLanguage())%>" style="display:none"
								class="imageViewOpBtn select">
							</div>
							
							<%-- 列表视图 --%>
							<div id="listViewDiv" name="listViewDiv" title="<%=SystemEnv.getHtmlLabelName(82532,user.getLanguage())%>"
								class="listViewOpBtn">
							</div>
						</div>
					<div style="clear: both;"></div>
					
					<script>
                    if(window.__isBrowser){
                        document.write("<div id='swfuploadbtn' class='swfuploadbtn'><span id='uploadButton'>上传</span></div>");
                    }
                </script>
				</div>
				
				
				
				<div style="padding:5px 10px 0 10px;position:relative">
				<%-- 目录 --%>
					<div style="width:100%; color: #939d9e; float:left;">
						<div style="padding-right:265px">
							<div style="position:relative;padding-left:40px;">
							<div class="upDiv" onclick="upFolder();"></div>
							<div class="e8MenuNav">
								<div class="e8Home" onclick=""></div>
								<div class="e8ParentNav" id="e8ParentNav">
									<div id="navItem">
									</div>
								</div>
							</div>
							<div style="clear: both;"></div>
							</div>
						</div>
					</div>
					<div style="clear: both;"></div>
					
					
					<%-- 搜索 --%>
					<div class="input-group">
						<%if(isSystemDoc){ %>
							<input type="text" name="keyword" id="keyword"
								class="searchinput" placeholder="<%=SystemEnv.getHtmlLabelName(126309,user.getLanguage())%>" />
							<span class="searchspan" title="<%= SystemEnv.getHtmlLabelName(82529, user.getLanguage()) %>"> </span>
							<span class="adspan"> <%= SystemEnv.getHtmlLabelName(347, user.getLanguage()) %> </span>
						<%}else{ %>
							<input type="text" name="keyword" id="keyword"
								class="searchinput private" placeholder="<%=SystemEnv.getHtmlLabelName(126309,user.getLanguage())%>" />
							<span class="searchspan" title="<%= SystemEnv.getHtmlLabelName(82529, user.getLanguage()) %>"> </span>	
						<%} %>
					</div>
				</div>
				
				
				<div class="divtab_menu"
					style="width: 70%; height: 36px; position: relative;display:none">
					<input type="hidden" name="loadFolderType" id="loadFolderType"
						value="<%=isSystemDoc ? "publicAll" : defaultPosition %>" />
					<input type="hidden" id="fpid" name="fpid" value='0' />
					<input type="hidden" id="fsize" name="fsize" value='10' />
					<input type="hidden" id="publicId" name="publicId" value='0' />
					<input type="hidden" id="privateId" name="privateId" value='<%=defaultCid%>' />
					<input type="hidden" id="ownerid" name="ownerid"
						value='<%=user.getUID()%>' />
					<input type="hidden" id="doclangurage" name="doclangurage"
						value='<%=user.getLanguage()%>' />
					<input type="hidden" id="docdepartmentid" name="docdepartmentid"
						value='<%=user.getUserDepartment()%>' />

					<ul>
						<li>
							<a id="publicLinkA"> <input type="hidden"
									name="model" value="publicAll"> <span
								class="nav-text-spacing "></span> <span
								class="nav-text-spacing-center"></span> <%= SystemEnv.getHtmlLabelName(126304, user.getLanguage()) %> </a>
						</li>
						<li>
							<a id="privateLinkA" class="selected"> <input type="hidden" name="model"
									value="privateAll"> <span class="nav-text-spacing "></span>
								<span class="nav-text-spacing-center"></span> <%= SystemEnv.getHtmlLabelName(125303, user.getLanguage()) %> </a>
						</li>
					</ul>
				</div>
			</div>
			

			<div
				style="width: 100%; bottom: 0px; overflow: hidden;height:0;padding-top:15px;">
				<iframe name="contentFrame" id="contentFrame" name="contentFrame"
					border="0" frameborder="no" noresize="noresize" width="100%"
					height="100%" scrolling="auto"
					src="/rdeploy/chatproject/doc/seccategoryViewList.jsp"></iframe>
			</div>
			<div class="hiddensearch">
				<div class="advancedSearch">
					<div class="rowbock rowwidth1">
						<span class="rowtitle"><%= SystemEnv.getHtmlLabelName(24986, user.getLanguage()) %></span>
						<div class="rowinputblock rowinputblockleft1">
							<INPUT type="text" class="rowinputtext" name="doctitle"
								id="doctitle" tabindex="0">
						</div>
					</div>
					<div class="searchline"></div>


					<div class="rowbock rowwidth1">
						<span class="rowtitle"><%= SystemEnv.getHtmlLabelName(882, user.getLanguage()) %></span>
						<div
							class="rowinputblock rowinputblockleft4 rowinputblock-brow-ie8">
							<span id="createridspanshow"> <brow:browser viewType="0"
									name="createrid" browserValue="" browserOnClick=""
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
									hasInput="true" isSingle="true" hasBrowser="true"
									isMustInput='1' completeUrl="/data.jsp"
									browserSpanValue=""></brow:browser>
							</span>
						</div>
					</div>
					<div class="searchline"></div>

					<div class="rowbock rowwidth1">
						<span class="rowtitle"><%= SystemEnv.getHtmlLabelName(19225, user.getLanguage()) %></span>
						<div
							class="rowinputblock rowinputblockleft2 rowinputblock-brow-ie8">
							<span> <brow:browser viewType="0" name="departmentid"
									browserValue=""
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
									hasInput="true" isSingle="true" hasBrowser="true"
									isMustInput="1" completeUrl="/data.jsp?type=4"
									browserDialogWidth="600px" browserSpanValue=""></brow:browser>
							</span>
						</div>
					</div>
					<div class="searchline"></div>
					<div class="rowbock rowwidth1">
						<span class="rowtitle"><%= SystemEnv.getHtmlLabelName(33092, user.getLanguage()) %></span>
						<div
							class="rowinputblock rowinputblockleft2 rowinputblock-brow-ie8">
							<span> <brow:browser viewType="0" name="seccategory"
									browserValue=""
									browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
									hasInput="true" isSingle="true" hasBrowser="true"
									isMustInput="1" completeUrl="/data.jsp?type=categoryBrowser&onlySec=true"
									browserDialogWidth="600px" browserSpanValue=""></brow:browser>
							</span>
						</div>
					</div>
					<div class="searchline"></div>
					<div class="rowbock rowwidth1">
						<span class="rowtitle" style="cursor: pointer;"><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></span>
						<div class="rowinputblock rowinputblockleft2">
							<input class="rowinputtext" type="text" id="date"
								readonly="readonly" style="cursor: pointer;">
							<INPUT type="hidden" name="createdatefrom" id="createdatefrom"
								value="">
							<INPUT type="hidden" name="createdateto" id="createdateto"
								value="">
						</div>
					</div>
					<div class="searchline"></div>

					<div style="width: 323px; margin-top: 7px; display: inline-block;">
						<span class="searchbtn searchbtn_cl" onclick="__resetCondtion()">
							<%= SystemEnv.getHtmlLabelName(125240, user.getLanguage()) %> </span>

						<span class="searchbtn searchbtn_rht" onclick="doSearch();">
							<%= SystemEnv.getHtmlLabelName(125241, user.getLanguage()) %></span>
					</div>
				</div>
			</div>
			<div class="searchshow">
				<div class="itemshow">
					<div class="resultshow">
						<%= SystemEnv.getHtmlLabelName(81289, user.getLanguage()) %>(<%= SystemEnv.getHtmlLabelName(126311, user.getLanguage())+" " %>
						<span id="rowCount">0</span><%= " "+SystemEnv.getHtmlLabelName(126312, user.getLanguage()) %>)
					</div>
					<div class="closesearch"></div>
				</div>
				<iframe name="searchFrame" id="searchFrame" border="0"
					frameborder="no" noresize="noresize" width="100%" height="100%"
					scrolling="auto" src=""></iframe>
			</div>
		</div>
		<div id="swfuploadbtnLi" class="swfuploadbtn"><span id="uploadButtonLi"></span></div>
		<ul id="rightClickMenu" class="rightMenu">
			<li onclick="onSubDocscribe()" id="subDocscribeLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(129209,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(129209,user.getLanguage())%></span></li>
			<li onclick="onAsk()" id="askLi"><span class="mtext" title="提交订阅">提交订阅</span></li>
			<li onclick="onImportSelect()" id="importSelectLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(21826,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(21826,user.getLanguage())%></span></li>
			<li onclick="onImportAll()" id="importAllLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(21827,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(21827,user.getLanguage())%></span></li>
			<li onclick="onDownloadBatch()" id="downloadBatchLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(27105,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(27105,user.getLanguage())%></span></li>
			
			<li onclick="onOpen()" id="openLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%></span></li>
			<li onclick="onDownload()" id="downloadLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></span></li>
			<%-- <li onclick="onSyncDownload()" id="syncDownloadLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(129212,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(129212,user.getLanguage())%></span></li>--%>
			<script>
			 if(!window.__isBrowser){
			     document.write('<li onclick="onShare()" id="shareLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(129144,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(129144,user.getLanguage())%></span></li>');
			 }
			</script>
			<li onclick="onPublic()" id="publicLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(129148,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(129148,user.getLanguage())%></span></li>
			<li class="lineLi"></li>
			<li onclick="onMove()" id="moveLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(129168,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(129168,user.getLanguage())%></span></li>
			<li onclick="onCopy()" id="copyLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%></span></li>
			<li onclick="onPaste()" id="pasteLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(16180,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(16180,user.getLanguage())%></span></li>
			<li class="lineLi"></li>
			<li onclick="onRename()" id="renameLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(19827,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(19827,user.getLanguage())%></span></li>
			<li onclick="onDelete()" id="deleteLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span></li>
			<li onclick="onUpload()" id="uploadLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></span></li>
			<li onclick="onCreate()" id="createLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(20002,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(20002,user.getLanguage())%></span></li>
			<li onclick="onShowShareObj()" id="shareObjLi"><span class="mtext" title="查看分享对象">查看分享对象</span></li>
			<li onclick="onCancelShare()" id="cancelShareLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(129158,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(129158,user.getLanguage())%></span></li>
			<li onclick="onSave2Disk()" id="save2DistLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(129159,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(129159,user.getLanguage())%></span></li>
			<li class="lineLi"></li>
			<li id="viewLi">
				<span class="mtext" title="<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></span>
				<ul class="rightMenu2">
					<li onclick="onViewTab('imageViewDiv')" id="viewLi_M">
						<span style="display:inline-block;height:25px;width:20px;float:left">√</span>
						<span class="mtext" title="<%=SystemEnv.getHtmlLabelName(129214,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(129214,user.getLanguage())%></span>
					</li>
					<li onclick="onViewTab('ListViewDiv')" id="viewLi_L">
						<span style="display:inline-block;height:25px;width:20px;float:left"></span>
						<span class="mtext" title="<%=SystemEnv.getHtmlLabelName(82532,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82532,user.getLanguage())%></span>
					</li>
				</ul>
				<span class="menu_right"></span>
			</li>
			<li onclick="onRefresh()" id="refreshLi"><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></span></li>
			<li id="orderLi">
				<span class="mtext" title="<%=SystemEnv.getHtmlLabelName(129216,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(129216,user.getLanguage())%></span>
				<ul class="rightMenu2">
					<li onclick="onOrder('name')" id="orderLi_N">
						<span style="display:inline-block;width:20px;height:25px;float:left">√</span>
						<span class="mtext" title="<%=SystemEnv.getHtmlLabelName(129217,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(129217,user.getLanguage())%></span>
					</li>
					<li onclick="onOrder('updatetime')" id="orderLi_T">
						<span style="display:inline-block;width:20px;height:25px;float:left">
						</span><span class="mtext" title="<%=SystemEnv.getHtmlLabelName(26805,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(26805,user.getLanguage())%></span>
					</li>
				</ul>
				<span class="menu_right"></span>
			</li>
			
		</ul>
		
		<div id="uploadList" class="hideBody <%=isSystemDoc ? "systemUpload" : "" %>">
			<div style="height: 40px; line-height: 40px; border: 1px solid #4baadf; background-color: #4ba9df;">
				<span style="padding-left: 15px;color: #fff; font-family: tahoma, arial, 宋体; font-size: 14px; font-weight: bold;float:left">
					<%=SystemEnv.getHtmlLabelName(129218,user.getLanguage())%>
				</span>
				<%-- 
					<div id="uploadCImg" class="uploadCImg">
					</div>
				--%>
				<div id="upload_current">
					<span class="num_current">0</span><%=SystemEnv.getHtmlLabelName(129219,user.getLanguage())%><span class="precent_current">0%</span>
				</div>
				<div id="upload_over" >
					<span class="num_current">0</span>个文件上传完成
				</div>
				<div id="download_current" >
					<span class="num_current">0</span><%=SystemEnv.getHtmlLabelName(129220,user.getLanguage())%><span class="precent_current">0%</span>
				</div>
				<div id="download_over" >
					<span class="num_current">0</span>个文件下载完成
				</div>
				<div id="uploadMImg" class="uploadMImg_max">
				</div>
			</div>
			<div id="uploadDialogBody" tabindex="5000">
				<div id="uploadTab">
				
					<ul>
						<li id="uploading" class="select"><div><%=SystemEnv.getHtmlLabelName(126308,user.getLanguage())%><span class="numSpan">(<span class="num"></span>)</span></div></li>
						<li id="downloading"><div><%=SystemEnv.getHtmlLabelName(129221,user.getLanguage())%><span class="numSpan">(<span class="num"></span>)</span></div></li>
						<li id="sendComplete"><div><%=SystemEnv.getHtmlLabelName(129222,user.getLanguage())%><span class="numSpan">(<span class="num"></span>)</span></div></li>
						<%if(!isSystemDoc){ %>
							<li id="syncComplete"><div><%=SystemEnv.getHtmlLabelName(129223,user.getLanguage())%><span class="numSpan">(<span class="num"></span>)</span></div></li>
						<%} %>
					</ul>
				<%-- 
					<span style="padding-left: 15px;color: #fff; font-family: tahoma, arial, 宋体; font-size: 14px; font-weight: bold;">
						<font id="uptitle">上传完成：</font>
						<font id="suCount">0</font><span id="sp">/</span><font id="count">0</font>
					</span>
				--%>	
				</div>
				<div id="uploadBody">
					<ul>
						<li id="uploadingContent">
							<div class="fullProcess" style="display:none">
								<label><span class="operateBgImage"></span><%=SystemEnv.getHtmlLabelName(129224,user.getLanguage())%></label>
								<div class="fullProcessBarDiv">
									<div class="fullProcessBar">
									</div>
									<div class="fullPrecent">0%</div>
								</div>
								<div class="operateBtn stopAll"><%=SystemEnv.getHtmlLabelName(129225,user.getLanguage())%></div>
								<div class="operateBtn cancelAll"><%=SystemEnv.getHtmlLabelName(129226,user.getLanguage())%></div>
							</div>
							<div class="contentProcess">
							</div>
							<div class="empty_data">
								<%=SystemEnv.getHtmlLabelName(129227,user.getLanguage())%>
							</div>
						</li>
						<li id="downloadingContent">
							<div class="fullProcess" style="display:none">
								<label><span class="operateBgImage"></span><%=SystemEnv.getHtmlLabelName(129228,user.getLanguage())%></label>
								<div class="fullProcessBarDiv">
									<div class="fullProcessBar">
									</div>
									<div class="fullPrecent">0%</div>
								</div>
								<div class="operateBtn stopAll"><%=SystemEnv.getHtmlLabelName(129225,user.getLanguage())%></div>
								<div class="operateBtn cancelAll"><%=SystemEnv.getHtmlLabelName(129226,user.getLanguage())%></div>
							</div>
							<div class="contentProcess">
							
							</div>
							<div class="empty_data">
								<%=SystemEnv.getHtmlLabelName(129229,user.getLanguage())%>
							</div>
						</li>
						<li id="sendCompleteContent">
							<div id="fullTab">
								<div id="allProcee" class="tab select">
									<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%><span class="processSpan">(<span class="processNum">0</span>)</span>
								</div>
								<div class="tabLine"></div>
								<div id="uploadComplete" class="tab">
									<%=SystemEnv.getHtmlLabelName(83072,user.getLanguage())%><span class="processSpan">(<span class="processNum">0</span>)</span>
								</div>
								<div class="tabLine"></div>
								<div id="downloadComplete" class="tab">
									 <%=SystemEnv.getHtmlLabelName(129230,user.getLanguage())%><span class="processSpan">(<span class="processNum">0</span>)</span>
								</div>
								<div class="operateBtn fl_right clearRecord" style="display:none"><%=SystemEnv.getHtmlLabelName(129234,user.getLanguage())%></div>
							</div>
							<div id="fullContent">
							
							</div>
							<div class="empty_data">
								<%=SystemEnv.getHtmlLabelName(129231,user.getLanguage())%>
							</div>
						</li>
						<%if(!isSystemDoc){ %>
							<li id="syncCompleteContent">
								<div class="fullProcess" style="display:none">
									<div class="syncCompleteMsg">共<span class="processNum">0</span><%=SystemEnv.getHtmlLabelName(129232,user.getLanguage())%>!</div>
									<div class="operateBtn fl_right clearRecord" style="margin-right:2px;display:none"><%=SystemEnv.getHtmlLabelName(129233,user.getLanguage())%></div>
								</div>
								<div class="contentProcess">
								
								</div>
								<div class="empty_data">
									<%=SystemEnv.getHtmlLabelName(129235,user.getLanguage())%>
								</div>
							</li>
						<%} %>	
					</ul>
				</div>
			</div>
			
			
			
			<div id="uploadList2" 
            style="display: none; width: 533px; position: absolute; right: 10px; bottom: 0px; z-index: 999;">
              <div id="swfuploadbtnAdd" class="swfuploadbtn"><span id="uploadButtonAdd"></span></div>
            <div
                style="height: 40px; line-height: 40px; border: 1px solid #4baadf; background-color: #4baadf;">
                <span style="padding-left: 15px;color: #fff; font-family: tahoma, arial, 宋体; font-size: 14px; font-weight: bold;">
                    <font id="uptitle"><%=SystemEnv.getHtmlLabelName(126308,user.getLanguage())%>：</font>
                    <font id="suCount">0</font><span id="sp">/</span><font id="count">0</font>
                </span>
                
                <div id="uploadMImg" class="uploadMImg_max">
                </div>
            </div>
            <div id="uploadDialogBody"
                style="border: 1px solid #d7e2e4; border-top-style: none; height: 375px; background-color: #fff;">
                <div style="width: 100%;" id="fsUploadProgressannexupload">
                    <div id="norecord_uploadDiv" class="norecord_uploadDiv">
                        <div class="recordpicture"></div>
                        <div class="recordmessage"><%=SystemEnv.getHtmlLabelName(129227,user.getLanguage())%></div>
                    </div>
                </div>
            </div>
            <div id="cancelAllDiv" class="nocalcelAllDiv" style="display:none">
                <div class="addFile">
	               <span><%=SystemEnv.getHtmlLabelName(20800,user.getLanguage())%></span>
                </div>
                <div class="cancelAllUpload">
                    <span><%=SystemEnv.getHtmlLabelName(129226,user.getLanguage())%></span>
                </div>
           </div>
        </div>
			
		</div>
		<div id="dataloadingbg"></div>
		<div id="dataloading">
			<img src="/rdeploy/assets/img/doc/loading.gif">
		</div>
		<div id="toaskInfo">
			<div class="msg"></div>
		<div>
        <iframe id="downloadFrame" style="display: none"></iframe>
	</body>
</html>
<script type="text/javascript">
	var currentAjax = null;
	var currentFolderAjax = null;
	// 上传列表滚动条美化
	// $('#uploadDialogBody').perfectScrollbar();
	 
	 $("#uploadBody").perfectScrollbar();
	
	jQuery("#loadFolderType").val(this.VIEW_MODEL == "systemDoc" ? "publicAll" : "<%=defaultPosition%>"); //避免缓存
	jQuery("#privateId").val("<%=defaultCid%>"); //避免缓存
</script>
