
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.cowork.*" %> 
<%@ page import="java.io.*" %>
<%@ page import="weaver.file.FileUpload" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page" />
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<jsp:useBean id="settingComInfo" class="weaver.systeminfo.setting.HrmUserSettingComInfo" scope="page" />
<jsp:useBean id="csm" class="weaver.cowork.CoworkShareManager" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CoworkService" class="weaver.cowork.CoworkService" scope="page" />
<%
	int userid=user.getUID();//用户id
	FileUpload fu = new FileUpload(request);
    
    //通过楼层ID获得协作ID
	 int id=0;
	 String discussids=Util.null2String(request.getParameter("discussids"));
	 RecordSet2.execute("select * from cowork_discuss where id="+discussids);
	  while(RecordSet2.next()){
	      id=RecordSet2.getInt("coworkid");
	 }
    
	String needfresh = Util.fromScreen(fu.getParameter("needfresh"),user.getLanguage());//刷新左侧列表变量 1 刷新
	String from = Util.null2String(fu.getParameter("from"));
	if(id==0){ //如果id=0跳转到新建页面
		response.sendRedirect("/cowork/welcome.jsp?from="+from+"&needfresh="+needfresh);
		return;
	}
	
	boolean canEdit = false;    //是否具有编辑权限
	boolean canApproval=false;  //是否具有审批权限
	
	canEdit=CoworkShareManager.isCanEdit(""+id,""+userid,"all");
	canApproval=CoworkShareManager.isCanEdit(""+id,""+userid,"typemanager");
	
	String isCoworkManager=canEdit?"1":"0";
	
	
	int docid=Util.getIntValue(Util.null2String(fu.getParameter("docid")),0);//TD5067，从协作区创建文档返回的文档ID
	String maintypeid = Util.null2String(fu.getParameter("maintypeid"));
	int type=Util.getIntValue(fu.getParameter("type"),0);
	int viewall=Util.getIntValue(fu.getParameter("viewall"),0);//是否查看部分讨论记录，0：否,1：是
	int isworkflow = Util.getIntValue(Util.null2String(fu.getParameter("isworkflow")),0);
	int isreward = Util.getIntValue(Util.null2String(fu.getParameter("isreward")),0);
	
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0：非政务系统。2：政务系统。
	String view = (String)fu.getParameter("view");
	
	if(isworkflow==1&&id!=0){	
		response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+id);
		return;
	}
	String isCoworkHead=settingComInfo.getIsCoworkHead(settingComInfo.getId(""+userid));
	
	CoworkDAO dao = new CoworkDAO(id);
	CoworkItemsVO vo = dao.getCoworkItemsVO();
	String name = Util.null2String(vo.getName());                 //协作名称
	String levelvalue = Util.null2String(vo.getLevelvalue());     //等级
	String typeid=Util.null2String(vo.getTypeid());               //所属协作区
	String begindate = Util.null2String(vo.getBegindate());       //开始日期
	String beingtime = Util.null2String(vo.getBeingtime());       //开始时间      
	String enddate = Util.null2String(vo.getEnddate());           //结束日期
	String endtime = Util.null2String(vo.getEndtime());           //结束时间
	String remark = Util.null2String(vo.getRemark()).trim();             //详细描述

	String creater = Util.null2String(vo.getCreater());           //协作创建人
	String status = Util.null2String(vo.getStatus());             //协作状态
	String createdate2 = Util.null2String(vo.getCreatedate());    //创建日期
	String createtime2 = Util.null2String(vo.getCreatetime());    //创建时间
	String principal=Util.null2String(vo.getPrincipal());         //协作负责人 
	String coworkid2=vo.getId();                                  //协作id
	
	String isApproval = Util.null2String(vo.getIsApproval());     //是否需要审批
	String isAnonymous = Util.null2String(vo.getIsAnonymous());   //是否允许匿名(主题中设置)
	String approvalAtatus = Util.null2String(vo.getApprovalAtatus());   //审批状态
    
    String isCoworkTypeAnonymous = "0";  //后台设置，板块是否允许匿名
	RecordSet.execute("select isAnonymous from cowork_types where id = "+ typeid);
    if(RecordSet.next()) {
        isCoworkTypeAnonymous = Util.null2s(RecordSet.getString("isAnonymous"), "0");
    }
	String logintype = user.getLogintype();                       //登陆类型
    
	//添加查看者记录
    String sql="select id from cowork_read where coworkid="+id+" and userid="+userid;
	RecordSet.execute(sql);  
	if(!RecordSet.next()){
		sql="insert into cowork_read(coworkid,userid) values("+id+","+userid+")";
		RecordSet.execute(sql);
    }

	//添加查看日志
	dao.addCoworkLog(id,2,userid,fu);
	//协作查看后，删除系统提醒信息
	dao.removeCoworkRemindInfo(id,userid);
	
	boolean isImportant=false;
	boolean isHidden=false;
	
    RecordSet.execute("select id from cowork_important where coworkid="+id+" and userid="+userid);
    if(RecordSet.next())
    	isImportant=true;
    RecordSet.execute("select id from cowork_hidden where coworkid="+id+" and userid="+userid);
    if(RecordSet.next())
    	isHidden=true;
    
    //增加查看记录
    RecordSet.execute("update cowork_items set readNum=readNum+1 where id="+id);
	
	int pagesize = 10;//讨论交流每页显示条数
	int currentpage =1;
	
	BlogDao blogDao=new BlogDao();
	String isOpenBlog=blogDao.getBlogStatus(); //是否启用微博模块
	
	Map dirMap=dao.getAccessoryDir(typeid);
	String mainId =(String)dirMap.get("mainId");
	String subId = (String)dirMap.get("subId");
	String secId = (String)dirMap.get("secId");
	String maxsize = (String)dirMap.get("maxsize");
	
	Map appStatusMap=CoworkService.getAppStatus();
    
    //判断后端协作基本设置信息
    String basesql="select * from cowork_base_set";
    String itemstate="";
    String infostate="";
    String dealchangeminute="";
    RecordSet.execute(basesql); 
    while(RecordSet.next()){
          itemstate=RecordSet.getString("itemstate");
          infostate=RecordSet.getString("infostate");
          dealchangeminute=RecordSet.getString("dealchangeminute");
    }
    
%>
<html>
<head>
<title><%=name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<!-- 图片缩略 -->
<link href="/blog/js/weaverImgZoom/weaverImgZoom_wev8.css" rel="stylesheet" type="text/css">
<script src="/blog/js/weaverImgZoom/weaverImgZoom_wev8.js"></script>

<link rel="stylesheet" href="/cowork/css/cowork_wev8.css" type="text/css" />
<link rel=stylesheet href="/css/Weaver_wev8.css" type="text/css" />
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="js/cowork_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/cowork/js/coworkUtil_wev8.js"></script>
<link rel=stylesheet type="text/css" href="/cowork/css/coworkNew_wev8.css"/>

<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>

<%
  if(isOpenBlog.equals("1")){
%>
<!-- 微博便签 -->
<script type="text/javascript" src="/blog/js/notepad/notepad_wev8.js"></script>
<%} %>
<%@ include file="/cowork/uploader.jsp" %>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script type="text/javascript" src="/cowork/js/kkpager/kkpager_wev8.js"></script>
<link rel="stylesheet" href="/cowork/js/kkpager/kkpager_wev8.css" type="text/css"/>

<!-- 加载javascript -->
<jsp:include page="CoworkUtil.jsp"></jsp:include>
</head>
<script  type="text/javascript">

var coworkid="<%=id%>"; //协作id
var isAnonymous="<%=isAnonymous%>"; //协作是否允许匿名
var isCoworkTypeAnonymous = "<%=isCoworkTypeAnonymous%>";  // 后台设置，协作板块是否允许匿名
var typeid="<%=typeid%>"; //协作类型
var from="<%=from%>"; //来自哪里
var approvalAtatus="<%=approvalAtatus%>";

var itemstate="<%=itemstate%>";
var infostate="<%=infostate%>";
var dealchangeminute="<%=dealchangeminute%>";

jQuery(document).ready(function(){
  
   toPage(1);
   
   $("#remarkdiv").find('img').each(function(){
		  initImg(this);
   });
   
   //绑定附件上传
   if(jQuery("#uploadDiv").length>0)
     bindUploaderDiv(jQuery("#uploadDiv"),"relatedacc");
   
   //绑定收缩下拉框事件
   if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
	    jQuery(document.body).bind("mouseup",function(){
		   parent.jQuery("html").trigger("mouseup.jsp");	
	    });
	    jQuery(document.body).bind("click",function(){
			jQuery(parent.document.body).trigger("click");		
	    });
    }
    
    if(<%=docid%>!=0)
      showExternal($('#external')[0]);
   <%
	  if(isOpenBlog.equals("1") && Util.null2String(blogDao.getSysSetting("isSendBlogNote")).equals("1")){
	%>
		notepad('.discuss_content'); //微博便签选取数据
	<%}%>
	
	$(".btn_add_type").hover(function(){
		$(this).addClass("btn_add_type_hover");
	},function(){
		$(this).removeClass("btn_add_type_hover");
	});
	
	<%if(needfresh.equals("1")&&from.equals("cowork")){ //是否需要刷新协作列表
    %>
    	window.parent.reLoadCoworkList();
    <%}%>
    
    //附件下载样式初始化
    $(".accitem").live('hover',function(event){ 
		if(event.type=='mouseenter'){ 
			$(this).css({"background-color":"#ddffdd"});
			$(this).find(".accdown").show();
		}else{ 
			$(this).css({"background-color":""}); 
			$(this).find(".accdown").hide();
		} 
	}) 
	
    //默认开启主题标题
    if(itemstate==1){
        $(".remark_icon").click();
        
    }
    if(!$("#remarkContent").is(':hidden')&&infostate==1){
        $(".extendbtn").click();
    }
});


function remarkActive(){
   highEditor('remarkContent');
}


//分页
function toPage(pageNum){
	if(!jQuery("#mainsupports").is(":hidden")) {
		jQuery("#mainsupports").hide();
	}
 // var  searchStr=getSearchStr();
  var  searchStr=null;
  url="/cowork/CollectDisucssView.jsp?canEdit=<%=canEdit%>&typeid=<%=typeid%>&type=1&discussids=<%=discussids%>&id=<%=id%>&currentpage="+pageNum+searchStr;
  displayLoading(1,"page");
  var srchcontent=jQuery("#srchcontent").val();
  jQuery.post(url,{"srchcontent":srchcontent,"discussant":jQuery("#discussant").val()},function(data){
  
     var tempdiv=jQuery("<div>"+data+"</div>");
     tempdiv=coomixImg(tempdiv);
     
     var recordType=$("#recordType").val();
     if(recordType=="relatedme"){
     	 jQuery("#relatedme").html("");
	     jQuery("#relatedme").append(tempdiv);	
     }else{
	     jQuery("#discusslist").html("");
	     jQuery("#discusslist").append(tempdiv);
     }
     displayLoading(0);
     
	 preReplayid="";
	 resizeImg();
	 
	 moveToTop();
	 
	 jQuery('body').jNice();
	 
  });
}

//转到
function toGoPage(totalpage,topage){
 	    var topagenum=jQuery("#"+topage);
 		var topage =topagenum.val();
 		if(topage <0 || topage!=parseInt(topage) ) {
              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25167,user.getLanguage())%>");  //请输入整数
              topagenum.val(""); //置空
              topagenum.focus();
 		      return ;
 		 }
 		if(topage>totalpage) topage=totalpage; //大于最大页数
 		if(topage==0) topage=1;                //小于最小页数 
 		toPage(topage);
}

 
//附件删除
function onDeleteAcc(obj,delid){
	
		var delrelatedacc=jQuery("#delrelatedacc").val();
        var relatedacc=jQuery("#edit_relatedacc").val();
        
	    relatedacc=","+relatedacc;
	    delrelatedacc=","+delrelatedacc;
	    
		delrelatedacc=delrelatedacc+delid+",";
		var index=relatedacc.indexOf(","+delid+",");
		relatedacc=relatedacc.substr(0,index+1)+relatedacc.substr(index+delid.length+2);
		
		jQuery("#edit_relatedacc").val(relatedacc.substr(1,relatedacc.length));
		jQuery("#delrelatedacc").val(delrelatedacc.substr(1,delrelatedacc.length));
		
		$(obj).parent().remove();
} 



  
  //根据楼号查找
  function findByFloorNum(event){
      if(event.altKey&&event.keyCode==71) { 
         var diag = new Dialog();
	     diag.Width = 240;
		 diag.Height =60;
		 diag.Modal = false;
		 diag.Title = "<%=SystemEnv.getHtmlLabelName(31509,user.getLanguage())%>";
		 diag.InnerHtml="<div style='text-align:left;padding-left:40px;'><div style='margin-top:10px;'><span style='margin-right:8px;'><%=SystemEnv.getHtmlLabelName(27519,user.getLanguage())%>:</span><input type=text id='findFloorNum' style='width:120px;'/></div><div id='floorNumError' style='display:none;color:red;padding-left:30px;'><%=SystemEnv.getHtmlLabelName(27691,user.getLanguage())%></div></div>"
		 //点击确定后调用的方法
		 diag.OKEvent = function(){ 
		    var findFloorNum=jQuery("#findFloorNum").val();
		    if(findFloorNum!=""&&(findFloorNum!=parseInt(findFloorNum)|| findFloorNum <=0)) {
              //alert("<%=SystemEnv.getHtmlLabelName(25167,user.getLanguage())%>");  //请输入整数
              jQuery("#floorNumError").show();
              jQuery("#findFloorNum").val(""); //置空
              jQuery("#findFloorNum").focus();
 		      return ;
 		   }else{
 		      jQuery("#srchFloorNum").val(findFloorNum);
 		      diag.close();
		      toPage(1);
		   }
		 };
		 diag.show();
		 
		 jQuery("#findFloorNum").bind("keypress",function(event){
		    if(event.keyCode==13){
		       diag.OKEvent();
		    }
		 });
		 jQuery("#findFloorNum").focus();
      } 
  }
  
 
  
</script>
<body id="ViewCoWorkBody" style="overflow: auto;background:rgb(249, 249, 249);" onkeydown="findByFloorNum(event)">
<div id="divTopMenu"></div>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
    String imagefilename = "";
    String titlename = "";
    String needfav = "1";
    String needhelp = "";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<%if(!from.equals("cowork")){%>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="collaboration"/>
	   <jsp:param name="navName" value="<%=name%>"/>
	</jsp:include>
<%}%>

<!-- 提交回复等待 -->
<div id="coworkLoading" class="loading" align='center'>
	<div id="loadingdiv" style="right:260px;">
		<div id="loadingMsg">
			<div><%=SystemEnv.getHtmlLabelName(81558,user.getLanguage())%>...</div>
		</div>
	</div>
</div>
 
<div class="nav"> 
	<div class="navitem navitemt">
		<div><%=SystemEnv.getHtmlLabelName(22432,user.getLanguage())%></div>
	</div>
	<div class="navitem navitemd">
		<div><%=SystemEnv.getHtmlLabelName(22433,user.getLanguage())%></div>
	</div>
</div>

<iframe id="downloadFrame" style="display: none"></iframe>

<div style="">

<form name="frmmain" id="frmmain" method="post" action="CoworkOperation.jsp">
  
  <input type=hidden name="type" value="<%=type%>">
  <input type=hidden name="viewall" value="<%=viewall%>">
  <input type=hidden name="method" id="method" value="doremark">
  <input type=hidden name="id" value="<%=id%>">
  <input type=hidden name="typeid" value="<%=typeid%>">  
  <input type=hidden name="creater" value="<%=creater%>">
  <input type=hidden name="txtPrincipal" value="<%=principal%>">
  <input type=hidden name="replayid" id="replayid" value="0">
  <input type=hidden name="floorNum" id="floorNum" value="0">
  <input type=hidden name="remark" id="remark" value="0">
  <input type=hidden name="from" id="remark" value="<%=from%>">
  <input type=hidden name="replyType" id="replyType" value="reply">
  <input type=hidden name="commentuserid" id="commentuserid" value="0">
  <input type=hidden name="topdiscussid" id="topdiscussid" value="0">
  <input type=hidden name="approvalAtatus" id="isApproval" value="<%=approvalAtatus%>"/> <!-- 审批状态 -->
  <input type=hidden name="isApproval" id="isApproval" value="<%=isApproval%>"/> <!-- 是否需要审批 -->
  <input type=hidden name="isReplay" id="isReplay" value=""/> <!-- 显示非回复记录 -->
  <input type=hidden name="isShowApproval" id="isShowApproval" value=""/> <!-- 显示非待审批记录 -->
  <input type=hidden name="recordType" id="recordType" value=""/> <!-- 记录类型 -->

  <div style="background:#fff">

  <div class="coworktopdiv">
	<div style="height:30px;line-height: 30px;float: left;vertical-align: middle;">
		<span style="color:#138efc;font-weight:bold;"><%=name%></span>
	</div>
	
	<div onclick="showRemark(this)" class="remark_icon" style="float: right;margin-right:5px;"></div>
	<div style="clear: both;"></div>
	
  </div>

  <div id="remarkdiv">
	<div id="remarkHtml" style="padding:8px 5px 8px 5px;">
		<table width="100%">
			<tr>
				<td>
					<div class="remark_content"><%=remark%></div>
				</td>
			</tr>
			<tr>
				<td>
					<div style="margin-top:5px;" align="left">
						<span style="color: #929393;"><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%>：<%=ResourceComInfo.getLastname(principal)%></span>
						<span style="color: #929393;margin-left:5px;"><%=SystemEnv.getHtmlLabelName(83209,user.getLanguage())%>：<%=CoTypeComInfo.getCoTypename(typeid)%></span>
						<span style="color: #929393;margin-left:5px;"><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%>：<%=begindate%> <%=beingtime%><%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%>&nbsp;<%=enddate%> <%=endtime%> </span>
					</div>
				</td>
			</tr>
		</table>
	</div>
		
  </div>

<div class="showhead"></div>

</div>

<!-- 相关交流 -->
<div id="discusses" class="tab_itemdiv"> 
	<div id="discusslist"></div>
</div>

<div id="relatedme" class="tab_itemdiv" style="display: none;"></div>

<div id="related" class="tab_itemdiv" style="display: none;"></div>

<div id="join" class="tab_itemdiv" style="display: none;"></div>

<div id="footer"></div>

<div id="editorTmp" style="display:none">
	<!--请填写回复内容-->
    <div id="tipcontent" class="tipcontent"><%=SystemEnv.getHtmlLabelName(23073,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18546,user.getLanguage())%></div>
    <div style="margin-bottom: 3px;margin-top:3px;">  
       <textarea name="remark_content" _editorName="remark_content" id="replay_content_###" style="width:100%;height:80px;border:1px solid #C7C7C7;" class="replayContent" ></textarea>
    </div>
	   
	<div class="discussOperation">
	   	   <%if(appStatusMap.size()>0){%>
		   	   <div class="right replay_external" id="replay_external_###">
		   	   		<a style="margin-right: 8px;" href="javascript:void(0)" onclick="showExternal(this)" class="externalBtn"><%=SystemEnv.getHtmlLabelName(26165,user.getLanguage())%></a>	  
		   	   </div>
	   	   <%}%>
	   	   <div class=left>
		       <button type=button class="submitBtn" onclick="doSave(this,'doremark')"><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></button> <!-- 回复 -->
		       <button type=button class="cancelBtn" onclick="cancelReply(this,'comment')"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></button> <!-- 取消 -->
	   	   	   <span id="isAnonymous_span"></span>
	   	   </div>
   	</div>
	   
	<div id="external_###" class="externalDiv" style="width: 100%">
	   		 <table class="LayoutTable" style="width: 100%">
	   		 	<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				<tr class="Spacing" style="height: 1px !important;"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>
	   		 	<%
	   		 	if(appStatusMap.containsKey("doc")){%>
		   		 	<tr>
			   			<!-- 相关文档 -->
			   			<td class="fieldName">
			   				<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>
			   			</td>
			   			<td class="field">
						  	<brow:browser viewType="0" name="relateddoc_temp" browserValue=""
					               	browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp"
					               	linkUrl="/docs/docs/DocDsp.jsp?id="
					               	completeUrl="/data.jsp?type=9"
					               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue=""> 
	               	   		</brow:browser>
			   			</td>
			   		</tr>
			   		<tr class="Spacing" style="height: 1px !important;"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>
		   		<%}%>
		   		<%if(appStatusMap.containsKey("workflow")){
		   			
		   		%>
			   		<tr>	
			   			<!-- 相关流程 -->
			   			<td class="fieldName">
			   				<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>
			   			</td>
			   			<td class="field">
					      	<brow:browser viewType="0" name="relatedwf_temp" browserValue=""
					               	browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp"
					               	linkUrl="/workflow/request/ViewRequest.jsp?requestid=" 
					               	completeUrl="/data.jsp?type=152"
					               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue=""> 
	               	  		</brow:browser>
			   			</td>
			   		</tr>
			   		<tr class="Spacing" style="height: 1px !important;"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>
		   		<%} %>
		   		<%if(appStatusMap.containsKey("crm")){%>
			   		<tr>	
			   			<!-- 相关客户-->
			   			<td class="fieldName">
			   				<%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>
			   			</td>
			   			<td class="field">
						    <brow:browser viewType="0" name="relatedcus_temp" browserValue=""
					               	browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp"
					               	linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=" 
					               	completeUrl="/data.jsp?type=7"
					               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue=""> 
	               	  		</brow:browser>
			   			</td>
			   		</tr>
			   		<tr class="Spacing" style="height: 1px !important;"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>	
		   		<%} %>
		   		<%if(appStatusMap.containsKey("project")){%>
			   		<tr>
			   			<!-- 相关项目 -->
			   			<td class="fieldName">
			   				<%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>
			   			</td>
			   			<td class="field">
						  	<brow:browser viewType="0" name="projectIDs_temp" browserValue=""
				               	browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp"
				               	linkUrl="/proj/data/ViewProject.jsp?ProjID=" 
				               	completeUrl="/data.jsp?type=8"
				               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue=""> 
	              	  	</brow:browser>
			   			</td>
			   		</tr>
			   		<tr class="Spacing" style="height: 1px !important;"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>
		   		<%} %>
		   		<%if(appStatusMap.containsKey("task")){%>
			   		<tr>	
			   			<!-- 相关项目任务 -->
			   			<td class="fieldName">
			   				<%=SystemEnv.getHtmlLabelName(522,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%>
			   			</td>
			   			<td class="field">
						 	 <brow:browser viewType="0" name="relatedprj_temp" browserValue=""
					               	browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp"
					               	linkUrl="/proj/process/ViewTask.jsp?taskrecordid=" 
					               	completeUrl="/data.jsp?type=prjtsk"
					               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue=""> 
	               	  		</brow:browser>
			   			</td>
			   		</tr>
			   		<tr class="Spacing" style="height: 1px !important;"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>
		   		<%} %>
		   		<%if(appStatusMap.containsKey("attachment")){%>
			   		<tr>	
			   			<td class="fieldName">
			   				<%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>
			   			</td>
			   			<td class="field">
		               		<%
								if(!secId.equals("")){
								%>
									<div class="uploadDiv" id="uploadDiv_###" mainId="" subId="" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
								<%}else{%>
								 	<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
								<%}%> 
			   			</td>
			   		</tr>
			   		<tr class="Spacing" style="height: 1px !important;"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>	
	   			<%} %>
	   		</table>	
    </div>
</div>


</form>
</div>
<style>
.fieldName{padding-left:8px !important;}
.paddingLeft18{padding-left:5px !important;}
</style>
</body>
</html>
