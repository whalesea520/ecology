
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="EvaluationLevelComInfo" class="weaver.crm.Maint.EvaluationLevelComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%

String CustomerID=Util.null2String(request.getParameter("CustomerID"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6070,user.getLanguage()) + ":" + CustomerInfoComInfo.getCustomerInfoname(CustomerID);
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
isfromtab = true;
String needfav ="1";
String needhelp ="";

String name="";
String proportionstr="";
String id=Util.null2String(request.getParameter("id"));
if(!id.equals("")){
	RecordSet.executeProc("CRM_Evaluation_SelectById",id);
	if(RecordSet.next()){
	 name=Util.null2String(RecordSet.getString("name"));
	 proportionstr=Util.null2String(RecordSet.getString("proportion"));
	}
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(17744,user.getLanguage())+",javascript:doSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSubmit()" type="button"  value="<%=SystemEnv.getHtmlLabelName(17744,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaverD name="weaverD" action="/CRM/Maint/EvaluationOperation.jsp" method=post>
<input type="hidden" name="method" value="getvalue">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
<input type="hidden" name="isfromtab" value="<%=isfromtab%>">
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>  
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <TBODY>
  <TR class=HeaderForXtalbe>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6072,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18093,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17506,user.getLanguage())%></th>
  </tr>
<%
RecordSet.executeProc("CRM_Evaluation_Select","");
boolean isLight = false;
int itemCount = RecordSet.getCounts();
int index = 0;
while(RecordSet.next()){
	index++;
	String evaluationID = RecordSet.getString("id");
	if(isLight = !isLight){%>	
	<TR CLASS=DataDark>
	<%}else{%>
	<TR CLASS=DataLight>
	<%}%>		
		<TD><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></TD>
		<input type="hidden" name="evaluationID" value="<%=RecordSet.getString("id")%>">
		<TD>
			 <select id="level" name="level" onchange="setValue(this,<%=index %>)">
				<%
				String checkLevel = "";
				String firstLevel = "";
				rs.executeSql("select levelID from CRM_Evaluation_LevelDetail where customerID = "+CustomerID+" and evaluationID ="+ evaluationID );											
				if(rs.next()){										
					checkLevel = rs.getString("levelID");
				}
				while (EvaluationLevelComInfo.next()) {
					firstLevel = firstLevel.equals("")?EvaluationLevelComInfo.getEvaluationLevellevelvalue():firstLevel;
				%>
	            <option value="<%=EvaluationLevelComInfo.getEvaluationLevellevelvalue()%>"
	            	 <%if(checkLevel.equals(EvaluationLevelComInfo.getEvaluationLevellevelvalue())){ %>selected <%}%>>
					<%=EvaluationLevelComInfo.getEvaluationLevelname()%>
				</option>
				<%}%>
			</select>
		</TD>
		<td><span id="point_<%=index%>"><%=checkLevel %></span></td>
		<TD>
			<input type="hidden" name="proportion" id="proportion_<%=index %>" value="<%=RecordSet.getString("proportion")%>">		
			<%=Util.toScreen(RecordSet.getString("proportion"),user.getLanguage())%>%
		</TD>
		<%
			double score = 0.0;
			if("".equals(checkLevel)){
				score = Util.getDoubleValue(firstLevel,0)*(Util.getDoubleValue(RecordSet.getString("proportion"),0))/100;
			}else{
				score = Util.getDoubleValue(checkLevel,0)*(Util.getDoubleValue(RecordSet.getString("proportion"),0))/100;
			}
		%>
		<td><span id="score_<%=index%>"><%=score %></span></td>
	</TR>
<%}%>
	<tr>
		<td colspan="3"></td>
		<td align="right"><%=SystemEnv.getHtmlLabelName(84356,user.getLanguage())%>:</td>
		<td>
			<span id="totalScore"></span>
		</td>
	</tr>
</TABLE>
</FORM>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</BODY>
</HTML>
<script language=javascript >
function doSubmit(){
		if ("<%=itemCount%>" < 1){
				alert("<%=SystemEnv.getHtmlLabelName(16497,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>");
		} else {
		    if($("#level").val() == null){
		        alert("<%=SystemEnv.getHtmlLabelName(16328,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>");
		    } else {
		    		weaverD.submit();
		    		
		    }
		}
}

function setValue(obj , index){
	var level = obj.value;
	var proportion = jQuery("#proportion_"+index).val();
	var score = parseFloat(level) * parseFloat(proportion) / 100;
	
	jQuery("#point_"+index).html(level);
	jQuery("#score_"+index).html(score);
	jQuery("#totalScore").html(getTotalValue());
}

function getTotalValue(){
	var value = 0;
	for(var index=1; index <= <%=index%>; index++){
		value += parseFloat(jQuery("#score_"+index).html());
	}
	return value.toFixed(2);
}

$(function(){
	jQuery("#totalScore").html(getTotalValue());
});
</script>