
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="js/wechat_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
String operate=Util.null2String(request.getParameter("operate"));
String id = Util.null2String(request.getParameter("id"));

String name = "";
String publicid="";

String autoReply=Util.null2String(request.getParameter("autoReply"));
String welcomeMsg=Util.null2String(request.getParameter("welcomeMsg"));
String suffix=Util.null2String(request.getParameter("suffix"));
String template=Util.null2String(request.getParameter("template"));
if("save".equals(operate)){
	String datasql="update wechat_platform set suffix='"+suffix+"',autoReply='"+autoReply+"',welcomeMsg='"+welcomeMsg+"',templateId='"+template+"' where id='"+id+"'";
	rs.executeSql(datasql);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(id),"个性化设置","公众平台个性化设置","214","2",0,Util.getIpAddr(request));
}else if("del".equals(operate)){
	String IDS=Util.null2String(request.getParameter("IDS"));//当前节点id
	if(IDS!=null&&!"".equals(IDS)){
		rs.executeSql("delete wechat_reply_rule where replyid in("+IDS+")");
		rs.executeSql("delete wechat_reply where id in ("+IDS+")");
	}
}else{

}

//页面内容
String datasql="select * from  wechat_platform where id='"+id+"'";
rs.executeSql(datasql);
if(rs.next()){
	name=rs.getString("name");
	suffix=rs.getString("suffix");
	autoReply=rs.getString("autoReply");
	welcomeMsg=rs.getString("welcomeMsg");
	publicid=rs.getString("publicid");
	template=rs.getString("templateId");
}


//查询规则

String perpage=PageIdConst.getPageSize(PageIdConst.Wechat_ReplyList,user.getUID());

String sqlwhere=" where publicid='"+publicid+"'";
String backFields = " t1.*,tt.keyword ";
String sqlFrom = " wechat_reply t1 left JOIN (SELECT replyid,STUFF((SELECT  keyword+' ' FROM wechat_reply_rule t3 WHERE t3.replyid = t2.replyid FOR XML PATH('')),1, 0, '') AS keyword FROM wechat_reply_rule t2 GROUP BY replyid) tt on t1.id=tt.replyid";
if(rs.getDBType().equals("oracle")){
	sqlFrom = " wechat_reply t1 left JOIN (SELECT replyid, WMSYS.WM_CONCAT(keyword) AS keyword  FROM wechat_reply_rule GROUP BY replyid) tt on t1.id=tt.replyid";
}
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"platformSetupTable\" tabletype=\"checkbox\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\"sort\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(19829,user.getLanguage())+"\" column=\"name\" />"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(117,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"replytype\"  transmethod=\"weaver.wechat.WechatTransMethod.getPersonalType\" otherpara=\""+user.getLanguage()+"\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(2093,user.getLanguage())+"\"  column=\"sort\"/>"+
					  "<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\"  column=\"state\" transmethod=\"weaver.wechat.WechatTransMethod.getPersonalState\" otherpara=\""+user.getLanguage()+"\"/>"+//状态
					  "<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(24290,user.getLanguage())+"\"  column=\"keyword\" />"+
			  "</head>";
 tableString +=  "<operates>"+
                "		<popedom column=\"id\" otherpara=\"column:state\" transmethod=\"weaver.wechat.WechatTransMethod.getPersonalOpt\"></popedom> "+
				"		<operate href=\"javascript:qiyong();\" text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:jinyong();\" text=\""+SystemEnv.getHtmlLabelName(18096,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		<operate href=\"javascript:editReply();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
				"		<operate href=\"javascript:delReply();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"3\"/>"+
				"		<operate href=\"javascript:setRule();\" text=\""+SystemEnv.getHtmlLabelName(24290,user.getLanguage())+"\" target=\"_self\" index=\"3\"/>"+
				"</operates>";
tableString += "</table>";
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32639,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow: hidden;">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

 
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<form name=frmmain method=post action="platformSetup.jsp">
<input type="hidden" name="operate">
<input type="hidden" name="IDS">
<input type="hidden" name="id" value="<%=id %>">
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			 <div class="zDialog_div_content" style="overflow-y:auto;overflow-x:hidden;">
				<wea:layout type="2col">
				     <wea:group context='<%=name%>'>
					      <wea:item><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%>ID</wea:item>
					      <wea:item>
					      	  <input class="InputStyle" type="text" id="template" name="template" value="<%=template%>" >
					       	  <SPAN>
				              		<a href='/wechat/images/template_wev8.png' target='_blank'><IMG src="images/remind_wev8.png" align=absMiddle ></a>
				              </SPAN>
					      </wea:item>
					      
					      <wea:item><%=SystemEnv.getHtmlLabelName(584,user.getLanguage())+SystemEnv.getHtmlLabelName(20148,user.getLanguage())%></wea:item>
					      <wea:item>
					         <input type="text" name="suffix" value="<%=suffix%>" class="InputStyle">
					      </wea:item>
					      
					      <wea:item><%=SystemEnv.getHtmlLabelName(32161,user.getLanguage())%></wea:item>
					      <wea:item>
					         <select id="autoReply" name="autoReply" onchange="changeAutoReply()">
				              		<option value=0 <%="0".equals(autoReply)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>
				              		<option value=1 <%="1".equals(autoReply)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
				              </select>
					      </wea:item>
					      
					      <wea:item attributes="{'samePair':'showautoreply'}"><%=SystemEnv.getHtmlLabelName(32876,user.getLanguage())%></wea:item>
					      <wea:item attributes="{'samePair':'showautoreply'}">
					         <textarea rows="5" style="width:80%" id="welcomeMsg" name="welcomeMsg" value="<%=welcomeMsg%>" ><%=welcomeMsg %></textarea> 
					      </wea:item>
				     </wea:group>
				     
				     <wea:group context="" attributes="{'groupDisplay':'none'}">
				     	<wea:item attributes="{'isTableList':'true','samePair':'showautoreply'}">
					      	<wea:layout type="2col">
						      <wea:group context='<%=SystemEnv.getHtmlLabelName(24290,user.getLanguage())+SystemEnv.getHtmlLabelName(32161,user.getLanguage())+SystemEnv.getHtmlLabelName(579,user.getLanguage()) %>' attributes="{'class':'e8_title_2'}">
							      <wea:item type="groupHead">
							         <input Class=addbtn type=button onclick="doAdd()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
									 <input Class=delbtn type=button onclick="doDel()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
							      </wea:item>
							      
							      <wea:item attributes="{'isTableList':'true'}">
							      		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Wechat_ReplyList%>"/>
										<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
								 </wea:item>
						     </wea:group>
						    </wea:layout>	
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
var publicid="<%=publicid %>";

var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
}catch(e){}

function btn_cancle(){
	parentWin.closeDialog();
}
 
var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function refreshTable(){
	_table.reLoad();
}

function closeDlgARfsh(){
	diag_vote.close();
	_table.reLoad();
}
 
$(document).ready(function() {
	changeAutoReply();
	resizeDialog(document);
});

function changeAutoReply(){
	if($('#autoReply').val()==0){
		hideEle('showautoreply');
	}else{
		showEle('showautoreply');
	}
}


function doBack(){
    
}

function doSubmit()
{
	jQuery("input[name=operate]").val("save");
	document.forms[0].submit();
}


function doAdd(){
	var param="id=&publicid="+publicid;
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(32161,user.getLanguage())%>";
	diag_vote.URL = "/wechat/replySetTab.jsp?"+param;
	diag_vote.show();
}

function doDel(){
	var deleteids = _xtable_CheckedCheckboxId();
	if(deleteids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}else{
	    var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   		window.top.Dialog.confirm(str,function(){
	        $.post("replyOperate.jsp", 
			{"operate":"del", "IDS": deleteids.substr(0,deleteids.length-1)},
		   	function(data){
				var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				 if(data=="true"){
				 	 _table.reLoad();
				 }else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
				 }
	   		});
	    });
    }
}

function delReply(id){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   		window.top.Dialog.confirm(str,function(){
	        $.post("replyOperate.jsp", 
			{"operate":"del", "IDS": id},
		   	function(data){
				var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				 if(data=="true"){
				 	 _table.reLoad();
				 }else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
				 }
	   		});
	    });
}

function editReply(id){
	var param="id="+id+"&publicid="+publicid;
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(32161,user.getLanguage())%>";
	diag_vote.URL = "/wechat/replySetTab.jsp?"+param;
	diag_vote.show();
}
function qiyong(id){
	setState(id,0);
}

function jinyong(id){
	setState(id,1);
}

function setState(id,state){
	if(state==1){
	   	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32690,user.getLanguage())%>",function(){//确定要禁用么
		     $.post("replyOperate.jsp", 
			{"operate":"state", "id": id,"state":state},
		   	function(data){
				var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				 if(data=="true"){
				 	 _table.reLoad();
				 }else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
				 }
	   		});
	     });
	}else{
			 $.post("replyOperate.jsp", 
			 {"operate":"state", "id": id,"state":state},
		   	function(data){
				var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				 if(data=="true"){
				 	 _table.reLoad();
				 }else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
				 }
	   		});
	}
}

function setRule(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(24290,user.getLanguage())%>";
	diag_vote.URL = "/wechat/replyRuleSetTab.jsp?id="+id;
	diag_vote.show();
	 
}

//reLoad()
</script>

</html>
