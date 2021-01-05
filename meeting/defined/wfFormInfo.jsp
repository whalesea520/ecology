<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.defined.MeetingFieldManager"%>
<%@page import="weaver.meeting.defined.MeetingWFUtil"%>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<%@page import="weaver.meeting.defined.MeetingWFComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />

<%
//会议流程设置
if(!HrmUserVarify.checkUserRight("Meeting:WFSetting", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}
/*权限判断结束*/

int billid=Util.getIntValue(request.getParameter("id"));


String method=Util.null2String(request.getParameter("method"));
if("edit".equals(method)){
	RecordSet.execute("delete from meeting_wf_relation where billid="+billid);
	Map map=request.getParameterMap();
	Iterator<String> it=map.keySet().iterator();
	String key="";
	String value="";
	String scope="";
	String fieldid="";
	String[] keys=null;
	while(it.hasNext()){
		key=it.next();
		if(!key.startsWith("WF_")) continue;
		value=request.getParameter(key);
		if("".equals(value)) continue;
		keys=key.split("_");
		RecordSet.execute("insert into meeting_wf_relation(defined,fieldid,fieldname,billid,bill_fieldname) values("+
				keys[1]+","+keys[2]+",'"+MeetingFieldComInfo.getFieldname(keys[2])+"',"+billid+",'"+value+"')");
	}
	new MeetingWFComInfo().removeFieldCache();
}

String type="";
String mode="";
String titlemsg=Util.null2String(request.getParameter("titlemsg"));
String desc_n=Util.null2String(request.getParameter("desc_n"));
String bodymsg=Util.null2String(request.getParameter("bodymsg"));
String needclose="false";
 
String titlename = SystemEnv.getHtmlLabelName(32714,user.getLanguage());
int langid=user.getLanguage();
String needcheck="";
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/skins/default/wui_wev8.css">
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
 
</HEAD>
<BODY style="overflow: hidden">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:jsOK();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="jsOK();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="zDialog_div_content">
<form id="weaver" name="weaver" action="wfFormInfo.jsp" method="post">
	<input name="id" type="hidden" value="<%=billid %>">
	<input name="method" type="hidden" value="edit">
 		 	<table class=ListStyle  border=0 cellspacing=1>
				  <colgroup>
				  	<col width="50%">
				  	<col width="50%">
				  </colgroup>
					<TR class=HeaderForXtalbe>
				  	<th>&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(82897,user.getLanguage())%></th>
				  	<th><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></th>
			  		</tr>
			 </table>
			 <div  id="remindVariable" style="height:465px;overflow: hidden">
			  		
			 <table class="LayoutTable" id="" style="width:100%;">
				<colgroup>
					<col width="50%">
					<col width="50%">
				</colgroup>
				<tbody>
					<%RecordSet.execute("SELECT t1.*,t2.tablename FROM  meeting_defined t1 join meeting_bill t2 on t1.scopeid=t2.defined "+
							" where billid="+billid+" ORDER BY dsporder");
					  while(RecordSet.next()){
						  int scope=RecordSet.getInt("scopeid");
						  int labelid=RecordSet.getInt("tablelabel");
						  String tablename=RecordSet.getString("tablename");
						  int isdetail=RecordSet.getInt("isdetail");
					%>	  
						<tr class="intervalTR" _samepair="" style="display:">
						<td colspan="2">
							<table class="LayoutTable" style="width:100%;">
								<colgroup>
									<col width="50%">
									<col width="50%">
								</colgroup>
								<tbody><tr class="groupHeadHide">
									<td class="interval">
										<span class="groupbg"> </span>
										<span class="e8_grouptitle"><%=SystemEnv.getHtmlLabelName(labelid, user.getLanguage()) %></span>
									</td>
								</tr>
							</tbody>
							</table>
						</td>
						</tr>
						<tr class="Spacing" style="height:1px;display:">
							<td class="Line" colspan="2">
						</td></tr>
					<%  
							MeetingFieldManager hfm = new MeetingFieldManager(scope);
							List<String> groupList=hfm.getLsGroup();
							for(String groupid:groupList){
								List<String> fieldList= hfm.getLsField(groupid);
								for(String fieldid:fieldList){
									String fieldname = MeetingFieldComInfo.getFieldname(fieldid);
									int fieldlabel = Util.getIntValue(MeetingFieldComInfo.getLabel(fieldid));
									int fieldhtmltype = Integer.parseInt(MeetingFieldComInfo.getFieldhtmltype(fieldid));
									int fieldtype = Integer.parseInt(MeetingFieldComInfo.getFieldType(fieldid));
								   	boolean ismand="1".equals(MeetingFieldComInfo.getIsmand(fieldid));
								   	String changeFun=ismand?"checkinput('WF_"+scope+"_"+fieldid+"','WF_"+scope+"_"+fieldid+"_span')":"";
								   	needcheck+=ismand?("".equals(needcheck)?"WF_"+scope+"_"+fieldid:","+"WF_"+scope+"_"+fieldid):"";
									//自定义字段,不显示的直接隐藏
									if("-1".equals(MeetingFieldComInfo.getIssystem(fieldid))&&!"1".equals(MeetingFieldComInfo.getIsused(fieldid))) continue;
									//提醒
									String title="";
									if(fieldhtmltype==1){
										title=SystemEnv.getHtmlLabelName(688,user.getLanguage());
										if(fieldtype==1){
											title+="("+SystemEnv.getHtmlLabelName(608,user.getLanguage())+")";
										}else if(fieldtype==2){
											title+="("+SystemEnv.getHtmlLabelName(696,user.getLanguage())+")";
										}else if(fieldtype==3){
											title+="("+SystemEnv.getHtmlLabelName(697,user.getLanguage())+")";
										}
									}else if(fieldhtmltype==2){
										title=SystemEnv.getHtmlLabelName(689,user.getLanguage());
									}else if(fieldhtmltype==3){
										title=SystemEnv.getHtmlLabelName(695,user.getLanguage());
										title=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(""+fieldtype),0),user.getLanguage())+title;
									}else if(fieldhtmltype==4){
										title=SystemEnv.getHtmlLabelName(691,user.getLanguage());
									}else if(fieldhtmltype==5){
										title=SystemEnv.getHtmlLabelName(690,user.getLanguage());
									}else if(fieldhtmltype==6){
										title=SystemEnv.getHtmlLabelName(17616,user.getLanguage());
									}
									JSONObject json=MeetingWFUtil.getOption(billid,fieldhtmltype,fieldtype,isdetail,tablename,fieldid);
									Map<String,Integer> optionMap= (Map)json.get("option");
									String selectValue=json.getString("select");
									Iterator<String> it=optionMap.keySet().iterator();
					%>
						<tr class="intervalTR" _samepair="" style="display:">
							<td class="fieldName">
								 <%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
							</td>
							<td class="field">
								 <select style="width:60%" name="<%="WF_"+scope+"_"+fieldid %>" id="<%="WF_"+scope+"_"+fieldid %>" onchange="<%=changeFun %>">
								 	<%if(fieldhtmltype==3&&optionMap.size()==1){}else{ %>
								 	<option value=""></option>
								 	<%
								 	}
								 		while(it.hasNext()){
								 			String key=it.next();
								 			if(fieldhtmltype==3&&optionMap.size()==1){
										 		if("".equals(selectValue)){
											 		selectValue=optionMap.get(key).toString();
										 		}
										 	}
								 			out.println("<option value=\""+key+"\" "+(key.equals(selectValue)?"selected":"")+">"+SystemEnv.getHtmlLabelName(optionMap.get(key),user.getLanguage())+"</option>");
								 		}
								 	%>
								 </select>
								 <SPAN style="display:-moz-inline-box; display:inline-block; width:15px;" id="<%="WF_"+scope+"_"+fieldid+"_span" %>">
									<%
				              		if(ismand&&"".equals(selectValue)){
					              	%>
					              	<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
					              	<%
					              	}%>
				              	</SPAN>
				              	<SPAN >
				              		 <IMG src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=title %>" > 
				              	</SPAN>
								 
							</td>
						</tr>
						<tr class="Spacing" style="height:1px;display:">
							<td class="Line" colspan="2">
						</td></tr>
					
					
					
									
					<%			}
							}
					
					
						}
					
					%>
					
		 		</td></tr>
		 	</tbody>
	    </table>
	    </div>
 </form>
 <!-- 为了引入样式 -->
 <div style="display:none">
	<wea:layout type="2col">
		<wea:group context="<%= SystemEnv.getHtmlLabelName(127873,user.getLanguage()) %>">
			<wea:item></wea:item>
		</wea:group>
	</wea:layout>
</div>
</div>
 	
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
	    </td></tr>
	</table>
</div>
 
</BODY>
</HTML>
<script type="text/javascript">


var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);	
function jsOK(){
	if(check_form(document.weaver,'<%=needcheck%>')){
		$('#weaver').submit();	
	}
}

$(document).ready(function() {
	 jQuery("#remindVariable").perfectScrollbar();
	  
});

</script>