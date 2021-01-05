<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("Meeting:WFSetting", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}
	
String id = Util.null2String(request.getParameter("id"));
String method=Util.null2String(request.getParameter("method"));
if("".equals(id)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
//取得formid
String getFormIdSql = "select formid from workflow_base where id = "+id;
RecordSet.execute(getFormIdSql);
RecordSet.next();
String formid = RecordSet.getString("formid");
String op="";
//判断有节点是非普通模式下的时候弹出框信息不同
boolean templateFlg = true;
String nodeId = "";
String nodeName = "";
String nodeType = "";
//周期会议/普通会议按钮是否显示
boolean showButton = true;
int ismode = -1;
Map<String,String> resultMap = new LinkedHashMap<String,String>();
StringBuffer testNodesSb=new StringBuffer();
testNodesSb.append(" select a.nodeId,b.nodeName,a.nodeType,a.ismode ")
			.append(" from  workflow_flownode a,workflow_nodebase b")
			.append(" where a.workflowId=").append(id)
			.append(" and a.nodeid=b.id")
			//添加本条件, 限制查询条件不包括自由流转中的节点
			.append(" and (b.isFreeNode != '1' OR b.isFreeNode IS null)")
			.append(" order by a.nodeorder,b.nodeName")
			;
RecordSet.execute(testNodesSb.toString());
while(RecordSet.next()){
	nodeId = RecordSet.getString("nodeid");
	nodeName= RecordSet.getString("nodeName");
	nodeType = RecordSet.getString("nodeType");
	ismode = Util.getIntValue(RecordSet.getString("ismode"),0);
	
	//针对E7升级E8的时候表workflow_nodeform没有重复字段数据,进行下面的操作
	String sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,detailtable,dsporder ";
	RecordSet1.execute(sql);
	while(RecordSet1.next()){
		RecordSet2.execute("select count(*) from workflow_nodeform where nodeid= " +nodeId + " and fieldid="+RecordSet1.getInt("id"));
		RecordSet2.next();
		
		if(RecordSet2.getInt(1) <= 0){
			RecordSet3.execute("insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory,orderid) values("+nodeId+","+RecordSet1.getInt("id")+",'"+0+"','"+0+"','"+0+"','"+0.00+"')");
		}
	}
	
	//当显示模式为1:普通模式的情况
	if(ismode == 0){
		if(!"".equals(method)){
			RecordSet1.execute("select a.fieldid, a.isview, a.isedit, b.fieldname from workflow_nodeform a ,workflow_billfield b where a.fieldid= b.id and b.fieldname in ('repeatdays','rptWeekDays','repeatmonthdays','repeatType','repeatweeks','repeatmonths','repeatStrategy') and a.nodeid = "+nodeId);
			while(RecordSet1.next()){
				if("repeat".equals(method)){
					//第一节点(创建节点)设置为可编辑不是必须输入
					if("0".equals(nodeType)){
						RecordSet2.execute("update workflow_nodeform set isview = '1', isedit = '1', ismandatory = '0' where fieldid ="+RecordSet1.getString("fieldid") +" and nodeid = "+nodeId);
					}else{
						//其他节点都设置为显示模式
						RecordSet2.execute("update workflow_nodeform set isview = '1', isedit = '0', ismandatory = '0' where fieldid ="+RecordSet1.getString("fieldid") +" and nodeid = "+nodeId);
					}
					op = "repeat";
				}else if("normal".equals(method)){
					RecordSet2.execute("update workflow_nodeform set isview = '0', isedit = '0', ismandatory = '0' where fieldid ="+RecordSet1.getString("fieldid") +" and nodeid = "+nodeId);
					op = "normal";
				}
			}
		}
		
		//对节点进行重复会议/普通会议进行判断,true:重复会议,false:普通会议
		RecordSet1.execute("select a.fieldid, a.isview, a.isedit, b.fieldname from workflow_nodeform a ,workflow_billfield b where a.fieldid= b.id and a.nodeid = "+nodeId);
		while(RecordSet1.next()){
			if("repeatStrategy".equalsIgnoreCase(RecordSet1.getString("fieldname")) ){
				if( "1".equals(RecordSet1.getString("isview"))){
					resultMap.put(nodeName,"repeat");
				}else{
					resultMap.put(nodeName,"normal");
				}
			}
		}
		//当显示模式为2:模板模式的情况
	}else if(ismode == 1){
		resultMap.put(nodeName,"isNormalTemplate");
		templateFlg = false;
		//当显示模式为3:HTML模式的情况
	}else if(ismode == 2){
		resultMap.put(nodeName,"isHtmlTemplate");
		templateFlg = false;
	}
}
	
if(resultMap.size() < 1){
	resultMap.put("error","noNode");
	showButton = false;
}
Iterator<String> it=resultMap.keySet().iterator();
String value="";

 
	 
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<LINK href="/js/ecology8/meeting/meetingbase_wev8.css" type=text/css rel=STYLESHEET>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css"
			type="text/css" />
		<link rel="stylesheet"
			href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"
			type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(22011, user.getLanguage());
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY style="overflow: hidden;">
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		if(showButton){
			RCMenu += "{" + SystemEnv.getHtmlLabelNames("33277", user.getLanguage())+ ",javascript:changeMeeting(0),_self} ";
			RCMenu += "{" + SystemEnv.getHtmlLabelNames("2086,34076", user.getLanguage())+ ",javascript:changeMeeting(1),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		}
		
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="meeting"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("33417,22011",user.getLanguage()) %>'/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan"
					style="text-align: right; width: 300px !important">
					<%if(showButton){ %>
					<input type="button" value='<%=SystemEnv.getHtmlLabelNames("33277", user.getLanguage())%>' class="e8_btn_top" onclick="changeMeeting(0)"/>
					<input type="button" value='<%=SystemEnv.getHtmlLabelNames("2086,34076", user.getLanguage())%>' class="e8_btn_top" onclick="changeMeeting(1)"/>
					<%} %>
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"  class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv">
			<span style="width:10px"></span>
			<span id="hoverBtnSpan" class="hoverBtnSpan">  
			</span>
		</div>
		<div class="zDialog_div_content" id="editDiv" name="editDiv">
			<FORM id=weaverA name=weaverA action="/meeting/defined/wfTestBillid.jsp" method=post>
				<input type="hidden" value="<%=id%>" name="id">
				<input type="hidden" value="" name="method" id = "method">
				
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelNames("82876", user.getLanguage())%>' >
						
						<!-- 服务项目名称 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(82876, user.getLanguage())%></wea:item>
						<wea:item>
							<div>
								<%while(it.hasNext()){
									String key=it.next();
									value = resultMap.get(key);
									if("repeat".equals(value)){
										%>
										<%=key%><%=SystemEnv.getHtmlLabelName(33417, user.getLanguage())%> : <%=SystemEnv.getHtmlLabelName(33277, user.getLanguage())%></br> 
										<%
									}else if("normal".equals(value)){
										%>
										<%=key%><%=SystemEnv.getHtmlLabelName(33417, user.getLanguage())%> : <%=SystemEnv.getHtmlLabelNames("2086,34076", user.getLanguage())%></br>
										<%
									}else if("noContent".equals(value)){
										%>
										<%=key%><%=SystemEnv.getHtmlLabelName(33417, user.getLanguage())%> : <font style="color:red"><%=SystemEnv.getHtmlLabelNames("15808,33473", user.getLanguage())%></font></br>
										<%
									}else if("noNode".equals(value)){
										%>
										<font style="color:red"><%=SystemEnv.getHtmlLabelNames("15808,33417", user.getLanguage())%></font></br>
										<%
									}else if("isNormalTemplate".equals(value)){
										%>
										<font style="color:red"><%=key%><%=SystemEnv.getHtmlLabelName(33417, user.getLanguage())%> : <%=SystemEnv.getHtmlLabelNames("130875", user.getLanguage())%></font></br>
										<%
									}else if("isHtmlTemplate".equals(value)){
										%>
										<font style="color:red"><%=key%><%=SystemEnv.getHtmlLabelName(33417, user.getLanguage())%> : <%=SystemEnv.getHtmlLabelNames("130876", user.getLanguage())%></font></br>
										<%
									}
								%>
								<%} %>
							</div>
						</wea:item>
					</wea:group>
				</wea:layout>
				<div style="line-height:18px;padding:5px">
					<%=SystemEnv.getHtmlLabelName(130083, user.getLanguage())%>
				</div>
			</FORM>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2col">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
							id="zd_btn_cancle" class="zd_btn_cancle" onclick="closeDialog()">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
	</body>
</html>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">
var parentWin;
try{
parentWin = parent.getParentWindow(window);
}catch(e){}

function preDo(){
	$("#topTitle").topMenuTitle({});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	jQuery("#hoverBtnSpan").hoverBtn();
};

function changeMeeting(idx){
	if(idx == 0){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(130878,user.getLanguage())%>", function (){
			document.getElementById("method").value = "repeat";
			$('#weaverA').submit();	
		});
	}else if(idx == 1){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(130877,user.getLanguage())%>", function (){
			document.getElementById("method").value = "normal";
			$('#weaverA').submit();	
		});
	}
}

function closeDialog(){
	parentWin.closeDialog();
}

//关闭页面并刷新列表
function closeDlgARfsh(){
	parentWin.closeDlgARfsh();
}
 
jQuery(document).ready(function(){
	resizeDialog();
	if("repeat"=="<%=op%>" && <%=templateFlg%>){
	 	Dialog.alert('<%=SystemEnv.getHtmlLabelNames("33277,16746", user.getLanguage())%>');
	}else if("normal"=="<%=op%>" && <%=templateFlg%>){
		Dialog.alert('<%=SystemEnv.getHtmlLabelNames("2086,34076,16746", user.getLanguage())%>');
	}else if("normal"=="<%=op%>" && !<%=templateFlg%>){
		Dialog.alert('<%=SystemEnv.getHtmlLabelNames("18016,2086,34076,16746", user.getLanguage())%>');
	}else if("repeat"=="<%=op%>" && !<%=templateFlg%>){
		Dialog.alert('<%=SystemEnv.getHtmlLabelNames("18016,33277,16746", user.getLanguage())%>');
	}
});

</script>
