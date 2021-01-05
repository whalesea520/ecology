
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="java.util.ArrayList" %><%@ page import="weaver.systeminfo.SystemEnv" %><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" /><jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" /><jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" /><jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/><jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/><jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" /><%@ page import="weaver.hrm.*" %><%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
int departmentid = Util.getIntValue(request.getParameter("departmentid"));   // 部门
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
int Language=  Util.getIntValue(request.getParameter("Language"),7);   // 部门
boolean isLight= Util.null2String(request.getParameter("islight")).equals("true")?true:false;
boolean showbox= Util.null2String(request.getParameter("showcheckbox")).equals("true")?true:false;
    String sqlstr = "";
    ArrayList itemlist=new ArrayList();
    ArrayList itemlist1=new ArrayList();
    sqlstr="select distinct d.showorder,c.itemid from HrmResource a,HrmSalaryPaydetail c,hrmsalaryitem d where a.id=c.hrmid and REPLACE(REPLACE(c.itemid,'_1',''),'_2','')=convert(varchar,d.id) and d.isshow='1' " + sqlwhere +" order by d.showorder,c.itemid";
    if("oracle".equalsIgnoreCase(RecordSet.getDBType())){
        sqlstr="select distinct d.showorder,c.itemid from HrmResource a,HrmSalaryPaydetail c,hrmsalaryitem d where a.id=c.hrmid and to_number(REPLACE(REPLACE(c.itemid,'_1',''),'_2',''))=d.id and d.isshow='1' " + sqlwhere +" order by d.showorder,c.itemid";
    }
    RecordSet.executeSql(sqlstr);
    while( RecordSet.next() ) {
        String tmpitemid = RecordSet.getString("itemid") ;
        if(itemlist.indexOf(tmpitemid)==-1){
            itemlist.add(tmpitemid);
        }
    }
	sqlstr="select distinct c.itemid from HrmResource a,HrmSalaryPaydetail c where a.id=c.hrmid and REPLACE(REPLACE(c.itemid,'_1',''),'_2','') not in(select convert(varchar,id) from hrmsalaryitem) " + sqlwhere +" order by c.itemid";
    if("oracle".equalsIgnoreCase(RecordSet.getDBType())){
        sqlstr="select distinct c.itemid from HrmResource a,HrmSalaryPaydetail c where a.id=c.hrmid and to_number(REPLACE(REPLACE(c.itemid,'_1',''),'_2','')) not in(select id from hrmsalaryitem) " + sqlwhere +" order by c.itemid";
    }
    RecordSet.executeSql(sqlstr);
    while( RecordSet.next() ) {
        String tmpitemid = RecordSet.getString("itemid") ;
        if(itemlist1.indexOf(tmpitemid)==-1){
            itemlist1.add(tmpitemid);
        }
        if(itemlist.indexOf(tmpitemid)==-1){
            itemlist.add(tmpitemid);
        }
    }
    if(itemlist.size()<1){
        itemlist=SalaryComInfo.getSubCompanySalary(subcompanyid);
    }
    sqlstr = " select a.id , a.jobtitle ,c.itemid,c.departmentid,c.salary,c.sent from HrmResource a ,HrmSalarypaydetail c "
        +" where a.id=c.hrmid and c.departmentid="+departmentid + sqlwhere + " order by c.departmentid , c.hrmid " ;
    //System.out.println(sqlstr);
//    ArrayList itemlist=SalaryComInfo.getSubCompanySalary(subcompanyid);
    RecordSet.executeSql(sqlstr);

    ArrayList deptlist=new ArrayList();
    ArrayList deptrows=new ArrayList();
    ArrayList resourcelist=new ArrayList();
    ArrayList jobtitlelist=new ArrayList();
    ArrayList statuslist=new ArrayList();
    int itemnums=itemlist.size();
    ArrayList[] itemsalarylist=new ArrayList[itemnums];
    for(int j=0;j<itemnums;j++){
        itemsalarylist[j]=new ArrayList();
    }
    int rows=0;
    while(RecordSet.next()){
        String deptid=Util.null2String(RecordSet.getString("departmentid"));
        String resourceidrs = Util.null2String(RecordSet.getString("id")) ;
        String jobtitlers = Util.null2String(RecordSet.getString("jobtitle")) ;
        String tmpitemid=Util.null2String(RecordSet.getString("itemid")) ;
        String tmpsalary=Util.null2String(RecordSet.getString("salary")) ;
        String tmpsent=Util.null2String(RecordSet.getString("sent")) ;
        if(deptlist.indexOf(deptid)<0){
			resourcelist.add(resourceidrs);
			statuslist.add(tmpsent);
			jobtitlelist.add(jobtitlers);
			for(int j=0;j<itemnums;j++){
				itemsalarylist[j].add("0.00");
			}
            deptlist.add(deptid);
            deptrows.add("0");
            rows=1;
        }else{
			if(resourcelist.indexOf(resourceidrs)<0){
				rows++;
				resourcelist.add(resourceidrs);
				statuslist.add(tmpsent);
				jobtitlelist.add(jobtitlers);
				for(int j=0;j<itemnums;j++){
					itemsalarylist[j].add("0.00");
				}
			}
            deptrows.set(deptlist.size()-1,""+rows);
        }
        if(itemlist.indexOf(tmpitemid)>-1){
            itemsalarylist[itemlist.indexOf(tmpitemid)].set(resourcelist.size()-1,tmpsalary);
        }
    }
int nowrows=0;
int tolrows=1;
ArrayList tempitems=new ArrayList();
String tempsubcompanyid="";
if(deptrows.size()>0){
int resourcenum=Util.getIntValue((String)deptrows.get(nowrows));
String tempcompanyid=DepartmentComInfo.getSubcompanyid1(""+departmentid);
    if (!tempcompanyid.equals(tempsubcompanyid)) {
        tempitems = SalaryComInfo.getSubCompanySalary(Util.getIntValue(tempcompanyid));
        tempsubcompanyid = tempcompanyid;
    }
    String viewresourceid=(String)resourcelist.get(nowrows);
    String viewjobtitle=(String)jobtitlelist.get(nowrows);
%>
<table border="0" cellspacing="1" cellpadding="0" width="100%">
<%if(isLight){
  %>
  <TR style="BACKGROUND-COLOR: #F7F7F7;">
  <%}else{%>
  <TR style="BACKGROUND-COLOR: #f5f5f5;">
  <%}%>                    
          <td width="200" style="padding-left: 0px" rowspan="<%=resourcenum%>"><%if(showbox){%><input type="checkbox" name="chkdeptid" value="<%=departmentid%>" onClick="CheckAll(this.checked,<%=departmentid%>)"><%}%><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+departmentid),Language)%></td>
          <td width="100" style="padding-left: 0px" <%if(tolrows%2==0){%>bgcolor="#e7e7e7"<%}else{%>bgcolor="#f5f5f5"<%}%>><%if(showbox){%><input type="checkbox" name="chkresourceid_<%=departmentid%>" value="<%=viewresourceid%>" onclick="CheckChanage(this,<%=departmentid%>)"><%}%><a href='javaScript:openhrm(<%=viewresourceid %>);' onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(viewresourceid),Language)%></a></td>
          <td width="150" style="padding-left: 0px" <%if(tolrows%2==0){%>bgcolor="#e7e7e7"<%}else{%>bgcolor="#f5f5f5"<%}%>><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(viewjobtitle),Language)%></td>
   <%
      String itemeid="";
      for(int k=0;k<itemnums;k++){
          itemeid=(String)itemlist.get(k);
          if(tempitems.indexOf(itemeid)>-1 || itemlist1.indexOf(itemeid)>-1){
   %>
          <td width="100" style="padding-left: 0px" align="right" <%if(tolrows%2==0){%>bgcolor="#e7e7e7"<%}else{%>bgcolor="#f5f5f5"<%}%>><%=itemsalarylist[k].get(nowrows)%></td>
   <%
           }else{
   %>
          <td width="100" style="padding-left: 0px" align="right" <%if(tolrows%2==0){%>bgcolor="#e7e7e7"<%}else{%>bgcolor="#f5f5f5"<%}%>>&nbsp;</td>
   <%
           }
      }
   %>
          <td width="100" style="padding-left: 0px" <%if(tolrows%2==0){%>bgcolor="#e7e7e7"<%}else{%>bgcolor="#f5f5f5"<%}%>><%if(((String)statuslist.get(nowrows)).equals("1")){ %><%=SystemEnv.getHtmlLabelName(19558,Language)%><%}else{ %><font color="red"><%=SystemEnv.getHtmlLabelName(19557,Language)%></font><%}%></td>
      </tr>
   <%
      for(int j=(nowrows+1);j<(nowrows+resourcenum);j++){
          tolrows++;
          viewresourceid=(String)resourcelist.get(j);
          viewjobtitle=(String)jobtitlelist.get(j);
   %>
      <%if(isLight){
  %>
  <TR style="BACKGROUND-COLOR: #F7F7F7;">
  <%}else{%>
  <TR style="BACKGROUND-COLOR: #f5f5f5;">
  <%}%>
          <td width="100" style="padding-left: 0px" <%if(tolrows%2==0){%>bgcolor="#e7e7e7"<%}else{%>bgcolor="#f5f5f5"<%}%>><input type="checkbox"  name="chkresourceid_<%=departmentid%>" value="<%=viewresourceid%>" onclick="CheckChanage(this,<%=departmentid%>)"><a href='javaScript:openhrm(<%=viewresourceid %>);' onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(viewresourceid),Language)%></a></td>
          <td width="150" style="padding-left: 0px" <%if(tolrows%2==0){%>bgcolor="#e7e7e7"<%}else{%>bgcolor="#f5f5f5"<%}%>><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(viewjobtitle),Language)%></td>
   <%
      itemeid="";

      for(int k=0;k<itemnums;k++){
          itemeid=(String)itemlist.get(k);
          if(tempitems.indexOf(itemeid)>-1 || itemlist1.indexOf(itemeid)>-1){
   %>
          <td width="100" style="padding-left: 0px" align="right" <%if(tolrows%2==0){%>bgcolor="#e7e7e7"<%}else{%>bgcolor="#f5f5f5"<%}%>><%=itemsalarylist[k].get(j)%></td>
   <%
           }else{
   %>
          <td width="100" style="padding-left: 0px" align="right" <%if(tolrows%2==0){%>bgcolor="#e7e7e7"<%}else{%>bgcolor="#f5f5f5"<%}%>>&nbsp;</td>
   <%
           }
      }
   %>
          <td width="100" style="padding-left: 0px" <%if(tolrows%2==0){%>bgcolor="#e7e7e7"<%}else{%>bgcolor="#f5f5f5"<%}%>><%if(((String)statuslist.get(j)).equals("1")){%><%=SystemEnv.getHtmlLabelName(19558,Language)%><%}else{%><font color="red"><%=SystemEnv.getHtmlLabelName(19557,Language)%></font><%}%></td>
      </tr>
   <%
      }
      %>
    </table>
<%
       }
      %>
