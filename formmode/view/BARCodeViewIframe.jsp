<%@page import="weaver.common.DateUtil"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FormModeTransMethod" class="weaver.formmode.search.FormModeTransMethod" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>


<%
String modeid = Util.null2String(request.getParameter("modeId"));
String formid = Util.null2String(request.getParameter("formId"));
String customid = Util.null2String(request.getParameter("customId"));
String billids = Util.null2String(request.getParameter("billId"));
 
float levelspacing = 0;
float verticalspacing = 0;
int numberrows = 0;
int numbercols = 0;

String info = "";
rs.executeSql("select * from mode_barcode where modeid="+modeid);
if (rs.next()) {
	info = rs.getString("info");
	levelspacing = Util.getFloatValue(rs.getString("levelspacing"),0);
	verticalspacing = Util.getFloatValue(rs.getString("verticalspacing"),0);
	numberrows = Util.getIntValue(rs.getString("numberrows"),0);
	numbercols = Util.getIntValue(rs.getString("numbercols"),0); 
}
info = FormModeTransMethod.getDefaultSqlToName(user,info);
boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formid);
String vdatasource = "";
String vprimarykey = "";
if(isVirtualForm){
	Map<String,Object> vFormInfo = VirtualFormHandler.getVFormInfo(formid);
	vdatasource = Util.null2String(vFormInfo.get("vdatasource"));
	vprimarykey = Util.null2String(vFormInfo.get("vprimarykey"));	//虚拟表单主键列名称
}
String tablename = "";
String sqlStr = "select tablename from workflow_bill where id="+formid;
RecordSet.executeSql(sqlStr);
if (RecordSet.next()) {
	tablename = Util.null2String(RecordSet.getString("tablename"));
}

String elSpacingStyle = "";
if(levelspacing > 0){
	elSpacingStyle += "margin-right:" + levelspacing + "cm;";
}
if(verticalspacing > 0){
	elSpacingStyle += "margin-bottom:" + verticalspacing + "cm;";
}
String splitLineDiv = "<div class='splitLine'></div>";
String pageBreakDiv = "<div class='pageBreak'></div>";
%>
<html>
<head>
<style>
	body{
		text-align:center;
	}
	table{
		border-spacing:0px;
	}
	.elBaseClass{
		display:inline-block;
	}
	.elSpacingClass{
		<%=elSpacingStyle%>
	}
	.splitLine{
		height:0px;
	}
	.pageBreak{
		page-break-after: always;
	}
</style>
</head>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:doPrint(),_self} " ;//打印
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div style="display:inline-block;text-align:left;">
		   <%
		   if(!billids.equals("")){
			   String[] billid =  billids.split(",");
			   String usercode = "";
			   recordSet.executeSql("SELECT workcode FROM hrmresource where id='"+user.getUID()+"'");
			   if(recordSet.next()){
				   usercode = Util.null2String(recordSet.getString("workcode"));
			   }
			   info = Util.replaceString2(info, "\\$formid\\$", formid);
			   /**
			   info = Util.replaceString2(info, "\\$UserId\\$", user.getLastname()+"");
			   info = Util.replaceString2(info, "\\$UserCode\\$", usercode);
			   info = Util.replaceString2(info, "\\$DepartmentId\\$", user.getUserDepartment()+"");
			   info = Util.replaceString2(info, "\\$SubcompanyId\\$", user.getUserSubCompany1()+"");
			   info = Util.replaceString2(info, "\\$date\\$", DateUtil.getCurrentDate());
			   String allDeptId = user.getUserDepartment()+"";
			   String sql = "select id from HrmDepartment where supdepid="+user.getUserDepartment();
			   recordSet.executeSql(sql);
			   while(recordSet.next()){
					String childDeptid =  Util.null2String(recordSet.getString(1));
					allDeptId += ","+childDeptid;
				}
				info = Util.replaceString2(info, "\\$AllDepartmentId\\$", allDeptId);
				
				String allSubCompanyId = user.getUserSubCompany1()+"";
				sql = "select id from HrmsubCompany where supsubcomid ="+ user.getUserSubCompany1();
				recordSet.executeSql(sql);
				while(recordSet.next()){
					String SubCompanyid =  Util.null2String(recordSet.getString(1));
					allSubCompanyId += ","+SubCompanyid;
				}
				info = Util.replaceString2(info, "\\$AllSubcompanyId\\$", allSubCompanyId);
				 */
				int rows = 0;
				int cols = 0;
				for(int i=0;i<billid.length;i++){
					String tempinfo = info;
					String requestid = "0";
					String datesql ="select * from "+tablename +" where id='"+billid[i]+"'";
					RecordSet.executeSql(datesql);
					while(RecordSet.next()){
					   	tempinfo = Util.replaceString2(tempinfo, "\\$billid\\$", billid[i]);
					    tempinfo = Util.replaceString2(tempinfo, "\\$modeid\\$", modeid);
					   requestid = RecordSet.getString("requestId");
					   info = Util.replaceString2(info, "\\$requestId\\$", requestid);
						RecordSet RecordSetfield = new RecordSet();
						String fieldsql = "select * from workflow_billfield where billid="+formid;
						RecordSetfield.executeSql(fieldsql);
						while(RecordSetfield.next()){
							int fieldid = RecordSetfield.getInt("id");
							String fieldhtype = RecordSetfield.getString("fieldhtmltype");
							String type = RecordSetfield.getString("type");
							String fielddbtype = RecordSetfield.getString("fielddbtype");
							String fieldname = RecordSetfield.getString("fieldname");
							int viewtype = RecordSetfield.getInt("viewtype");
							if(("2".equals(fieldhtype)&&"2".equals(type))||"".equals(Util.match(info, "\\$"+fieldname+"\\$", false))){
								continue;
							}
							String fieldvalue = RecordSet.getString(fieldname);
							String paraTwo = (isVirtualForm?vprimarykey:"id") + "+" + fieldid + "+" + fieldhtype + "+" + type + "+" + user.getLanguage() + "+" + "1" + "+" + fielddbtype + "+" + "+" +  modeid + "+" + 
													formid + "+" + viewtype + "+" + "3" + "+" + customid + "+fromsearchlist";
							String showname = FormModeTransMethod.getOthersNoTitle(fieldvalue, paraTwo);
							tempinfo = Util.replaceString2(tempinfo, "\\$"+fieldname+"\\$", showname);
						
						}
					}
					double randomnum = Math.random();
					String imageUrl = "<img alt=''  src='/weaver/weaver.formmode.servelt.BARcodeBuildAction?modeid="+modeid+"&formid="+formid+"&billid="+billid[i]+"&customid="+customid+"&randomnum="+randomnum+"'>";
					tempinfo = tempinfo.replaceAll("#BARCodeImg#",imageUrl);				  
					%>
				    <div class="elBaseClass elSpacingClass"><%=tempinfo%></div>
					<%
					cols++;
					if(numberrows == 0){
						if(numbercols == 0){
							out.print(splitLineDiv);
						}else if(cols%numbercols == 0){
							out.print(splitLineDiv);
							cols = 0;
						}
					}else{
						if(numbercols == 0){
							out.print(splitLineDiv);
							rows++;
						}else if(cols%numbercols == 0){
							out.print(splitLineDiv);
							cols = 0;
							rows++;
							if(rows%numberrows == 0){
								out.print("</div>");
								if(i < billid.length - 1){
									out.print(pageBreakDiv);
									out.print("<div style='display:inline-block;text-align:left;'>");
								}
							}
						}
					}
		   		}
		   }
		   %>
</div>
</body>
</html>
<script type="text/javascript">
function doPrint() {
	hideRightClickMenu();
	window.print();
}
</script>