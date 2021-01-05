<% weaver.filter.ECompatibleSetting.setVersion(weaver.filter.ECompatibleSetting.ECOLOGY_JSP_VERSION_E8,request); %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%
 String loginid = Util.null2String(request.getParameter("loginid"));
 String isclosed = Util.null2String(request.getParameter("isclosed"));
 String iconUrl=Util.null2String(request.getParameter("iconUrl"));
 
 String defaultUrl="/messager/images/logo_big.jpg";
 String sysUrl="";
 
 String strSql="select resourceimageid,messagerurl from hrmresource where loginid='"+loginid+"'"; 
 rs.executeSql(strSql);
 if(rs.next()){
	 String messagerurl=Util.null2String(rs.getString("messagerurl"));
	 int resourceimageid=Util.getIntValue(rs.getString("resourceimageid"),0);
	 
	 if(!"".equals(messagerurl)) {
		 defaultUrl=messagerurl;
	 }
	 
	 if(resourceimageid!=0) {
		 sysUrl="/weaver/weaver.file.FileDownload?fileid="+resourceimageid;
	 }
	 
	 
 }
 
 String imagefilename = "/images/hdMaintenance.gif";
 String titlename = SystemEnv.getHtmlLabelName(803,user.getLanguage());
 String needfav ="1";
 String needhelp ="";
 %>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(24504,user.getLanguage())+",javascript:doApply();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(24505,user.getLanguage())+",javascript:reSelect();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<HTML>
	<HEAD>	
		<LINK REL="stylesheet" type="text/css" HREF="/css/Weaver.css">
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
		</script>
	</HEAD>
	
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="mail"/>
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(83088,user.getLanguage())%>"/>
	</jsp:include>
	
	<wea:layout attributes="{layoutTableId:topTitle}">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
				<input class="e8_btn_top middle" onclick="doApply()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
			</wea:item>
		</wea:group>
	</wea:layout>
	
	<div class="zDialog_div_content">
	<body style="margin: 0px;padding: 0px;overflow: hidden;">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type=button class="e8_btn_top" onclick="doApply()" value="<%=SystemEnv.getHtmlLabelName(24504, user.getLanguage())%>">
				<input type=button class="e8_btn_top" onclick="reSelect()" value="<%=SystemEnv.getHtmlLabelName(24505, user.getLanguage())%>">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	
	<form name="frmMain" method="post" action="/email/new/MailHeadIconOpreate.jsp" enctype="multipart/form-data">
		<input name="loginid" value="<%=loginid%>" type="hidden">
		<input name="method" value="mailelesignicon" type="hidden">
		<input type="hidden" name="imagefileid" id="imagefileid"/>	
		<wea:layout>	
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
			<wea:item><%=SystemEnv.getHtmlLabelName(24502, user.getLanguage())%></wea:item>	
			<wea:item>
				<div id="divSelected"><input class="url" id="fileSrcUrl"  type="file" name="fileSrcUrl"></div>
				<div  id="divInfo" style="display:none"> <%=SystemEnv.getHtmlLabelName(24503, user.getLanguage())%></div>		
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<table style="width: 100%;height:400px">
					<tr>
						<td style="width: 80%;height: 80%;vertical-align: top;">			  												
							<iframe id="ifrmSrcImg" src="" name="ifrmSrcImg" 
							 style="border:1px solid #DDDDDD;" height="100%" width="100%" BORDER="0" 
							 FRAMEBORDER="no" NORESIZE="NORESIZE" scrolling="auto">
							</iframe>	
						</td>
						<td style="width: 2%"></td>
						<td style="width: 18%;vertical-align: top;">
							<div id="divSelect">			 				
								<div id="divTargetImg" style="border:1px solid #DDDDDD;height:127px;width:100px;background:#ffffff;overflow:hidden"></div>
								<div style="height: 5px"></div>
								x1:<input name="x1" style="width:25px">&nbsp;&nbsp;
								y1:<input name="y1"  style="width:25px">
								<div style="height: 5px"></div>
								x2:<input name="x2"  style="width:25px">&nbsp;&nbsp;
								y2:<input name="y2"  style="width:25px">
							</div>	
						</td>		
			</wea:item>
		</wea:group>
		</wea:layout>
		</form>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doApply();">	
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
	
	
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	</body>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
	$(document).ready( function() {	
		$("#fileSrcUrl").change( function() {			
			var imgUrl=this.value;
			
			if(imgUrl!=''){
				if(imgUrl.toLowerCase().indexOf(".gif")==-1 && imgUrl.toLowerCase().indexOf("jpg")==-1) {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24506, user.getLanguage())%>。");
					return;
				}		
				$("#divSelected").hide();
				
				$("#divInfo").show();	

				$(ifrmSrcImg.document.body).append("<img src='/images/messageimages/loading.gif'/><%=SystemEnv.getHtmlLabelName(19819, user.getLanguage())%>...");

				$('input[name=x1]').val('0');
				$('input[name=y1]').val('0');
				$('input[name=x2]').val('100');
				$('input[name=y2]').val('127');
							
				frmMain.target="ifrmSrcImg";
				frmMain.action="/email/new/GetSignIconOnlyImg.jsp";
				
				frmMain.submit();
			}			
		}); 			
	});

	
	function doApply(){
		
		var srcUrl=frmMain.fileSrcUrl.value;		
		if($.trim(srcUrl.value)==""&&$.trim($("#divSelected").css("display"))!="none"){		
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24506, user.getLanguage())%>");
			return;
		} else if (srcUrl.toLowerCase().indexOf(".gif")==-1 && srcUrl.toLowerCase().indexOf("jpg")==-1){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24506, user.getLanguage())%>。");
			return;
		} else {
				
			frmMain.target="_self";		
			frmMain.action="/email/new/MailHeadIconOpreate.jsp";
			frmMain.submit();
		}
	}

	function reSelect(){
		window.location.replace(window.location.href);
	}
</script>
<%
 if("true".equals(isclosed)){
	String userid=rci.getUserIdByLoginId(loginid);
	rci.updateResourceInfoCache(userid);
	   out.println("<script>jQuery('#headimg',parentWin.parent.document).attr('src','"+iconUrl+"');dialog.close();</script>");
 }
  %>
