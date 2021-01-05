
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportShare" class="weaver.workflow.report.ReportShare" scope="page"/>
<%

char flag=Util.getSeparator();
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String reportid = Util.null2String(request.getParameter("reportid")); 
String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String seclevel2 = Util.null2String(request.getParameter("seclevel2"));
String sharelevel = Util.null2String(request.getParameter("sharelevel"));
String departmentids = Util.null2String(request.getParameter("departmentids"));
if(departmentids.equals(""))
	departmentids = Util.null2String(request.getParameter("muticompanyid"));
String dialog = Util.null2String(request.getParameter("dialog"));
String isBill = Util.null2String(request.getParameter("isBill"));
String allowlook = Util.null2String(request.getParameter("allowlook"));
String formID = Util.null2String(request.getParameter("formID"));

String userid = "0" ;
String departmentid = "0" ;
String subcompanyid="0";
String roleid = "0" ;
String foralluser = "0" ;
int crmid=0;

if(method.equals("delete"))
{

	RecordSet.executeProc("WorkflowReportShare_Delete",id);

	//ReportShare.setReportShareByReport(reportid);

	
    response.sendRedirect("ReportShare.jsp?id="+reportid+"&isBill="+isBill+"&formID="+formID);
}
if(method.equals("deleteAll")){
	String ids[]=Util.TokenizerString2(id,",");
	for(int i=0;i<ids.length;i++){
		RecordSet.executeProc("WorkflowReportShare_Delete",ids[i]);
	}
	//ReportShare.setReportShareByReport(reportid);
	response.sendRedirect("ReportShare.jsp?id="+reportid+"&isBill="+isBill+"&formID="+formID);
}

else if(method.equals("add"))
{
	if(!"".equals(relatedshareid)){
		String arrayshareids[]=Util.TokenizerString2(relatedshareid,",");
		for(int i=0;i<arrayshareids.length;i++){
			relatedshareid = arrayshareids[i];
			
			if(!relatedshareid.startsWith(",")&&!sharetype.equals("4"))
				relatedshareid = ","+relatedshareid;
			if(!relatedshareid.endsWith(",")&&!sharetype.equals("4"))
				relatedshareid = relatedshareid+",";
			if(sharetype.equals("1")) userid = relatedshareid ;
			if(sharetype.equals("3")) departmentid = relatedshareid ;
			if(sharetype.equals("2")) subcompanyid = relatedshareid ;
			if(sharetype.equals("4")) roleid = relatedshareid ;
			if(sharetype.equals("5")) foralluser = "1" ;
			if(sharetype.equals("6")){
				userid = relatedshareid;
				seclevel = Util.null2String(request.getParameter("joblevel"));//将岗位级别对应安全级别字段，0指定部门、1指定分部、2总部
				if(!seclevel.equals("2")){
					departmentid = Util.null2String(request.getParameter("relatedshareid_6"));//将岗位指定级别具体值存入部门对象字段
					if(!departmentid.startsWith(","))
						departmentid = ","+departmentid;
					if(!departmentid.endsWith(","))
						departmentid = departmentid+",";
				}
			}
			
			ProcPara = reportid;
			ProcPara += flag+sharetype;
			ProcPara += flag+seclevel;
			ProcPara += flag+seclevel2;
			ProcPara += flag+rolelevel;
			ProcPara += flag+sharelevel;
			ProcPara += flag+userid;
			ProcPara += flag+subcompanyid;
			ProcPara += flag+departmentid;
			ProcPara += flag+roleid;
			ProcPara += flag+foralluser;
			ProcPara += flag+"0" ;              //  crmid
		    ProcPara += flag+departmentids;              //增加多部门
		    ProcPara += flag+allowlook;
		    //System.out.println(ProcPara);
		    RecordSet.executeProc("WorkflowReportShare_Insert",ProcPara);
		}
	}else{
		ProcPara = reportid;
		ProcPara += flag+sharetype;
		ProcPara += flag+seclevel;
		ProcPara += flag+seclevel2;
		ProcPara += flag+rolelevel;
		ProcPara += flag+sharelevel;
		ProcPara += flag+userid;
		ProcPara += flag+subcompanyid;
		ProcPara += flag+departmentid;
		ProcPara += flag+roleid;
		ProcPara += flag+foralluser;
		ProcPara += flag+"0" ;              //  crmid
	    ProcPara += flag+departmentids;              //增加多部门
	    ProcPara += flag+allowlook;
	    //System.out.println(ProcPara);
	    RecordSet.executeProc("WorkflowReportShare_Insert",ProcPara);
	}

	//ReportShare.setReportShareByReport(reportid);
	//ReportShare.setRptRolByReport(reportid);
	if("1".equals(dialog)){
		response.sendRedirect("ReportShareAdd.jsp?isclose=1&id="+reportid+"&isBill="+isBill+"&formID="+formID);
	}else{
		response.sendRedirect("ReportShare.jsp?id="+reportid);
	}    
}
%>
