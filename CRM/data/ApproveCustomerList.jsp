
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
    String imagefilename = "/images/hdDOC_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(16406,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    String isScuccess = Util.null2String(request.getParameter("issuccess"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:onApprove(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+",javascript:onReject(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>

<%
    String operType = "";
    if(user.getLogintype().equals("1")){
        operType = "0";
    }else{
        operType = "1";
    }

    String sql = "select distinct t1.requestid,t1.requestname,t3.type,t3.manager,t3.name,t3.status,t3.id,t4.approvedesc from bill_ApproveCustomer t4,workflow_requestbase t1,workflow_currentoperator t2, CRM_CustomerInfo t3 where t4.requestid=t1.requestid and t1.requestid=t2.requestid and t4.approvetype=1 and t4.approveid=t3.id and t2.userid="+user.getUID()+" and t2.usertype="+operType+" and t4.status='2' and t2.isremark in( '0','1')  and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '1' ";
    RecordSet.executeSql(sql);

%>

<form name=cusapprove action="ApproveCustomerMutiOpteration.jsp" method="post">
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



<TABLE class=ListStyle  cellspacing=1 >
  <TBODY>
  <TR class=Header>
      <th colspan=6><%=SystemEnv.getHtmlLabelName(17296,user.getLanguage())%></th>
  </tr>
  <TR class=Header>
      <th width=5%></th>
      <th width=25%><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></th>
      <th width=20%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
      <th width=15%><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></th>
      <th width=15%><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></th>
      <th width=20%><%=SystemEnv.getHtmlLabelName(129,user.getLanguage())%></th>
  </tr>
  <TR class=Line><TD colSpan=6 style="padding: 0"></TD></TR>
  <%
      int i=2;
      while(RecordSet.next()){
          if(i%2==0){
  %>
  <TR class=datadark>
  <%
          }else{
  %>
  <TR class=datalight>
  <%
          }
  %>
      <th width=5%>
      <input type="checkbox" name=requestid value="<%=RecordSet.getString("requestid")%>">
      </th>
      <td width=25%>
      <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("id")%>&isrequest=1&requestid=<%=RecordSet.getString("requestid")%>">
        <%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>
      </a>
      </td>
      <td width=20%>
      <%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("type")),user.getLanguage())%>
      </td>
      <td width=15%>
      <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("manager")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></a>
      </td>
      <td width=15%>
      <%=Util.toScreen(CustomerStatusComInfo.getCustomerStatusname(RecordSet.getString("status")),user.getLanguage())%>
      </td>
      <td width=20%>
      <%=Util.toScreen(RecordSet.getString("approvedesc"),user.getLanguage())%>
      </td>
  </tr>
  <%}%>
  </tbody>
</table>

<%
    sql = "select distinct t1.requestid,t1.requestname,t3.type,t3.manager,t3.name,t3.status,t3.id,t4.approvedesc from bill_ApproveCustomer t4,workflow_requestbase t1,workflow_currentoperator t2, CRM_CustomerInfo t3 where t4.requestid=t1.requestid and t1.requestid=t2.requestid and t4.approvetype<>1 and t4.approveid=t3.id and t2.userid="+user.getUID()+" and t2.usertype="+operType+" and t4.status='2' and t2.isremark in( '0','1')  and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> '3' ";
    RecordSet.executeSql(sql);
%>
<p><p><p>
<TABLE class=ListStyle  cellspacing=1 >
  <TBODY>
  <TR class=Header>
      <th colspan=6><%=SystemEnv.getHtmlLabelName(17297,user.getLanguage())%></th>
  </tr>
  <TR class=Header>
      <th width=5%></th>
      <th width=25%><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></th>
      <th width=20%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
      <th width=15%><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></th>
      <th width=15%><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></th>
      <th width=20%><%=SystemEnv.getHtmlLabelName(129,user.getLanguage())%></th>
  </tr>
  <TR class=Line><TD colSpan=6 style="padding: 0"></TD></TR>
  <%
      i=2;
      while(RecordSet.next()){
          if(i%2==0){
  %>
  <TR class=datadark>
  <%
          }else{
  %>
  <TR class=datalight>
  <%
          }
  %>
      <th width=5%>
      <input type="checkbox" name=requestid value="<%=RecordSet.getString("requestid")%>">
      </th>
      <td width=25%>
      <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("id")%>&isrequest=1&requestid=<%=RecordSet.getString("requestid")%>">
        <%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>
      </a>
      </td>
      <td width=20%>
      <%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("type")),user.getLanguage())%>
      </td>
      <td width=15%>
      <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("manager")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></a>
      </td>
      <td width=15%>
      <%=Util.toScreen(CustomerStatusComInfo.getCustomerStatusname(RecordSet.getString("status")),user.getLanguage())%>
      </td>
      <td width=20%>
      <%=Util.toScreen(RecordSet.getString("approvedesc"),user.getLanguage())%>
      </td>
  </tr>
  <%}%>
  </tbody>
</table>
<input type=hidden name=operation>
<input type="checkbox" name=requestid style="display:none">
<input type="checkbox" name=requestid style="display:none">
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language="JavaScript">
<%
	if("false".equals(isScuccess)){
%>
	alert('<%=SystemEnv.getHtmlLabelName(16333,user.getLanguage())%>');
<%
	}
%>
function onApprove(obj){
    var isSelected = false;
    var i;
    for(i=0; i<document.all("requestid").length-2; i++){
        if(jQuery(document.all("requestid")[i]).attr("checked")){
            isSelected = true;
            break;
        }
    }
    if(!isSelected){
        alert("<%=SystemEnv.getHtmlLabelName(18922,user.getLanguage())%>");
        return;
    }
    obj.disabled=true;
    document.cusapprove.operation.value='approve';
    cusapprove.submit();
}

function onReject(obj){
    var isSelected = false;
    var i;
    for(i=0; i<document.all("requestid").length-2; i++){
        if(jQuery(document.all("requestid")[i]).attr("checked")){
            isSelected = true;
            break;
        }
    }
    if(!isSelected){
        alert("<%=SystemEnv.getHtmlLabelName(21258,user.getLanguage())%>");
        return;
    }
    obj.disabled=true;
    document.cusapprove.operation.value='reject';
    cusapprove.submit();
}
</script>
</body>
</html>