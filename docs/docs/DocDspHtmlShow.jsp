
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*,weaver.general.Util" %>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
BaseBean baseBeanRigthMenu = new BaseBean();

int userightmenu = 1;
String doccontentbackgroud=Util.null2String(request.getParameter("doccontentbackgroud"));
try{
	userightmenu = Util.getIntValue(baseBeanRigthMenu.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}

BlogDao blogDao=new BlogDao();
String isOpenBlog=blogDao.getBlogStatus(); //是否启用微博模块 
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/FCKEditor/editor/css/fck_editorarea_docdsp_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>
<script type="text/javascript" src="/js/odoc/common/commonjs.js"></script>
<%
  if(isOpenBlog.equals("1")){
%>
<!-- 微博便签 -->
<script type="text/javascript" src="/blog/js/notepad/notepad_wev8.js"></script>
<%} %>
<script type="text/javascript">

var rightMenu=null;
var initSignatureCount;

jQuery(document).ready(function(){
	rightMenu = parent.document.getElementById('rightMenu');
	try{
		//parent.finalDo();
	}catch(e){}
});

//打开附件
function opendoc1(showid,obj){
    //  var discussid=jQuery(obj).parents(".reportItem").attr("id");
    openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"");
}

function showRightClickMenu(e){	
		var event = e?e:(window.event?window.event:null);
		var loc=event.clientY+70;
		var rightedge=document.body.clientWidth-event.clientX;
		var bottomedge=document.body.clientHeight-event.clientY;
		if (rightedge<rightMenu.offsetWidth)
			rightMenu.style.left=(event.clientX-rightMenu.offsetWidth)+"px";
		else
			rightMenu.style.left=event.clientX+"px";
		if (bottomedge<rightMenu.offsetHeight)
			rightMenu.style.top=(loc-rightMenu.offsetHeight)+"px";
		else
			rightMenu.style.top=loc+"px";
			rightMenu.style.visibility="visible"
			rightMenu.style.display="block";
		if(!!event){
			try{
			 	event.stopPropagation();
			 	event.preventDefault();
			}catch(e){
				window.event.cancelBubble = true;
				return false;
			}
		}	
		return false;
}

function hideRightClickMenu(){		
		rightMenu.style.visibility="hidden"
		rightMenu.style.display="none";
		
}


</script>
<style>
#spanContent A {
	COLOR: blue; TEXT-DECORATION: underline
}
#spanContent A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

#spanContent A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
#spanContent A:visited {
	TEXT-DECORATION: underline}
body{
	padding:0;
}

.HtmlShowTable  .HtmlShowTd{
   border:none;
}

</style>

<%
int docid=Util.getIntValue(request.getParameter("docid"),0);
int iscopycontrol=Util.getIntValue(request.getParameter("iscopycontrol"),0);
int imagefileId=Util.getIntValue(request.getParameter("imagefileId"),0);
int nodeId=Util.getIntValue(request.getParameter("nodeId"),0);

boolean isPDF = Util.getIntValue(request.getParameter("isPDF"),0)==1;
boolean canEdit = Util.getIntValue(request.getParameter("canEdit"),0)==1;
boolean canPrint = Util.getIntValue(request.getParameter("canPrint"),0)==1;
if(canEdit){
	iscopycontrol=0;	
}
String isrequest=Util.null2String(request.getParameter("isrequest"));
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
boolean isSignatureNodes=Util.getIntValue(request.getParameter("isSignatureNodes"),0)==1;
if(isPDF){ 

	String sessionParaPDF=""+docid+"_"+imagefileId+"_"+user.getUID()+"_"+user.getLogintype();
	canEdit="1".equals((String)session.getAttribute("canEdit_"+sessionParaPDF))?true:false;
	canPrint="1".equals((String)session.getAttribute("canPrint_"+sessionParaPDF))?true:false;
	isSignatureNodes="1".equals((String)session.getAttribute("isSignatureNodes_"+sessionParaPDF))?true:false;


	String pointUrl = Util.null2String(request.getParameter("pointUrl")); // 指定版本查看标记
	int pointImagefileId = Util.getIntValue(request.getParameter("pointImagefileId"),0);// 指定pdf文件的imagefileId

	if("true".equals(pointUrl)) {
		imagefileId = pointImagefileId;
	} else{
		if(imagefileId>0){
			RecordSet.executeSql("select max(a.imageFileId) as imageFileId  from DocImageFile a  where a.docId="+docid+" and exists(select 1  from DocImageFile b  where b.id=a.id and b.docId="+docid+" and b.imageFileId="+imagefileId+")");
			if(RecordSet.next()){
				int imagefileId_new=Util.getIntValue(RecordSet.getString("imageFileId"));
				if(imagefileId_new>imagefileId){
					imagefileId=imagefileId_new;
				}
			}
		}
	}
}
%>
<% if(isPDF){ %>
<body  onUnload="UnLoad()">
<%@ include file="iWebPDFConf.jsp" %>
<%
String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl=temStr+mServerName;
String mClientUrl=temStr+mClientName;

%>
<OBJECT id="WebPDF" width="100%" height="103%" classid="<%=mClassId%>" codebase="<%=mClientName%>" VIEWASTEXT style="POSITION:absolute;top:-23px;filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';">
</object>
</body>
<script type="text/javascript">
<!--
$(document).ready(function(){
try{
   
	if(document.getElementById("WebPDF").Version){
	    //以下属性必须设置，实始化iWebPDF
		parent.finalDo("view");
	    document.getElementById("WebPDF").WebUrl="<%=mServerName%>";
	    document.getElementById("WebPDF").RecordID="<%=docid%>";
	    document.getElementById("WebPDF").FileName="<%=imagefileId%>";
	    document.getElementById("WebPDF").UserName="<%=user.getUID()%>";
<%if(canEdit){%>
		document.getElementById("WebPDF").ShowTools = 1;
		document.getElementById("WebPDF").ShowMenus = 1;
		document.getElementById("WebPDF").ShowSigns = 1;
		document.getElementById("WebPDF").ShowPostil= 1;
		document.getElementById("WebPDF").SaveRight = 1;
<%}else{%>
		document.getElementById("WebPDF").ShowTools = 0;
		document.getElementById("WebPDF").ShowMenus = 0;

		document.getElementById("WebPDF").ShowPostil= 0;
    <%if(isSignatureNodes){%>
		document.getElementById("WebPDF").SaveRight = 1;
		document.getElementById("WebPDF").ShowSigns = 1;
    <%}else{%>
		document.getElementById("WebPDF").SaveRight = 0;
		document.getElementById("WebPDF").ShowSigns = 0;
    <%}%>
<%}%>
	    document.getElementById("WebPDF").ShowState = 1;
	    document.getElementById("WebPDF").ShowSides = 0;
	    document.getElementById("WebPDF").ShowMarks = 0;
	    document.getElementById("WebPDF").ShowTitle = 1;
	    document.getElementById("WebPDF").ShowBookMark = 0;
	    
	    document.getElementById("WebPDF").AlterUser = 0;
		document.getElementById("WebPDF").PrnScreen = false;
	    
	
		<% if(canPrint){ %>
	    document.getElementById("WebPDF").PrintRight = 1;
	    <% } else { %>
	    document.getElementById("WebPDF").PrintRight = 0;
	    <% } %>
	    document.getElementById("WebPDF").ShowSchedule=false;	    
	    document.getElementById("WebPDF").WebOpen();
		document.getElementById("WebPDF").CursorState = 0;
	    document.getElementById("WebPDF").Zoom = 100;
	    document.getElementById("WebPDF").Rotate = 360;
	    document.getElementById("WebPDF").CurPage = 1;
	    
	    document.body.scroll = "no";
	    document.oncontextmenu = function(){
	   		return false;
	    }
	} else {
		alert("<%=SystemEnv.getHtmlLabelName(25132,user.getLanguage())%>");
	}
}catch(e){
    //alert(e.description);
}
});
//-->

//作用：退出iWebPDF
function UnLoad(){
  try{
    if (! document.getElementById("WebPDF").WebClose()){
      alert( document.getElementById("WebPDF").Status);
    }
  }catch(e){
  }
}
</script>
<% } else { %>
<table  class=HtmlShowTable width="100%"  style="height:100%;">
	<tr>
	<td class=HtmlShowTd>
		<span id="spanContent" style="display:none;">

		</span>
		<script type="text/javascript">
		
			function displayRightMenu(){
			//try{
				var _document = document.getElementById("spanContentFrame").contentWindow.document;
				<%if(userightmenu==1){%>
					jQuery(_document.body).bind("contextmenu",function(e){
						showRightClickMenu(e);						
					});
					_document.body.onclick=hideRightClickMenu;		
				<%}%>
				jQuery(_document.body).css("height","100%");
				jQuery(_document.body).parent().css("height","100%");
			//}catch(e){}
			}
			function hideLoading(){
				try{
					parent.finalDo("view");
				}catch(e){}
			}
		</script>
		<iframe frameborder="0" style="width:100%;height:100%;" src="/docs/docs/DocDspHtmlShowContent.jsp?docid=<%=docid%>&doccontentbackgroud=<%=URLEncoder.encode(doccontentbackgroud)%>" id="spanContentFrame" onload="hideLoading();displayRightMenu();
			<%
			if(iscopycontrol==1){
				%>
					addCopycontrol();
				<%  
			}
			%>
		"></iframe>
		<script type="text/javascript">
		
			
			try{
				document.body.style.overflow="hidden";
			}catch(e){}
			var scf = jQuery("#spanContentFrame");
			scf.height(jQuery(window).height());
			jQuery(window).resize(function(){
				scf.height(jQuery(window).height());
			});
		</script>
	</td>
	</tr>
</table>
<% } %>
<script>
	<%if(userightmenu==1){%>
		document.oncontextmenu=showRightClickMenu;
		document.body.onclick=hideRightClickMenu;		
	<%}%>
	
	jQuery(document).ready(function(){
<% if(isPDF){ %>
		initSignatureCount = WebPDF.SignatureCount();
<%} %>	   
<%
  if(isOpenBlog.equals("1") && Util.null2String(blogDao.getSysSetting("isSendBlogNote")).equals("1")){
%>
		notepad('#spanContent');
<%} %>
	});
function addCopycontrol(){
	var ifmObj=document.getElementById("spanContentFrame").contentWindow.document.body;
	ifmObj.style.cssText += ';-moz-user-select: none;-webkit-user-select: none;-ms-user-select: none;-khtml-user-select: none;user-select: none;unselectable:on;';
	ifmObj.onselectstart = function(){return false};
}		

<% if(isPDF){ %>
    function onPrint(){
		document.getElementById("WebPDF").WebPrint(0,"",0,0,true);
	}

	function onSave(flag){
	    if(document.getElementById("WebPDF").WebSave()){
			var imagefileId=document.getElementById("WebPDF").WebGetMsgByName("IMAGEFILEID");
			var paramsObj = null;
			paramsObj = {
				"url":"/docs/docs/docImageFileServlet.jsp",
				"type":"versionDetail",
				"imagefileId":imagefileId,
				"userName":"<%=user.getUsername() %>",
				"otherParams":"<%=SystemEnv.getHtmlLabelName(21706,user.getLanguage()) %>"
			};
			queryData(paramsObj);
			try {
				if(flag) { // 签章确认
					paramsObj = {
						"url":"/docs/docs/docImageFileServlet.jsp",
						"type":"signatureCount",
						"requestId":"<%=requestid %>",
						"nodeId":"<%=nodeId %>",
						"userId":"<%=user.getUID() %>",
						"loginType":"<%=Util.getIntValue(user.getLogintype(),1) %>",
						"signatureCount":WebPDF.SignatureCount(),
						"initSignatureCount":initSignatureCount
					};
					queryData(paramsObj,sucQueryData);
				}
			} catch(e) {
				alert();
			}
			
			parent.document.location.href="/docs/docs/DocDsp.jsp?id=<%=docid%>&imagefileId="+imagefileId+"&isrequest=<%=isrequest%>&requestid=<%=requestid%>";
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21809,user.getLanguage())%>");
		}
	}

<%} %>
</script>

<% if(isPDF){ %>

<script language="javascript" for=WebPDF event="OnToolsClick(vIndex,vCaption)">
    if (vIndex==10){onSave();}
</script>

<%} %>