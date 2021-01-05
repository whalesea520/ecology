
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingHandler" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSetting" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%

String imagefilename = "/images/hdMaintenance_wev8.gif";

String needhelp = "";
//待更改
String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage()) + " - "+SystemEnv.getHtmlLabelName(84138,user.getLanguage());


int userid = user.getUID();

cutoverWay = "";
transitionTime = "";
transitionWay = "";

String self = request.getParameter("self");

if (self != null && self.equals("1")) {
	cutoverWay = request.getParameter("cutoverWay");
	transitionTime = request.getParameter("TransitionTime");
	transitionWay = request.getParameter("TransitionWay");
	
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	weaver.conn.RecordSet rs2 = new weaver.conn.RecordSet();


	rs.executeSql("select * from SysSkinSetting where userid=" + userid);
	String sql = "";
	if(rs.next()){
		sql = "update SysSkinSetting set cutoverWay='" + cutoverWay + "', transitionTime='" + transitionTime + "', transitionWay='" + transitionWay + "' where userid=" + userid;
	} else {
	    sql = "insert into SysSkinSetting(userid, cutoverWay, TransitionTime, TransitionWay) values ('" + userid + "', '" + cutoverWay + "', '" + transitionTime + "', '" + transitionWay + "')";
	}	
	rs2.executeSql(sql);
}

weaver.conn.RecordSet recordSet = new weaver.conn.RecordSet();

recordSet.executeSql("select cutoverWay, TransitionTime, TransitionWay from SysSkinSetting where userid=" + userid);

if(recordSet.next()){
	cutoverWay = Util.null2String(recordSet.getString("cutoverWay"));
	transitionTime = Util.null2String(recordSet.getString("TransitionTime"));
	transitionWay = Util.null2String(recordSet.getString("TransitionWay"));
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
    
<script type="text/javascript">
    function submit() {
        document.all.form1.submit();
    }
</script>
  </head>
  
  <body>
  <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
  <%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submit(),_self} " ;
  RCMenuHeight += RCMenuHeightStep ;
  %>
  
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="/wui/theme/ecology8/page/pageCutoverSetting.jsp" name="form1" method="POST">
    <input type="hidden" name="self" value="1">
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
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
			
    <TABLE class=ViewForm>
		<COLGROUP>
		<COL width="30%">
		<COL width="70%">
		
			<TR class=Title>
				<TH colSpan=2><%=SystemEnv.getHtmlLabelName(84138,user.getLanguage()) %></TH>
			</TR>
			
			<TR class=Spacing>
			<TD class=Line1 colSpan=2></TD>
			</TR>
		
			<tr>
              <td><%=SystemEnv.getHtmlLabelName(84140,user.getLanguage()) %></td>
              <td class=Field>
                <select name="cutoverWay" value="<%=cutoverWay %>">
                    <option value="Page-Enter" <%="Page-Enter".equals(cutoverWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31527,user.getLanguage()) %></option>
                    <option value="Page-Exit"  <%="Page-Exit".equals(cutoverWay) ?  "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31528,user.getLanguage()) %></option>
                </select>
              </td>
            </tr>

            <TR>
                <TD class=Line colspan=2></TD>
            </TR>
            
            
            <tr>
              <td><%=SystemEnv.getHtmlLabelName(84142,user.getLanguage()) %></td>
              <td class=Field>
                <input type="text" name="TransitionTime" onkeypress="ItemNum_KeyPress()" value="<%=transitionTime %>"><%=SystemEnv.getHtmlLabelName(84144,user.getLanguage()) %>
              </td>
            </tr>

            <TR>
                <TD class=Line colspan=2></TD>
            </TR>
            
            <tr>
              <td><%=SystemEnv.getHtmlLabelName(84146,user.getLanguage()) %></td>
              <td class=Field>
	               <select name="TransitionWay" value="<%=transitionWay %>">
	                    <option value="0" <%="0".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31532,user.getLanguage()) %></option>
						<option value="1" <%="1".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31554,user.getLanguage()) %></option>
						<option value="2" <%="2".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31555,user.getLanguage()) %></option>
						<option value="3" <%="3".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31533,user.getLanguage()) %></option>
						<option value="4" <%="4".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31534,user.getLanguage()) %></option>
						<option value="5" <%="5".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31535,user.getLanguage()) %></option>
						<option value="6" <%="6".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31536,user.getLanguage()) %></option>
						<option value="7" <%="7".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31537,user.getLanguage()) %></option>
						<option value="8" <%="8".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31538,user.getLanguage()) %></option>
						<option value="9" <%="9".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31539,user.getLanguage()) %></option>
						<option value="10" <%="10".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31540,user.getLanguage()) %></option>
						<option value="11" <%="11".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31541,user.getLanguage()) %></option>
						<option value="12" <%="12".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31542,user.getLanguage()) %></option>
						<option value="13" <%="13".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31543,user.getLanguage()) %></option>
						<option value="14" <%="14".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31544,user.getLanguage()) %></option>
						<option value="15" <%="15".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31545,user.getLanguage()) %></option>
						<option value="16" <%="16".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31546,user.getLanguage()) %></option>
						<option value="17" <%="17".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31547,user.getLanguage()) %></option>
						<option value="18" <%="18".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31548,user.getLanguage()) %></option>
						<option value="19" <%="19".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31549,user.getLanguage()) %></option>
						<option value="20" <%="20".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31550,user.getLanguage()) %></option>
						<option value="21" <%="21".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31551,user.getLanguage()) %></option>
						<option value="22" <%="22".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31552,user.getLanguage()) %></option>
						<option value="23" <%="23".equals(transitionWay) ? "selected" : "" %>><%=SystemEnv.getHtmlLabelName(31553,user.getLanguage()) %></option>
	                </select>
              </td>
            </tr>

            <TR>
                <TD class=Line colspan=2></TD>
            </TR>
		
		</TBODY>
	</TABLE>

			
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
</form>   


  </body>
</html>
