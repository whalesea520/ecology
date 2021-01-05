
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<link type="text/css" href="/js/tabs/css/e8tabs_wev8.css" rel="stylesheet" />
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
		<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<style>
		  .titlecss{
			font-weight: bold;
		  }
		  .ui-widget-header {
			background: #85D08D;
		  }
		</style>
	</head>
	<%
		if (!HrmUserVarify.checkUserRight("eAssistant:fixedInst", user)) {
	        response.sendRedirect("/notice/noright.jsp");
	        return;
	    }
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(32838, user.getLanguage());
		String needfav = "1";
		String needhelp = "";
		//check 方式
		Map<String,String> checkedMap=new HashMap<String,String>();
		checkedMap.put("ALLOWSUBMITFAQ","0");
		checkedMap.put("ALLOWAUTOSUBMITFAQ","0");
		checkedMap.put("recordInstruction","0");
		checkedMap.put("EnableWorkbench","0");
		// input 方式
		Map<String,String> inputMap=new HashMap<String,String>();
		inputMap.put("recordInstructionUrl","");
		inputMap.put("WorkbenchWaitTimeout","10");
		inputMap.put("WorkbenchProcessTimeout","5");
		inputMap.put("FullEMaskTime","1500");
		inputMap.put("FullEMaskTips","将为您临时切换到主界面");
		inputMap.put("EStyle","");
		
		
		String key="";
		if(checkedMap.size()>0){
			Iterator<String> it=checkedMap.keySet().iterator();
			while(it.hasNext()){
				key=it.next();
				if(key!=null&&!"".equals(key)){
					RecordSet.execute("select sKey ,sValue from FullSearch_EAssistantSet where sKey  = '"+key+"'");
					if(RecordSet.next()){
						checkedMap.put(key,Util.null2String(RecordSet.getString("sValue"),"0"));
					}else{
						RecordSet.execute("insert into FullSearch_EAssistantSet(sKey ,sValue) values('"+key+"','0')");
					}
				}
			}
		}
		
		if(inputMap.size()>0){
			Iterator<String> it=inputMap.keySet().iterator();
			while(it.hasNext()){
				key=it.next();
				if(key!=null&&!"".equals(key)){
					RecordSet.execute("select sKey ,sValue from FullSearch_EAssistantSet where sKey  = '"+key+"'");
					if(RecordSet.next()){
						inputMap.put(key,Util.null2String(RecordSet.getString("sValue")));
					}else{
						RecordSet.execute("insert into FullSearch_EAssistantSet(sKey ,sValue) values('"+key+"','"+Util.null2String(inputMap.get(key))+"')");
					}
				}
			}
		}
		
	%>
	<BODY >
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
					+ ",javascript:submitData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan"
					style="text-align: right; width: 400px !important">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="submitData()" />
					<span
						title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"  class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv">
			<span style="width:10px"></span>
			<span id="hoverBtnSpan" class="hoverBtnSpan"> 
				<span id="edit" onclick="" class="selectedTitle" ><%=SystemEnv.getHtmlLabelName(31811, user.getLanguage())%></span>
			</span>
		</div>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
		<FORM id=weaverA name=weaverA action="EAssistantOperation.jsp" method="post">
			<wea:layout  type="2Col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(129552, user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1','itemAreaDisplay':'block'}">
					<!-- 允许用户提交问题 -->
					<wea:item><%=SystemEnv.getHtmlLabelName(129553, user.getLanguage())%></wea:item>
					<wea:item>
						<input tzCheckbox="true" class=inputstyle type="checkbox" id="allowSubmitFaq" name="ALLOWSUBMITFAQ" value="1" <%if("1".equals(checkedMap.get("ALLOWSUBMITFAQ"))){%>checked<%}%>> &nbsp;
					</wea:item>
					<!-- 自动收集问题 -->
					<wea:item><%=SystemEnv.getHtmlLabelNames("81855,86,24419", user.getLanguage())%></wea:item> 
					<wea:item>
						<input tzCheckbox="true" class=inputstyle type="checkbox" id="allowAutoSubmitFaq" name="ALLOWAUTOSUBMITFAQ" value="1" <%if("1".equals(checkedMap.get("ALLOWAUTOSUBMITFAQ"))){%>checked<%}%>> &nbsp;
					</wea:item>
				</wea:group>
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("264,83", user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1','itemAreaDisplay':'block'}">	
					<!-- 自动收集问题 -->
					<wea:item><%=SystemEnv.getHtmlLabelNames("18624,264,83", user.getLanguage())%></wea:item>
					<wea:item>
						<input tzCheckbox="true" class=inputstyle type="checkbox" id="recordInstruction" name="recordInstruction" value="1" <%if("1".equals(checkedMap.get("recordInstruction"))){%>checked<%}%>> &nbsp;
					</wea:item>
					
					<!-- 自动收集问题 -->
					<wea:item><%=SystemEnv.getHtmlLabelNames("31953,26134", user.getLanguage())%></wea:item>
					<wea:item>
						<input class="inputstyle" type="text" id="recordInstructionUrl" name="recordInstructionUrl" value="<%=inputMap.get("recordInstructionUrl")%>"> &nbsp;
					</wea:item>
				</wea:group>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(131430, user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1','itemAreaDisplay':'block'}">	
					<!-- 是否启用 -->
					<wea:item><%=SystemEnv.getHtmlLabelName(18624, user.getLanguage())%></wea:item>
					<wea:item>
						<input tzCheckbox="true" class=inputstyle type="checkbox" id="EnableWorkbench" name="EnableWorkbench" value="1" <%if("1".equals(checkedMap.get("EnableWorkbench"))){%>checked<%}%>> &nbsp;
					</wea:item>
					
					<!-- 等待超时 -->
					<wea:item><%=SystemEnv.getHtmlLabelName(132052, user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(27954, user.getLanguage())%>)</wea:item>
					<wea:item>
						<input class="inputstyle" type="text" id="WorkbenchWaitTimeout" name="WorkbenchWaitTimeout" value="<%=inputMap.get("WorkbenchWaitTimeout")%>"> &nbsp;
					</wea:item>
					<!-- 处理超时 -->
					<wea:item><%=SystemEnv.getHtmlLabelName(132053, user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(27954, user.getLanguage())%>)</wea:item>
					<wea:item>
						<input class="inputstyle" type="text" id="WorkbenchProcessTimeout" name="WorkbenchProcessTimeout" value="<%=inputMap.get("WorkbenchProcessTimeout")%>"> &nbsp;
					</wea:item>
				</wea:group>
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("128696", user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1','itemAreaDisplay':'block'}">	
					<!-- 样式,默认深蓝色,支持暗红色 -->
					<wea:item><%=SystemEnv.getHtmlLabelName(1014, user.getLanguage())%></wea:item>
					<wea:item>
						<input class="inputstyle" type="text" id="EStyle" name="EStyle" value="<%=inputMap.get("EStyle")%>"> &nbsp;
					</wea:item>
				</wea:group>
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("26096,128696", user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1','itemAreaDisplay':'block'}">	
					<!-- 返回时间 -->
					<wea:item><%=SystemEnv.getHtmlLabelName(130448, user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(26287, user.getLanguage())%>)</wea:item>
					<wea:item>
						<input class="inputstyle" type="text" id="FullEMaskTime" name="FullEMaskTime" value="<%=inputMap.get("FullEMaskTime")%>"> &nbsp;
					</wea:item>
					<!-- 处理超时 -->
					<wea:item><%=SystemEnv.getHtmlLabelNames("1290,558", user.getLanguage())%></wea:item>
					<wea:item>
						<input class="inputstyle" type="text" id="FullEMaskTips" name="FullEMaskTips" value="<%=inputMap.get("FullEMaskTips")%>"> &nbsp;
					</wea:item>
				</wea:group>
			</wea:layout>
		</FORM>
	</body>
</html>
<script src="/js/tabs/jquery.tabs_wev8.js"></script>
 
<script type="text/javascript">

function submitData(){
	$('#weaverA').submit();
}

</script>