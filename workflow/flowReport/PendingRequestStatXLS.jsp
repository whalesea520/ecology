
<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="WorkflowVersion" class="weaver.workflow.workflow.WorkflowVersion" scope="page" />
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<HTML><HEAD>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style>
<!--
TABLE.ListStyle {
	width: "100%";
	BACKGROUND-COLOR: #FFFFFF;
	BORDER-Spacing: 1pt;
}

TABLE.ListStyle TR.Header {
	COLOR: #FFFFFF;
	BACKGROUND-COLOR: #808080;
	HEIGHT: 40px;
	FONT-WEIGHT: BOLD;
}

TABLE.ListStyle TR.Obj {
	COLOR: #FFFFFF;
	BACKGROUND-COLOR: #538DD5;
}

TABLE.ListStyle TR.Obj TD.ObjName {
	FONT-WEIGHT: BOLD;
}

TABLE.ListStyle TR TD.Flowtype {
	COLOR: #538DD5;
}

TABLE.ListStyle TR.Total {
	BACKGROUND-COLOR: #EBF1DE;
}

TABLE.ListStyle TH,TABLE.ListStyle TD {
	VERTICAL-ALIGN: MIDDLE;
}
-->
</style>
</head>

<BODY>
<%
response.setContentType("application/vnd.ms-excel");
	User user = HrmUserVarify.getUser (request , response) ;
	String titlename = SystemEnv.getHtmlLabelName(19028,user.getLanguage()) ; 
	response.setHeader("Content-disposition","attachment;filename="+new String(titlename.getBytes("gbk"),"iso8859-1")+".xls");
	if(user == null)  return ;
	String imagefilename = "/images/hdReport_wev8.gif" ; 
	String needfav = "1" ;
	String needhelp = "" ; 
	String objType=SystemEnv.getHtmlLabelName(1867,user.getLanguage());
	int objType1=Util.getIntValue(request.getParameter("objType"),2);
	String objIds=Util.null2String(request.getParameter("objId"));
	if(null == objIds || "".equals(objIds)){
	    objIds = (String)session.getAttribute("objIds");
	}
	String sqlCondition=" ";  //未查询前不显示记录

	String sql="";
	
	String userRights=ReportAuthorization.getUserRights("-2",user);//得到用户查看范围
	   if (userRights.equals("-100")){
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
    }

	String datefrom = Util.toScreenToEdit(request.getParameter("datefrom"),user.getLanguage());
	String dateto = Util.toScreenToEdit(request.getParameter("dateto"),user.getLanguage());
	String wfIds = Util.null2String(request.getParameter("wfId"));
	//String exportpara = "objType="+objType1+"&objId="+objIds+"&objNames="+objNames+"&wfNames="+wfNames+"&datefrom="+wfNames+"&dateto="+dateto+"&wfId="+wfIds+"&isthisWeek="+isthisWeek+"&isthisMonth="+isthisMonth+"&isthisSeason="+isthisSeason+"&isthisYear="+isthisYear;

	String newwhere = "";
	if(!datefrom.equals("")){//开始日期

		newwhere = " workflow_currentoperator.receivedate >= '" + datefrom + "'";//workflow_currentoperator.receivedate,workflow_currentoperator.receivetime
	}
	if(!dateto.equals("")){//结束日期
		if(!newwhere.equals("")) newwhere += " and ";
		newwhere += " workflow_currentoperator.receivedate <= '" + dateto + "' ";
	}

	String devfromdate = Util.null2String(request.getParameter("devfromdate"));
	String devtodate = Util.null2String(request.getParameter("devtodate"));	
	if(!"".equals(devfromdate)) {
		sqlCondition += " and exists (select 1 from workflow_requestbase where requestid = workflow_currentoperator.requestid and createdate >='"+devfromdate+"')";
	}
	if(!"".equals(devtodate)) {
		sqlCondition += " and exists (select 1 from workflow_requestbase where requestid = workflow_currentoperator.requestid and createdate <='"+devtodate+"')";
	}
	
	String typeId=Util.null2String(request.getParameter("typeId"));//得到搜索条件
	if (!typeId.equals("")){
		if (!newwhere.equals(""))
			newwhere += " and ";
		newwhere += "  workflow_currentoperator.workflowtype=" + typeId;
	}
	
    ArrayList users=new ArrayList();
    ArrayList wftypes=new ArrayList();
	ArrayList wftypecounts=new ArrayList();
	ArrayList workflows=new ArrayList();
	ArrayList workflowcounts=new ArrayList();     //总计
	ArrayList temp=new ArrayList();     
    ArrayList newremarkwfcounts0=new ArrayList(); 
    ArrayList wftypecounts0=new ArrayList(); 
    ArrayList wfUsers=new ArrayList(); 
    ArrayList flowUsers=new ArrayList();
    if (userRights.equals(""))
    {sqlCondition+=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
    }
    else
    {sqlCondition+=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
    }
    		
     String sql2="";
	String sqlfrom="";
	
	switch (objType1){
	        case 1:
	        objType=SystemEnv.getHtmlLabelName(179,user.getLanguage());
	        sql="select userid,workflowtype, workflowid,"+
			   	 " count(distinct requestid) workflowcount from "+
				 " workflow_currentoperator where "+
				(wfIds.equals("")?"":"workflowid in (" + wfIds + ") and ")+(newwhere.equals("")?"":newwhere+" and ")+
			     "  workflowtype > 0 and isremark in ('0','1','5','7','8','9') and islasttimes=1 and  usertype='0' " ;
			sql += " and ("+Util.getSubINClause(objIds,"userid","in")+")";
			sqlfrom="workflow_currentoperator,workflow_requestbase a";
			sql2=" where workflow_currentoperator.workflowtype>0 and workflow_currentoperator.isremark in ('0','1','5','7','8','9') and workflow_currentoperator.islasttimes=1 and  workflow_currentoperator.usertype='0'  and workflow_currentoperator.requestid=a.requestid" ;
			sql2+=(wfIds.equals("")?"":" and workflow_currentoperator.workflowid in (" + wfIds + ") ");
			sql2+=(newwhere.equals("")?"":" and "+newwhere);
			sql2+=sqlCondition;
			sql+=sqlCondition;   
	        sql+=" group by userid,workflowtype, workflowid ";
	        sql+= " order by userid,workflow_currentoperator.workflowtype, workflowid";
	        break;
	        case 2:
	        sql="select a.departmentid,workflowtype, workflowid,"+
			    " count(distinct requestid) workflowcount from "+
			    " workflow_currentoperator ,hrmresource a  where "+
				(wfIds.equals("")?"":"workflowid in (" + wfIds + ") and ")+(newwhere.equals("")?"":newwhere+" and ")+
			    "  workflowtype > 0 and isremark in ('0','1','5','7','8','9') and  usertype='0' and islasttimes=1 and  a.id=workflow_currentoperator.userid " ;
	        sql+=" and a.departmentid in ("+objIds+")"  ; 
	        sql+=sqlCondition;
			sqlfrom="workflow_currentoperator,hrmresource b ,workflow_requestbase a";
			sql2="where workflow_currentoperator.workflowtype>0 and workflow_currentoperator.isremark in ('0','1','5','7','8','9') and workflow_currentoperator.islasttimes=1 and  workflow_currentoperator.usertype='0'  and b.id=workflow_currentoperator.userid and workflow_currentoperator.requestid=a.requestid" ;
			sql2+=(wfIds.equals("")?"":" and workflow_currentoperator.workflowid in (" + wfIds + ") ");
			sql2+=(newwhere.equals("")?"":" and "+newwhere);
			sql2+=sqlCondition;
	        sql+=" group by a.departmentid,workflowtype, workflowid ";
	        sql+= " order by a.departmentid,workflow_currentoperator.workflowtype, workflowid";
	        objType=SystemEnv.getHtmlLabelName(124,user.getLanguage());
	        break;
	        case 3:
	        sql="select a.subcompanyid1,workflowtype, workflowid,"+
			    " count(distinct requestid) workflowcount from "+
			    " workflow_currentoperator ,hrmresource a  where "+
				(wfIds.equals("")?"":"workflowid in (" + wfIds + ") and ")+(newwhere.equals("")?"":newwhere+" and ")+
			    "  workflowtype > 0 and isremark in ('0','1','5','7','8','9') and islasttimes=1 and  usertype='0' and a.id=workflow_currentoperator.userid " ;
	        sql+=" and a.subcompanyid1 in ("+objIds+")"  ;
	        sql+=sqlCondition;

			sqlfrom="workflow_currentoperator,hrmresource b ,workflow_requestbase a";
			sql2=" where workflow_currentoperator.workflowtype>0 and workflow_currentoperator.isremark in ('0','1','5','7','8','9') and workflow_currentoperator.islasttimes=1 and  workflow_currentoperator.usertype='0'  and b.id=workflow_currentoperator.userid and workflow_currentoperator.requestid=a.requestid" ;
			sql2+=(wfIds.equals("")?"":" and workflow_currentoperator.workflowid in (" + wfIds + ") ");
			sql2+=(newwhere.equals("")?"":" and "+newwhere);
			sql2+=sqlCondition;

	        sql+=" group by a.subcompanyid1,workflowtype, workflowid ";
	        sql+= " order by a.subcompanyid1,workflow_currentoperator.workflowtype, workflowid"; 
	        objType=SystemEnv.getHtmlLabelName(141,user.getLanguage());
	        break;
	}
   if (!"".equals(objIds)){
   RecordSet.executeSql(sql);
   int addindex = 0;
	while(RecordSet.next()){       
        String theworkflowid = Util.null2String(RecordSet.getString("workflowid")) ;
        String objId=Util.null2String(RecordSet.getString(1)) ;        
        String theworkflowtype = Util.null2String(RecordSet.getString("workflowtype")) ;
		int theworkflowcount = Util.getIntValue(RecordSet.getString("workflowcount"),0) ;
		theworkflowid = WorkflowVersion.getActiveVersionWFID(theworkflowid);
        if(WorkflowComInfo.getIsValid(theworkflowid).equals("1")){
            int userIndex=users.indexOf(objId);
            int wfindex = workflows.indexOf(objId+","+theworkflowid);
            if(wfindex != -1) {
	     		String beforecount[] = newremarkwfcounts0.get(wfindex).toString().split(",");
                int wfCount  = Util.getIntValue(beforecount[2]) + theworkflowcount;	                
                //System.out.println("===========================>theworkflowid= "+ theworkflowid + ", " +beforecount[1] + ":"+ beforecount[2]);
                //System.out.println("===========================>workflows= "+ workflows + ", newremarkwfcounts0=" +newremarkwfcounts0 + ", wfindex="+ wfindex + ", addindex="+ addindex + "\n\n");
                //System.out.println("========================workflows= " + workflows + "\n\n\n");
            	newremarkwfcounts0.set(wfindex, objId+","+theworkflowid+","+wfCount);
            }else{
                workflows.add(objId+","+theworkflowid);
                newremarkwfcounts0.add(objId+","+theworkflowid+","+theworkflowcount);
            }
            flowUsers.add(objId);	
            int wftindex = wftypes.indexOf(theworkflowtype) ;
            int tempIndex=temp.indexOf(objId+"$"+theworkflowtype);
            if (userIndex!=-1)
            { 
            
            workflowcounts.set(userIndex,""+(Util.getIntValue((String)workflowcounts.get(userIndex),0)+theworkflowcount)) ;
            if(tempIndex != -1) {
            wftypecounts.set(tempIndex,""+(Util.getIntValue((String)wftypecounts.get(tempIndex),0)+theworkflowcount)) ;
            }
            else {
            temp.add(objId+"$"+theworkflowtype); 
            wftypes.add(theworkflowtype) ;
            wfUsers.add(objId);
            wftypecounts.add(""+theworkflowcount) ;
             
            }
            }
            else
            {
            temp.add(objId+"$"+theworkflowtype);
            users.add(objId);
            workflowcounts.add(""+theworkflowcount) ;  
            wftypes.add(theworkflowtype) ;
            wfUsers.add(objId);
            wftypecounts.add(""+theworkflowcount) ;
            }
           
        }
	}
	}
%>




<TABLE class=ListStyle cellspacing=1 border="1">
<!--详细内容在此-->
    <COLGROUP/> 
  <col width="80%"> 
  <col align=right width="20%">
<TR class=Header> 
<td><%=objType%>-<%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(26361,user.getLanguage())%></td>
<td><%=SystemEnv.getHtmlLabelNames("1207,16851",user.getLanguage())%></td>
</tr>
</table>

<TABLE class=ListStyle cellspacing=1 border="1">
<!--详细内容在此-->
     <COLGROUP/> 
  <col width="80%"> 
  <col align=right width="20%">
  <%
	int total = 0;
	if (!"".equals(objIds)) {
  	for (int i=0;i<users.size();i++) {
		total += Util.getIntValue("" + workflowcounts.get(i), 0);
	}
	%>
	<tr align=right class=Total>
		<TD>
			<%=SystemEnv.getHtmlLabelName(523, user.getLanguage())%>
		</TD>
		<TD><%=total%></TD>
	</tr>
	<%}%>
<%
if (!"".equals(objIds))
{
	List tmpList=null;
	Map[] dataMap=new HashMap[users.size()];
	String chartTitle=null;
for (int i=0;i<users.size();i++)
{
	String sql3=""; 
	String userId=""+users.get(i);
	tmpList=new ArrayList();
	dataMap[i]=new HashMap();
%>
<tr class=Obj>
<td class=ObjName>
<%
switch (objType1){
case 1:
	    sql3=sql2+" and workflow_currentoperator.userid="+users.get(i)  ;
		out.print(resourceComInfo.getLastname(""+users.get(i)));
		chartTitle=resourceComInfo.getLastname(""+users.get(i));
		break;
case 2:
	    sql3=sql2+" and  b.departmentid="+users.get(i)  ;
		out.print(DepartmentComInfo.getDepartmentname(""+users.get(i)));
		chartTitle=DepartmentComInfo.getDepartmentname(""+users.get(i));
		break;
case 3:
		sql3=sql2+" and  b.subcompanyid1="+users.get(i)  ;
		out.print(SubCompanyComInfo.getSubCompanyname(""+users.get(i)));
		chartTitle=SubCompanyComInfo.getSubCompanyname(""+users.get(i));
		break;				
}%></td>
<td><%=workflowcounts.get(i)%></td>
</tr>
<%
for (int j=0;j<wftypes.size();j++) {
String tempObjId=""+wfUsers.get(j);
String wfId=""+wftypes.get(j);
if (!tempObjId.equals(userId)) continue;
/*****************************/
dataMap[i].put(WorkTypeComInfo.getWorkTypename(wfId),wftypecounts.get(j).toString());
tmpList.add(WorkTypeComInfo.getWorkTypename(wfId));
/*****************************/
%>
<tr>
<td class=FlowType>&nbsp;&nbsp;&nbsp;<%=WorkTypeComInfo.getWorkTypename(wfId)%></td>
<td><%=wftypecounts.get(j)%></td>
</tr>

<%
//for (int k=0;k<workflows.size();k++) {
//String curtypeid=WorkflowComInfo.getWorkflowtype(""+workflows.get(k));
//String tempUser=""+flowUsers.get(k);
//if(!curtypeid.equals(wfId)||!tempUser.equals(userId))	continue;

for (int k = 0; k < workflows.size(); k++) {
	String wflowid = (String) workflows.get(k);
	String wfid01[] = wflowid.split(",");
	String wfisshow = wfid01[1];
	
	String curtypeid = WorkflowComInfo.getWorkflowtype("" + wfisshow);
	if(!curtypeid.equals(wfId) || !wfid01[0].equals(userId))
		continue;
	
	String wfcountisshow = "";
	for(int x=0;x<newremarkwfcounts0.size();x++){
		String wfcount01[] = newremarkwfcounts0.get(x).toString().split(",");
		if(!userId.equals(wfcount01[0]) || !wfisshow.equals(wfcount01[1]))
			continue;
			
		wfcountisshow = wfcount01[2];
	}
%>

<tr>
<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=WorkflowComInfo.getWorkflowname(""+wfisshow)%></td>
<td><%=wfcountisshow%></td>
</tr>

<%
  workflows.remove(k);
  flowUsers.remove(k);
  newremarkwfcounts0.remove(k);
  k--;
}
  wftypes.remove(j);
  wfUsers.remove(j);
  wftypecounts.remove(j);
  j--;
  
}
	}//Enf for.


}
%>
 <%
	if (!"".equals(objIds)) {
	%>
	<tr align=right class=Total>
		<TD>
			<%=SystemEnv.getHtmlLabelName(523, user.getLanguage())%>
		</TD>
		<TD><%=total%></TD>
	</tr>
	<%}%>
<!--详细内容结束-->


</TABLE>


</body></html>
