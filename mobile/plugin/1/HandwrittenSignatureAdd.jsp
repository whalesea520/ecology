<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*"%>

<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("SignatureAdd:Add", user)){
    response.sendRedirect("/notice/noright.jsp");
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "<b>"+SystemEnv.getHtmlLabelName(30493,user.getLanguage())+"</b>";
String needfav = "1";
String needhelp = "1";

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<SCRIPT language="javascript">

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

function verifyPassword(){
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

//保存手写签章信息
function onSave(){
	    if(check_form(document.weaverSignature,"markName,hrmresid,markPassword1,markPassword2,markPic")){
	    	if(verifyPassword()){
	    		if(ValidateImgFormat()){
			        weaverSignature.opera.value="add";
		       		weaverSignature.submit();
	    		}
	    	}
	    }
}
</script>
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

//modiby dongping for td1228 start
//签章设置中，如果先进行搜索，然后再点击新建签章，再选择返回的话，则会出现网页过期错误页面。
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='/mobile/plugin/1/HandwrittenSignatureList.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//end
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


<FORM id="weaverSignature" name="weaverSignature" method=post enctype="multipart/form-data" action="UploadHandwrittenSignature.jsp">
<INPUT TYPE="hidden" name = "opera" id="opera">
<INPUT TYPE="hidden" name = "markId" value="">
<INPUT TYPE="hidden" name = "hrmresid" id="hrmresid" value="" onChange='checkinput("hrmresid","hrmresspan")'>

<table class=ViewForm>
  <colgroup>
  <col width="20%">
  <col width="80%">
  <tbody>
  
<!-- 电子签章用户id -->
<TR style="height: 1px!important;"><TD class=Line1 colSpan=2></TD></TR>
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
    <td class=field><button type="button" class=Browser type="button" onClick="onShowResource('hrmresid','hrmresspan')" ></button><span id=hrmresspan style="padding-top:5px"><IMG src='/images/BacoError.gif' align=absMiddle></span></td>
    </tr>

<!-- 电子签章名称 -->
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(30491,user.getLanguage())%></td>
    <td class=field><INPUT TYPE="text" class=InputStyle id="markName"  NAME="markName" value="" onChange='checkinput("markName","markNamespan")'><span id=markNamespan><IMG src='/images/BacoError.gif' align=absMiddle></span></td>
    </tr>

<!-- 电子签章密码 -->
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
    <tr>
	    <td><%=SystemEnv.getHtmlLabelName(30492,user.getLanguage())%></td>
	    <td class=field><INPUT type="password" id="markPassword1" class=InputStyle NAME="markPassword1" 
		onChange='checkinput("markPassword1","markPassword1span")'><span id=markPassword1span><IMG src='/images/BacoError.gif' align=absMiddle></span></td>
    </tr>
<!-- 电子签章确认密码 -->
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
    <tr>
	    <td><%=SystemEnv.getHtmlLabelName(30496,user.getLanguage())%></td>
	    <td class=field><INPUT type="password" id="markPassword2" class=InputStyle NAME="markPassword2" 
	    onChange='checkinput("markPassword2","markPassword2span")'><span id=markPassword2span><IMG src='/images/BacoError.gif' align=absMiddle></span></td>
    </tr>
    
<!-- 电子签章图片 -->
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(30497,user.getLanguage())%></td>
    <td class=field><INPUT TYPE="file" id="markPic" NAME="markPic"  class=InputStyle><%=SystemEnv.getHtmlLabelName(23258,user.getLanguage())%></td>
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