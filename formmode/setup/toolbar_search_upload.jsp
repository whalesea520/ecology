
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%
 String loginid = Util.null2String(request.getParameter("loginid"));
 String isclosed = Util.null2String(request.getParameter("isclosed"));
 String requestFrom=Util.null2String(request.getParameter("requestFrom")); //页面请求来自哪里  homepage表示来自主页左侧菜单设置图标请求
 String iconUrl=Util.null2String(request.getParameter("iconUrl"));
 
 String defaultUrl="/messager/images/logo_big_wev8.jpg";
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

//RCMenu += "{"+SystemEnv.getHtmlLabelName(24505,user.getLanguage())+",javascript:reSelect();,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	


<style type="text/css">
		* {font:12px Microsoft YaHei}
		html,body{
			height: 100%;
			margin: 0px;
			padding: 0px 0 0 2px;
		}
		.e8_right_top{
			padding: 10px 0px 0px 0px;
			position: relative;
		}
		.e8_right_top .e8_baseinfo{
			border-bottom: 1px solid #E9E9E9;
			padding-bottom: 16px;
		}
		.e8_right_top .e8_baseinfo_name{
			font-size: 18px;
			color: #333;
		}
		.e8_right_top .e8_baseinfo_modify{
			font-size: 12px;
			color: #AFAFAF;
		}
		.e8_right_top ul{
			list-style: none;
			right: 20px;
			bottom: 15px;
		}
		.e8_right_top ul li{
			float: left;
			padding: 0px 20px 0px 0px;
		}
		.e8_right_top ul li .def{
			display: block;
			font-size: 15px;
			color: rgb(13,147,246);
			padding: 1px;
			text-decoration: none;
			cursor: pointer;
			border-bottom: 2px solid #fff;
		}
		.e8_right_top ul li .undef{
			display: block;
			font-size: 15px;
			color: #A3A3A3;
			padding: 1px;
			text-decoration: none;
			cursor: pointer;
			border-bottom: 2px solid #fff;
		}
		.e8_right_center{
			overflow: hidden;
			padding: 0px 10px;
		}
		.e8_right_center .e8_right_frameContainer{
			display: none;
			height: 100%;
		}
		
		.e8_btn_top_first{
			color:#fff;
			background-color:#30b5ff;
			padding-left:25px !important;
			padding-right:25px !important;
			height:28px;
			line-height:22px;
			vertical-align:middle;
			border:1px solid #30b5ff;
			cursor:pointer;
		}
		
		.gradient{ 
		    position:absolute;
            width:100px; 
            opacity:0;
			filter:alpha(opacity=0);			
		} 
	</style>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<SCRIPT LANGUAGE="JavaScript">
     function addformtabsubmit0(){
         var imageid = $("#imagefileid").val();
         var imageSource = "";
         if(imageid == ""){
            imageSource = "local";
         }else{
            imageSource = "url";
         }
         var frame = window.frames['ifrmSrcImg'];
         if(frame.document.getElementById("ferret") != null){
	         var src = frame.document.getElementById("ferret").getAttribute("src");  
	         var url = dialog.currentWindow.document.getElementById("aurl");
	         var url2 = dialog.currentWindow.document.getElementById("aurl2");
	         url.style.display ="none";	         
	         dialog.currentWindow.document.getElementById("imageUrl2").src=src; 
	         dialog.currentWindow.document.getElementById("imageRelUrl").value=src;
	         dialog.currentWindow.document.getElementById("imageid").value=imageid;
	         dialog.currentWindow.document.getElementById("imageSource").value=imageSource;
	         url2.style.display ="block";
         }     
         dialog.closeByHand();
     }
  
</SCRIPT>
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
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="javascript:addformtabsubmit0()">
				<span title="<%=SystemEnv.getHtmlLabelName(83721, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
    </table>
	<form name="frmMain" method="post" action="/messager/GetUserIconOpreate.jsp?temploginid=<%=loginid%>&trmphomepage=<%=requestFrom%>" enctype="multipart/form-data">
		<input name="loginid" value="<%=loginid%>" type="hidden">
		<input name="method" value="usericon" type="hidden">
		<input name="requestFrom" value="<%=requestFrom%>" type="hidden">
		<input type="hidden" name="imagefileid" id="imagefileid"/>	
		
	<table id="tabs" style="padding-left:20px;" cellspacing="10" >
	   <tr>
	      <td>
	      	<div class="e8_right_top">
		         <ul>
		            <li><a class="def" href="#" onclick="changetab(this);"><%=SystemEnv.getHtmlLabelName(125077,user.getLanguage()) %></a></li>
		            <li>|</li>
		            <li><a class="undef" href="#" onclick="changetab(this);" ><%=SystemEnv.getHtmlLabelName(125078,user.getLanguage()) %></a></li>
		            <li>|</li>
		            <input type="hidden" id="urltype" value="1">
		         </ul>
		    </div>
	      </td>
	   </tr>
	   <tr>
	      <td id="local">
	         <div id="tt" style="position:absolute;">
			      <input class="e8_btn_top_first" type="button" value="<%=SystemEnv.getHtmlLabelName(125080,user.getLanguage()) %>">
			 </div>
	         <div id="div1">
	             <input class="url gradient" id="fileSrcUrl"  type="file" name="fileSrcUrl" hidefocus>
	         </div>   
	         <font style="color:#a3a3a3;font-size:15px;margin-left:110px;"><%=SystemEnv.getHtmlLabelName(125081,user.getLanguage()) %></font>    
	      </td>
	      <td id="url" style="display:none;">
	         <div class="e8_right_top">
		         <ul>
		            <li><a class="def" href="#" onclick="changetab(this);"><%=SystemEnv.getHtmlLabelName(125079,user.getLanguage()) %></a></li>
		            <input type="text" style="width:270px;" id="urlbrowser">
		         </ul>	         
		     </div>      
		  </td>
	   </tr>
	</table>
	<table style="width:100%;padding-left:20px;height:200px;">
	   <tr>
	      <td >
	         <iframe id="ifrmSrcImg" src="" name="ifrmSrcImg" style="border:0px solid #DDDDDD;" height="100%" width="100%" BORDER="0" 
			  FRAMEBORDER="no" NORESIZE="NORESIZE" scrolling="auto">
	         </iframe>
	      </td>
	   </tr>
	</table>
	</form>
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
		$("#fileSrcUrl").bind("change",function(){
		    var urltype = $("#urltype").val();	    
			var imgUrl=this.value;		
			if(imgUrl!=''){
				if(imgUrl.toLowerCase().indexOf(".gif")==-1 && imgUrl.toLowerCase().indexOf("jpg")==-1) {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24506, user.getLanguage())%>");
					return;
				}		
				$(ifrmSrcImg.document.body).append("<img src='/images/messageimages/loading_wev8.gif'/><%=SystemEnv.getHtmlLabelName(19819, user.getLanguage())%>...");
				frmMain.target="ifrmSrcImg";
				frmMain.action="/formmode/setup/toolbar_search_onlyImage.jsp?urltype="+urltype;			
				frmMain.submit();
			}
		});
		$("#urlbrowser").bind("blur",function(){
		    var urltype = $("#urltype").val();
		    var urlbrowser = $("#urlbrowser").val();
		    if( urlbrowser != ""){								
					$(ifrmSrcImg.document.body).append("<img src='/images/messageimages/loading_wev8.gif'/><%=SystemEnv.getHtmlLabelName(19819, user.getLanguage())%>...");
					frmMain.target="ifrmSrcImg";
					frmMain.action="/formmode/setup/toolbar_search_onlyImage.jsp?urltype="+urltype;			
					frmMain.submit();
			}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(124909, user.getLanguage())%>");
					return;
			}	
		});
});



   function changetab(obj){
    var li = $(".e8_right_top").find("a");
    for(var i=0;i<li.length;i++){
        if(obj == li[i]){
           $(obj).removeClass().addClass("def");      
        }else{
           $(li[i]).removeClass().addClass("undef");
        }
    }
    if($(obj).html() == "<%=SystemEnv.getHtmlLabelName(125078,user.getLanguage()) %>"){
        $("#url").show();
        $("#local").hide();       
        $("#urltype").val("2");
    }else{      	 
        $("#url").hide();
        $("#local").show();
        $("#urlbrowser").val("");
        $("#urltype").val("1");
    }
}
	
function doApply(){
	var srcUrl=frmMain.fileSrcUrl.value;	
	if($.trim(srcUrl)==""){	
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24506, user.getLanguage())%>");
		return;
	} else if (srcUrl.toLowerCase().indexOf(".gif")==-1 && srcUrl.toLowerCase().indexOf("jpg")==-1){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24506, user.getLanguage())%>");
		return;
	} else {
		addformtabsubmit0();
	}
}

	function reSelect(){
		frmMain.action="/formmode/setup/add_toolbarSearch_upload.jsp?dialog=1&isFromMode=1";
		window.location.replace(window.location.href);
	}
	
</script>