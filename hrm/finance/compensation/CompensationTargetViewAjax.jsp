
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="java.util.ArrayList" %><jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" /><jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/><jsp:useBean id="CompensationTargetMaint" class="weaver.hrm.finance.compensation.CompensationTargetMaint" scope="page"/><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.hrm.*" %>
<%
	User user = HrmUserVarify.getUser (request , response);
	if(user == null)  return ;
    int departmentid = Util.getIntValue(request.getParameter("departmentid"));
    int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
    String currentyear = Util.null2String(request.getParameter("CompensationYear"));
    String currentmonth = Util.null2String(request.getParameter("CompensationMonth"));
    int userid = Util.getIntValue(request.getParameter("userid"));
    int isedit = Util.getIntValue(request.getParameter("isedit"));
    boolean showdept = Util.getIntValue(request.getParameter("showdept")) > 0 ? false : true;
    if(showdept){
        CompensationTargetMaint.getDepartmentTarget(subcompanyid, -1, userid, "Compensation:Maintenance", isedit==1?0:-1, isedit==1?false:true);
    }else{
        CompensationTargetMaint.getDepartmentTarget(subcompanyid, departmentid, userid, "Compensation:Maintenance", isedit==1?0:-1, isedit==1?false:true);
    }
    ArrayList targetlist = CompensationTargetMaint.getTargetlist();
%>
<table   width="100%">
  <%
  String sql="";
  int i=Util.getIntValue(request.getParameter("xuhao"),0);
  sql="select a.id,a.workcode,a.lastname,a.subcompanyid1,a.departmentid,b.id as comtargetid,b.memo from hrmresource a left join HRM_CompensationTargetInfo b on a.id=b.Userid and b.CompensationYear="+currentyear+" and b.CompensationMonth="+Util.getIntValue(currentmonth)+" where a.departmentid="+departmentid+" and a.status in(0,1,2,3) order by a.id";
  RecordSet.executeSql(sql);
  while(RecordSet.next()){
      int cuserid=RecordSet.getInt("id");
      String workcode=RecordSet.getString("workcode");
      String cusername=RecordSet.getString("lastname");
      String subcompanyid1=RecordSet.getString("subcompanyid1");
      String departmentid1=RecordSet.getString("departmentid");
      String subcompanyname=SubCompanyComInfo.getSubCompanyname(subcompanyid1);
      String departmentname=DepartmentComInfo.getDepartmentname(departmentid1);
      String comtargetid=RecordSet.getString("comtargetid");
      String memo=RecordSet.getString("memo");
      ArrayList templist=CompensationTargetMaint.getTarget(comtargetid,targetlist);
  if(i%2==0){
  %>
  <TR style="BACKGROUND-COLOR: #F7F7F7;word-wrap:break-word; word-break:break-all;">
  <%}else{%>
  <TR style="BACKGROUND-COLOR: #FFFFFF;word-wrap:break-word; word-break:break-all;">
  <%}%>
      <TD width="50" style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><%=(i+1)%></TD>
      <%if(showdept){%>
      <TD width="200" style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><%=subcompanyname%></TD>
      <TD width="200" style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><%=departmentname%></TD>
      <%}
      //System.out.println("i:"+i+"|"+cuserid);
      %>
      <TD width="100" style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><%if(isedit==1){%><input type='hidden'  id='Userid_<%=i%>' name='Userid_<%=i%>' value="<%=cuserid%>"><%}%><%=cusername%></TD>
      <TD width="100" style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><%=workcode%></TD>
      <%for(int j=0;j<targetlist.size();j++){
        String temp=(String)templist.get(j);
        if(isedit==1){
        %>
      <TD width="100" style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><input type='text'  name='target<%=j%>_<%=i%>' <%if(Util.getDoubleValue(temp)!=0){%>value="<%=temp%>"<%}%> onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this)" maxlength="13"></TD>
      <%
        }else{
      %>
      <TD width="100" style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><%if(Util.getDoubleValue(temp)!=0){%><%=temp%><%}%></TD>
      <%}
      }
      if(isedit==1){
      %>
      <TD width="200" style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><input type='text'  name='memo_<%=i%>' value="<%=memo%>" maxlength=500></TD>
      <%
      }else{
      %>
      <TD width="200" style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><%=memo%></TD>
      <%
      }
      %>
  </TR>
  <%
  i++;
  }
  %>
</table>