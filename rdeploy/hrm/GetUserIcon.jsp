
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%
 String id = Util.null2String(request.getParameter("id"));
 String imgurl_ = Util.null2String(request.getParameter("imgurl_"));
 int imageid = Util.getIntValue(request.getParameter("imageid"),-1);
 String isclosed = Util.null2String(request.getParameter("isclosed"));
 String requestFrom=Util.null2String(request.getParameter("requestFrom")); //页面请求来自哪里  homepage表示来自主页左侧菜单设置图标请求
 String iconUrl=Util.null2String(request.getParameter("iconUrl"));
 
 String defaultUrl="/messager/images/logo_big_wev8.jpg";
 String sysUrl="";
 
 if(imgurl_.equals("/messager/images/icon_m_wev8.jpg")){
     imgurl_="";
 }
 
 //String strSql="select resourceimageid,messagerurl from hrmresource where id='"+id+"'"; 
 //rs.executeSql(strSql);
 //if(rs.next()){
	 String messagerurl=imgurl_;
	 int resourceimageid=imageid;
	 
	 if(!"".equals(messagerurl)) {
		 defaultUrl=messagerurl;
		 if(!"true".equals(isclosed)){
			 out.println("<script>$(document).ready( function() { showDefaultImage();});</script>"); 
		 }
	 }
	 
	 if(resourceimageid!=0) {
		 sysUrl="/weaver/weaver.file.FileDownload?fileid="+resourceimageid;
	 }
	 
	 
 //}
 
 String imagefilename = "/images/hdMaintenance_wev8.gif";
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
		<LINK REL="stylesheet" type="text/css" HREF="/css/Weaver_wev8.css">
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
		</script>
	</HEAD>
	<div class="zDialog_div_content">
	<body style="margin: 0px;padding: 0px;overflow: hidden;">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type=button class="e8_btn_top" onclick="doApply()" value="<%=SystemEnv.getHtmlLabelName(24504, user.getLanguage())%>">
				<input type=button class="e8_btn_top" onclick="reSelect()" value="<%=SystemEnv.getHtmlLabelName(24505, user.getLanguage())%>">
				<input type=button class="e8_btn_top" onclick="dodelete()" value="<%=SystemEnv.getHtmlLabelNames("91,24513", user.getLanguage())%>">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<form name="frmShowImage" method="get" action="GetUserIconSub.jsp">
		<input name="defaultimageUrl" id="defaultimageUrl" value="<%=defaultUrl %>" type="hidden">
	</form>
	<form name="frmMain" method="post" action="GetUserIconOpreate.jsp?temploginid=<%=id%>&trmphomepage=<%=requestFrom%>" enctype="multipart/form-data">
		<input name="id" value="<%=id%>" type="hidden">
		<input name="imgurl_" value="<%=imgurl_%>" type="hidden">
		<input name="method" value="usericon" type="hidden">
		<input name="requestFrom" value="<%=requestFrom%>" type="hidden">
		<input type="hidden" name="imagefileid" id="imagefileid"/>	
		<input type="hidden" name="formatWidth" id="formatWidth"/>	
		<input type="hidden" name="formatHeight" id="formatHeight"/>
  
		<wea:layout>	
			<wea:group context="<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>" attributes="{'groupDisplay':'none'}">
			<wea:item><%=SystemEnv.getHtmlLabelName(24502, user.getLanguage())%></wea:item>	
			<wea:item>
				<div id="divSelected"><input class="url" id="fileSrcUrl"  type="file" name="fileSrcUrl"></div>
				<div  id="divInfo" style="display:none"> <%=SystemEnv.getHtmlLabelName(24503, user.getLanguage())%></div>		
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<table style="width: 100%;height:310px">
					<tr>
						<td style="width: 100%;height: 100%;vertical-align: top;">			  												
							<iframe id="ifrmSrcImg" src="" name="ifrmSrcImg" 
							 style="border:1px solid #DDDDDD;" height="100%" width="100%" BORDER="0" 
							 FRAMEBORDER="no" NORESIZE="NORESIZE" scrolling="auto">
							</iframe>	
						</td>
						<td style="width: 2%"></td>
						<td style="width: 18%;vertical-align: top;">
							<div id="divSelect">							
								<div id="divTargetImg" style="border:1px solid #DDDDDD;height:102px;width:102px;background:#ffffff;overflow:hidden"></div>
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
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">	
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
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

				$(ifrmSrcImg.document.body).append("<img src='/images/messageimages/loading_wev8.gif'/><%=SystemEnv.getHtmlLabelName(19819, user.getLanguage())%>...");

				$('input[name=x1]').val('0');
				$('input[name=y1]').val('0');
				$('input[name=x2]').val('100');
				$('input[name=y2]').val('100');
							
				frmMain.target="ifrmSrcImg";
				frmMain.action="GetUserIconOnlyImg.jsp";
				
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
			
			$('input[name=formatWidth]').val(jQuery("#ferret",ifrmSrcImg.document).width());
			$('input[name=formatHeight]').val(jQuery("#ferret",ifrmSrcImg.document).height());
			frmMain.target="_self";		
			frmMain.action="GetUserIconOpreate.jsp";
			frmMain.submit();
		}
	}

	function reSelect(){
		frmMain.action="GetUserIconOpreate.jsp?temploginid=<%=id%>&imgurl_=<%=imgurl_%>?&trmphomepage=<%=requestFrom%>";
		window.location.replace(window.location.href);
	}
	
		function dodelete(){
			window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(30952, user.getLanguage())%>',
			function(){
				frmMain.target="_self";		
				frmMain.action="GetUserIconOpreate.jsp";
				document.frmMain.method.value="delete";
				frmMain.submit();
			})
		}
	function showDefaultImage(){
		frmShowImage.target="ifrmSrcImg";
		frmShowImage.action="GetUserIconSub.jsp";
		frmShowImage.submit();
	}
</script>
<%
 if("true".equals(isclosed)){
	//String userid=rci.getUserIdByLoginId(id);
	rci.updateResourceInfoCache(id);
	//if(requestFrom.equals("homepage")){
	 
	out.println("<script>parent.parent.getParentWindow(window.parent.window).changeIcon('"+iconUrl+"');window.parent.parent.Dialog.close();</script>");
	//}else
	//   out.println("<script>parent.imgWindow.hide();parent.reloadMyLogo();window.location='GetUserIcon.jsp?id="+id+"'</script>"); 
 }
  %>