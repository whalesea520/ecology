<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><!--added by xwj for td2023 on 2005-05-20-->
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="crmComInfo1" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";
int isfirst = Util.getIntValue(request.getParameter("isfirst"), 0);
int iswaitdo= Util.getIntValue(request.getParameter("iswaitdo"),0) ;
String mothed = Util.null2String(request.getParameter("mothed"));
String isthisWeek = Util.null2String(request.getParameter("isthisWeek"));
String isthisMonth = Util.null2String(request.getParameter("isthisMonth"));
String isthisDep = Util.null2String(request.getParameter("isthisDep"));
String isSelf = Util.null2String(request.getParameter("isSelf"));
//out.print(Util.numtochinese("4341009009.12"));
int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;
String workflowid=Util.null2String(request.getParameter("workflowid"));
String isbill=WorkflowComInfo.getIsBill(workflowid);
String formID=WorkflowComInfo.getFormId(workflowid);
String workflowname = WorkflowComInfo.getWorkflowname(workflowid);
workflowname = Util.processBody(workflowname,user.getLanguage()+"");
String requestname = Util.null2String(request.getParameter("requestname"));
String requestlevel = Util.null2String(request.getParameter("requestlevel"));
String querys=Util.null2String(request.getParameter("query"));
String fromself =Util.null2String(request.getParameter("fromself"));
String fromselfSql =Util.null2String(request.getParameter("fromselfSql"));
String tablename = "workflow_form";
if(isbill.equals("1")){
	rs.executeSql("select tablename from workflow_bill where id = " + formID); // 查询工作流单据表的信息

	if (rs.next()){
		tablename = rs.getString("tablename");          // 获得单据的主表

	}		
}

//System.out.print("workflowid = " + workflowid);
//System.out.print("formID = " + formID);
//System.out.println("isbill = " + isbill);

String CurrentUser = Util.null2String((String)session.getAttribute("RequestViewResource")) ;

String userID = String.valueOf(user.getUID());
String logintype = ""+user.getLogintype();
int usertype = 0;

if(CurrentUser.equals("")) {
	CurrentUser = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
}
boolean superior = false;  //是否为被查看者上级或者本身

if(userID.equals(CurrentUser))
{
	superior = true;
}
else
{
	RecordSet.executeSql("SELECT * FROM HrmResource WHERE ID = " + CurrentUser + " AND (managerStr LIKE '%," + userID + ",%' OR managerStr LIKE '" + userID + ",%')");
	
	if(RecordSet.next())
	{
		superior = true;	
	}
}

Hashtable ids = new Hashtable();
Hashtable colnames = new Hashtable();
Hashtable opts = new Hashtable();
Hashtable values = new Hashtable();
Hashtable names = new Hashtable();
Hashtable opt1s = new Hashtable();
Hashtable value1s = new Hashtable();

String sqlwhere="";

sqlwhere="where t1.deleted<>1 and t1.requestid = t2.requestid and d.requestid=t1.requestid and t2.userid = "+CurrentUser+" and t2.usertype=" + usertype;
if("search".equals(mothed)){
	sqlwhere += " and t1.workflowid in ("+workflowid+") and islasttimes=1 ";
	//快捷查询
	Calendar now = Calendar.getInstance();
	String today=Util.add0(now.get(Calendar.YEAR), 4) +"-"+Util.add0(now.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(now.get(Calendar.DAY_OF_MONTH), 2) ;
	int year=now.get(Calendar.YEAR);
	int month=now.get(Calendar.MONTH);
	int day=now.get(Calendar.DAY_OF_MONTH);
	if("1".equals(isthisWeek)){
		int days=now.getTime().getDay();
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-days);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		sqlwhere +=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if("1".equals(isthisMonth)){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,1);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		sqlwhere +=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if("1".equals(isthisDep)){
		int departmentid = Util.getIntValue(ResourceComInfo.getDepartmentID(CurrentUser), 0);
		sqlwhere += " and t1.creater in (select id from hrmresource where departmentid="+departmentid+" )";
	}
	if("1".equals(isSelf)){
		sqlwhere += " and t1.creater="+CurrentUser+" ";
	}
	//下面开始自定义查询条件
String[] checkcons = request.getParameterValues("check_con");

if(checkcons!=null){

for(int i=0;i<checkcons.length;i++){

		String tmpid = ""+checkcons[i];
		String tmpcolname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_colname"));
		String htmltype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_htmltype"));
		String type = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_type"));
		String tmpopt = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt"));
		String tmpvalue = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value"));
		String tmpname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_name"));
		String tmpopt1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt1"));
		String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value1"));
	ids.put("con"+tmpid, tmpid);
	colnames.put("con"+tmpid, tmpcolname);
	opts.put("con"+tmpid, tmpopt);
	values.put("con"+tmpid, tmpvalue);
	names.put("con"+tmpid, tmpname);
	opt1s.put("con"+tmpid, tmpopt1);
	value1s.put("con"+tmpid, tmpvalue1);
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){  //文本框

//if(!tmpvalue.equals(""))
{
sqlwhere += "and (d."+tmpcolname;
if(tmpopt.equals("1"))	sqlwhere+=" ='"+tmpvalue +"' ";
if(tmpopt.equals("2"))	sqlwhere+=" <>'"+tmpvalue +"' ";
if(tmpopt.equals("3"))	sqlwhere+=" like '%"+tmpvalue +"%' ";
if(tmpopt.equals("4"))	sqlwhere+=" not like '%"+tmpvalue +"%' ";
}
}
else if(htmltype.equals("1")&& !type.equals("1")){  //数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->


if(!tmpvalue.equals("")){
	sqlwhere += "and (d."+tmpcolname;
	if(tmpopt.equals("1"))	sqlwhere+=" >"+tmpvalue +" ";
	if(tmpopt.equals("2"))	sqlwhere+=" >="+tmpvalue +" ";
	if(tmpopt.equals("3"))	sqlwhere+=" <"+tmpvalue +" ";
	if(tmpopt.equals("4"))	sqlwhere+=" <="+tmpvalue +" ";
	if(tmpopt.equals("5"))	sqlwhere+=" ="+tmpvalue +" ";
	if(tmpopt.equals("6"))	sqlwhere+=" <>"+tmpvalue +" ";
   
	}
	if(!tmpvalue1.equals("")){
	sqlwhere += " and d."+tmpcolname;
	if(tmpopt1.equals("1"))	sqlwhere+=" >"+tmpvalue1 +" ";
	if(tmpopt1.equals("2"))	sqlwhere+=" >="+tmpvalue1 +" ";
	if(tmpopt1.equals("3"))	sqlwhere+=" <"+tmpvalue1 +" ";
	if(tmpopt1.equals("4"))	sqlwhere+=" <="+tmpvalue1 +" ";
    if(tmpopt1.equals("5"))	sqlwhere+=" ="+tmpvalue1+" ";
	if(tmpopt1.equals("6"))	sqlwhere+=" <>"+tmpvalue1 +" ";
	}

}
else if(htmltype.equals("4")){   //check类型 = !=
sqlwhere += "and (d."+tmpcolname;
if(!tmpvalue.equals("1")) sqlwhere+="<>'1' ";
else sqlwhere +="='1' ";
}
else if(htmltype.equals("5")){  //选择框   = !=

	sqlwhere += "and (d."+tmpcolname;
	if(tmpvalue.equals("")) 
	{
	if(tmpopt.equals("1"))	sqlwhere+=" is null ";
	if(tmpopt.equals("2"))	sqlwhere+=" not is null ";
	}
	else
	{
	if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
	if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
	}


} else if(htmltype.equals("3") && (type.equals("1")||type.equals("9")||type.equals("4")||type.equals("7")||type.equals("8")||type.equals("16"))){//浏览框单人力资源  条件为多人力 (int  not  in),条件为多文挡,条件为多部门,条件为多客户,条件为多项目,条件为多请求
	if(!tmpvalue.equals("")) 
		{
				sqlwhere += "and (d."+tmpcolname;
				if(tmpopt.equals("1"))	sqlwhere+=" in ("+tmpvalue +") ";
				if(tmpopt.equals("2"))	sqlwhere+=" not in ("+tmpvalue +") ";
	}


}else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别 > >= = < !  and > >= = < !

if(!tmpvalue.equals("")){
	sqlwhere += "and (d."+tmpcolname;
	if(tmpopt.equals("1"))	sqlwhere+=" >"+tmpvalue +" ";
	if(tmpopt.equals("2"))	sqlwhere+=" >="+tmpvalue +" ";
	if(tmpopt.equals("3"))	sqlwhere+=" <"+tmpvalue +" ";
	if(tmpopt.equals("4"))	sqlwhere+=" <="+tmpvalue +" ";
	if(tmpopt.equals("5"))	sqlwhere+=" ="+tmpvalue +" ";
	if(tmpopt.equals("6"))	sqlwhere+=" <>"+tmpvalue +" ";
   
	}
	if(!tmpvalue1.equals("")){
	sqlwhere += " and d."+tmpcolname;
	if(tmpopt1.equals("1"))	sqlwhere+=" >"+tmpvalue1 +" ";
	if(tmpopt1.equals("2"))	sqlwhere+=" >="+tmpvalue1 +" ";
	if(tmpopt1.equals("3"))	sqlwhere+=" <"+tmpvalue1 +" ";
	if(tmpopt1.equals("4"))	sqlwhere+=" <="+tmpvalue1 +" ";
    if(tmpopt1.equals("5"))	sqlwhere+=" ="+tmpvalue1+" ";
	if(tmpopt1.equals("6"))	sqlwhere+=" <>"+tmpvalue1 +" ";
	}

}//职位安全级别end

else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期 > >= = < !  and > >= = < !

if(!tmpvalue.equals("")){
	sqlwhere += "and (d."+tmpcolname;
	if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
	if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
	if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
	if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
	if(tmpopt.equals("5"))	sqlwhere+=" ='"+tmpvalue +"' ";
	if(tmpopt.equals("6"))	sqlwhere+=" <>'"+tmpvalue +"' ";
   
	}
	if(!tmpvalue1.equals("")){
	sqlwhere += " and d."+tmpcolname;
	if(tmpopt1.equals("1"))	sqlwhere+=" >'"+tmpvalue1 +"' ";
	if(tmpopt1.equals("2"))	sqlwhere+=" >='"+tmpvalue1 +"' ";
	if(tmpopt1.equals("3"))	sqlwhere+=" <'"+tmpvalue1 +"' ";
	if(tmpopt1.equals("4"))	sqlwhere+=" <='"+tmpvalue1 +"' ";
    if(tmpopt1.equals("5"))	sqlwhere+=" ='"+tmpvalue1+"' ";
	if(tmpopt1.equals("6"))	sqlwhere+=" <>'"+tmpvalue1 +"' ";
	}

} else if(htmltype.equals("3") && (type.equals("17")||type.equals("57")||type.equals("135")||type.equals("152")||type.equals("18")||type.equals("160"))){  //浏览框  多选筐条件为单选筐(多文挡) 多选筐条件为单选筐（多部门） 多选筐条件为单选筐（多项目 ）多选筐条件为单选筐（多项目 ）

//if(!tmpvalue.equals(""))
	{
 if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
      sqlwhere += "and (','||d."+tmpcolname+"||','";
     else
      sqlwhere += "and (','+CONVERT(varchar,d."+tmpcolname+")+',' ";

	if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
	if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
}
}
else if(htmltype.equals("3") && (type.equals("141")||type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137")||type.equals("142"))){//浏览框  
    // 浏览按钮弹出页面的url like not like
//if(!tmpvalue.equals(""))
{
 if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
       sqlwhere += "and (','||d."+tmpcolname+"||','";
     else
      sqlwhere += "and (','+CONVERT(varchar,d."+tmpcolname+")+',' ";

	if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
	if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
}

} else if (htmltype.equals("3")){   //其他浏览框

// if(!tmpvalue.equals(""))
	 {
 if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
       sqlwhere += "and (','||d."+tmpcolname+"||','";
     else
      sqlwhere += "and (','+CONVERT(varchar,d."+tmpcolname+")+',' ";

	if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
	if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
}


} else if (htmltype.equals("6")){   //附件上传同多文挡
//if(!tmpvalue.equals(""))
	{
 if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
       sqlwhere += "and (','||d."+tmpcolname+"||','";
     else
      sqlwhere += "and (','+CONVERT(varchar,d."+tmpcolname+")+',' ";

	if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
	if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
}


}
if ((htmltype.equals("1")&& !type.equals("1"))||(htmltype.equals("3") && (type.equals("1")||type.equals("9")||type.equals("4")||type.equals("7")||type.equals("8")||type.equals("16")))||(htmltype.equals("3") && type.equals("24"))||(htmltype.equals("3") &&( type.equals("2") || type.equals("19")))) {
if(!tmpvalue.equals("")) sqlwhere +=") ";
}
else
sqlwhere +=") ";
}
}

//自定义结束

}else{
	if(isfirst == 0){
		sqlwhere += " and t1.workflowid in ("+workflowid+") and islasttimes=1 ";
	}else{
		String firstWFids = Util.null2String(request.getParameter("firstWFids"));
		//System.out.println("workflowid = " + workflowid);
		//System.out.println("firstWFids = " + firstWFids);
		if(!"".equals(firstWFids)){
			sqlwhere += " and t1.workflowid in ("+firstWFids+") and islasttimes=1 ";
		}else{
			sqlwhere += " and t1.workflowid in ("+workflowid+") and islasttimes=1 ";
		}
	}
}
//System.out.println("sqlwhere = " + sqlwhere);

String orderby = " t1.createdate,t1.createtime ";

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
String sql="";
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);

//add by xhheng @ 20050302 for TD 1545

boolean isMultiSubmit=false;

int perpage=10;
boolean hascreatetime =true;
boolean hascreater =true;
boolean hasworkflowname =true;
boolean hasrequestlevel =true;
boolean hasrequestname =true;
boolean hasreceivetime =true;
boolean hasstatus =true;
boolean hasreceivedpersons =true;
boolean hascurrentnode =true;
RecordSet.executeProc("workflow_RUserDefault_Select",""+user.getUID());
if(RecordSet.next()){
    if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
    if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
    if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
    if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
    if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
    if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
    if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
    if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
    if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
    perpage= RecordSet.getInt("numperpage");
}else{
    RecordSet.executeProc("workflow_RUserDefault_Select","1");
    if(RecordSet.next()){
        if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
        if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
        if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
        if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
        if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
        if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
        if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
        if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
        if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
        perpage= RecordSet.getInt("numperpage");
    }
}


//update by fanggsh 20060711 for TD4532 begin
boolean hasSubWorkflow =false;

if(workflowid!=null&&!workflowid.equals("")&&workflowid.indexOf(",")==-1&&isfirst == 0){
	RecordSet.executeSql("select id from Workflow_SubWfSet where mainWorkflowId="+workflowid);
	if(RecordSet.next()){
		hasSubWorkflow=true;
	}

	RecordSet.executeSql("select id from Workflow_TriDiffWfDiffField where mainWorkflowId="+workflowid);
	if(RecordSet.next()){
		hasSubWorkflow=true;
	}
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onResetSelf(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(73,user.getLanguage())+",javascript:location.href='/workflow/request/RequestUserDefault.jsp',_top}} " ;
RCMenuHeight += RCMenuHeightStep ;
//翻页按钮
RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmmain" method="post" action="CustomSearch2New.jsp">
<input name=iswaitdo type=hidden value="<%=iswaitdo%>">
<input name=mothed type=hidden value="">
<input name=workflowid type=hidden value=<%=workflowid%>>
<input name=formid type=hidden value=<%=formID%>>
<input name=isbill type=hidden value=<%=isbill%>>
<input name=isthisWeek type=hidden value="<%=isthisWeek%>">
<input name=isthisMonth type=hidden value="<%=isthisMonth%>">
<input name=isthisDep type=hidden value="<%=isthisDep%>">
<input name=isSelf type=hidden value="<%=isSelf%>">
		<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td valign="top">
		<table class="viewform" >
  <colgroup>
  <col width="25%">
  <col width="25%">
  <col width="25%">
  <col width="25%">
  <tbody>
<TR class="Title"><th COLSPAN=4><%=SystemEnv.getHtmlLabelName(21832,user.getLanguage())%></th></TR>
  <TR class=Separartor><TD class="Line1" COLSPAN=4></TD></TR>
  <tr height="20">
  <!--快捷查询按钮-->
    <td class=field align=center><span id="spanisthisWeek" name="spanisthisWeek" style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(isthisWeek)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="javascript:submitDataisthisWeek();">[<%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())+workflowname%>]</span></td>
    <td class=field align=center><span id="spanisthisMonth" name="spanisthisMonth" style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(isthisMonth)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="javascript:submitDataisthisMonth();">[<%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())+workflowname%>]</span></td>
    <td class=field align=center><span id="spanisthisDep" name="spanisthisDep" style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(isthisDep)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="javascript:submitDataisthisDep();">[<%=SystemEnv.getHtmlLabelName(21837,user.getLanguage())+workflowname%>]</span></td>
    <td class=field align=center><span id="spanisSelf" name="spanisSelf" style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(isSelf)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="javascript:submitDataisSelf();">[<%=SystemEnv.getHtmlLabelName(15763,user.getLanguage())+workflowname%>]</span></div></td>
  </tr>
   <TR class=Separartor><TD class="Line" COLSPAN=4></TD></TR>
<!--自定义字段查询-->
 <TR class="Title"><th COLSPAN=4><%=SystemEnv.getHtmlLabelName(21836,user.getLanguage())%></th></TR>
  <TR class=Separartor><TD class="Line1" COLSPAN=4></TD></TR>
   <input type='checkbox' name='check_con' style="display:none">
   <TR><TD COLSPAN=4>
   <table class="viewform" >
  <colgroup>
  <col width="12%">
  <col width="38%">
  <col width="12%">
  <col width="38%">
  <tbody>
<%//以下开始列出自定义查询条件

if(isbill.equals("0")){
sql = "select Workflow_CustomDspField.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fielddbtype as dbtype, workflow_formdict.fieldhtmltype as httype,workflow_formdict.type as type from Workflow_CustomDspField,Workflow_Custom, workflow_formdict,workflow_fieldlable,workflow_formfield where workflow_formfield.formid="+formID+" and workflow_formfield.fieldid=workflow_fieldlable.fieldid and  Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.formid="+formID+" and Workflow_Custom.isbill='0'  and Workflow_CustomDspField.ifquery='1' and workflow_fieldlable.formid = Workflow_Custom.formid and workflow_fieldlable.isdefault = 1 and workflow_fieldlable.fieldid =Workflow_CustomDspField.fieldid and workflow_formdict.id = Workflow_CustomDspField.fieldid order by workflow_formfield.fieldorder ";

}else if(isbill.equals("1")){
	sql = "select workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type from workflow_billfield,Workflow_CustomDspField,Workflow_Custom where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.formid="+formID+" and Workflow_Custom.isbill='1'  and Workflow_CustomDspField.ifquery='1' and workflow_billfield.billid="+formID+"  and   workflow_billfield.id=Workflow_CustomDspField.fieldid order by workflow_billfield.dsporder";
}
int i=0;
int tmpcount = 0;
RecordSet.execute(sql);
//out.print(sql);
while (RecordSet.next())
{tmpcount++;
i++;
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");
String htmltype = RecordSet.getString("httype");
String type = RecordSet.getString("type");
String id = RecordSet.getString("id");
String opt = "";
String value = "";
String opt1 = "";
String value1 = "";
String tmpid = (String)ids.get("con"+id);
String showName = "";
String checked = "";
if(tmpid!=null && !"".equals(tmpid)){
	checked = "checked";
	opt = Util.null2String((String)opts.get("con"+id));
	value = Util.null2String((String)values.get("con"+id));
	opt1 = Util.null2String((String)opt1s.get("con"+id));
	value1 = Util.null2String((String)value1s.get("con"+id));
	showName = Util.null2String((String)names.get("con"+id));
}
if(isbill.equals("1")){
	label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
}
%>
<input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
<input type=hidden name="con<%=id%>_type" value="<%=type%>">
<input type=hidden name="con<%=id%>_colname" value="<%=name%>">

<%if (i%2 !=0) {%><tr><%}%>
<td><input type='checkbox' name='check_con' title="<%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%>" value="<%=id%>" <%=checked%>> <%=label%></td>
<%
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){  //文本框

%>
<td class=field>
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
<%if(!htmltype.equals("2")){%>
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>     <!--等于-->
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>   <!--不等于-->
<%}%>
<option value="3" <%if("3".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>   <!--包含-->
<option value="4" <%if("4".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>   <!--不包含-->

</select>
<input type=text class=InputStyle size=12 name="con<%=id%>_value" value="<%=value%>"  onfocus="changelevel('<%=tmpcount%>')" >
</td>
<%}
else if(htmltype.equals("1")&& !type.equals("1")){  //数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
%>
<td class=field>
<select class=inputstyle  name="con<%=id%>_opt" style="width:20%" onfocus="changelevel('<%=tmpcount%>')"  >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if("3".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if("4".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if("5".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if("6".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select><input type=text class=InputStyle size=10 name="con<%=id%>_value" onblur="checknumber('con<%=id%>_value1')" onfocus="changelevel('<%=tmpcount%>')" value="<%=value%>" >
<select class=inputstyle  name="con<%=id%>_opt1" style="width:20%"  onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if("1".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if("3".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if("4".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if("5".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if("6".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<input type=text class=InputStyle size=10 name="con<%=id%>_value1"  onblur="checknumber('con<%=id%>_value1')" onfocus="changelevel('<%=tmpcount%>')" value="<%=value1%>" >
</td>
<%
}
else if(htmltype.equals("4")){   //check类型
%>
<td class=field >
<input type=checkbox value=1 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if("1".equals(value)){%>checked <%}%>>

</td>
<%}
else if(htmltype.equals("5")){  //选择框

%>

<td class=field>
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%"  onfocus="changelevel('<%=tmpcount%>')" >
	

<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>

<select class=inputstyle  name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" >
<option value="" ></option>
<%
char flag=2;
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
%>
<option value="<%=tmpselectvalue%>" <%if(value.equals(""+tmpselectvalue)){%>selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
<%}%>
</select>
</td>

<%} else if(htmltype.equals("3") && type.equals("1")){//浏览框单人力资源  条件为多人力 (like not like)
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button class=Browser   onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp','<%=type%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>

</td>
<%} else if(htmltype.equals("3") && type.equals("9")){//浏览框单文挡  条件为多文挡 (like not lik)
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp','<%=type%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>

</td>
<%} else if(htmltype.equals("3") && type.equals("4")){//浏览框单部门  条件为多部门 (like not lik)
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser3('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp','<%=type%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>

</td>
	<%} else if(htmltype.equals("3") && type.equals("7")){//浏览框单客户  条件为多客户 (like not lik)
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%"  onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp','<%=type%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>

</td>
<%} else if(htmltype.equals("3") && type.equals("8")){//浏览框单项目  条件为多项目 (like not lik)
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%"  onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp','<%=type%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>

</td>
<%} else if(htmltype.equals("3") && type.equals("16")){//浏览框单请求  条件为多请求 (like not lik)
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button class=Browser onfocus="changelevel('<%=tmpcount%>')"    onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp','<%=type%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>

</td>
<%}else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别

%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:20%"  onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if("3".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if("4".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if("5".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if("6".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<input type=text class=InputStyle size=10 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')"  value="<%=value%>">
<select class=inputstyle  name="con<%=id%>_opt1" style="width:20%" onfocus="changelevel('<%=tmpcount%>')"  >
<option value="1" <%if("1".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if("3".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if("4".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if("5".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if("6".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>

<input type=text class=InputStyle size=10 name="con<%=id%>_value1"  onfocus="changelevel('<%=tmpcount%>')"   value="<%=value1%>">
</td>
<%}//职位安全级别end

else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:20%"  onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if("3".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if("4".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if("5".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if("6".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<button class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
 onclick="onSearchWFDate(con<%=id%>_valuespan,con<%=id%>_value)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_valuespan,con<%=id%>_value)"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=value%></span>
<select class=inputstyle  name="con<%=id%>_opt1" style="width:20%"  onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if("1".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if("3".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if("4".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if("5".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if("6".equals(opt1)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>

<button class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
 onclick="onSearchWFDate(con<%=id%>_value1span,con<%=id%>_value1)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_value1span,con<%=id%>_value1)"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value1" value="<%=value1%>">
<span name="con<%=id%>_value1span" id="con<%=id%>_value1span"><%=value1%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("17")){
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("37")){//浏览框  多选筐条件为单选筐(多文挡)
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("57")){//浏览框  多选筐条件为单选筐（多部门）

%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser3('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("135")){//浏览框  多选筐条件为单选筐（多项目 ）

%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("152")){//浏览框  多选筐条件为单选筐（多请求 ）

%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%"  onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("18")){//浏览框  多选筐条件为单选筐
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button class=Browser onfocus="changelevel('<%=tmpcount%>')"   onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>
</td>
<%}
else if(htmltype.equals("3") && type.equals("160")){//浏览框  多选筐条件为单选筐
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%"  onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>
</td>
<%}
else if(htmltype.equals("3") && (type.equals("141")||type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137")||type.equals("142"))){//浏览框  
String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%"  onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button class=Browser onfocus="changelevel('<%=tmpcount%>')"   onclick="onShowBrowser('<%=id%>','<%=urls%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>
</td>
<%} else if (htmltype.equals("3")){
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%" onfocus="changelevel('<%=tmpcount%>')"  >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>

<button class=Browser onfocus="changelevel('<%=tmpcount%>')"   onclick="onShowBrowser('<%=id%>','<%=urls%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>
</td> 
<%} else if (htmltype.equals("6")){   //附件上传同多文挡
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:50%"  onfocus="changelevel('<%=tmpcount%>')"  >
<option value="1" <%if("1".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if("2".equals(opt)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button class=Browser  onfocus="changelevel('<%=tmpcount%>')"  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=value%>">
<input type=hidden name="con<%=id%>_name" value="<%=showName%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showName%></span>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_SEARCH_CUSTOMSEARCH2NEW %>"/>
</td>
<%}
%>
<%if (i%2 ==0) {%></tr>
<TR class=Separartor><td class=field class="Line" COLSPAN=4></TD></TR><%}%>
<%
}%>
</table>
</TD></TR>

                    <tr>
                      <td COLSPAN=4>
						<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
						</div>
                          <%
                           String tableString = "";
                            if(perpage <2) perpage=10;                                 
                            String backfields = " t1.requestid, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status,t1.requestlevel,t1.currentnodeid,t2.viewtype,t2.receivedate,t2.receivetime,t2.isremark ";
							//加上自定以字段

							isbill=WorkflowComInfo.getIsBill(workflowid);
							formID=WorkflowComInfo.getFormId(workflowid);
							String sqls="";
							String showfield="";
							if(isbill.equals("0")){
							sqls = "select Workflow_CustomDspField.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fielddbtype as dbtype, workflow_formdict.fieldhtmltype as httype,workflow_formdict.type as type,showorder from Workflow_CustomDspField,Workflow_Custom, workflow_formdict,workflow_fieldlable where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.formid="+formID+" and Workflow_Custom.isbill='0'  and Workflow_CustomDspField.ifshow='1' and workflow_fieldlable.formid = Workflow_Custom.formid and workflow_fieldlable.isdefault = 1 and workflow_fieldlable.fieldid =Workflow_CustomDspField.fieldid and workflow_formdict.id = Workflow_CustomDspField.fieldid  union"+
							"   select Workflow_CustomDspField.fieldid as id,'1' as name,'2' as label,'3' as dbtype, '4' as httype,5 as type ,Workflow_CustomDspField.showorder from Workflow_CustomDspField ,Workflow_Custom where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.formid="+formID+" and Workflow_Custom.isbill='0'  and Workflow_CustomDspField.ifshow='1'  and fieldid<0 order by showorder ";

							}else if(isbill.equals("1")){
								sqls = "select workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type,showorder from workflow_billfield,Workflow_CustomDspField,Workflow_Custom where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.formid="+formID+" and Workflow_Custom.isbill='1'  and Workflow_CustomDspField.ifshow='1' and workflow_billfield.billid="+formID+"  and   workflow_billfield.id=Workflow_CustomDspField.fieldid union "+
								"   select Workflow_CustomDspField.fieldid as id,'1' as name,2 as label,'3' as dbtype, '4' as httype,5 as type ,Workflow_CustomDspField.showorder from Workflow_CustomDspField ,Workflow_Custom where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.formid="+formID+" and Workflow_Custom.isbill='1'  and Workflow_CustomDspField.ifshow='1'  and fieldid<0 order by showorder";
							}
							//out.print(sqls);
							RecordSet.execute(sqls);
                            while (RecordSet.next())
							{
							if (RecordSet.getInt(1)>0)
							showfield=showfield+","+"d."+RecordSet.getString("name");
							}
							RecordSet.beforFirst();
							backfields=backfields+showfield;
                            String fromSql  = " from workflow_requestbase t1,workflow_currentoperator t2 ,"+tablename+" d ";
                            String sqlWhere = sqlwhere;
                            String para2="column:requestid+column:workflowid+column:viewtype+"+isovertime+"+"+user.getLanguage();

                            if(!superior)
                        	{
                            	sqlWhere += " AND EXISTS (SELECT 1 FROM workFlow_CurrentOperator workFlowCurrentOperator WHERE t2.workflowid = workFlowCurrentOperator.workflowid AND t2.requestid = workFlowCurrentOperator.requestid AND workFlowCurrentOperator.userid=" + userID + " and workFlowCurrentOperator.usertype = " + usertype +") ";
                        	}
                        	if(RecordSet.getDBType().equals("oracle"))
                            {
                            	sqlWhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
                            }
                            else
                            {
                            	sqlWhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
                            }
                          //out.println("select "+backfields+fromSql+sqlWhere);
                          if(isMultiSubmit && iswaitdo==1){
                          tableString =" <table instanceid=\"workflowRequestListTable\"  tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_SEARCH_CUSTOMSEARCH2NEW,user.getUID())+"\" >"+
                                        " <checkboxpopedom    popedompara=\"column:workflowid+column:isremark+column:requestid\" showmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCheckBox\" />"+ 
                                               "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\"  />"+
                                                  "			<head>";
						  }
						  else
						  {
						   tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_SEARCH_CUSTOMSEARCH2NEW,user.getUID())+"\" >"+
                                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\"  />"+
                                                 "			<head>";
						  }
						while (RecordSet.next()) {
                          if(RecordSet.getString("id").equals("-3")) 
                                    tableString+="				<col   text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                          else if(RecordSet.getString("id").equals("-4")) //-4
                                    tableString+="				<col  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
                         else if(RecordSet.getString("id").equals("-5")) //-5
                                    tableString+="				<col   text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
                         else if(RecordSet.getString("id").equals("-2")) //-2
                                    tableString+="				<col    text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""+user.getLanguage()+"\"/>";
                        else  if(RecordSet.getString("id").equals("-1")) //-1
                                    tableString+="				<col  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"t1.requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLink\"  otherpara=\""+para2+"\"/>";
                        else  if(RecordSet.getString("id").equals("-6")) //-6
                                    tableString+="				<col  text=\""+SystemEnv.getHtmlLabelName(18564,user.getLanguage())+"\" column=\"currentnodeid\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
                        else  if(RecordSet.getString("id").equals("-7")) //-7
                                    tableString+="			    <col  text=\""+SystemEnv.getHtmlLabelName(17994,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"t2.receivedate,t2.receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                       else   if(RecordSet.getString("id").equals("-8")) //-8
                                    tableString+="			    <col  text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"t1.status\" />";
                       else   if(RecordSet.getString("id").equals("-9")) //-9
                                    tableString+="			    <col   text=\""+SystemEnv.getHtmlLabelName(16354,user.getLanguage())+"\" column=\"requestid\" otherpara=\""+user.getLanguage()+"+"+user.getUID()+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
                          else
						  {String tempfield=RecordSet.getString("id");
						   String name = RecordSet.getString("name");
						   String label = RecordSet.getString("label");
						   String htmltype = RecordSet.getString("httype");
						   String type = RecordSet.getString("type");
						   String id = RecordSet.getString("id");
						   String para3="column:requestid+"+id+"+"+htmltype+"+"+type+"+"+user.getLanguage()+"+"+isbill+"+"+RecordSet.getDBType();
							if(isbill.equals("1"))
								label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
						 tableString+="			    <col  text=\""+label+"\"  column=\""+name+"\"  otherpara=\""+para3+"\"  transmethod=\"weaver.general.WorkFlowTransMethod.getOthers\"/>";
						   }
						  }
						  if (RecordSet.getCounts()==0)
						  {
						  if(hascreatetime)
                                    tableString+="				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                          if(hascreater)
                                    tableString+="				<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
                          if(hasworkflowname)
                                    tableString+="				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
                          if(hasrequestlevel)
                                    tableString+="				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""+user.getLanguage()+"\"/>";
                          if(hasrequestname)
                                    tableString+="				<col width=\"19%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"t1.requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLink\"  otherpara=\""+para2+"\"/>";
                          if(hascurrentnode)
                                    tableString+="				<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(18564,user.getLanguage())+"\" column=\"currentnodeid\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
                          if(hasreceivetime)
                                    tableString+="			    <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17994,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"t2.receivedate,t2.receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                          if(hasstatus)
                                    tableString+="			    <col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"t1.status\" />";
                          if(hasreceivedpersons)
                                    tableString+="			    <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(16354,user.getLanguage())+"\" column=\"requestid\" otherpara=\""+user.getLanguage()+"+"+user.getUID()+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
						  }
						  if(hasSubWorkflow) 
                                    tableString+="				<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(19363,user.getLanguage())+"\" column=\"requestid\" orderkey=\"t1.requestid\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_self\" transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFLinkNew\"  otherpara=\""+user.getLanguage()+"\"/>";
                                    tableString+="			</head>"+   			
                                                 "</table>";
                          %>
                         <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
                      </td>
                    </tr>
</tbody>
</table>


<!--   added by xwj for td2023 on 2005-05-20  end  -->
     
<table align=right>
   <tr>
   <td>
   <%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;

	// RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.toString(),_self}" ;
    //RCMenuHeight += RCMenuHeightStep ;
   %>
   </tr>

</TABLE>
	  
</td>
</tr>
</table>
		</td>
		</tr>
		</TABLE>


</form>
<script language=vbs src="/js/browser/WorkFlowBrowser.vbs"></script>

<script language="vbs">
sub changelevel(tmpindex)
        
 		document.frmmain.check_con(tmpindex*1).checked = true

end sub

sub onShowBrowser(id,url)

		id1 = window.showModalDialog(url)
		if NOT isempty(id1) then
		        if id1(0)<> "" then
				document.all("con"+id+"_valuespan").innerHtml = id1(1)
				document.all("con"+id+"_value").value=id1(0)
				document.all("con"+id+"_name").value=id1(1)
			else
				document.all("con"+id+"_valuespan").innerHtml = empty
				document.all("con"+id+"_value").value=""
				document.all("con"+id+"_name").value=""
			end if
		end if
end sub
sub onShowBrowser1(id,url,type1)

	if type1= 1 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		document.all("con"+id+"_valuespan").innerHtml = id1
		document.all("con"+id+"_value").value=id1
	elseif type1=2 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		document.all("con"+id+"_value1span").innerHtml = id1
		document.all("con"+id+"_value1").value=id1
	end if
end sub

sub onShowBrowser2(id,url,type1)
    
          if type1=8 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=9 then
            tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
			elseif type1=1 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			elseif type1=4 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			elseif type1=16 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			else type1=7 
			tmpids =document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
           end if
	//id1 = window.showModalDialog(url)
		if NOT isempty(id1) then
			resourceids = id1(0)
			resourcename = id1(1)
			resourceids = Mid(resourceids,2,len(resourceids))
			resourcename = Mid(resourcename,2,len(resourcename))	
			document.all("con"+id+"_valuespan").innerHtml =resourcename 
			document.all("con"+id+"_value").value=resourceids
			document.all("con"+id+"_name").value=resourcename
			else
			document.all("con"+id+"_valuespan").innerHtml = empty
			document.all("con"+id+"_value").value=""
			document.all("con"+id+"_name").value=""
		 end if
		
end sub

sub onShowBrowser3(id,url,type1)
	url1 = url&"?selectedids="&document.all("con"+id+"_value").value
	onShowBrowser2(id,url1,type1)
end sub

sub onShowMutiHrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&curname&"&nbsp"
					wend
					sHtml = sHtml&resourcename&"&nbsp"
					document.all(spanname).innerHtml = sHtml
                    if InStr(spanname,"remindobjectidspan")>0 then
                        document.all("isother").checked=true
                    else
                        document.all("flownextoperator")(0).checked=false
                        document.all("flownextoperator")(1).checked=true
                    end if
                else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
                    if InStr(spanname,"remindobjectidspan")>0 then
                        document.all("isother").checked=false
                    else
                        document.all("flownextoperator")(0).checked=true
                        document.all("flownextoperator")(1).checked=false
                    end if
                end if
			end if
end sub

</script>
<script language="javascript">


function submitData()
{
	document.frmmain.mothed.value="search";
	frmmain.submit();
}

function submitClear()
{
	btnclear_onclick();
}
function enablemenuall()
{
for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++)
		{
		window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
}
//window.frames["rightMenuIframe"].event.srcElement.disabled = true;
}

function OnChangePage(start){
        document.frmmain.start.value = start;
		document.frmmain.submit();
}

function OnSearch(){
        document.frmmain.fromself.value="1";
        //document.frmmain.isfirst.value="1";
		if (document.frmmain.workflowid.value=="")  document.frmmain.action="WFSearchResult.jsp";
		document.frmmain.submit();
}

function OnMultiSubmit(){

    document.frmmain1.multiSubIds.value = _xtable_CheckedCheckboxId();
    //alert (document.frmmain1.multiSubIds.value);
    document.frmmain1.submit();
}

function CheckAll(haschecked) {

    len = document.weaver1.elements.length;
    var i=0;
    for( i=0; i<len; i++) {
        if (document.weaver1.elements[i].name.substring(0,13)=='multi_submit_') {
            document.weaver1.elements[i].checked=(haschecked==true?true:false);
        }
    }


}


var showTableDiv  = document.getElementById('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("<div>");
     message_Div.id="message_Div";
     message_Div.className="xTable_message";
     showTableDiv.appendChild(message_Div);
     var message_Div1  = document.getElementById("message_Div");
     message_Div1.style.display="inline";
     message_Div1.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_Div1.style.position="absolute"
     message_Div1.style.posTop=pTop;
     message_Div1.style.posLeft=pLeft;

     message_Div1.style.zIndex=1002;

     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_Div1.style.zIndex - 1;
     oIframe.style.width = parseInt(message_Div1.offsetWidth);
     oIframe.style.height = parseInt(message_Div1.offsetHeight);
     oIframe.style.display = 'block';
}
function displaydiv_1()
{
	if(WorkFlowDiv.style.display == ""){
		WorkFlowDiv.style.display = "none";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
	}
	else{
		WorkFlowDiv.style.display = "";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";

	}
}

function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showallreceived(requestid,returntdid){
    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
    var ajax=ajaxinit();
	
    ajax.open("POST", "WorkflowUnoperatorPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid="+requestid+"&returntdid="+returntdid);
    //获取执行状态

    //alert(ajax.readyState);
	//alert(ajax.status);
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里

        if (ajax.readyState==4&&ajax.status == 200) {
            try{
            document.all(returntdid).innerHTML = ajax.responseText;
            }catch(e){}
            showTableDiv.style.display='none';
            oIframe.style.display='none';
        } 
    } 
}
function submitDataisthisWeek(){
	onClearSwift();
	document.frmmain.isthisWeek.value="1";
	document.getElementById("spanisthisWeek").style.color = "#0000FF";
	submitData();
}
function submitDataisthisMonth(){
	onClearSwift();
	document.frmmain.isthisMonth.value="1";
	document.getElementById("spanisthisMonth").style.color = "#0000FF";
	submitData();
}
function submitDataisthisDep(){
	onClearSwift();
	document.frmmain.isthisDep.value="1";
	document.getElementById("spanisthisDep").style.color = "#0000FF";
	submitData();
}
function submitDataisSelf(){
	onClearSwift();
	document.frmmain.isSelf.value="1";
	document.getElementById("spanisSelf").style.color = "#0000FF";
	submitData();
}
function onResetSelf(){
	frmmain.reset();
	onClearSwift();
}
function onClearSwift(){
	document.frmmain.isthisWeek.value="0";
	document.frmmain.isthisMonth.value="0";
	document.frmmain.isthisDep.value="0";
	document.frmmain.isSelf.value="0";
	document.getElementById("spanisthisWeek").style.color = "#6A9EE6";
	document.getElementById("spanisthisMonth").style.color = "#6A9EE6";
	document.getElementById("spanisthisDep").style.color = "#6A9EE6";
	document.getElementById("spanisSelf").style.color = "#6A9EE6";
}
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
