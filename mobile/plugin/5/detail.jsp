
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="java.text.*" %>
<%@ page import="org.apache.commons.lang.time.DateFormatUtils" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.docs.docs.DocImageManager"%>
<%@page import="weaver.meeting.MeetingMobileUtil"%>
<%@page import="weaver.meeting.qrcode.MeetingSignUtil"%>
<%@page import="weaver.meeting.MeetingShareUtil"%> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="meetingService" class="weaver.mobile.plugin.ecology.service.MeetingService" scope="page" />
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>

<%!
	public String getAccessorys(String accessorys,User user,String classdiv) throws Exception{
		DocImageManager DocImageManager=new DocImageManager();
		RecordSet RecordSet=new RecordSet();
		String showvalue="";
		ArrayList arrayaccessorys = Util.TokenizerString(accessorys,",");
		for(int i=0;i<arrayaccessorys.size();i++){
			String accessoryid = (String)arrayaccessorys.get(i);
			if(accessoryid.equals("")){
		        continue;
		    }
		    RecordSet.executeSql("select id,docsubject,accessorycount from docdetail where id="+accessoryid);
		    int linknum=-1;
		    if(RecordSet.next())
		     {
		    	showvalue+="<div class=\""+("".equals(Util.null2o(classdiv))?"pcontent":"classdiv")+"\">";
				linknum++;
	          			String showid = Util.null2String(RecordSet.getString(1)) ;
		                String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
		                int accessoryCount=RecordSet.getInt(3);
		
		                DocImageManager.resetParameter();
		                DocImageManager.setDocid(Integer.parseInt(showid));
		                DocImageManager.selectDocImageInfo();
		
		                String docImagefileid = "";
		                long docImagefileSize = 0;
		                String docImagefilename = "";
		                String fileExtendName = "";
		                int versionId = 0;
		
		                if(DocImageManager.next())
		                {
			                //DocImageManager浼氬緱鍒癲oc绗竴涓檮浠剁殑鏈€鏂扮増鏈?
			                docImagefileid = DocImageManager.getImagefileid();
			                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
			                docImagefilename = DocImageManager.getImagefilename();
			                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
			                versionId = DocImageManager.getVersionId();
		                }
		                if(accessoryCount>1)
		                {
		                	fileExtendName ="htm";
		                }
	             	    String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
					showvalue+=imgSrc+"<a  style='color:blue;cursor:hand' onclick=\"downloads('" + docImagefileid + "','" + docImagefilename + "');\">"+docImagefilename+ "&nbsp;&nbsp;(" + (docImagefileSize / 1000) + "K)"+"</a>&nbsp;</div>";
		    }
		}
		return showvalue;
	}
%>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

User user = HrmUserVarify.getUser(request , response);
if(user == null)  return ;

int id = Util.getIntValue((String)request.getParameter("id"));
int detailid = Util.getIntValue(request.getParameter("detailid"));
int module = Util.getIntValue(request.getParameter("module"));
int scope = Util.getIntValue(request.getParameter("scope"));

String titleurl = Util.null2String((String)request.getParameter("title"));
String title = StringEscapeUtils.escapeHtml(URLDecoder.decode(titleurl,"UTF-8"));
titleurl = StringEscapeUtils.escapeHtml(URLEncoder.encode(titleurl, "UTF-8"));

String clienttype = Util.null2String((String)request.getParameter("clienttype"));
String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));

String date = Util.null2String((String)request.getParameter("date"));
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
Date selectDate = null;
try {selectDate = dateFormat.parse(date);} catch (Exception e) {selectDate = new Date();}
date = DateFormatUtils.format(selectDate,"yyyy-MM-dd");

int requestid = Util.getIntValue((String)request.getParameter("requestid"));
String fromWF = Util.null2String((String)request.getParameter("fromWF"));
fromWF = "true".equals(fromWF) ? "true" : "";
int fromRequestid = Util.getIntValue(request.getParameter("fromRequestid"), 0);

Map meeting = meetingService.getMeeting(id, user);
//处理相关附件
String showvalue="";
RecordSet rs = new RecordSet();
String othermembers="";
String othersremark="";

//处理会议手机签到二维码功能
String qrticket="";
String caller="";
String contacter="";
String creater="";
boolean showQR=false;
String allUser=MeetingShareUtil.getAllUser(user);
String name="";
String servletUrl = "";
rs.executeSql("select name,qrticket,caller,contacter,creater,accessorys,othermembers,othersremark from Meeting where id="+id);
if(rs.next()) {
	String accessorys=Util.null2String(rs.getString("accessorys"));
	showvalue=getAccessorys(accessorys,user,"");
	othermembers=Util.null2String(rs.getString("othermembers"));
	othersremark=Util.null2String(rs.getString("othersremark"));
	qrticket=Util.null2String(rs.getString("qrticket"));
	caller=Util.null2String(rs.getString("caller"));
	contacter=Util.null2String(rs.getString("contacter"));
	creater=Util.null2String(rs.getString("creater"));
	name=Util.null2String(rs.getString("name"));
}

if("".equals(qrticket)){
	qrticket=MeetingSignUtil.createTicket(""+id,user);
}
if((meetingSetInfo.getCreaterPrm()>=2&&MeetingShareUtil.containUser(allUser,creater))||MeetingShareUtil.containUser(allUser,caller)||MeetingShareUtil.containUser(allUser,contacter)){
	showQR=true;
}
//加了一个.jpg扩展名是为了通过手机组安全过滤规则
if(!"".equals(qrticket)){
	servletUrl = URLEncoder.encode("/weaver/weaver.meeting.qrcode.CreateQRCodeServlet?isUrl=1&content="+qrticket+"&flg=.jpg","UTF-8");
}

//标识会议已经查看过
String sql="update Meeting_View_Status set status = 1 where meetingId ="+id +" and userid="+user.getUID();
RecordSet.executeSql(sql);
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1, minimum-scale=1, user-scalable=no, minimal-ui" />
	<title><%=title %></title>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
	<style>
		html, body {
			font-size: 14px;
			margin: 0;
			padding: 0;
			background-color: #EDEDED;
		}
		
		#view_header {
			width: 100%;
			height:40px;
			filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',endColorstr='#ececec' );
			background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF),to(#ECECEC) );
			background: -moz-linear-gradient(top, white, #ECECEC);
			border-bottom: #CCC solid 1px;
			font-size:9pt;
			position:relative;
		}
		
		#view_title {
			color: #336699;
			font-size: 20px;
			font-weight: bold;
			text-align: center;
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
		}

		.line {
			border-bottom: 1px solid #C5C5C5;
			padding: 0;
		}

		img {
			max-height: 15px;
			max-width: 15px;
			float: left;
			margin-right: 10px;
		}

		.lines {
			padding: 10px 20px;
			background-color: #FFFFFF;
		}

		.ptitle {
			float:left;
			width:80px;
			word-break: keep-all;
			text-overflow: ellipsis;
			white-space: nowrap;
			overflow: hidden;
		}
		
		.pcontent {
			padding-left: 105px;
			word-wrap: break-word;
			word-break: normal;
		}
		
		.reBtn{
			width: 50%;
			float: left;
			text-align: center;
			height: 30px;
			line-height: 30px;
			border-top: 2px;
		}
		
		.attend{
			width: 49%;
			color:blue;
			border-top: 2px solid blue;
			border-bottom: 2px solid #C5C5C5;
			border-right:2px solid #C5C5C5;
		}
		
		.noattend{
			color:red;
			border-top: 2px solid red;
			border-bottom: 2px solid #C5C5C5;
		}
		
		.reTitle{
			background-color:#E0E0E0;
		}	
		.reTitleChd{
			margin-left: 10px;
		}	
		.reDiv{
			min-height: 30px;
			line-height: 30px;
		}
		.reDiv:after{
         clear: both;
         content: '';
         display: block;
         }
		
		.reName{
			float: left;
  			width: 70%;
  			margin-left: 20px;
			white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
		}
		.fontred{
			color:red;
		}
	</style>
	<script type="text/javascript">
	function doLeftButton() {
		var fromWF = "<%=fromWF%>";
		if(fromWF == "true"){
			location = '/mobile/plugin/1/view.jsp?requestid=<%=requestid%>&module=<%=module%>&scope=<%=scope%>&fromRequestid=<%=fromRequestid%>';
			return 1;
		}else{
			location = "/mobile/plugin/5/meeting.jsp?module=<%=module%>&scope=<%=scope%>&title=<%=titleurl%>&date=<%=date%>";
			return "BACK";
		}
	}
	
	function doBack() {
		var fromWF = "<%=fromWF%>";
		if(fromWF == "true"){
			location = '/mobile/plugin/1/view.jsp?requestid=<%=requestid%>&module=<%=module%>&scope=<%=scope%>&fromRequestid=<%=fromRequestid%>';
			return 1;
		} else {
			var result = doLeftButton();
			if(result==null||result=="BACK"){
				location = "/home.do";
			}
		}
	}
	function downloads(fid,fname)
	{
		window.open("/download.do?meetingid=<%=id%>&download=1&fileid="+fid+"&filename="+fname,'_blank');
	}
	
	
	function isattend(attend){
		var msg="<%=SystemEnv.getHtmlLabelNames("16631,2195,82179", user.getLanguage())%>";
		if(attend==2){
			msg="<%=SystemEnv.getHtmlLabelNames("16631,233,2195,82179", user.getLanguage())%>";
		}
		if(confirm(msg)){
			forbiddenPage();
			jQuery.ajax({
				type: "post",
			    url: "/mobile/plugin/5/opreation.jsp?operation=reHrm",
			    data:{"meetingid":"<%=id%>","receiptId":jQuery('#receiptId').val(),"isattend":attend,"recRemark":jQuery('#recRemark').val()},
			    dataType: "json",  
			    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    complete: function(){
					//if(para.loadingTarget!=null)  jQuery(para.loadingTarget).hideLoading();
				},
			    error:function (XMLHttpRequest, textStatus, errorThrown) {
			       //alert(errorThrown);
			    } , 
			    success:function (data, textStatus) {
			    	if (data == undefined || data == null) {
			    		alert("<%=SystemEnv.getHtmlLabelName(127900,user.getLanguage())%>!\n<%=SystemEnv.getHtmlLabelName(125961,user.getLanguage())%>!");
			    		return;
			    	}else{
			    		location.reload() ;
			    	}  
			    } 
	    	});
		}
	}
	
	jQuery(document).ready(function(){
		window.scrollTo(0,0);
		if(jQuery('.reBtn').length>0){
			jQuery('.reBtn').width((document.body.clientWidth-2)/2);
		}
		
	});
	
	function forbiddenPage(){
	$("<div class=\"datagrid-mask\" style=\"position:fixed;z-index:2;opacity:0.4;filter:alpha(opacity=40);BACKGROUND-COLOR:#fff;\"></div>").css({display:"block",width:"100%",height:"100%",top:0,left:0}).appendTo("body");   
    $("<div class=\"datagrid-mask-msg\" style=\"background:#fff;position:fixed;z-index:3;padding: 10px;padding-top: 6px;padding-bottom: 6px;border: 1px solid;\"></div>").html("<%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%>").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});  
	} 
	
	function releasePage(){  
	    $(".datagrid-mask,.datagrid-mask-msg").hide();  
	}
	
	function showQr(){
	    
		$("<div class=\"datagrid-mask\" style=\"position:fixed;z-index:2;opacity:0.8;filter:alpha(opacity=0.8);BACKGROUND-COLOR:#666666;\"></div>").css({display:"block",width:"100%",height:"100%",top:0,left:0}).appendTo("body");   
		$("<div class=\"datagrid-mask-msg\" style=\"background:#fff;position:fixed;z-index:3;border: 0px solid;\"></div>").html("<div style=\"text-align: center;margin-top: 20px;word-wrap:break-word; width:260px;\"><%=name%></div><div><img border=0 src=\"/download.do?url=<%=servletUrl %>\"  style=\"max-height: 240px;max-width: 240px;  margin-left: 20px;margin-top: 20px;margin-bottom: 10px;\"/></div><div style=\"text-align: center;margin-bottom: 15px;color: gray;\"><%=SystemEnv.getHtmlLabelName(129713,user.getLanguage())%></div>").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 270) / 2,top:($(window).height() - 350) / 2}); 

		$(".datagrid-mask,.datagrid-mask-msg").bind("click",function(){
			$(".datagrid-mask,.datagrid-mask-msg").remove();
		}); 
	}

	</script>
</head>
<body>
	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<a href="javascript:doBack();">
			<div style="position:absolute;left:5px;top:6px;width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
				<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>
			</div>
		</a>
		<div id="view_title" style="position:absolute;left:65px;top:6px;right:65px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;"><%=title %></div>
	</div>
<%
if(meeting==null || meeting.size()<=0) {
	%><div style="width:100%;height:280px;"><div style="padding:10px;"><%=SystemEnv.getHtmlLabelName(125652, user.getLanguage())%></div></div><%
} else {
	String meetingstatus = "";
	int meetingstatusId = Util.getIntValue((String)meeting.get("meetingstatus"));
	switch(meetingstatusId) {
		case 0:
			meetingstatus = SystemEnv.getHtmlLabelName(220,user.getLanguage());
			break;
		case 1:
			meetingstatus = SystemEnv.getHtmlLabelName(2242,user.getLanguage());
			break;
		case 2:
			meetingstatus = SystemEnv.getHtmlLabelName(225,user.getLanguage());
			break;
		case 3:
			meetingstatus = SystemEnv.getHtmlLabelName(1010,user.getLanguage());
			break;
		default:
			meetingstatus = "";
	}
	%>
	<div class="lines" style="margin-top: 15px;">
		<img src="/mobile/plugin/5/images/title_wev8.png">
		<div style="padding-left: 25px;word-wrap: break-word;word-break: normal;"><%=meeting.get("name") %>&nbsp;</div>
	</div>
	<div class="line"></div>
	<div class="lines">
		<img style="margin-top: 8px;" src="/mobile/plugin/5/images/time_wev8.png">
		<div style="float:left"><%=meeting.get("begindate") %><br><%=meeting.get("begintime") %></div>
		<div style="float:left;font-size: 28px;margin: 0 35px;">&gt;</div>
		<div style="float:left"><%=meeting.get("enddate") %><br><%=meeting.get("endtime") %></div>
		<div style="clear: both;"></div>
	</div>
	<div class="line"></div>
	<div class="lines">
		<img src="/mobile/plugin/5/images/person_wev8.png">
		<div class="ptitle"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("3")),user.getLanguage())%></div>
		<div class="pcontent"><%=meeting.get("caller") %>&nbsp;</div>
	</div>
	<div class="line"></div>
	<div class="lines">
		<img src="/mobile/plugin/5/images/person_wev8.png">
		<div class="ptitle"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("29")),user.getLanguage())%></div>
		<div class="pcontent"><%=meeting.get("othermemberstr") %>&nbsp;</div>
	</div>
	<div class="line"></div>
	<div class="lines">
		<div style="width:15px;height:15px;float:left;margin-right: 10px;"></div>
		<div class="ptitle"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("5")),user.getLanguage())%></div>
		<div class="pcontent"><%=meeting.get("address") %>&nbsp;</div>
	</div>
	<div class="line"></div>
	<div class="lines" style="min-height: 32px;">
		<div style="width:15px;height:15px;float:left;margin-right: 10px;"></div>
		<div class="ptitle" style="white-space:<%=user.getLanguage()==7||user.getLanguage()==9?"inherit":"nowrap" %>"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("6")),user.getLanguage())%></div>
		<div class="pcontent"><%=meeting.get("customizeAddress") %>&nbsp;</div>
	</div>
	<div class="line"></div>
	<div class="lines">
		<div style="width:15px;height:15px;float:left;margin-right: 10px;"></div>
		<div class="ptitle"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage()) %></div>
		<div class="pcontent"><%=meetingstatus %>&nbsp;</div>
	</div>
	<%if(showQR){%>
	<div class="line"></div>
	<div class="lines" style="height:20px" onclick="showQr()">
		<div style="width:15px;height:15px;float:left;margin-right: 10px;"></div>
		<div class="ptitle"><%=SystemEnv.getHtmlLabelName(129712,user.getLanguage()) %></div>
		<div class="pcontent" style="float:right;margin-right:10px;line-height: 25px;"><img src="images/qr.png" style="max-height: 20px;max-width: 20px;"><span>></span></div>
	</div>
	<%}%>
	<div class="lines" style="margin-top: 15px;">
		<div style="width:15px;height:15px;float:left;margin-right: 10px;"></div>
		<div class="ptitle"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage()) %></div>
		<div class="pcontent"><%=meeting.get("decision") %>&nbsp;</div>
	</div>
	<%if(!"".equals(showvalue)){%>
	<div class="line"></div>
	<div class="lines" style="margin-top: 5px;">
		<div style="width:15px;height:15px;float:left;margin-right: 10px;"></div>
		<div class="ptitle"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("35")),user.getLanguage())%></div>
		<div class="pcontent">&nbsp;</div>
	</div>
	
	<div class="lines" style="padding-top: 0px;">
		<div class="pcontent" style="padding-left: 50px;">
			<%=showvalue %>
		</div>
	</div>
	<div class="line"></div>
	<%}
	int receiptId=MeetingMobileUtil.getReceiptId(user.getUID()+"",id+"");
	if(receiptId>0){ %>
	<div class="lines" style="margin-top: 10px;padding-top: 10px;">
		<div class="ptitle" style="margin-top: 5px;"><%=SystemEnv.getHtmlLabelName(22265,user.getLanguage())%></div>
		<div class="pcontent" style="padding-left:0px">
			<INPUT type="hidden" id="receiptId" name="receiptId" value="<%=receiptId %>">
			<INPUT type="text" id="recRemark" name="recRemark" placeholder="<%=SystemEnv.getHtmlLabelNames("2108,22265",user.getLanguage())%>" value="">
		</div>
	</div>
	<div class="lines" style="padding: 0px;height:32px;">
		<div class="reBtn attend" onclick="isattend(1)"><%=SystemEnv.getHtmlLabelName(2195,user.getLanguage()) %></div>
		<div class="reBtn noattend" onclick="isattend(2)"><%=SystemEnv.getHtmlLabelNames("233,2195",user.getLanguage()) %></div>
	</div>
	<div class="line"></div>
	<%} %>
	<div class="lines" style="margin-top: 10px;padding: 0px;">
		 <div>
		 
			<%
			int hrmnum=0;
			int crmnum=0;
			String temp_hrm="";
			String temp_crm="";
			String temp_attend="";
			String temp_recRemark="";
			String temp_attend_str=SystemEnv.getHtmlLabelName(2195,user.getLanguage());
			String temp_noattend_str=SystemEnv.getHtmlLabelNames("233,2195",user.getLanguage());
			String temp_other_attend_str=SystemEnv.getHtmlLabelName(2188,user.getLanguage());
			
			rs.execute("SELECT memberid,isattend,recRemark FROM  Meeting_Member2 where meetingid="+id+" and membertype=1 order by id");
			if(rs.getCounts()>0){
			%>
			<div class="reTitle"><div class="reTitleChd"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("29")),user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(2166,user.getLanguage())%><%=rs.getCounts()%>)</div></div></td></tr>
			<%  while(rs.next()){
				  temp_hrm=rs.getString(1);
				  temp_attend=rs.getString(2);
			%>	  
				
			  <div class="reDiv">
			  	<div class="reName"><%=Util.toScreen(ResourceComInfo.getResourcename(temp_hrm),user.getLanguage())%></div>
			  	<div class="reAttend">
			  	  <%if("1".equals(temp_attend)){
			  			hrmnum++;
			  			out.println(temp_attend_str);
			  		}else if("2".equals(temp_attend)){
			  			out.println(temp_noattend_str);
					}else if("3".equals(temp_attend)){
						out.println(temp_other_attend_str);
					}%>
			  	</div>
			  </div>
			  <div class="line"></div>
			<%}
			}
			rs.execute("SELECT memberid,isattend,membermanager FROM  Meeting_Member2 where meetingid="+id+" and membertype=2 order by id");
			if(rs.getCounts()>0){
			%>
			<div class="reTitle"><div class="reTitleChd"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("32")),user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(32591,user.getLanguage())%><%=rs.getCounts()%>)</div></div>
			<%
			  while(rs.next()){
				  temp_crm=rs.getString(1);
				  temp_attend=rs.getString(2);
				  temp_hrm=rs.getString(3);
			%>	  
				 <div class="reDiv">
			  		<div class="reName"><%=CustomerInfoComInfo.getCustomerInfoname(temp_crm)+" ("+Util.toScreen(ResourceComInfo.getResourcename(temp_hrm),user.getLanguage())+")"%></div>
			  		<div class="reAttend">
				  		<%if("1".equals(temp_attend)){
				  			crmnum++;
				  			out.println(temp_attend_str);
				  		}else if("2".equals(temp_attend)){
				  			out.println(temp_noattend_str);
						}else if("3".equals(temp_attend)){
							out.println(temp_other_attend_str);
						}%>
					</div>
			  	</div>
			  	<div class="line"></div>
			<%}
			}
			if(!"".equals(othermembers)){
			%>
			<div class="reTitle"><div class="reTitleChd"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("30")),user.getLanguage())%></div></div>
			
			<div class="reDiv">
		  		<div class="reName"><%=othermembers%></div>
		  		<div class="reAttend"><%="1".equals(temp_attend)?temp_attend_str:"2".equals(temp_attend)?temp_noattend_str:"3".equals(temp_attend)?temp_other_attend_str:"" %></div>
		  	</div>
		  	<div class="line"></div>
		  		
			<%	
				if(!"".equals(othersremark)){
			%>
				<div class="reDiv">
			  		<div style="float: left;margin-left: 20px;"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%>:</div>
			  		<div style="float: left;margin-left: 5px;"><%=othersremark%></div>
		  		</div>
		  		<div class="line"></div>		
			<%	}
			}
			%>
			<div class="reTitle">
			<%=SystemEnv.getHtmlLabelName(2207,user.getLanguage())%><font class="fontred"><%=hrmnum+crmnum%></font><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(2208,user.getLanguage())%><font class="fontred"><%=hrmnum%></font><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(2209,user.getLanguage())%><font class="fontred"><%=crmnum%></font><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
			</div>
			<div class="line"></div>
		</div>
	</div>
	<div class="line"></div>
<%}%>
</body>
</html>