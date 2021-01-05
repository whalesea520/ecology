<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.definedfield.HrmFieldManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.hrm.tools.HrmValidate" %>

<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session" />
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="PortalUtil" class="weaver.rdeploy.portal.PortalUtil" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();//账号类型
//默认显示的字段 其余都隐藏
List<String> lsFieldShow = new ArrayList<String>();
lsFieldShow.add("id");
lsFieldShow.add("lastname");
if(!PortalUtil.isuserdeploy()) {
	lsFieldShow.add("subcompanyid1");
}
lsFieldShow.add("departmentid");
lsFieldShow.add("managerid");
lsFieldShow.add("telephone");
lsFieldShow.add("mobile");

String tempstr = Util.null2String(request.getSession().getAttribute("hrmSearchTmpStr")) ;
String backfields = "*";
String sqlWhere = " "+tempstr;
String fromSql  = "";
String orderby = " dsporder,lastname" ;
String tableString = "";
String  operateString= "";

String tabletype="checkbox";
operateString = "<operates width=\"8%\">";
if(HrmValidate.hasEmessage(user)){
	operateString +="     <operate href=\"javascript:sendEmessage();\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(127379,user.getLanguage())+"\"  index=\"5\"/>";
}
if(HrmListValidate.isValidate(19)){
	operateString +="			<operate href=\"/email/new/MailInBox.jsp\"  linkkey=\"opNewEmail=1&amp;isInternal=1&amp;internalto\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(2051,user.getLanguage())+"\" target=\"_fullwindow\" isalwaysshow='true' index=\"0\"/>";
}if(HrmListValidate.isValidate(31)){
	operateString +="     <operate href=\"/sms/SmsMessageEdit.jsp\" text=\""+SystemEnv.getHtmlLabelName(16635,user.getLanguage())+"\" linkkey=\"hrmid\" linkvaluecolumn=\"id\" target=\"_fullwindow\" isalwaysshow='true' index=\"1\"/>";
}if(HrmListValidate.isValidate(32)){
	operateString +="     <operate href=\"javascript:doAddWorkPlanByHrm();\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(18481,user.getLanguage())+"\" target=\"_fullwindow\" isalwaysshow='true' index=\"2\"/>";
}if(HrmListValidate.isValidate(33)){
	operateString +="     <operate href=\"/cowork/AddCoWork.jsp\" linkkey=\"hrmid\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(18034,user.getLanguage())+"\" target=\"_fullwindow\" isalwaysshow='true' index=\"3\"/>";
}if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)){
	operateString +="     <operate href=\"javascript:jsHrmResourceSystemView();\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(15804,user.getLanguage())+"\" target=\"_fullwindow\" index=\"4\"/>";
}
operateString +="</operates>";
int[] scopeIds;
String pageId = "";
if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)){
	scopeIds= new int[]{-1,1,3};
	pageId = PageIdConst.HRM_ResourceSearchResultByManager;
}else{
	scopeIds= new int[]{-1};
	pageId = PageIdConst.HRM_ResourceSearchResult;
}

LinkedHashMap<String,String> ht = new LinkedHashMap<String,String>();
HrmFieldManager hfm = null;
String[] backfield = new String[]{"id as t1_id","id as t2_id","id as t3_id"};

for(int i=0;i<scopeIds.length;i++){
	int scopeId=scopeIds[i];
	hfm = new HrmFieldManager("HrmCustomFieldByInfoType",scopeId);
	hfm.getCustomFields();
	while(hfm.next()){
  	if(!hfm.isUse())continue;
  	if(hfm.getHtmlType().equals("6"))continue;//屏蔽附件上传
  	if(hfm.getFieldname().equals("loginid")){
    	if(!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))continue;
  	}
  	if(hfm.isBaseField(hfm.getFieldname())){
  		ht.put(hfm.getFieldname(),hfm.getLable());
  		continue;
  	}
  	if(backfield[i].length()>0)backfield[i]+=",";
  	if(hfm.getFieldname().indexOf("field")!=-1){
    	backfield[i]+=hfm.getFieldname()+" as t"+i+"_"+hfm.getFieldname();
  	}else{
    	backfield[i]+=hfm.getFieldname();
  	}
  	if(ht.get(hfm.getFieldname())==null)ht.put("t"+i+"_"+hfm.getFieldname(),hfm.getLable());
	}
}
//增加后台未开放定义，但是需要显示的列
if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)){
	ht.put("seclevel","683");
}
fromSql  = " from HrmResource " 
 								+ " left join (SELECT "+backfield[0]+" FROM cus_fielddata WHERE scope='HrmCustomFieldByInfoType' AND scopeId=-1) t1 on hrmresource.id=t1_id "
								+ " left join (SELECT "+backfield[1]+" FROM cus_fielddata WHERE scope='HrmCustomFieldByInfoType' AND scopeId=1) t2 on hrmresource.id=t2_id"
								+ " left join (SELECT "+backfield[2]+" FROM cus_fielddata WHERE scope='HrmCustomFieldByInfoType' AND scopeId=3) t3 on hrmresource.id=t3_id ";
tableString = "";
orderby = " hrmresource.dsporder,hrmresource.lastname" ;
StringBuffer colString = new StringBuffer();
Iterator iter = ht.entrySet().iterator();
int count = 0;
while (iter.hasNext()) {
	Map.Entry entry = (Map.Entry) iter.next();
	String fieldname = ((String)entry.getKey()).toLowerCase();
	String fieldlabel = (String)entry.getValue();
	String display = lsFieldShow.contains(fieldname)?"true":"false";
	if(fieldname.equals("accounttype")&&flagaccount){
		colString.append("<col width=\"10%\" display=\""+display+"\" labelid=\""+fieldlabel+"\" text=\""+SystemEnv.getHtmlLabelNames(fieldlabel,user.getLanguage())+"\" column=\"accounttype\" transmethod=\"weaver.general.AccountType.getAccountType\" otherpara=\""+user.getLanguage()+"\" />");                 
	}else if(fieldname.equals("lastname")){
		colString.append("<col width=\"10%\" labelid=\"547\"  text=\""+SystemEnv.getHtmlLabelName(547,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.isOnline\" />");
		colString.append("<col width=\"10%\" display=\""+display+"\" labelid=\""+fieldlabel+"\" text=\""+SystemEnv.getHtmlLabelNames(fieldlabel,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" linkvaluecolumn=\"id\"  linkkey=\"id\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmResource\" target=\"_fullwindow\" />");
	}else if(fieldname.equals("sex")){
		colString.append("<col width=\"10%\" display=\""+display+"\" labelid=\""+fieldlabel+"\"  text=\""+SystemEnv.getHtmlLabelNames(fieldlabel,user.getLanguage())+"\" column=\"sex\" orderkey=\"sex\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getSexName\" otherpara=\""+user.getLanguage()+"\"/>");
	}else if(fieldname.equals("departmentid")){
	    if(!PortalUtil.isuserdeploy()) {
			colString.append("<col width=\"10%\" labelid=\"141\"  text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"subcompanyid1\" orderkey=\"subcompanyid1\"  href=\"/hrm/company/HrmDepartment.jsp\"  linkkey=\"subcompanyid\" target=\"_fullwindow\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />");
	    }
		colString.append("<col width=\"10%\" labelid=\""+fieldlabel+"\"  text=\""+SystemEnv.getHtmlLabelNames(fieldlabel,user.getLanguage())+"\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" linkkey=\"id\" href=\"/hrm/company/HrmDepartmentDsp.jsp?hasTree=false\" target=\"_fullwindow\" />");
	}else if(fieldname.equals("managerid")){
		colString.append("<col width=\"10%\" display=\""+display+"\" labelid=\""+fieldlabel+"\"  text=\""+SystemEnv.getHtmlLabelNames(fieldlabel,user.getLanguage())+"\" column=\"managerid\" orderkey=\"managerid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" linkvaluecolumn=\"managerid\"  linkkey=\"id\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmResource\" target=\"_fullwindow\" />");
	}else if(fieldname.equals("jobtitle")){
		colString.append("<col width=\"10%\" display=\""+display+"\" labelid=\""+fieldlabel+"\"  text=\""+SystemEnv.getHtmlLabelNames(fieldlabel,user.getLanguage())+"\" column=\"jobtitle\" orderkey=\"jobtitle\" linkkey=\"id\"  transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitlesname\" href=\"/hrm/jobtitles/HrmJobTitlesEdit.jsp\" target=\"_fullwindow\"/>");
	}else if(fieldname.equals("mobile")){
		colString.append("<col width=\"10%\" display=\""+display+"\" labelid=\""+fieldlabel+"\" text=\""+SystemEnv.getHtmlLabelNames(fieldlabel,user.getLanguage())+"\" column=\"mobile\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMobileShow1\" otherpara=\"column:id+"+user.getUID()+"\"/>");
	}else if(fieldname.equals("status")){
		colString.append("<col width=\"10%\" display=\""+display+"\" labelid=\""+fieldlabel+"\" text=\""+SystemEnv.getHtmlLabelNames(fieldlabel,user.getLanguage())+"\" column=\"status\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getStatusName\" otherpara=\""+user.getLanguage()+"\"/>");
	}else if(fieldname.equals("jobactivity")){
		 colString.append("<col width=\"10%\" display=\""+display+"\" labelid=\"1915\" text=\""+SystemEnv.getHtmlLabelNames("1915",user.getLanguage())+"\" column=\"jobactivity\" transmethod=\"weaver.hrm.HrmTransMethod.getJobActivitiesname\" otherpara=\"column:jobtitle\"/>");
	}else if(fieldname.equals("seclevel")){
		 colString.append("<col width=\"10%\" display=\""+display+"\" labelid=\"683\" text=\""+SystemEnv.getHtmlLabelNames("683",user.getLanguage())+"\" column=\"seclevel\" />");
	}else{
		colString.append("<col width=\"10%\" display=\""+display+"\" labelid=\""+fieldlabel+"\"   text=\""+SystemEnv.getHtmlLabelNames(fieldlabel,user.getLanguage())+"\" column=\""+fieldname+"\" orderkey=\""+fieldname+"\" transmethod=\"weaver.hrm.HrmTransMethod.getDefineContent\" otherpara=\""+fieldname+":"+user.getLanguage()+"\"/>");
	}
}
tableString =" <table  tabletype=\""+tabletype+"\" pageId=\""+pageId+"\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),PageIdConst.HRM)+"\" >"+
"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"hrmresource.id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
operateString+
"			<head>"
+colString.toString()
+ "			</head>"
+ " </table>";
String sql = "SELECT " + backfields + " " + fromSql + " " + sqlWhere + " ORDER BY " + orderby;
request.getSession().setAttribute("HrmResourceSearchResultExcelSql",sql);
%>
<script>
function exportExcel()
{
  document.getElementById("excels").src = "HrmResourceSearchResultExcel.jsp?export=true";
}

function doAddWorkPlanByHrm(id) {
	openFullWindowForXtable("/workplan/data/WorkPlan.jsp?resourceid="+id+"&add=1")	
}
</script>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
