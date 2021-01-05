
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>


<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
</head>
<%
int userid=user.getUID();   
if(!HrmUserVarify.checkUserRight("searchIndex:manager", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String dialog=Util.null2String(request.getParameter("dialog")); 


int id=Util.getIntValue(request.getParameter("id"));
String title=Util.null2String(request.getParameter("title"));
String keywords=Util.null2String(request.getParameter("keywords"));
String showDiv=Util.null2String(request.getParameter("showDiv"));
String url=Util.null2String(request.getParameter("url"));
String iframeUrl =Util.null2String(request.getParameter("iframeUrl"));
int width =Math.abs(Util.getIntValue(request.getParameter("width"),0));
int height =Math.abs(Util.getIntValue(request.getParameter("height"),0));
String op="";
String operate = Util.null2String(request.getParameter("operate"));

if("save".equals(operate)){//修改和新建的保存
	if(id==0){//修改
		RecordSet.executeSql("INSERT into FullSearch_Robot(title,keywords,url,createdate,iframeUrl,width,height,showDiv,state)"+
			"VALUES('"+title+"','"+keywords+"','"+url+"','2015-04-01','"+iframeUrl+"',"+width+","+height+",'"+showDiv+"',0)");
	}else{//新增
		RecordSet.executeSql("update FullSearch_Robot set title='"+title+"',keywords='"+keywords+"',url='"+url+"',iframeUrl='"+iframeUrl+"',width="+width+",height="+height+",showDiv='"+showDiv+"' "+
				" where id="+id);
	}
	op="success";
}else{//进入编辑页面
	if(id>0){
		String datasql="select * from  FullSearch_Robot where id='"+id+"'";
		RecordSet.executeSql(datasql);
		if(RecordSet.next()){
			title=RecordSet.getString("title");
			keywords=RecordSet.getString("keywords");
			showDiv=RecordSet.getString("showDiv");
			url=RecordSet.getString("url");
			iframeUrl =RecordSet.getString("iframeUrl");
			width=Util.getIntValue(RecordSet.getString("width"),0);
			height=Util.getIntValue(RecordSet.getString("height"),0);
		}
	}
}
 
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31953,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id=weaverA name=weaverA method=post action="RobotEdit.jsp">
<input type="hidden" name="operate" value="save">
<input type="hidden" name="id" value="<%=id %>">
<input type="hidden" value="<%=dialog%>" name="dialog" id="dialog" />
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td>
					</td>
					<td class="rightSearchSpan" style="text-align:right; ">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSubmit()"/>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
					</td>
				</tr>
			</table>
			<div class="zDialog_div_content" style="overflow:auto;">
			 <wea:layout type="2col">
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}" >
				      <wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
				      <wea:item>
				         <input type="text" id="title" name="title" value="<%=title%>" class="InputStyle" onchange='checkinput("title","titleimage")'>
				         <SPAN id="titleimage">
				         	<%if("".equals(title)){%>
			              	<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
			              	<%
			              	} %>
				         </SPAN>
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(2095,user.getLanguage())%></wea:item>
				      <wea:item>
				      	<textarea rows="5" style="width:80%" id="keywords" name="keywords" value="<%=keywords%>"title="<%=SystemEnv.getHtmlLabelName(83422,user.getLanguage())%>"  onchange='checkinput("keywords","keywordsimage")'><%=keywords %></textarea> 
				      	<SPAN id="keywordsimage">
				      		<%if("".equals(title)){%>
			              	<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
			              	<%
			              	} %>
				      	</SPAN>
				     </wea:item>
				     
				     <wea:item><%=SystemEnv.getHtmlLabelName(21653,user.getLanguage())%></wea:item>
				      <wea:item>
				      	 <select id="showDiv"  name="showDiv" style="width:80px;" onchange="changeShowDiv()">
							<option value=0 <%if(showDiv.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19494,user.getLanguage())%></option>
							<option value=1 <%if(showDiv.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(82833,user.getLanguage())%></option>
						 </select>
				     </wea:item>
				     
				     <wea:item attributes="{'samePair':'showDiv0'}"><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></wea:item>
				      <wea:item attributes="{'samePair':'showDiv0'}">
				      	<input type="text" id="url" name="url" value="<%=url%>" class="InputStyle" onchange='checkinput("url","urlimage")'>
				      	<SPAN id="urlimage">
				      		<%if("".equals(title)){%>
			              	<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
			              	<%
			              	} %>
				      	</SPAN>
				     </wea:item>
				     
				     <wea:item attributes="{'samePair':'showDiv1'}"><%=SystemEnv.getHtmlLabelName(32309,user.getLanguage())%></wea:item>
				      <wea:item attributes="{'samePair':'showDiv1'}">
				      	<input type="text" id="iframeUrl" name="iframeUrl" value="<%=iframeUrl%>" class="InputStyle" onchange='checkinput("iframeUrl","iframeUrlimage")'>
				      	<SPAN id="iframeUrlimage">
				      		<%if("".equals(iframeUrl)){%>
			              	<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
			              	<%
			              	} %>
				      	</SPAN>
				     </wea:item>
				     
				     <wea:item attributes="{'samePair':'showDiv1'}"><%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%></wea:item>
				      <wea:item attributes="{'samePair':'showDiv1'}">
				      	<input type="text" id="width" name="width" value="<%=width%>" class="InputStyle" style="width:80px;" onchange='checkinput("width","widthimage")'>
				      	<SPAN id="widthimage">
				      		<%if("".equals(width)){%>
			              	<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
			              	<%
			              	} %>
				      	</SPAN>
				     </wea:item>
				     
				     <wea:item attributes="{'samePair':'showDiv1'}"><%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%></wea:item>
				      <wea:item attributes="{'samePair':'showDiv1'}">
				      	<input type="text" id="height" name="height" value="<%=height%>" class="InputStyle" style="width:80px;" onchange='checknumber("height");checkinput("height","heightimage")'>
				      	<SPAN id="heightimage">
				      		<%if("".equals("height")){%>
			              	<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
			              	<%} %>
				      	</SPAN>
				     </wea:item> 
				      
				      
			     </wea:group>
			</wea:layout>	
			</div>
		 
		 
			<div id="zDialog_div_bottom" class="zDialog_div_bottom">
				<wea:layout type="2col">
					<!-- 操作 -->
				     <wea:group context="">
				    	<wea:item type="toolbar">
						  <input type="button"
							value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
							id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
					    </wea:item>
				    </wea:group>
			    </wea:layout>
			</div>
			 
			</td>
		</tr>
		</TABLE>
	</td>
</tr>
</table>
</form>
</body>
<script language="javascript">
var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
dialog = parent.parent.getDialog(parent);
}catch(e){}

var op="<%=op%>";
$(document).ready(function() {
	changeShowDiv();
	resizeDialog(document);
	if(op!=''){
		if(op=="success"){
			parentWin.closeDlgARfsh();
		}else{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31825,user.getLanguage())%>") ;
		}
	}
}); 

function btn_cancle(){
	dialog.close();
}

function changeShowDiv(){
	if($('#showDiv').val()=="0"){
		hideEle('showDiv1');
		showEle('showDiv0');
	}else{
		hideEle('showDiv0');
		showEle('showDiv1');
	}
}

function doSubmit()
{
	if (onCheckForm()){
		document.forms[0].submit();
    }
}

function onCheckForm()
{
	var ck="title,keywords";
	if($('#showDiv').val()=="0"){
		ck+=",url";
	}else{
		ck+=",iframeUrl,width,height";
	} 
	if(!check_form(weaverA,ck)){
		return false;
	}
	return true;
}

function preDo(){
	$("#topTitle").topMenuTitle({});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	jQuery("#hoverBtnSpan").hoverBtn();
};
</script>

</html>
