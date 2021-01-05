<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.voting.VotingManager" %>
<%@ page import="weaver.docs.docpreview.DocPreviewHtmlManager" %>
<HTML>
	<HEAD>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<%
		String agent = request.getHeader("user-agent");
		if((agent.contains("Firefox")||agent.contains(" Chrome")||agent.contains("Safari") )&& !agent.contains("Edge")){
		    isIE = "false";
		}
		else{
		    isIE = "true";
		}
		
		int fileId = Util.getIntValue(request.getParameter("fileid"),0);
		int votingId = Util.getIntValue(request.getParameter("votingId"),0);
		if(fileId == 0 || votingId == 0){
		    //错误请求
		    return;
		}
		RecordSet rs = new RecordSet();
		rs.executeSql("select *from ImageFile where imagefileid=" + fileId);
		
		if(!rs.next()){
		    //文档不存在
		    return;
		}
		
		String filename = Util.null2String(rs.getString("imagefilename"));
		String extname = filename.indexOf(".") >=0 ? filename.substring(filename.lastIndexOf(".")) : "";
		extname = extname.toLowerCase();
		boolean readOnLine = false; //是否允许在线查看（否则下载）
		if(".doc".equals(extname) || ".docx".equals(extname) || ".xls".equals(extname) || ".xlsx".equals(extname)){
		    readOnLine = true;
		}
		
		
		VotingManager votingManager = new VotingManager();
		boolean hasRight = votingManager.hasRightByFileid(votingId,fileId,user);
		if(!hasRight){
		    //没有权限
		    response.sendRedirect("/notice/noright.jsp") ;
		    return;
		}
		
		//	FileUpload fu = new FileUpload(request);
		//    String docsubject = "test";
		//    String readCount_int = "12";
		//    String imagefileId = "123456";
		   // String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
		   // String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
		  //  User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
		  
		  
		  
		  if(!readOnLine){
		      response.sendRedirect("/weaver/weaver.file.FileDownload?votingId=" + votingId + "&fileid=" + fileId);
		      return;
		  }
		  
		  String iframeSrc = "";
		  if(isIE.equals("false")){
		      DocPreviewHtmlManager docPreviewHtmlManager = new DocPreviewHtmlManager();
		      int htmlFileId = 0;
		      try{
		          htmlFileId = docPreviewHtmlManager.doFileConvert(fileId,null,null,-1,-1);
		      }catch(Exception e){
		          request.setAttribute("labelid",Util.null2String(e.getMessage()));
				  request.getRequestDispatcher("/wui/common/page/sysRemindDocpreview.jsp").forward(request,response);
		         return; 
		      }
		      if(htmlFileId > 0){
		          iframeSrc = "/weaver/weaver.file.FileDownload?fileid=" + htmlFileId;
		      }
		  }
		%>
		<title><%=SystemEnv.getHtmlLabelName(367, user.getLanguage())%>:<%=filename%></title>
	</HEAD>

	<script type="text/javascript"
		src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
	<script type="text/javascript"
		src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
	<script type="text/javascript"
		src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
	<link rel="stylesheet" href="/css/init_wev8.css" type="text/css" />
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css"
		rel="stylesheet"></link>
	<link type="text/css" href="/css/ecology8/crudoc_wev8.css"
		rel="stylesheet"></link>
	<style type="text/css">
html,body {
	height: 100%;
	overflow: hidden;
}

#ext-gen34,#ext-gen29 {
	Line-height: 161% !important;
	font-family: "verdana", "宋体" !important;
}
</style>
	<%if (user.getLanguage() == 7) {%>
	<script type='text/javascript' src='/js/weaver-lang-cn-gbk_wev8.js'></script>
	<%} else if (user.getLanguage() == 8) {%>
	<script type='text/javascript' src='/js/weaver-lang-en-gbk_wev8.js'></script>
	<%} else if (user.getLanguage() == 9) {%>
	<script type='text/javascript' src='/js/weaver-lang-tw-gbk_wev8.js'></script>
	<% } %>
	<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery('.e8_box').Tabs({
		 	getLine:0,
		 	image:false,
		 	needLine:true,
		 	lineSep: ">",
		 	exceptHeight:true,
		 	objName:"<%=filename%>",
        	mouldID:"<%=MouldIDConst.getID("doc")%>"
		 });
		 jQuery("div#divTab").show();
	});
</script>
	<body class="ext-ie ext-ie8 x-border-layout-ct" scroll="no"
		style="overflow-x: auto;">
		
<%@ include file="/docs/office/iWebOfficeConf.jsp" %>		
<%

String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl="/docs/office/"+mServerName;
String mClientUrl="/docs/docs/"+mClientName;

%>		
		
		<div style="width: 100%; height: 100%;">
			<div id="divContentTab" style="width: 100%; height: 100%;">
				<table id="topTitle" cellpadding="0" cellspacing="0">
					<tr>
						<td>
						</td>
						<td class="rightSearchSpan" style="text-align: right;">
							<input type=button class="e8_btn_top" style="margin-right:10px"
								onclick="javascript:onDownLoad()" value="下载"></input>
						</td>
					</tr>
				</table>
				<div class="e8_box demo2">
					<div class="e8_boxhead">
						<div class="div_e8_xtree" id="div_e8_xtree"></div>
						<div class="e8_tablogo" id="e8_tablogo"></div>
						<div class="e8_ultab">
							<div class="e8_navtab" id="e8_navtab">
								<span id="objName"></span>
							</div>
							<div>
							<div id="rightBox" class="e8_rightBox"></div>
							</div>
						</div>
					</div>
					<div class="tab_box _synergyBox">
						<div style="width: 100%; height: 100%;">
							<div id="divContent" style="width: 100%;height: 100%;">
								<div id="divContentInfo" class="e8_propTab "
									style="width: 100%; height: 100%;position:relative">
									<%if(isIE.equals("true")){ %>
										<OBJECT id="WebOffice" name="WebOffice" classid="<%=mClassId%>" style="POSITION:absolute;width:0px;height:0px;top:-20px" codebase="<%=mClientUrl%>" >
										</OBJECT>	
									<%}else{ %>
									<iframe id="doccontentifm" onload="hideLoading();displayRightMenu(this);"
										style="OVERFLOW: auto; width: 100%; height: 100%;"
										class=x-managed-iframe src="" frameBorder=0></iframe>
									<%} %>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<iframe src="" style="display:none" id="downloadIfr"></iframe>
	</body>
</html>
<script language="javascript" type="text/javascript">
$(document).ready(
	function(){
		try{
			if(jQuery("#WebOffice").size() > 0){
				onLoad();
			}
		} catch(e){}
		try{
			if(jQuery("#doccontentifm").size() > 0){
				document.getElementById("doccontentifm").src = "<%=iframeSrc%>";
			}
		} catch(e){}
		try{	
			onLoadEnd();
		} catch(e){}
	}
);

function onLoad(){
     try{
        document.getElementById("WebOffice").WebUrl="<%=mServerUrl%>";
        document.getElementById("WebOffice").RecordID="<%=fileId%>";
        document.getElementById("WebOffice").FileName="<%=filename%>";
        document.getElementById("WebOffice").FileType="<%=extname%>";
        document.getElementById("WebOffice").ShowToolBar="2";      //ShowToolBar:是否显示工具栏:1显示,0不显示  2 :隐藏OFFICE软件工具栏
		document.getElementById("WebOffice").WebOpen();
		document.getElementById("WebOffice").style.width = "100%";
		document.getElementById("WebOffice").style.height = parseInt(jQuery("#WebOffice").parent().height()) + 20 + "px";
	 }catch(e){
            //alert("error:"+e.description);
     }
}

function displayRightMenu(obj){
			var _document = obj.contentWindow.document;
			jQuery(_document.body).css("height","100%");
			jQuery(_document.body).parent().css("height","100%");
	}
	
function onDownLoad(){
	jQuery("#downloadIfr").attr("src","/weaver/weaver.file.FileDownload?votingId=<%=votingId%>&fileid=<%=fileId%>&download=1");
}	
</script>
<style>
.x-ie-shadow {
	background-color: #fff; *
	background-color: #777 !important;
}
</style>