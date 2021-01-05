<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page import="weaver.general.Util"%>
<%@page import="weaver.email.domain.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">


<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" scope="page" />
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="mfs" class="weaver.email.service.MailFolderService" scope="page" />
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />

		
<%

	String userid = user.getUID()+"";
	String receivemail = Util.null2String(request.getParameter("receivemail"));
	String receivemailid = Util.null2String(request.getParameter("receivemailid"));
	String subject = Util.null2String(request.getParameter("subject"));
	String folderid = Util.null2String(request.getParameter("folderid"));
	String labelid = Util.null2String(request.getParameter("labelid"));
	String star = Util.null2String(request.getParameter("star"));
	String method = Util.null2String(request.getParameter("method"));
	String mailaccountid = Util.null2String(request.getParameter("mailaccountid"));
	String status = Util.null2String(request.getParameter("status"));
	String from = Util.null2String(request.getParameter("from"));
	String to = Util.null2String(request.getParameter("to"));
	String tohrmid = Util.null2String(request.getParameter("tohrmid"));
	String fromhrmid = Util.null2String(request.getParameter("fromhrmid"));
	String attachmentnumber = Util.null2String(request.getParameter("attachmentnumber"));
	int isInternal = Util.getIntValue(request.getParameter("isInternal"),-1);
	String startdate = Util.null2String(request.getParameter("startdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	String datetype = Util.null2String(request.getParameter("datetype"));
	String waitdeal = Util.null2String(request.getParameter("waitdeal"));
	//clickObj=0点击是“全部",=1点击的是"未读",=2点击的是某个标签,=""不是点击【全部，未读，标签】进行搜索
	String clickObj=Util.null2String(request.getParameter("clickObj"));
	//1表示标签是在页面点击出来的，而不是通过超链接点击出来的
	String labelidchecked=Util.null2String(request.getParameter("labelidchecked"));

	mss.selectMailSetting(user.getUID());
	int userLayout = Util.getIntValue(mss.getLayout(),0);
	
	String url="/email/new/MailInboxList.jsp";
 	//如果是3，通过url传中文有乱码，所以通过作用域来传递
 	 // 此部分一定要保证参数顺序，不能变更
 	 String newurl="";
 	 newurl+=""+isInternal;
	 newurl+="#"+receivemailid;
	 newurl+="#"+star;
	 newurl+="#"+labelid;
	 newurl+="#"+folderid;
	 newurl+="#"+receivemail;
	 newurl+="#"+subject;
	 newurl+="#"+from;
	 newurl+="#"+to;
	
	 newurl+="#"+status;
	 newurl+="#"+mailaccountid;
	 newurl+="#"+attachmentnumber;
	 newurl+="#"+startdate;
	 newurl+="#"+enddate;
	 newurl+="#"+labelidchecked;
	 
	 //这后面加一个空字符串，非常重要
	//不然这个字符串【-1@@@@0@@会员@@@1@@@@@1】,以#分割转为数组的长度只有10 
	 newurl+="#"+clickObj+"";
	 newurl+="#"+tohrmid;
	 newurl+="#"+fromhrmid+" ";
	 newurl+="#"+datetype+" ";
	 newurl+="#"+waitdeal+" ";
	 session.setAttribute("newEmailurl",newurl);
	 url+="?isInternal="+isInternal;
		//?isInternal="+isInternal+"&receivemailid="+receivemailid+"&star="+star+"&labelid="+labelid+"&folderid="+folderid+"&receivemail="+receivemail
		
	
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
	}else if(isInternal==1){
		displayName =  SystemEnv.getHtmlLabelName(24714,user.getLanguage());
	}else{
		displayName = SystemEnv.getHtmlLabelName(81337,user.getLanguage());
	}
	
	//用于列表切换的tab的id叫:MailChangeList
	String MailChangeList="MailChangeList";
	//用于新建、发送、回复邮件的id叫：MailChangeUpdae
	String MailChangeUpdae="MailChangeUpdae";
	
	//MailView.jsp?isInternal==isInternal &star==star&folderid==folderid&receivemail==receivemail&mailid=mailid 
 %>
 <%
 //上下
 if(userLayout==1){
  %>
	  <script type="text/javascript">
	var languageid = '<%=user.getLanguage()%>'
	</script>
  <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js" charset="UTF-8"></script>
  <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js" ></script> 
  <script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
 <script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/messagejs/highslide/highslide-full_wev8.js"></script>
	<script type="text/javascript" src="/js/messagejs/simplehrm_wev8.js"></script>
	<script type="text/javascript" src="/js/messagejs/messagejs_wev8.js"></script>
  <div class="easyui-layout" style="width: 100%;height: 100%;">
 	<div class="northDiv" data-options="region:'north',split:true"  style="overflow:hidden"></div>  
    <div class="centerDiv " data-options="region:'center',title:'center title'" style="overflow: hidden;"></div>  
</div>
 <%
 //左右
 }else if(userLayout==2){
  %>
	  <script type="text/javascript">
	var languageid = '<%=user.getLanguage()%>'
	</script>
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js" charset="UTF-8"></script>
	<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js" ></script> 
	<script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
	<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	<script type="text/javascript" src="/js/messagejs/highslide/highslide-full_wev8.js"></script>
	<script type="text/javascript" src="/js/messagejs/simplehrm_wev8.js"></script>
	<script type="text/javascript" src="/js/messagejs/messagejs_wev8.js"></script>
  <div class="easyui-layout" style="width: 100%;height: 100%;">
 	<div class="northDiv" data-options="region:'west',split:true" style="height:100%;overflow:hidden;"></div>   
    <div class="centerDiv " data-options="region:'center',title:'center title'" style="height: 60%;overflow: hidden;"></div>    
</div>
 <%
 }else{
 	//request.getRequestDispatcher(url).forward(request, response);
	 response.sendRedirect(url);
	 return;
 }
	//封装搜索条件对象
	MailSearchDomain msd = new MailSearchDomain();
	msd.setSubject(subject);
	msd.setFrom(from);
	msd.setTo(to);
	msd.setAttachmentnumber(attachmentnumber);
	msd.setMailaccountid(mailaccountid);
	msd.setStartdate(startdate);
	msd.setEnddate(enddate);
	msd.setStatus(status);
	msd.setFromhrmid(fromhrmid);
	msd.setTohrmid(tohrmid);
	msd.setResourceid(userid);
  String url02=mrs.getLatestEmailViewUrl(folderid,star,labelid,user.getUID(),msd);
  %>
<style type="text/css"  >
html, body { 
	width : 100%;
	height : 100%;
	padding : 0; 
	margin : 0px; 
	padding:0px;'
	overflow : hidden;
	font-family:"Lucida Grande","Lucida Sans Unicode",Arial,Verdana,sans-serif; /* MAIN BODY FONTS */
}
.jcTab { width:100%; height:100%;}



.layout-panel{
	
}

</style>
<!-- link href="css/core_wev8.css" rel="stylesheet" type="text/css"/ -->
<link href="/email/css/TabPanel_wev8.css" rel="stylesheet" type="text/css"/>
<link href="/email/js/easyui/themes/default/layout_wev8.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript">
var  tempuserid ='';
</script>

<script type="text/javascript" src="/email/js/wdScrollTab/Fader_wev8.js"></script>
<script type="text/javascript" src="/email/js/wdScrollTab/TabPanel_wev8.js"></script>
<script type="text/javascript" src="/email/js/wdScrollTab/Math.uuid_wev8.js"></script>
<script type="text/javascript" src="/email/js/easyui/jquery.easyui.min_wev8.js"></script>
<script type="text/javascript" src="/email/js/resize/jquery.resize.min_wev8.js"></script>


		
<script>
	$(document).ready(function(){
		var init = true;
		$(".northDiv").resize(function(){
			if(init){
				if(userLayout=="2"){
					$(".northDiv").find("#mailList").css("height",document.body.clientHeight-$("#mailListTop").height()-1);
					$("#mailContent").css("height",document.body.clientHeight-130);
					$(".centerDiv").append("<iframe id='centerFrame' height='100%' frameborder='0'/>");
					//$("#centerFrame").css("width",$(".centerDiv").width());
				}else{
					$(".northDiv").find("#mailList").css("height",document.body.clientHeight/2-$("#mailListTop").height());
					$("#mailContent").css("height",document.body.clientHeight/2-130);
					$(".centerDiv").append("<iframe id='centerFrame' width='100%' height='100%' frameborder='0'/>");
				}
			}else{
				if(userLayout=="2"){
					$(".northDiv").find("#mailList").css("height",$(".northDiv").height()-$("#mailListTop").height()-1);
					$("#mailContent").css("height",document.body.clientHeight-130);
					$("#mailContent").css("width",$(".centerDiv").width())
					//$("#centerFrame").css("width",$(".centerDiv").width());
				}else{
					$(".northDiv").find("#mailList").css("height",$(".northDiv").height()-$("#mailListTop").height());
					//$("#mailContent").css("height",$(".centerDiv").height()-130);
					//$("#mailContent").css("width",$(".centerDiv").width())
					$("#centerFrame").css("width",$(".centerDiv").width());
				}
			}
			init = false;
			
			
		});
		
		var userLayout = "<%=userLayout%>";
		$(".northDiv").load("<%=url%>&"+new Date().getTime(),function(data){
			
			if(userLayout=="2"){
				$(".northDiv").css("width",document.body.clientWidth/2+"px")
				$(".northDiv").parent().css("width",document.body.clientWidth/2+"px")
			
				$(".layout-panel-center").css("left",document.body.clientWidth/2+"px")
			}else if(userLayout=="1"){
				
				$(".northDiv").css("height",document.body.clientHeight/2+"px")
				$(".northDiv").css("width","100%")
				$(".layout-panel-center").css("top",document.body.clientHeight/2+"px")
				$(".layout-panel-center").css("width","100%")
			}
		});
		 $("#centerFrame").attr("src","<%=url02 %>&"+new Date().getTime());
			if(userLayout=="2"){
				$(".centerDiv").parent().css("width",document.body.clientWidth/2+"px")
				$(".centerDiv").css("width",document.body.clientWidth/2+"px")
				$(".centerDiv").parent().css("height","100%")
				$(".centerDiv").css("height","100%")
				$(".centerDiv").css("width","100%")
			}else if(userLayout=="1"){
				$(".centerDiv").parent().css("height",document.body.clientHeight/2+"px").css("overflow","hidden");
				$(".centerDiv").css("height",document.body.clientHeight/2+"px")
				$(".centerDiv").parent().css("width","100%")
				
			}
		 window.onresize=function(){
				if(userLayout=="2"){
					//alert($(".northDiv").height())
					$(".northDiv").find("#mailList").css("height",$(".northDiv").height()-$("#mailListTop").height()-1);
					$("#mailContent").css("height",document.body.clientHeight-130);
					$("#centerFrame").css("width",$(".centerDiv").width())
				}else{
					$(".northDiv").find("#mailList").css("height",$(".northDiv").height()-$("#mailListTop").height());
					$("#mailContent").css("height",$(".centerDiv").height()-130);
					//$("#centerFrame").css("width",$(".centerDiv").width())
				}
		}
	})

	function addTab(type,url,tabname,mailId){
		window.parent.addTab(type,url,tabname,mailId);
	}
	
	function closeDialog() {
		Dialog.getInstance('0').close();
	}
	
	
</script>
</html>
