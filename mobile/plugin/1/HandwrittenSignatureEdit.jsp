<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*"%>

<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<jsp:useBean id="HandwrittenSignatureManager" class="weaver.mobile.webservices.workflow.soa.HandwrittenSignatureManager" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("SignatureEdit:Edit", user)){
    response.sendRedirect("/notice/noright.jsp");
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "<b>"+SystemEnv.getHtmlLabelName(30493,user.getLanguage())+"</b>";
String needfav = "1";
String needhelp = "1";

User userObj = HrmUserVarify.getUser(request,response) ;
int userid=userObj.getUID();

int markId = Util.getIntValue(request.getParameter("markId"), 0) ;
HandwrittenSignatureManager.setMarkId(markId);
HandwrittenSignatureManager.getSignatureInfoById();
HandwrittenSignatureManager.next();
int hrmresid = HandwrittenSignatureManager.getHrmresid(); //得到手写签章的用户部门Id
String markName = HandwrittenSignatureManager.getMarkName();//得到手写签章的名称
String Password = HandwrittenSignatureManager.getPassword();//得到手写签章的密码
String markPath = HandwrittenSignatureManager.getMarkPath();  //得到手写签章的路径


%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<SCRIPT language="javascript">

//删除手写签章信息
function onDelete(){
if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
    weaverSignature.opera.value="delete";
    weaverSignature.submit();
	}
}

//图片格式验证
function ValidateImgFormat(){
	    var  str=document.weaverSignature.markPic.value;
	    var ext= str.substring(str.length-3);
	    ext =ext.toLowerCase();
	    if (ext=="jpg" || ext=="bmp" ||ext=="gif") {
	        return true;
	    }else{
	        alert("请选择正确的图片格式!");
	        return false;
	    }
}

//保存修改的手写签章信息
function onSave(){
		if(check_form(document.weaverSignature,"markName,hrmresid,oldMarkPassword1,markPassword1,markPassword2,markPic")){
			if(validationOldpassword()){
				  if(ValidateImgFormat()){
					weaverSignature.opera.value="edit";
		       	    weaverSignature.submit();
		       	  }				
			}
	    }
}

//验证旧密码
function validationOldpassword(){
	//验证旧密码
	var oldPassword = '<%=Password%>';
	var pwd = document.getElementById("oldMarkPassword1").value;
	if(oldPassword != pwd){
		alert("旧密码输入有误！");
		var markPassword2 = document.getElementById("oldMarkPassword1").focus(); 
		return false;
	}else{
		//验证确认密码
		var markPassword1 = document.getElementById("markPassword1").value;
		var markPassword2 = document.getElementById("markPassword2").value;
		if(markPassword1!=markPassword2){
			alert("两次密码输入不一致！");
			var markPassword2 = document.getElementById("markPassword2").focus(); 
			return false;
		}
		if(markPassword1 == markPassword2){
			return true;
		}
	}
}

function onShowResource(inputname,spanname){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			_displayTemplate:"#b{name}",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	 linkurl="javaScript:openhrm(";
   datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
  if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href="+linkurl+ids[i]+")  onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
}
</script>



</head>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("HandwrittenSignatureEdit:Delete", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='/mobile/plugin/1/HandwrittenSignatureList.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<FORM id=weaverSignature name=weaverSignature method=post enctype="multipart/form-data" action="UploadHandwrittenSignature.jsp">
<INPUT TYPE="hidden" name = "opera" id="opera">
<INPUT TYPE="hidden" name = "markId" value="<%=markId%>">
<INPUT TYPE="hidden" name = "markPath" value="<%=markPath%>">
<INPUT TYPE="hidden" name = "hrmresid" id="hrmresid" value="<%=hrmresid%>">

<table class=ViewForm>
  <colgroup>
  <col width="20%">
  <col width="80%">
  <tbody>
	    <TR class=Spacing><TD colspan=2 class=sep2></TD></TR>
	    <tr>
	    <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
	    <td class=field><button type="button" class=Browser type="button" onClick="onShowResource('hrmresid','hrmresspan')"></button><span id=hrmresspan>
	   
		<A href="javaScript:openhrm(<%=hrmresid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(""+hrmresid),user.getLanguage())%></A>
		 </span>
		</td>
	    </tr>
	    <!-- 电子签章名称 -->
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		    <tr>
			    <td><%=SystemEnv.getHtmlLabelName(30491,user.getLanguage())%></td>
			    <td class=field><INPUT TYPE="text" value="<%=markName%>"  class=InputStyle id="markName"  NAME="markName" value="" onChange='checkinput("markName","markNamespan1")'><span id=markNamespan1>
			   
			    <%
			    if (markName == null || "".equals(markName)) {
			    %>
			    <IMG src='/images/BacoError.gif' align=absMiddle>
			    <%} %>
			    
			    </span></td>
		    </tr>
		
		 <!-- 电子签章旧密码 -->
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		    <tr>
			    <td><%=SystemEnv.getHtmlLabelName(30498,user.getLanguage())%></td>
			    <td class=field><INPUT type="password" id="oldMarkPassword1" class=InputStyle NAME="oldMarkPassword1" 
				onChange='checkinput("oldMarkPassword1","oldMarkPassword1span")'><span id=oldMarkPassword1span><IMG src='/images/BacoError.gif' align=absMiddle></span></td>
		    </tr>
		 <!-- 电子签章新密码 -->
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		    <tr>
			    <td><%=SystemEnv.getHtmlLabelName(30499,user.getLanguage())%></td>
			    <td class=field><INPUT type="password" id="markPassword1" class=InputStyle NAME="markPassword1" 
				onChange='checkinput("markPassword1","markPassword1span")'><span id=markPassword1span><IMG src='/images/BacoError.gif' align=absMiddle></span></td>
		    </tr>
		<!-- 电子签章新确认密码 -->
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		    <tr>
			    <td><%=SystemEnv.getHtmlLabelName(30500,user.getLanguage())%></td>
			    <td class=field><INPUT type="password" id="markPassword2" class=InputStyle NAME="markPassword2" 
			    onChange='checkinput("markPassword2","markPassword2span")'><span id=markPassword2span><IMG src='/images/BacoError.gif' align=absMiddle></span></td>
		    </tr>
		<!-- 电子签章图片 -->
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		   <tr>
		    <td><%=SystemEnv.getHtmlLabelName(30497,user.getLanguage())%></td>
		    <td class=field><INPUT TYPE="file" NAME="markPic"  class=InputStyle  onChange="markImg.src=weaverSignature.markPic.value;markImg.style.display=''"><%=SystemEnv.getHtmlLabelName(23258,user.getLanguage()) %></td>
		   </tr>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		    <tr>
		    <td></td>
		    <td class=field><img id=markImg src="/HsImageDownload.do?markId=<%=markId%>&userid=<%=userid%>" ></img></td>
		    </tr>
		    
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
  </tbody>
</table>
</form>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</body>