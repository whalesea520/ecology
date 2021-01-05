<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.moduledetach.ManageDetachComInfo"%> 
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/docs/iWebOfficeConf.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script>
var canDelete="<%=Util.null2String(request.getParameter("state"))%>";
if(canDelete=="nodelete")top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21799,user.getLanguage())%>");
var dialog = parent.parent.getDialog(parent); 
var parentWin = parent.parent.getParentWindow(parent);
</script>
</head>
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<%
if("false".equals(isIE)){	
	request.setAttribute("labelid","125483");
	request.getRequestDispatcher("/wui/common/page/sysRemind.jsp").forward(request,response);		
	return;
}
int messageid = Util.getIntValue(request.getParameter("messageid"),0);

//编辑：王金永 
String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl=temStr+mServerName;
String mClientUrl="/docs/docs/"+mClientName;

int id = Util.getIntValue(request.getParameter("id"),0);
int detachable = 0;
ManageDetachComInfo comInfo =  new ManageDetachComInfo();
boolean isUseHrmManageDetach=comInfo.isUseDocManageDetach();
if(isUseHrmManageDetach){
	detachable=1;
}

String isDialog = Util.null2String(request.getParameter("isdialog"));
String urlfrom = Util.null2String(request.getParameter("urlfrom"));
MouldManager.setId(id);
MouldManager.getMouldInfoById();
MouldManager.getMouldSubInfoById();
int subcompanyid1 = MouldManager.getSubcompanyid1();
int subcompanyid = subcompanyid1;
String mouldname=MouldManager.getMouldName();
String mouldtext=MouldManager.getMouldText();
int mouldType = MouldManager.getMouldType();
String docType=".doc";
if(mouldType==2){
    docType=".doc";
}else if(mouldType==3){
    docType=".xls";
}else if(mouldType==4){
    docType=".wps";
}else if(mouldType==5){
    docType=".et";
}else{
    docType=".doc";
}
session.setAttribute("DocMouldDspExt.jsp_",String.valueOf(subcompanyid1));

MouldManager.closeStatement();

boolean canNotDelete = false;
RecordSet.executeSql("select t1.* from DocSecCategoryMould t1 where t1.mouldId = "+id+" and mouldType in(2,4,6,8)");
if(RecordSet.getCounts()>0){
    canNotDelete = true;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if(urlfrom.equals("hr")){
  titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(64,user.getLanguage());
}else{
  titlename = SystemEnv.getHtmlLabelName(16449,user.getLanguage())+"："+mouldname;
}
String needfav ="1";
String needhelp ="";

%>

<script>
function StatusMsg(mString){
  StatusBar.innerText=mString;
}

function WebSaveLocal(){
  try{
    weaver.WebOffice.WebSaveLocal();
    StatusMsg(weaver.WebOffice.Status);
  }catch(e){}
}

function WebOpenLocal(){
  try{
    weaver.WebOffice.WebOpenLocal();
    StatusMsg(weaver.WebOffice.Status);
  }catch(e){
  }
}

function Load(){
  //weaver.WebOffice.WebUrl="<%=mServerUrl%>"
  try{
  weaver.WebOffice.WebUrl="<%=mServerUrl%>";
  weaver.WebOffice.RecordID="<%=id%>";
  weaver.WebOffice.Template="";
  weaver.WebOffice.FileName="";
  weaver.WebOffice.FileType="<%=docType%>";
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 鐗规湁鍐呭寮€濮?
  weaver.WebOffice.EditType="0,0";
  weaver.WebOffice.ShowToolBar="0";      //ShowToolBar:鏄惁鏄剧ず宸ュ叿鏍?1鏄剧ず,0涓嶆樉绀?
//iWebOffice2006 鐗规湁鍐呭缁撴潫
<%}else{%>
  weaver.WebOffice.EditType="0";
<%}%>
  weaver.WebOffice.UserName="<%=user.getUsername()%>";
<%if(user.getLanguage()==7){%>
  weaver.WebOffice.Language="CH";
<%}else if(user.getLanguage()==9){%>
  weaver.WebOffice.Language="TW";
<%}else{%>
  weaver.WebOffice.Language="EN";
<%}%>
  weaver.WebOffice.WebOpen();  	//鎵撳紑璇ユ枃妗?
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 鐗规湁鍐呭寮€濮?
  weaver.WebOffice.ShowType="1";  //鏂囨。鏄剧ず鏂瑰紡  1:琛ㄧず鏂囧瓧鎵规敞  2:琛ㄧず鎵嬪啓鎵规敞  0:琛ㄧず鏂囨。鏍哥
//iWebOffice2006 鐗规湁鍐呭缁撴潫
<%}%>
  StatusMsg(weaver.WebOffice.Status);

  }catch(e){}
}


function UnLoad(){
  try{
  if (!weaver.WebOffice.WebClose()){
     StatusMsg(weaver.WebOffice.Status);
  }else{
     StatusMsg("<%=SystemEnv.getHtmlLabelName(19716,user.getLanguage())%>...");
  }
  }catch(e){}
}
</script>


<BODY onLoad="Load()" onUnload="UnLoad()">
<%if("2".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%if(messageid!=0){%>
<font color=red><%=SystemEnv.getErrorMsgName(messageid,user.getLanguage())%></font>
<%}%>
<FORM id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<input type=hidden name=urlfrom value="<%=urlfrom%>">
<%if(!isDialog.equals("2")){ %>
<DIV>
<%
if(HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)){
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='DocMouldEdit.jsp?id="+id+"&urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMouldEdit:add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='DocMouldAdd.jsp?urlfrom="+urlfrom+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}if(HrmUserVarify.checkUserRight("DocMouldEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}if(HrmUserVarify.checkUserRight("DocMould:log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?secid=63&sqlwhere="+xssUtil.put("where operateitem=75 and relatedid="+id)+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/mouldfile/DocMould.jsp?urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
</DIV>
<%} %>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
		<wea:item>
		<%=id%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
		<wea:item>
		<%=mouldname%>
		</wea:item>
		
		<%if(detachable==1){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
		<wea:item>
		<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid))%>
		</wea:item>
		<%}%>
	
		<wea:item attributes="{'colspan':'full','samePair':'imgfield','display':'none'}">
			<div></div>
		</wea:item>
		<wea:item attributes="{'colspan':'full'}">
			<%=SystemEnv.getHtmlLabelName(18693,user.getLanguage())%>
		</wea:item>
		<wea:item>
<iframe id="e8shadowifrm" name="e8shadowifrm" frameborder="none" scrolling="no" style="overflow:hidden;z-index:1;width:100%;height:23px;position:absolute;top:37px;visibility:hidden;left:0px;background-color:#fff;" src="javascript:return false;"></iframe>
<div style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;position:relative;">
    <OBJECT  id="WebOffice" style="POSITION: relative;top:-23px" width="100%"  height="680"  value="" classid="<%=mClassId%>" codebase="<%=mClientUrl%>" >
    </OBJECT>
    <span id=StatusBar>&nbsp;</span>
		</wea:item>
	</wea:group>
</wea:layout>
    

<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=mouldname value="<%=mouldname%>">
<textarea id="mouldtext" name=mouldtext style="display:none;width:100%;height=500px">##<%=mouldtext%></textarea>
</FORM>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("2".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>	
</body>

<script>
try{
	parent.setTabObjName("<%= mouldname %>");
}catch(e){}
function onDelete(){

	if(<%=canNotDelete%>){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23134,user.getLanguage())%>");
		return;
	}

	top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		document.weaver.operation.value='delete';
		document.weaver.submit();
	});
}
</script>

