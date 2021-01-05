
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
<jsp:useBean id="quiterrs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="insertqtrs" class="weaver.conn.RecordSet" scope="page" />
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
	int id=Util.getIntValue(fu.getParameter("id"),0);  //协作id
	String needfresh = Util.fromScreen(fu.getParameter("needfresh"),user.getLanguage());//刷新左侧列表变量 1 刷新
	String from = Util.null2String(fu.getParameter("from"));
	if(id==0){ //如果id=0跳转到新建页面
		response.sendRedirect("/cowork/welcome.jsp?from="+from+"&needfresh="+needfresh);
		return;
	}
	
	boolean canView = false;    //是否具有查看权限
	boolean canEdit = false;    //是否具有编辑权限
	boolean canApproval=false;  //是否具有审批权限
	
	canView=CoworkShareManager.isCanView(""+id,""+userid,"all");
	canEdit=CoworkShareManager.isCanEdit(""+id,""+userid,"all");
	canApproval=CoworkShareManager.isCanEdit(""+id,""+userid,"typemanager");
	
	String isCoworkManager=canEdit?"1":"0";
	
	//如果不具有查看权限则跳转到无权限页面
	if (id>0&&!canView) {
		response.sendRedirect("/notice/noright.jsp") ;
		return;
	}
	
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
    String basesql="select itemstate,infostate,dealchangeminute,coworkstate from cowork_base_set";
    String itemstate="";
    String infostate="";
    String dealchangeminute="";
    String coworkstate="";
    RecordSet.execute(basesql); 
    while(RecordSet.next()){
          itemstate=RecordSet.getString("itemstate");
          infostate=RecordSet.getString("infostate");
          dealchangeminute=RecordSet.getString("dealchangeminute");
          coworkstate=RecordSet.getString("coworkstate");
    }
    
    
    
    //协作退出提醒功能
    String coworkid = Util.null2String(fu.getParameter("id"));
    String quiters="";
    String quitersname="";
    //判断是否已经提醒
    String quitersql= "select userid,coworkothers from cowork_quiter where itemid="+coworkid +" and (coworkothers not like '%,"+userid+",%' or coworkothers is null)";
  
    quiterrs.execute(quitersql);
    while(quiterrs.next()){
        //退出协作者
       String quiter= quiterrs.getString("userid");
        //被提醒过人字段
       String coworkothers= quiterrs.getString("coworkothers");
       quiters=quiters+","+quiter+",";
       
       coworkothers=coworkothers+","+userid+",";
       //提醒后加入该用户已经被提醒过得标识
       insertqtrs.execute("update cowork_quiter set coworkothers='"+coworkothers+"' where itemid="+coworkid +"and userid="+quiter);
    
    }

    if(!quiters.isEmpty()){
        quitersname=resourceComInfo.getMulResourcename(quiters);
        quitersname=quitersname+"退出协作";
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
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>

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
    
    if("<%=quitersname%>"!=""){
    setTimeout("coworkquitremind()",2000);
    }
  
});

function coworkquitremind(){
    $("#quitersname").html("");
}


 window.onbeforeunload=function (event){
 	/*
    if((jQuery.trim(jQuery("#remarkContent").val())!=""&&jQuery.trim(jQuery("#remarkContent").val())!="<%=SystemEnv.getHtmlLabelName(83268,user.getLanguage())%>  ")||(jQuery("#relateddoc").val()!=''&&jQuery("#relateddoc").val()!='0')||jQuery("#relatedcus").val()!=''
 	  ||jQuery("#relatedwf").val()!=''||jQuery("#relatedprj").val()!=''||jQuery("#projectIDs").val()!=''||document.all("relatedacc").value!='')
 	  
      return "<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
    //编辑状态下 
    if(jQuery("#editdiv").length!=0)
      return "<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>"; 
     */ 
 }

function remarkActive(){
   highEditor('remarkContent');
}

//查询
function getSearchStr(){
	 //var srchcontent=jQuery("#srchcontent").val();
	 var startdate=jQuery("#startdate").val();
	 var enddate=jQuery("#enddate").val();
	 var discussant = jQuery("#discussant").val();
	 var srchFloorNum=jQuery("#srchFloorNum").val();
	 
	 if(srchFloorNum!=""&&srchFloorNum!=undefined){
	    if(srchFloorNum!=parseInt(srchFloorNum)|| srchFloorNum <=0) {
              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25167,user.getLanguage())%>");  //请输入整数
              jQuery("#srchFloorNum").val(""); //置空
              jQuery("#srchFloorNum").focus();
 		      return ;
 		}
	 }
	 var isReplay=jQuery("#isReplay").val();
	 
	 var isShowApproval=jQuery("#isShowApproval").val();
	 
	 if(startdate!=""&&enddate!=""&& startdate>enddate){
		 window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(54,user.getLanguage())%>");
		 return ;
	 }
     var paramStr="&startdate="+startdate+"&enddate="+enddate+"&srchFloorNum="+srchFloorNum+"&isReplay="+isReplay+"&isShowApproval="+isShowApproval;
     
     var recordType=jQuery("#recordType").val(); //记录类型
     paramStr+="&recordType="+recordType;
     
     return paramStr;
 }
 
 //清除搜索条件
 function clearSearch(){
   jQuery("#srchcontent").val("");
   jQuery("#startdate").val("");
   jQuery("#startdatespan").html("");
   jQuery("#enddatespan").html("");
   
   jQuery("#enddate").val("");
   jQuery("#discussant").val("");
   jQuery("#discussantspan").html("");
   jQuery("#srchFloorNum").val("");
}

//分页
function toPage(pageNum){
	if(!jQuery("#mainsupports").is(":hidden")) {
		jQuery("#mainsupports").hide();
	}


  var  searchStr=getSearchStr();
  url="/cowork/DiscussRecord.jsp?canEdit=<%=canEdit%>&typeid=<%=typeid%>&type=1&id=<%=id%>&currentpage="+pageNum+searchStr;
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

//是否为高级编辑器模式
function isHighEditor(){
  return jQuery("#remarkContent").is(":hidden");
}

//删除讨论 delall=1 彻底删除 非管理员删除时
 function deleteDiscuss(discussid,delType){
    var inhtml  = '<div class="deletedialog none-select">';
        inhtml += '<table height="100%" border="0" align="center" cellpadding="10" cellspacing="0" style="padding-top:20px"><tbody><tr><td align="right"><img id="Icon_undefined" src="/wui/theme/ecology8/skins/default/rightbox/icon_query_wev8.png" style="margin-right:10px;" width="26" height="26" align="absmiddle"></td><td align="left" id="Message_undefined" style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(25405,user.getLanguage())%></td></tr></tbody></table>';
        inhtml += '   <div class="isDelAll" style="padding-top:20px"><input type="checkbox" checked id="isDelAll" name="isDelAll"  />同时删除该帖子的所有评论</div>';
        inhtml += '</div>';
        
    var diag = new window.top.Dialog();
    diag.Title = '信息确认';
    diag.Width = 280;
    diag.Height = 120;
    diag.normalDialog= false;
    diag.InnerHtml = inhtml;
    diag.OKEvent = function(){
       var isDelAll =$(window.top.document).find('#isDelAll').is(':checked');
       var method="delete";
       if(delType=="0") //逻辑删除
           method="logicDel";
       	 //确认要删除该讨论记录
          jQuery.post("CoworkOperation.jsp?method="+method+"&id=<%=id%>&discussid="+discussid+"&isDelAll="+isDelAll,{},function(data){
             if(jQuery.trim(data)=="0"){
                 toPage(1);
                 diag.close();
    	     }else if(jQuery.trim(data)=="1"){
    	         window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26229,user.getLanguage())%>");
    	         toPage(1);
    	         jQuery(".operationTimeOut").hide();
    	      }else if(jQuery.trim(data)=="2"){   
    	         window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131838,user.getLanguage())%>");
                 jQuery(".operationTimeOut").hide();
              }else if(jQuery.trim(data)=="3"){   
                 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131836,user.getLanguage())%>");
                 jQuery(".operationTimeOut").hide();
              }
              
       }); 
     };
    diag.CancelEvent = function(){
        diag.close();
    };
        
    diag.show();    
    $(window.top.document).find(".deletedialog").jNice();
    
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

 /*添加到日程安排*/
 function doAdd(){

   if(window.confirm("<%=SystemEnv.getHtmlLabelName(16634,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17698,user.getLanguage())%>?")){ //确认添加日程
      jQuery.post("CoworkOperation.jsp?method=addtoplan&id=<%=id%>",function(data){
          window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>");//日程添加成功
      });
      }
   else      
      return ;
 }

 /*导出协作*/
 function doexport(){
     window.openFullWindowHaveBar("/docs/docs/DocList.jsp?coworkid=<%=id%>&isExpDiscussion=y");
 }
 
 /*协作参与情况tab切换*/
function changeJoinTab(id,target){
  if(jQuery("#"+id).hasClass("active_tab"))
     return false; 
     
  var activeTab=jQuery("#cowork_join_tab .active_tab");
  var activeTabId=activeTab.attr("id");   
  activeTab.removeClass("active_tab");
  
  jQuery("#weavertabs-"+activeTabId).hide();
  
  jQuery("#"+id).addClass("active_tab");
  jQuery("#weavertabs-"+id).show();  
}

function markAsImportant(){
    if("<%=isImportant%>"=="true"){  
       jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {coworkid:"<%=id%>",type:"normal"},function(data){
             window.location.href="/cowork/ViewCoWork.jsp?from=<%=from%>&&needfresh=1&id=<%=id%>";
        	 return true; 
       });
     }else{
       jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {coworkid:"<%=id%>",type:"important"},function(data){
             window.location.href="/cowork/ViewCoWork.jsp?from=<%=from%>&&needfresh=1&id=<%=id%>";
        	 return true; 
       });
     }
 }
  
  function markAsHidden(){
    if("<%=isHidden%>"=="true"){  
       jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {coworkid:"<%=id%>",type:"show"},function(data){
             window.location.href="/cowork/ViewCoWork.jsp?from=<%=from%>&&needfresh=1&id=<%=id%>";
        	 return true; 
       });
     }else{
       jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {coworkid:"<%=id%>",type:"hidden"},function(data){
             window.location.href="/cowork/ViewCoWork.jsp?from=<%=from%>&&needfresh=1&id=<%=id%>";
        	 return true; 
       });
     }
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
  
 
 function firstPage(){
    if(jQuery("#firstPage").length>0)
       jQuery("#firstPage").click();
 }
 
 function prePage(){
    if(jQuery("#prePage").length>0)
       jQuery("#prePage").click();
 }
 
 function nextPage(){
    if(jQuery("#nextPage").length>0)
       jQuery("#nextPage").click();
 }
 
 function lastPage(){
    if(jQuery("#lastPage").length>0)
       jQuery("#lastPage").click();
 }
 
  //批准协作
 function doApprove(){
     jQuery.post("CoworkOperation.jsp?method=doApprove", {id:"<%=id%>"},function(data){
           window.location.href="/cowork/ViewCoWork.jsp?from=<%=from%>&&needfresh=1&id=<%=id%>";
      	 return true; 
     });
 }
 
 function doBatchApproveDiscuss(){
	 jQuery("#discusslist").find("input:checked").each(function(){
		 var discussid=jQuery(this).val();
		 var obj=jQuery(this).parents("table:first").find(".approveDiscuss");
		 doApproveDiscuss(discussid,obj);
	 });
 }
 
 //批准协作留言
 function doApproveDiscuss(discussid,obj){
     jQuery.post("CoworkOperation.jsp?method=doApproveDiscuss", {discussid:discussid},function(data){
         jQuery(obj).parent().hide();
         jQuery(obj).parent().prev().show();
         jQuery(obj).parents("table:first").find(".isApproval_tr").hide();
     });
 }
 
 //删除协作留言
 function doDeleteDiscuss(discussid,obj){
     jQuery.post("CoworkOperation.jsp?method=doDeleteDiscuss", {discussid:discussid},function(data){
         jQuery(obj).parent().hide();
         jQuery(obj).parent().prev().show();
         jQuery(obj).parents("table:first").find(".isApproval_td").html("【<%=SystemEnv.getHtmlLabelName(83248,user.getLanguage())%>】");
     });
 }
 
 function doSubmit(){
 	$("#btnSubmit").click();
 }
  
</script>
<body id="ViewCoWorkBody" style="overflow: auto;background:rgb(249, 249, 249);" onkeydown="findByFloorNum(event)">
<div id="divTopMenu"></div>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
	int menuIndex=0;
	int menuIndex2=0;
	if(canApproval&&approvalAtatus.equals("1")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:doApprove(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		menuIndex++;
	}
	RCMenu += "{"+(isApproval.equals("1")?SystemEnv.getHtmlLabelName(15143,user.getLanguage()):SystemEnv.getHtmlLabelName(615,user.getLanguage()))+",javascript:doSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	menuIndex++;
	
	//if(status.equals("-1")) menuIndex++;
if(canEdit&&id!=0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	menuIndex++;
} 

if(isCoworkManager.equals("1")){
	menuIndex2=menuIndex;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+",javascript:doBatchApproveDiscuss(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	menuIndex++;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doBatchDelDiscuss(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	menuIndex++;
}

if(isImportant){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(25422,user.getLanguage())+",javascript:markAsImportant(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    menuIndex++;
    
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(25421,user.getLanguage())+",javascript:markAsImportant(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    menuIndex++;
}

if(isHidden){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(25424,user.getLanguage())+",javascript:markAsHidden(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    menuIndex++;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(25423,user.getLanguage())+",javascript:markAsHidden(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	menuIndex++;
}
    
if(canEdit&&id!=0){ 
	if(!status.equals("2")){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(405,user.getLanguage())+",javascript:doEnd(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    menuIndex++;
    } 
    if(status.equals("2")){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(360,user.getLanguage())+",javascript:doOpen(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    menuIndex++;
    }
}

	RCMenu += "{"+SystemEnv.getHtmlLabelName(17480,user.getLanguage())+",javascript:viewLog(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	menuIndex++;


	RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+SystemEnv.getHtmlLabelName(15153,user.getLanguage())+",javascript:doexport(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	menuIndex++;


	RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:firstPage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:prePage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:nextPage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:lastPage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
%>
<%
    String imagefilename = "";
    String titlename = "";
    String needfav = "1";
    String needhelp = "";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
    
    var menuIndex=<%=menuIndex-1%>;
    var menuIndex2=<%=menuIndex2-1%>;
    
    jQuery(document).bind("mousedown",function(event){
        if(event.button==2){
          	initPageMenu();
	    }  
    });  
    function firstPage(){
    	kkpager._clickHandler(1);
    }
    function prePage(){
    	kkpager._clickHandler(kkpager.pno - 1);
    }
    function nextPage(){
    	kkpager._clickHandler(kkpager.pno + 1);
    }
    function lastPage(){
    	kkpager._clickHandler(kkpager.total);
    }
    
    function initPageMenu(){
    	// alert(menuIndex+"  "+event.button);
        //alert(kkpager.total+"  "+kkpager.pno);
      	showPageMenu(menuIndex+1,kkpager.pno!=1?"":"disabled"); //右键首页菜单是否显示
  	    showPageMenu(menuIndex+2,kkpager.pno!=1?"":"disabled"); //右键上一页菜单是否显示
  	      
  	    showPageMenu(menuIndex+3,kkpager.pno!=kkpager.total?"":"disabled"); //右键下一页菜单是否显示
  	    showPageMenu(menuIndex+4,kkpager.pno!=kkpager.total?"":"disabled"); //右键尾页菜单是否显示
  	      
	    if("<%=isCoworkManager%>"=="1"){
	      	showPageMenu(menuIndex2+1,$("#isShowApproval").val()=="1"?"":"disabled"); //右键尾页菜单是否显示
  	    }
  	    
    }
    
    function showPageMenu(menuIndex,disabled){
      	$("#rightMenuIframe").contents().find("#menuItemDivId"+menuIndex+" button").attr("disabled",disabled);
    }
    
	function doSearch(){
		changeOrderType($(".tabItemdiv:eq(0)")[0]);
		toPage(1);
	}
    
    /*
    点赞功能
    **/
    function agree(status,itemId,discussid){
         $.ajax({
            url: '/cowork/CoworkCountVotes.jsp?status='+status+'&itemId='+itemId+'&discussid='+discussid,
            async : false,
            success: function(result){
               result = eval('('+result+')');
               var votetype=result.votetype; 
               var agreevote=result.agreevote;
            //   $("#agreevote_"+discussid).html("("+agreevote+")");
               var initcount=$("#agreevote_"+discussid).html().replace("(","").replace(")","");//取实时页面赞数
               //赞
               if(0==votetype){
            //     $("#agreevoteclick_"+discussid).find("img").attr("src","/cowork/images/zaned_wev8.png");
                   $("#agreevoteclick_"+discussid).attr("class","zaned item replayLink");
                   $("#agreevoteclick_"+discussid).attr("title","<%=SystemEnv.getHtmlLabelNames("201,32942", user.getLanguage())%>");
                   $("#agreevote_"+discussid).html("("+(initcount*1+1)+")");
               }
               //取消状态
               else{
            //     $("#agreevoteclick_"+discussid).find("img").attr("src","/cowork/images/zan_wev8.png");
                   $("#agreevoteclick_"+discussid).attr("class","zan item replayLink");
                   $("#agreevoteclick_"+discussid).attr("title","<%=SystemEnv.getHtmlLabelName(32942, user.getLanguage())%>");
                   $("#agreevote_"+discussid).html("("+(initcount*1-1)+")");
               }
            }
        })
    }
    
   /*
    收藏功能
   **/
   function collect (itemId,discussid){
       $.ajax({
            url: '/cowork/CoworkCollect.jsp?itemId='+itemId+'&discussid='+discussid,
            async : false,
            success: function(result){
                result = eval('('+result+')');
                var iscollect=result.iscollect;
                if(iscollect==1){
                //收藏了
                 $("#collect_"+discussid).find("img").attr("src","/cowork/images/collect_wev8.png");
                }else{
                //取消了
                 $("#collect_"+discussid).find("img").attr("src","/cowork/images/nocollect_wev8.png");
                }
            }
       }) 
   }
   
   function quit(id,userid){
        
       window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(129889,user.getLanguage())%>",function(){
        $.ajax({
            url:'/cowork/CoworkQuit.jsp?itemId='+id+'&userid='+userid,
            async : false,
            success: function(result){
                alert("<%=SystemEnv.getHtmlLabelNames("1205,84565", user.getLanguage())%>");
                window.parent.location.reload()
              
            }
        })
      });
   }
    
</script>
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
        <span id="quitersname" style="text-align:center;padding-left:500px;"><%=quitersname %></span>
	</div>

    <div style="height:30px;line-height: 27px;float: right;vertical-align: middle; margin-right: 5px;">
        <!--<input type="button" class="e8_btn_top" style="margin-right: 15px;" onclick="quit('<%=id %>','<%=userid %>')" value="<%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%>" title="<%=SystemEnv.getHtmlLabelNames("1205,17855", user.getLanguage())%>" />-->
    	<div onclick="showRemark(this)" class="remark_icon" style="float: right;margin-right:5px;"></div>
    </div>
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

<%
 if("".equals(coworkstate)&&"2".equals(status)){
     
 }else{
%>
  <div id="submitdiv" class="submitdiv discuss_item">
	
	<div>
		<textarea id="remarkContent" _editorid="remarkContent" _editorName="remark_content" type="text/plain" style="width:100%;height:80px;border:1px solid #C7C7C7;display:none;"></textarea>
		<div name="remark_content" id="remarkContentdiv" class="remarkContent" style="resize: none;"><%=SystemEnv.getHtmlLabelName(83268,user.getLanguage())%></div>
	</div>
	
	<div id="operationdiv" style="overflow: hidden;height: 0px;">
		 <div style="padding:5px 0 5px 0;border-bottom:1px solid #dadada;">
		 	<div class="left">
				<button type="button" onclick="doSave(this,'doremark')" style="<%=isApproval.equals("1")?"width:80px;":""%>" id="btnSubmit" class="submitBtn"/><%=isApproval.equals("1")?SystemEnv.getHtmlLabelName(15143,user.getLanguage()):SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
				<span style="<%=("1".equals(isCoworkTypeAnonymous) && "1".equals(isAnonymous))?"":"display:none;"%>">
					<input type="checkbox" name="isAnonymous" id="isAnonymous" value="1"><%=SystemEnv.getHtmlLabelName(18611,user.getLanguage())%>
				</span>
			</div>
			<%if(appStatusMap.size()>0){%>
				<div class="right">
					<div onclick="showExtend(this)" _status="0" id="extendbtn" class="extendbtn"><%=SystemEnv.getHtmlLabelName(83273,user.getLanguage())%></div>
				</div>
			<%}%>
			<div class="clear"></div>
		 </div>	
	</div>	
	
	<div id="external" class="externalDiv" style="overflow: auto;display:none;"> 
		<table class="LayoutTable" id="table1">
			<col width="30%">
			<col width="70%">
			<%if(appStatusMap.containsKey("doc")){%>
			<!-- 相关文档 -->
			<tr>
				<td class="fieldName"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
				<td class="field">
					<%
               	     String docName=DocComInfo.getDocname(Integer.toString(docid));
               	   %>
               	   <brow:browser viewType="0" name="relateddoc" browserValue='<%=""+docid%>'
				               	browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp"
				               	linkUrl="/docs/docs/DocDsp.jsp?id=" 
				               	completeUrl="/data.jsp?type=9"
				               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue='<%=docName%>'> 
               	   </brow:browser>
				</td>
			</tr>
			<tr style="height:1px!important;display:;" class="Spacing"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>
			<%} %>
			<%if(appStatusMap.containsKey("workflow")){%>
			<!-- 相关流程 -->
			<tr>
				<td class="fieldName"><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
				<td class="field">
					<brow:browser viewType="0" name="relatedwf" browserValue=""
				               	browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp"
				               	linkUrl="/workflow/request/ViewRequest.jsp?requestid=" 
				               	completeUrl="/data.jsp?type=152"
				               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue=""> 
               	  	</brow:browser>
				</td>
			</tr>
			<tr style="height:1px!important;display:;" class="Spacing"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>
			<%} %>
			<%if(appStatusMap.containsKey("crm")){%>
			<!-- 相关客户 -->
			<tr>
				<td class="fieldName"><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
				<td class="field">
					<brow:browser viewType="0" name="relatedcus" browserValue=""
				               	browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp"
				               	linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=" 
				               	completeUrl="/data.jsp?type=7"
				               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue=""> 
               	  	</brow:browser>
				</td>
			</tr>
			<tr style="height:1px!important;display:;" class="Spacing"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>
			<%} %>
			<%if(appStatusMap.containsKey("project")){%>
			<!-- 相关项目 -->
			<tr>
				<td class="fieldName"><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
				<td class="field">
					<brow:browser viewType="0" name="projectIDs" browserValue=""
			               	browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp"
			               	linkUrl="/proj/data/ViewProject.jsp?ProjID=" 
			               	completeUrl="/data.jsp?type=8"
			               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue=""> 
              	  	</brow:browser>
				</td>
			</tr>
			<tr style="height:1px!important;display:;" class="Spacing"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>
			<%} %>
			<%if(appStatusMap.containsKey("task")){%>
			<!-- 相关项目任务 -->
			<tr>
				<td class="fieldName"><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td>
				<td class="field">
					<brow:browser viewType="0" name="relatedprj" browserValue=""
				               	browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp"
				               	linkUrl="/proj/process/ViewTask.jsp?taskrecordid=" 
				               	completeUrl="/data.jsp?type=prjtsk"
				               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue=""> 
               	  	</brow:browser>
				</td>
			</tr>
			<tr style="height:1px!important;display:;" class="Spacing"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>
			<%} %>
			<%if(appStatusMap.containsKey("attachment")){%>
			<!-- 相关附件 -->
			<tr>
				<td class="fieldName"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
				<td class="field">
					<%
					if(!secId.equals("")){
					%>
						<div id="uploadDiv" class="uploadDiv" mainId="" subId="" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
					<%}else{%>
					 	<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
					<%}%> 
				</td>
			</tr>
			<tr style="height:1px!important;display:;" class="Spacing"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>
			<%} %>
		</table>
       
	</div>
	
  </div>
<% }%>

  <div id="fixeddiv" class="finxeddiv_normal">
	
	<div class="left tabMenu">
		<div class="left tabItemdiv active" onclick="changeOrderType(this)" _target="#discusses">
			<div class="tabItem discusses"><%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%></div>
			<div class="arrow"></div>
		</div>
		<div class="left tabItemdiv normal" style="" onclick="changeOrderType(this)" _target="#relatedme">
			<div class="tabItem relatedme"><%=SystemEnv.getHtmlLabelName(32572,user.getLanguage())%>
				<%
				int unreadRelatedCount=CoworkService.getRelatedUnreadCount(""+userid,""+id);
				if(unreadRelatedCount>0){
				%>
				<img id="remindimg" src="/images/ecology8/statusicon/BDNew_wev8.png">
				<%}%>
			</div>
			<div class="arrow"></div>
		</div>
		<div class="left tabItemdiv normal" onclick="changeOrderType(this)" _target="#join">
			<div class="tabItem join"><%=SystemEnv.getHtmlLabelName(83274,user.getLanguage())%></div>
			<div class="arrow"></div>
		</div>
		<div class="left tabItemdiv normal" onclick="changeOrderType(this)" _target="#related">
			<div class="tabItem related"><%=SystemEnv.getHtmlLabelName(84399,user.getLanguage())%></div>
			<div class="arrow"></div>
		</div>
		<div class="clear"></div>
	</div>
	
	<div class="right p-r-5">
        <span id="searchblockspan" style="width:95px;">
			<span class="searchInputSpan searchSpan" id="searchInputSpan" style="position:relative;top:0px;">
				<input type="text" class="searchInput middle" name="flowTitle" value="" onkeypress="if(event.keyCode==13){$('#srchcontent').val($(this).val());doSearch();}" style="vertical-align: top;">
				<span class="middle searchImg" onclick="$('#srchcontent').val($('.searchInput').val());doSearch();">
					<img class="middle" style="vertical-align:top;margin-top:2px;" src="/images/ecology8/request/search-input_wev8.png">
				</span>
			</span>
		</span>
		<span id="highsearchBtn" onclick="showHightSearch(this,event);" style="height:21px;vertical-align:top" class="advancedSearch middle"><span><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span></span>
	</div>
	
	<div class="right checkMenus">
		<div class="left check_item normal" title="<%=SystemEnv.getHtmlLabelName(84336,user.getLanguage())%>" _target="#isReplay">
			<div  class="replay"></div>
		</div>
		<%if(isApproval.equals("1")&&isCoworkManager.equals("1")){%>
			<div class="left check_item normal" title="<%=SystemEnv.getHtmlLabelName(83275,user.getLanguage())%>" _target="#isShowApproval">
				<div class="approval" style=""></div>
			</div>
		<%}%>
		<div class="left check_item <%=!isCoworkHead.equals("0")?"active":"normal"%>" title="<%=SystemEnv.getHtmlLabelName(81563,user.getLanguage())%>" _target="#showHead">
			<div class="showhead"></div>
		</div>
		<div class="clear"></div>
	</div>
	
	<div class="clear"></div>
	
	<!-- 高级搜索 -->
	<div id="highSearchdiv">
	  <div class="searchdiv">
	  	<wea:layout type="4col" attributes="{'layoutTableId':'searchTable'}">
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<!-- 内容 -->
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%>
				</wea:item>
				<wea:item>
					<input class="inputstyle" type="text" id='srchcontent' value="" style="width:80%"/>
				</wea:item>
				
				<!-- 发表人 -->
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(26225,user.getLanguage())%>
				</wea:item>
				<wea:item>
					<brow:browser viewType="0" name="discussant" browserValue="" 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp" width="80%" 
							browserSpanValue="">
					</brow:browser>
				</wea:item>
				
				<!-- 时间 -->
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(17697,user.getLanguage())%>
				</wea:item>
				<wea:item>
					 <BUTTON type="button" class=Calendar onclick="getDate(startdatespan,startdate)"></BUTTON> 
		             <SPAN id=startdatespan></SPAN> 
		             <input type="hidden" name="startdate" id="startdate" >
		             <%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>&nbsp&nbsp
		             <BUTTON  type="button" class=Calendar onclick="getDate(enddatespan,enddate)"></BUTTON> 
		             <SPAN id=enddatespan></SPAN> 
		             <input type="hidden" name="enddate" id="enddate" >
				</wea:item>
				
				<!-- 时间 -->
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(27519,user.getLanguage())%>
				</wea:item>
				<wea:item>
					 <span style="margin-right: 15px;">
					 	<input class=inputstyle type=text id='srchFloorNum' value="" size="5" style="width:40px;">(Alt+G)
					 </span>
			  		 <button type=button class="submitBtn" onclick="doSearch();"><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></button> <!-- 搜索 -->
			   		 <button type=button class="cancelBtn" onclick="clearSearch();"><%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></button> <!-- 清除 -->
				</wea:item>
				
			</wea:group>
		</wea:layout>
		
	  </div>
	</div>
	
	</div>

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
