
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MailConfigService" class="weaver.email.service.MailConfigService" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int msgLabelId = Util.getIntValue(request.getParameter("msgLabelId"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage());
String needfav ="1";
String needhelp ="";

String showTop = Util.null2String(request.getParameter("showTop"));

if(msgLabelId!=-1){
	titlename += " <span style='color:red;font-weight:bold'>" + SystemEnv.getHtmlLabelName(msgLabelId,user.getLanguage()) + "</span>";
}

rs.execute("SELECT id FROM MailAccount WHERE userId = "+user.getUID()+"  AND isDefault = 1");
String defaultId = null;
while(rs.next()){
	defaultId = rs.getString("id");
}

RecordSet rs2 = new RecordSet();
boolean isExist = false;
rs2.execute("select id from MailAccount where userid = " + user.getUID());
while(rs2.next()){
	isExist = true;
}

String email = "";
if(!isExist) {
	RecordSet rs3 = new RecordSet();
	rs3.execute("select email from HrmResource where id = " + user.getUID());
	while(rs3.next()){
		email = rs3.getString("email");
	}
}	

Map mailConfig=MailConfigService.getMailConfig();
int outterMail=Util.getIntValue(Util.null2String(mailConfig.get("outterMail")),0);

%>

<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
</head>

<script language="javascript">
 var defaultId = "<%=defaultId%>";
	
	jQuery(document).ready(function(){
		<%if(!isExist) {%>
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("82861",user.getLanguage()) %>",function(){
			addInfo('<%=email%>');
		});
		<% }%>
	});	


 function  formSubmit(){
    
     fMailAccount.submit();
 }
 
var dialog = null;
function closeDialog(){
	if(dialog){
		dialog.close();
		_table. reLoad();
	}
}
 
 function addInfo(param){    
    dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(typeof(param) == 'undefined')param = '';
	var url = "/email/MailAccountAdd.jsp?isFirst=1&mailaccountid="+param;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,23845,87",user.getLanguage()) %>";
	dialog.Width = 600;
	dialog.Height = 560;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
 }
 
 function editInfo(id){    
    dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/email/MailAccountEdit.jsp?id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,23845,87",user.getLanguage()) %>";
	dialog.Width = 600;
	dialog.Height = 560;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
 }


function deleteAccount(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(81509,user.getLanguage())%>",function(){
		jQuery.post("/email/MailAccountOperation.jsp",{"ids":id,"operation":"delete"},function(info){
			info = jQuery.trim(info);
			if("ruleuse" == info){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20245,user.getLanguage())%>");
				return;
			}
			_table. reLoad();
			
			try{
				window.parent.parent.mailUnreadUpdate();
			}catch(e){
					try{
						//说明是老版的模式查看
						window.parent.parent.document.getElementById("LeftMenuFrame").contentWindow.document.getElementById("ifrm2").contentWindow.mailUnreadUpdate();	
					}catch(e){
						//左右树形结构查看
						window.parent.parent.document.getElementById("mailFrameLeft").contentWindow.mailUnreadUpdate();
					}	
		
			}
		});
	});
}


function batchDelete(){
	var id = _xtable_CheckedCheckboxId();
   	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	deleteAccount(id);
	
}

var isClear = false;
function detectRadioStatus(obj){
	if(defaultId==obj.value && !isClear){
		isClear = true;
		jQuery("#isclear").val("1");	
		clearRadioSelected();
		
	}else{
		isClear = false;
		jQuery("#isclear").val("0");	
		defaultId =obj.value;
		
		changeRadioStatus(obj,true);
	}
	
}
function clearRadioSelected(){
	var radios =  document.getElementsByName("isDefault");;
	for(var i=0;i<radios.length;i++){
		changeRadioStatus(obj,false);
	}
}


</script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:formSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
if(outterMail==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addInfo(),_self} " ;    
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="formSubmit()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<%if(outterMail==1){%>
			<input class="e8_btn_top middle" onclick="addInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>"/>
			<%}%>
			<input class="e8_btn_top middle" onclick="batchDelete()" type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<%
int languageid = user.getLanguage();
String orderBy = "accountName";
String backFields = "id , accountName , accountmailaddress , serverType , isDefault ,sendStatus,receiveStatus";
String sqlFrom = "from MailAccount";
String sqlwhere = "userId = "+user.getUID();
String operateString= "<operates width=\"15%\">";
       operateString+=" <popedom transmethod=\"weaver.email.MailSettingTransMethod.getAccountOpratePopedom\"></popedom> ";
       operateString+="     <operate href=\"javascript:editInfo()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>";
   	   operateString+="     <operate href=\"javascript:deleteAccount()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>";
       operateString+="</operates>";
String tableString="<table  pageId=\""+PageIdConst.Email_account+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_account,user.getUID(),PageIdConst.EMAIL)+"\" tabletype=\"checkbox\">";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"ASC\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
       tableString+="<head>";
       tableString+="<col width=\"30%\"  target=\"_self\" text=\""+ SystemEnv.getHtmlLabelName(19804,user.getLanguage()) +"\" column=\"accountName\""+
       		 " otherpara=\"column:id\" transmethod=\"weaver.email.MailSettingTransMethod.getAccountInfo\" />";
       tableString+="<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(19805,user.getLanguage()) +"\" column=\"accountmailaddress\"/>";
       tableString+="<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(63,user.getLanguage()) +"\" column=\"serverType\""+
			 " transmethod=\"weaver.email.MailSettingTransMethod.getAccountServerType\" />";
	   tableString+="<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(602,user.getLanguage()) +"\" column=\"sendStatus\""+
			 " otherpara=\"column:receiveStatus+"+languageid+"\" transmethod=\"weaver.email.MailSettingTransMethod.getAccountStatus\" />";	 
       tableString+="<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(149,user.getLanguage()) +"\" column=\"isDefault\""+
       				" otherpara = \"column:id\" transmethod=\"weaver.email.MailSettingTransMethod.getAccountDefaultInfo\"/>";
       tableString+="</head>"+operateString;
       tableString+="</table>";
%>


<form id="fMailAccount" method="post" action="MailAccountOperation.jsp">
<input type="hidden" name="isclear" id="isclear" value="0">
<input type="hidden" name="operation" value="default" />
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Email_account%>">
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/> 
</form>
<div>
<span style="color: red;font-size: 14px;font-weight:bold;margin-left: 20px;"><%=SystemEnv.getHtmlLabelName(558,user.getLanguage()) %>：</span>
<ul>
	<li class="mail_hint_li" >* <%=SystemEnv.getHtmlLabelName(125584,user.getLanguage()) %></li>
	<li class="mail_hint_li" >* <%=SystemEnv.getHtmlLabelName(125586,user.getLanguage()) %></li>
</ul>
</div>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</body>
 <style>
.mail_hint_li{margin: 5px 2px 5px 10px;color:red}
</style>
