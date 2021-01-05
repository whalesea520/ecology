
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.util.*" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

/*
 * QC:256124
 * 解决新建名称重复有效性检查可以通过
 * SJZ 2017-03-16
 *
 * BEGIN
 */
String setname = Util.null2String(request.getParameter("setname"));//名称
String viewid = Util.null2String(request.getParameter("viewid"));//keyid

if(!setname.isEmpty()) {
	String checkNameExistSql = "select 1 from outerdatawfset where setname = '" + setname + "'";
	if (!viewid.isEmpty()) {
		checkNameExistSql += " and id != '" + viewid + "'";
	}

	RecordSet rs = new RecordSet();
	boolean bool = rs.executeSql(checkNameExistSql);

	if (!bool || rs.next()) {
		out.println("-2"); //名称重复返回代码
		return;
	}
} else {
    out.println("-3"); //名称必填
	return;
}
// END


String operate = Util.null2String(request.getParameter("operate"));
String typename = Util.null2String(request.getParameter("typename"));
String workFlowId = Util.null2String(request.getParameter("workFlowId"));//流程id
String datasourceid = Util.null2String(request.getParameter("datasourceid"));//数据源
String outermaintable = Util.null2String(request.getParameter("outermaintable"));//外部主表
String outermainwhere = Util.null2String(request.getParameter("outermainwhere"));//外部主表条件
String datarecordtype = Util.null2String(request.getParameter("datarecordtype"));//
String datarecordtable = Util.null2String(request.getParameter("datarecordtable"));//
String keyfield = Util.null2String(request.getParameter("keyfield"));//
String requestid = Util.null2String(request.getParameter("requestid"));//
String FTriggerFlag = Util.null2String(request.getParameter("FTriggerFlag"));//
String FTriggerFlagValue = Util.null2String(request.getParameter("FTriggerFlagValue"));//
if("".equals(keyfield))
	keyfield = "id";
if("2".equals(datarecordtype))
{
	if("".equals(requestid))
		requestid = "requestid";
	if("".equals(FTriggerFlag))
		FTriggerFlag = "FTriggerFlag";
}
outermaintable = Util.replace(outermaintable,"'","''",0);
keyfield = Util.replace(keyfield,"'","''",0);
requestid = Util.replace(requestid,"'","''",0);
FTriggerFlag = Util.replace(FTriggerFlag,"'","''",0);
FTriggerFlagValue = Util.replace(FTriggerFlagValue,"'","''",0);
//System.out.println("datasourceid : "+datasourceid);
RecordSetDataSource rs = new RecordSetDataSource(datasourceid);
String sql = "";
if("2".equals(datarecordtype)||"".equals(datarecordtype))
{
	sql = "select "+keyfield+","+requestid+","+FTriggerFlag+" from "+outermaintable;
}
else
{
	sql = "select "+keyfield+" from "+outermaintable;
}
if(!"".equals(outermainwhere))
{
	sql += " "+outermainwhere+" and 1=2 ";
}
else
{
	sql += " where 1=2 ";
}
//System.out.println("test : "+sql);
boolean issuccess = rs.executeSql(sql);
String result = "-1";
if(issuccess)
{
	//System.out.println("issuccess : "+issuccess);
	int detailcount = Util.getIntValue(Util.null2String(request.getParameter("detailcount")),0);//明细数量
	for(int i=0;i<detailcount;i++){
	    String tempouterdetailname = Util.null2String(request.getParameter("outerdetailname"+i));
	    String tempouterdetailwhere = Util.null2String(request.getParameter("outerdetailwhere"+i));
	    if(!tempouterdetailname.equals(""))
	    {
	    	sql = "select 1 from "+outermaintable+","+tempouterdetailname;
	    	
	    	if(!tempouterdetailwhere.equals(""))
	    	{
	    		sql += " "+tempouterdetailwhere;
	    	}
	    	else
	    		sql += " where 1=2 ";
	    	
	    	issuccess = rs.executeSql(sql);
	    	if(issuccess)
	    	{
	    		continue;
	    	}
	    	else
	    	{
	    		result = ""+(i+1);
	    		break;
	    	}
	    }
	}
}
else
{
	result = "0";
}
out.println(""+result);
%>