<%@page import="weaver.email.service.MailGuideService"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" scope="page" />
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="mfs" class="weaver.email.service.MailFolderService" scope="page" />
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<script type="text/javascript" src="/email/js/wdScrollTab/Fader_wev8.js"></script>
<script type="text/javascript" src="/email/js/wdScrollTab/TabPanel_wev8.js"></script>
<script type="text/javascript" src="/email/js/wdScrollTab/Math.uuid_wev8.js"></script>
<script type="text/javascript" src="/email/joyride/jquery.cookie_wev8.js"></script>
<script type="text/javascript" src="/email/joyride/modernizr.mq_wev8.js"></script>
<script type="text/javascript" src="/email/joyride/jquery.joyride-1.0.5_wev8.js"></script>
<link rel="stylesheet" href="/email/joyride/joyride-1.0.5_wev8.css">
<link rel="stylesheet" href="/email/joyride/demo-style_wev8.css">
<link rel="stylesheet" href="/email/joyride/mobile_wev8.css">
<link href="/email/css/TabPanel_wev8.css" rel="stylesheet" type="text/css"/>
<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css"/>

<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragrma","no-cache");
response.setDateHeader("Expires",0);

String receivemail = Util.null2String(request.getParameter("receivemail"));

String receivemailid = Util.null2String(request.getParameter("receivemailid"));
mss.selectMailSetting(user.getUID());
if(!Util.null2String(request.getAttribute("newEmailRemindIds")).equals("")){
	rs.execute("delete from SysPoppupRemindInfoNew where type = 15 and userid = '"+user.getUID()+"'");
}
int userLayout = Util.getIntValue(mss.getLayout(),3);



String labelid =Util.null2String(request.getParameter("labelid"));
String star =Util.null2String(request.getParameter("star"));
String isInternal = Util.null2String(request.getParameter("isInternal"));
String folderid = Util.null2String(request.getParameter("folderid"),"0");
String opNewEmail=Util.null2String(request.getParameter("opNewEmail"));
String mailid = Util.null2String(request.getParameter("mailid"));
String status = Util.null2String(request.getParameter("status"));
String quickSearch = Util.null2String(request.getParameter("quickSearch"));	
String fromhp =  Util.null2String(request.getParameter("fromhp"));	
String fileid = Util.null2String(request.getParameter("fileid"));//群发邮件时候的附件主键信息
String waitdeal = Util.null2String(request.getParameter("waitdeal"),"");
String blogid = Util.null2String(request.getParameter("blogid"),"");
String fromable = Util.null2String(request.getParameter("fromable"));

//clickObj=0点击是“全部",=1点击的是"未读",=2点击的是某个标签,=""不是点击【全部，未读，标签】进行搜索
String clickObj=Util.null2String(request.getParameter("clickObj"));
String to = Util.null2String(request.getParameter("to"));
String internalto = Util.null2String(request.getParameter("internalto"));
//布局信息
mss.selectMailSetting(user.getUID());
int layout = Util.getIntValue(mss.getLayout(),3);
String displayName ="";
if(!folderid.equals("")){
	displayName = mfs.getSysFolderName(Util.getIntValue(folderid),user.getLanguage());
	if(displayName.equals("")){
		mfs.selectMailFolderInfo(Util.getIntValue(folderid));
		if(mfs.next()){
			displayName = mfs.getFolderName();
		}
	}
}else if(!labelid.equals("")){
	displayName = lms.getLabelInfo(labelid).getName();
}else if(isInternal.equals("1")){
	displayName =  SystemEnv.getHtmlLabelName(24714,user.getLanguage());
}else if(star.equals("1")){
	displayName = SystemEnv.getHtmlLabelName(81337,user.getLanguage());
}else if("1".equals(waitdeal)) {
	displayName = "待办邮件";
}else{
	displayName = SystemEnv.getHtmlLabelName(17065,user.getLanguage());
}

String tabName=SystemEnv.getHtmlLabelName(33212,user.getLanguage());
if(!mailid.equals("")){
	tabName = SystemEnv.getHtmlLabelName(71,user.getLanguage());
}
boolean checkuser=MailGuideService.checkUserSeeGuide(user.getUID()+"");
if(!checkuser){
	MailGuideService.insertEmailGuide(user.getUID()+"");
}	
//用于列表切换的tab的id叫:MailChangeList
String MailChangeList="MailChangeList";
//用于新建、发送、回复邮件的id叫：MailChangeUpdae
String MailChangeUpdae="MailChangeUpdae";
String   url="";
if(userLayout==1){
	 url="/email/new/MailInboxListMain.jsp";
}else if(userLayout==2){
	 url="/email/new/MailInboxListMain.jsp";
}else{
	url="/email/new/MailInboxList.jsp";
}
 url+="?isInternal="+isInternal;
 url+="&receivemailid="+receivemailid;
 url+="&star="+star;
 url+="&labelid="+labelid;
 url+="&folderid="+folderid;
 url+="&receivemail="+receivemail;
 url+="&status="+status;
 url+="&clickObj="+clickObj;
 url+="&quickSearch="+quickSearch;
 url+="&checkuser="+checkuser+"";
 url+="&waitdeal="+waitdeal;
 if(!mailid.equals("")){
	 url = "/email/new/MailView.jsp?loadjquery=1&folderid="+folderid+"&mailid="+mailid+"&fromable="+fromable;
 }
 
 if(folderid.equals("")&&opNewEmail.equals("1")){
	 displayName=SystemEnv.getHtmlLabelName(2029,user.getLanguage());
	 tabName=SystemEnv.getHtmlLabelName(30912,user.getLanguage());
	 url="/email/new/MailAdd.jsp?to="+to+"&isInternal="+isInternal+"&fileid="+fileid+"&internalto="+internalto;
 }

%>

</head>

<body scroll="no">

<div  class="maskguide"  id="maskguide"></div>

<!-- tab -->
<div style="left:6px;width:43px;height:60px;background: url('/js/tabs/images/nav/mnav17_wev8.png') no-repeat center center;position: absolute;"></div>
<div id="tabTitle" style="left:50px;top:10px;width:80px;height:60px;position: absolute;font-size:16px;"><%=displayName%></div>		 
<div id="tab" style="position: relative;width:100%;float: left;margin-top:30px;"></div>


 <!-- 缓存当前切换的url -->
 <input type="hidden" id="comurl" value="<%=url%>"/>
 
  <!-- 缓存当前切换的css-->
 <input type="hidden" id="comcss" value="<%=layout%>"/>



<script type="text/javascript" >
var userLayout="<%=userLayout%>";
var checkuser="<%=checkuser%>";
var tabpanel;  
var jcTabs = [
'<iframe src="<%=url%>" width="100%" height="100%" frameborder="0" id="mainConEmail" ></iframe>'
];
var tempid=1;


$(document).ready(function(){  
	
	//alert($("body").height());
	$("#tab").height($("body").height()-30);
	var tabHeight=$("body").height()-30;
	var maxLength=($("#tab").width()-86)/104;
    tabpanel = new TabPanel({  
        renderTo:'tab',  
        //border:'none',  
        height:tabHeight,
        active : 0,
        autoResizable:true,
        maxLength : maxLength,  
        items : [
          		  {id:'<%=MailChangeList%>',title:'<%=tabName%>',html:jcTabs[0],closable: false}
        ]
    });
	<%
		if(!folderid.equals("")&&opNewEmail.equals("1")){ 
	%>
			addTab("1","/email/new/MailAdd.jsp?internalto=<%=internalto%>&to=<%=to%>&isInternal=<%=isInternal%>&fileid=<%=fileid%>","<%=SystemEnv.getHtmlLabelName(30912,user.getLanguage()) %>");
			
	<%
		}
	%>
}); 

//添加tab页
function addTab(type,url,tabname,mailId){
	
	//这里的id分为li--tab的id,和tab里面内嵌的iframe的id
	var v_mailId="";
	var mainConEmail="";
	if(type=="1"){
		v_mailId="<%=MailChangeUpdae%>";
		mainConEmail="sh_"+v_mailId;
	}else{
		v_mailId=mailId;
		mainConEmail="sh_"+v_mailId;
	}
	var wk=tabpanel.getTabPosision(v_mailId);
	 if(typeof wk == 'number'){
	 			tabpanel.show(wk,false);//设置tab被选中，并且显示
	 			tabpanel.setTitle(wk, tabname);//设置tab的标题
	 			document.getElementById(mainConEmail).src=url;//刷新页面
	 			return;
	 }
	var page="<iframe src='"+url+"' width='100%' height='100%' frameborder='0' id='"+mainConEmail+"'></iframe>";
	tabpanel.addTab({id:v_mailId,title:tabname,html:page,closable: true});
}

//切换tab页
function refreshMailTab(type,url,tabname){

			$("#tabTitle").html(tabname);	
			tabpanel.show(0,false);
			$(".active > .title").html("<%=SystemEnv.getHtmlLabelName(33212,user.getLanguage())%>");	
			//缓存切换的url
			$("#comurl").val(url);
			//缓存切换的css
			try{
				$("#comcss").val(window.parent.document.getElementById("menu_userLayout").value);
			}catch(e){
				//说明是经典模式下
				try{
					$("#comcss").val(window.parent.document.getElementById("LeftMenuFrame").contentWindow.document.getElementById("ifrm2").contentWindow.document.getElementById("menu_userLayout").value);
				}catch(e){}
			}
			document.getElementById("mainConEmail").src=url;//刷新页面
}

//删除tab页
function deleteTab(folderid){	
		if(<%=layout%>==3){
			var wk=tabpanel.getActiveIndex();
			 if(typeof wk == 'number'){
	 			if(tabpanel.getTabsCount()>1)
						tabpanel.kill(wk);//关闭发送成功或失败的界面
	 			tabpanel.show(0,false);
	 			//刷新页面，调至收件箱
				document.getElementById("mainConEmail").src="/email/new/MailInboxList.jsp?folderid="+folderid+"&receivemail=false&"+new Date().getTime();
			 }	
		 }else{
	 				tabpanel.show(0,false);
		 			//刷新页面，调至收件箱
					document.getElementById("mainConEmail").src="/email/new/MailInboxListMain.jsp?folderid="+folderid+"&receivemail=false&"+new Date().getTime();
		 }
		 
}
//跳到收件箱或发件箱
function gosjx(type,url,tabTitle,tabname){	
		var wk=tabpanel.getActiveIndex();
		 if(typeof wk == 'number'){
		 		if(tabpanel.getTabsCount()>1)
	 				tabpanel.kill(wk);//关闭发送成功或失败的界面
				tabpanel.show(0,false);//跳到收件箱界面
				$(".active > .title").html(tabname);
				$("#tabTitle").html(tabTitle);
				document.getElementById("mainConEmail").src=url;//刷新页面
		}
}
</script>


</body>
</html>
