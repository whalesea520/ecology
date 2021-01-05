
<%@ page language="java" contentType="text/html; charset=UTF-8" %>


 <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />

<HTML><HEAD>

<link rel=stylesheet type="text/css" href="/css/Browser_wev8.css">
<link rel=stylesheet type="text/css" href="/css/Weaver_wev8.css">
<script language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(16532,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(15505,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";

//报表id
int reportid = Util.getIntValue(request.getParameter("id"),0);

//模板id
int mouldId = Util.getIntValue(request.getParameter("mouldId"),0);

int sharelevel = 0 ;

RecordSet.executeSql("select sharelevel from WorkflowReportShareDetail where userid="+user.getUID()+" and usertype=1 and reportid="+reportid);

if(RecordSet.next()) {
    sharelevel = Util.getIntValue(RecordSet.getString("sharelevel"),0) ;
}
else {
    response.sendRedirect("/notice/noright.jsp");
    return;
}


String sql = " select a.formid , a.isbill from Workflow_Report a " +
 " where  a.id="+reportid ;

RecordSet.execute(sql) ;
RecordSet.next() ;

String isbill = Util.null2String(RecordSet.getString("isbill"));
int formid = Util.getIntValue(RecordSet.getString("formid"),0);

List ids = new ArrayList();
List isShows = new ArrayList();
List isCheckConds = new ArrayList();
List colnames = new ArrayList();
List opts = new ArrayList();
List values = new ArrayList();
List names = new ArrayList();
List opt1s = new ArrayList();
List value1s = new ArrayList();

RecordSet.execute("select fieldId,isShow,isCheckCond,colName,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond from WorkflowRptCondMouldDetail where mouldId="+mouldId) ;

while(RecordSet.next()){
	ids.add(Util.null2String(RecordSet.getString("fieldId")));
	isShows.add(Util.null2String(RecordSet.getString("isShow")));
	isCheckConds.add(Util.null2String(RecordSet.getString("isCheckCond")));
	colnames.add(Util.null2String(RecordSet.getString("colName")));
	opts.add(Util.null2String(RecordSet.getString("optionFirst")));
	values.add(Util.null2String(RecordSet.getString("valueFirst")));
	names.add(Util.null2String(RecordSet.getString("nameFirst")));
	opt1s.add(Util.null2String(RecordSet.getString("optionSecond")));
	value1s.add(Util.null2String(RecordSet.getString("valueSecond")));
}



//获得报表显示项
String strReportDspField=",";
String fieldId="";
RecordSet.execute("select fieldId from Workflow_ReportDspField where reportId="+reportid) ;

while(RecordSet.next()){
	fieldId=RecordSet.getString(1);
	if(fieldId!=null&&!fieldId.equals("")){
		strReportDspField+=fieldId+",";
	}
}


%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
//必须在SearchForm.reset() 前面加上 document 才能解决 火狐兼容问题
RCMenu += "{"+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+",javascript:resetform(),_self} ";
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEditSaveTemplate(),_top} " ;
RCMenuHeight += RCMenuHeightStep;


RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+",javascript:onSaveAsTemplate(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDeleteTemplate(),_top} " ;
RCMenuHeight += RCMenuHeightStep;



%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ReportResult.jsp" method="post">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name=isbill value="<%=isbill%>">
<input type=hidden name=reportid value="<%=reportid%>">
<input type=hidden name=mouldId value="<%=mouldId%>">
<input type=hidden name=operation>

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

<table class=ViewForm>
  <tr>
    <td width="80%">

  <table width=100% class=viewform>
    <COLGROUP> <COL width="4%"><COL width="4%"> <COL width="20%"> <COL width="18%"> <COL width="18%">
    <COL width="18%"> <COL width="18%">
    <TR class=title>
      <TH colSpan=7><%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%></TH>
    </TR>
    <!-- 2012-08-16 ypc 修改-->  
      <TR style="height:2px">
      <TD class=line1 colSpan=7></TD>
    </TR>
    <TR class=title>
      <td><%=SystemEnv.getHtmlLabelName(19664,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>
      <td colspan=4><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
    </tr>    
      <!-- 2012-08-16 ypc 修改-->  
      <TR style="height:2px">
      <TD class=line colSpan=7></TD>
    </TR>
    
    
    <!--xwj for td2974 20051026   B E G I N-->
    <TR class=title>
      <td>
<%
	if(strReportDspField.indexOf(",-1,")>-1){
%>
	<input type="checkbox" name="requestNameIsShow"  value="1" 
<%
	    if((ids.indexOf("-1")!=-1)&&((String)isShows.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("1")){
%>
	checked 
<%
	    }
%>
    >
<%
    }
%>
	  </td>
      <td>
	    <input type="checkbox" name="requestname_check_con"  value="1"
<%
	    if((ids.indexOf("-1")!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("1")){
%>
	checked 
<%
	    }
%>
	    >
		</td>
      <td><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></td>
      <td>
      <select class="inputstyle" name="requestname"  style="width:100%" onfocus="changeclick1()">
        <option value="1"  <%if((ids.indexOf("-1")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2"  <%if((ids.indexOf("-1")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("2")){%> selected <%}%>  ><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        <option value="3"   <%if((ids.indexOf("-1")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="4"  <%if((ids.indexOf("-1")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("4")){%> selected <%}%>  ><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
      </td>
      <td colspan=3>
      <input type=text class=inputstyle size=12 name="requestnamevalue" onfocus="changeclick1()"  <%if(ids.indexOf("-1")!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf("-1"))))%><%}%>> 
      </td>
    </tr>    
      <!-- 2012-08-16 ypc 修改-->  
      <tr style="height:2px"><td colSpan=7 class=line1></td></tr>

      <TR class=title>
      <td>
<%
	if(strReportDspField.indexOf(",-2,")>-1){
%>
	  <input type="checkbox" name="requestLevelIsShow"  value="1"  
<%
	    if((ids.indexOf("-2")!=-1)&&((String)isShows.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("1")){
%>
	checked 
<%
	    }
%>
    >
<%
    }
%>
	  </td>
      <td>
	    <input type="checkbox" name="requestlevel_check_con"  value="1" 
<%
	    if((ids.indexOf("-2")!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("1")){
%>
	checked 
<%
	    }
%>
		>
	  </td>
      <td><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></td>
      <td>
      <select class="inputstyle" name="requestlevelvalue"  style="width:100%" onfocus="changeclick2()">
        <option value="0"   <%if((ids.indexOf("-2")!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
        <option value="1"<%if((ids.indexOf("-2")!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
        <option value="2"<%if((ids.indexOf("-2")!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
      </select>
      </td>
      <td colspan=3>
      </td>
    </tr>   
      <!-- 2012-08-16 ypc 修改-->  
      <tr style="height:2px"><td colSpan=7 class=line1></td></tr>
    <!--xwj for td2974 20051026  E N D-->
    
    <!--xwj for td451 20051105   B E G I N-->
      <TR class=title>
      <td>
<%
	if(strReportDspField.indexOf(",-3,")>-1){
%>
	 <input type="checkbox" name="requestStatusIsShow"  value="1"  
<%
	    if((ids.indexOf("-3")!=-1)&&((String)isShows.get(Util.getIntValue(""+ids.indexOf("-3")))).equals("1")){
%>
	selected 
<%
	    }
%>
    >
<%
    }
%>	  
	  </td>
      <td><input type="checkbox" name="requeststatus_check_con"  value="1"
<%
	    if((ids.indexOf("-3")!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-3")))).equals("1")){
%>
	checked 
<%
	    }
%>	  
	  >
	  </td>
      <td><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
      <td>
      <select class="inputstyle" name="requeststatusvalue"  style="width:100%" onfocus="changeclick3()">
        <option value="1" <%if((ids.indexOf("-3")!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf("-3")))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
        <option value="2"<%if((ids.indexOf("-3")!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf("-3")))).equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(17999,user.getLanguage())%></option>
      </select>
      </td>
      <td colspan=3>
      </td>
    </tr>   
      <!-- 2012-08-16 ypc 修改-->  
      <tr style="height:2px"><td colSpan=7 class=line1></td></tr>
         
    <tr>
    <td></td>
    <td><input type="checkbox" name="archiveTime"  value="1"
<%
	    if((ids.indexOf("-4")!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-4")))).equals("1")){
%>
	checked 
<%
	    }
%>	  
	  >
	  </td>
	  <td><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19736,user.getLanguage())%></td>
	  <td colspan=2><BUTTON type='button' class=calendar id=SelectDate onfocus="changeclick4()" onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%if(ids.indexOf("-4")!=-1){%><%=values.get(Util.getIntValue(""+ids.indexOf("-4")))%><%}%></SPAN>
    -&nbsp;&nbsp;<BUTTON type='button' class=calendar id=SelectDate2 onfocus="changeclick4()" onclick="gettheDate(todate,todatespan)"></BUTTON>&nbsp;
    <SPAN id=todatespan ><%if(ids.indexOf("-4")!=-1){%><%=value1s.get(Util.getIntValue(""+ids.indexOf("-4")))%><%}%></SPAN>
	  <input type="hidden" name="fromdate" class=Inputstyle <%if(ids.indexOf("-4")!=-1){%>value="<%=values.get(Util.getIntValue(""+ids.indexOf("-4")))%>"<%}%>>
	  <input type="hidden" name="todate" class=Inputstyle <%if(ids.indexOf("-4")!=-1){%>value="<%=value1s.get(Util.getIntValue(""+ids.indexOf("-4")))%>"<%}%>>
    </td>
	  </tr>
	  <!-- 2012-08-16 ypc 修改-->  
      <tr style="height:2px"><td colSpan=7 class=line1></td></tr>

    <!--xwj for td451 20051105   E N D--->
    <%
int linecolor=0;
sql="";
//if(isbill.equals("0"))
/* workflow_fieldlable b 
and  b.langurageid = @language_2
and a.fieldid= b.fieldid
and d.formid = b.formid
用子查询代替上述内容，能限制主表和明细id相同时重复出现的情况，但是无法保证显示名唯一（因为已经确定某报表，所以效率方面不会有很大差别）

by ben 2006-03-27 for td3595
*/
//	sql = "select t1.fieldid as id,(select distinct fieldname  from workflow_fieldlable t3 where t3.formid = t1.formid and t3.langurageid = "+user.getLanguage() + " and t3.fieldid =t1.fieldid) as name ,(select distinct t3.fieldlable as label from workflow_fieldlable t3 where t3.formid = t1.formid and t3.langurageid = "+user.getLanguage() + " and t3.fieldid =t1.fieldid) as label,t2.fieldhtmltype as htmltype,t2.type as type,t2.fielddbtype as dbtype from workflow_formfield t1,workflow_formdict t2 where  t2.id = t1.fieldid and t1.formid="+formid + " and (t1.isdetail <> '1' or t1.isdetail is null)";
//else if(isbill.equals("1"))
//	sql = "select id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type,fielddbtype as dbtype,viewtype from workflow_billfield where billid = "+formid + " order by dsporder,viewtype ";
//获取用户语言，默认为7
int userLanguage = user.getLanguage();
userLanguage = (userLanguage == 0) ? 7 : userLanguage;
if(isbill.equals("0")){
	StringBuffer sqlSB = new StringBuffer();
	sqlSB.append("   Select bf.* from                                               \n");
	sqlSB.append("     (select t1.fieldid as id,                                    \n");
	sqlSB.append("             (select distinct fieldname                           \n");
	sqlSB.append("                from workflow_fieldlable t3                       \n");
	sqlSB.append("               where t3.formid = t1.formid                        \n");
	sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
	sqlSB.append("                 and t3.fieldid = t1.fieldid) as name,            \n");
	sqlSB.append("             (select distinct t3.fieldlable as label              \n");
	sqlSB.append("                from workflow_fieldlable t3                       \n");
	sqlSB.append("               where t3.formid = t1.formid                        \n");
	sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
	sqlSB.append("                 and t3.fieldid = t1.fieldid) as label,           \n");
	sqlSB.append("             t2.fieldhtmltype as htmltype,                        \n");
	sqlSB.append("             t2.type as type,                                     \n");
	sqlSB.append("             t2.fielddbtype as dbtype,                            \n");
	sqlSB.append("             1 as ismain,                            				\n");
	sqlSB.append("             NULL as groupid                                      \n");
	sqlSB.append("        from workflow_formfield t1, workflow_formdict t2          \n");
	sqlSB.append("       where t2.id = t1.fieldid                                   \n");
	sqlSB.append("         and t1.formid = " + formid + "                           \n");
	sqlSB.append("         and (t1.isdetail <> '1' or t1.isdetail is null)          \n");
	sqlSB.append("      UNION                                                       \n");
	sqlSB.append("      select t1.fieldid as id,                                    \n");
	sqlSB.append("             (select distinct fieldname                           \n");
	sqlSB.append("                from workflow_fieldlable t3                       \n");
	sqlSB.append("               where t3.formid = t1.formid                        \n");
	sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
	sqlSB.append("                 and t3.fieldid = t1.fieldid) as name,            \n");
	sqlSB.append("             (select distinct t3.fieldlable                       \n");
	sqlSB.append("                from workflow_fieldlable t3                       \n");
	sqlSB.append("               where t3.formid = t1.formid                        \n");
	sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
	sqlSB.append("                 and t3.fieldid = t1.fieldid) as label,           \n");
	sqlSB.append("             t2.fieldhtmltype as htmltype,                        \n");
	sqlSB.append("             t2.type as type,                                     \n");
	sqlSB.append("             t2.fielddbtype as dbtype,                            \n");
	sqlSB.append("             0 as ismain,                            				\n");
	sqlSB.append("             t1.groupid                                           \n");
	sqlSB.append("        from workflow_formfield t1, workflow_formdictdetail t2    \n");
	sqlSB.append("       where t2.id = t1.fieldid                                   \n");
	sqlSB.append("         and t1.formid = " + formid + "                           \n");
	sqlSB.append("         and (t1.isdetail = '1' or t1.isdetail is not null)) bf   \n");
	sqlSB.append("   left join (Select * from Workflow_ReportDspField               \n");
	sqlSB.append("                    where reportid = " + reportid + " ) rf        \n");
	sqlSB.append("   on (bf.id = rf.fieldid OR bf.id = rf.fieldidbak)               \n");
	sqlSB.append("   order by rf.dsporder                                           \n");
	sql = sqlSB.toString();
} else if(isbill.equals("1")){
	StringBuffer sqlSB = new StringBuffer();
	sqlSB.append("  select bf.* from (                              \n");
	sqlSB.append("    select wfbf.id            as id,              \n");
	sqlSB.append("           wfbf.fieldname     as name,            \n");
	sqlSB.append("           wfbf.fieldlabel    as label,           \n");
	sqlSB.append("           wfbf.fieldhtmltype as htmltype,        \n");
	sqlSB.append("           wfbf.type          as type,            \n");
	sqlSB.append("           wfbf.fielddbtype   as dbtype,          \n");
	sqlSB.append("           wfbf.viewtype      as viewtype,        \n");
	sqlSB.append("           wfbf.dsporder      as dsporder,        \n");
	sqlSB.append("           wfbf.detailtable   as detailtable      \n");
	sqlSB.append("      from workflow_billfield wfbf                \n");
	sqlSB.append("     where wfbf.billid = " + formid + " AND wfbf.viewtype = 0               \n");
	sqlSB.append("    Union                                         \n");
	sqlSB.append("    select wfbf.id            as id,              \n");
	sqlSB.append("           wfbf.fieldname     as name,            \n");
	sqlSB.append("           wfbf.fieldlabel    as label,           \n");
	sqlSB.append("           wfbf.fieldhtmltype as htmltype,        \n");
	sqlSB.append("           wfbf.type          as type,            \n");
	sqlSB.append("           wfbf.fielddbtype   as dbtype,          \n");
	sqlSB.append("		     wfbf.viewtype      as viewtype,        \n");
	sqlSB.append("		     wfbf.dsporder+100  as dsporder,        \n");
	sqlSB.append("           wfbf.detailtable   as detailtable      \n");
	sqlSB.append("		from workflow_billfield wfbf                \n");
	sqlSB.append("	   where wfbf.billid = " + formid + " AND wfbf.viewtype = 1               \n");
	sqlSB.append("  ) bf left join (Select fieldid,dsporder,fieldidbak                        \n");
	sqlSB.append("      from Workflow_ReportDspField  where reportid = " + reportid + ") rf   \n");
	sqlSB.append("      on (bf.id = rf.fieldid OR bf.id = rf.fieldidbak)                      \n");
	sqlSB.append("   order by rf.dsporder, bf.dsporder,   bf.detailtable                      \n");
	sql = sqlSB.toString();
}
RecordSet.executeSql(sql);
int tmpcount = 0;
while(RecordSet.next()){
tmpcount += 1;
String id = RecordSet.getString("id");
String  _type = RecordSet.getString("type");
%><tr class=title >
    <td>
<%
	if(strReportDspField.indexOf(","+id+",")>-1){
%>
      <input type='checkbox' name='isShow'  value="<%=id%>" <%if((ids.indexOf(""+id)!=-1)&&((String)isShows.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>
<%
    }
%>
    </td>
    <td>
      <input type='checkbox' name='check_con'  value="<%=id%>"  <%=_type.equals("141")?"style='display:none;'":""%>  <%if((ids.indexOf(""+id)!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>

    </td>
    <td>
      <input type=hidden name="con<%=id%>_id" value="<%=id%>">

      <%
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");
int ismain=1;
if(isbill.equals("1")){
	label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
    int viewtypeint=Util.getIntValue(RecordSet.getString("viewtype"));
    if(viewtypeint==1){
        label="("+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+")"+label;
        ismain=0;
    }
} else {
	ismain=Util.getIntValue(RecordSet.getString("ismain"), 1);
}
%>
      <input type=hidden name="con<%=id%>_ismain" value="<%=ismain%>">
      <%=Util.toScreen(label,user.getLanguage())%>
      <input type=hidden name="con<%=id%>_colname" value="<%=name%>">
    </td>
    <%
String htmltype = RecordSet.getString("htmltype");
String type = RecordSet.getString("type");
String dbtype = RecordSet.getString("dbtype");
%>
    <input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
    <input type=hidden name="con<%=id%>_type" value="<%=type%>">
    <%
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3>
      <input type=text class=inputstyle size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
    </td>
    <%}
else if(htmltype.equals("1")&& !type.equals("1")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td >
      <input type=text class=inputstyle size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
    </td>
    <td>
      <select class=inputstyle name="con<%=id%>_opt1" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td>
      <input type=text class=inputstyle size=12 name="con<%=id%>_value1"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
    </td>
    <%
}
else if(htmltype.equals("4")){
%>
    <td colspan=4>
      <input type=checkbox value=1 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>
    </td>
    <%}
else if(htmltype.equals("5")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3>
      <select class=inputstyle name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')">
      	<option value=""  <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("")){%> selected <%}%>></option>
        <%
char flag=2;
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
%>
        <option value="<%=tmpselectvalue%>"  <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
        <%}%>
      </select>
    </td>
    <%} else if(htmltype.equals("3") && !type.equals("2")&& !type.equals("18")&& !type.equals("4")&& !type.equals("19")&& !type.equals("17") && !type.equals("37") && !type.equals("65")&& !type.equals("57")&&!type.equals("162") && !type.equals("141") && !type.equals("142")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3>
         <%
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
            if(type.equals("4") && sharelevel <2) {
                if(sharelevel == 1) browserurl = browserurl.trim() + "?sqlwhere=where subcompanyid1 = " + user.getUserSubCompany1() ;
                else browserurl = browserurl.trim() + "?sqlwhere=where id = " + user.getUserDepartment() ;
            }else if("161".equals(type)){
				browserurl = browserurl.trim() + "?type="+dbtype;
		    }
         %>
        <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
	  <%} else if(htmltype.equals("3") && type.equals("141") && false){ //
	%>
	<td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3>
         <%
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
         %>
       <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowResourceConditionBrowser('<%=id%>','<%=browserurl%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){ // 增加日期和时间的处理（之间）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
   onclick="onSearchWFDate(con<%=id%>_valuespan,con<%=id%>_value)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_valuespan,con<%=id%>_value)"
<%}%>
 ></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <td >
      <select class=inputstyle name="con<%=id%>_opt1" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td > <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
   onclick="onSearchWFDate(con<%=id%>_value1span,con<%=id%>_value1)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_value1span,con<%=id%>_value1)"
<%}%>
 ></button>
      <input type=hidden name="con<%=id%>_value1" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <span name="con<%=id%>_value1span" id="con<%=id%>_value1span">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
     <%} else if(htmltype.equals("3") && type.equals("57")){ // 增加多部门的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
		 <%} else if(htmltype.equals("3") && type.equals("4")){ // 增加部门的处理（可选择多个部门）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("17")){ // 增加多人力资源的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("65")){ 
        // modify by mackjoe at 2005-11-24 td2862 增加多角色的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("18")){ // 增加多客户的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("37")){ // 增加多文档的处理（包含，不包含） %>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
     <%} else if(htmltype.equals("3") && type.equals("162")){ // 增加多自定义浏览框的处理（包含，不包含） %>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <%
		String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
		browserurl = browserurl.trim() + "?type="+dbtype;
    %>
    <td colspan=3> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("142")){ // 增加收发文单位的处理（包含，不包含） %>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <%
		String browserurl = "/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowser.jsp";
    %>
    <td colspan=3> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <%}%>
    </tr>
	  <!-- 2012-08-16 ypc 修改-->  
      <tr style="height:2px"><td colSpan=7 class=line1></td></tr>

    <%
 if(linecolor==0) linecolor=1;
          else linecolor=0;}%>

<%--因为当报表是单据的时候，上面的代码本身就可以显示明细字段了。--%>
<%--而如果是表单，则因为表单的明细自动在不同的表里，所以上面的--%>
<%--sql语句查不出明细字段，必须补上下面的代码才行--%>
<%if(isbill.equals("0")){%>

    <%
linecolor=0;
sql="";

/* workflow_fieldlable b 
and  b.langurageid = @language_2
and a.fieldid= b.fieldid
and d.formid = b.formid
用子查询代替上述内容，能限制主表和明细id相同时重复出现的情况，但是无法保证显示名唯一
by ben 2006-03-27 for td3595
*/
sql = "select t1.fieldid as id,(select distinct fieldname  from workflow_fieldlable t3 where t3.formid = t1.formid and t3.langurageid = "+user.getLanguage() + " and t3.fieldid =t1.fieldid) as name,(select distinct t3.fieldlable  from workflow_fieldlable t3 where t3.formid = t1.formid and t3.langurageid = "+user.getLanguage() + " and t3.fieldid =t1.fieldid) as label,t2.fieldhtmltype as htmltype,t2.type as type,t2.fielddbtype as dbtype from workflow_formfield t1,workflow_formdictdetail t2 where  t2.id = t1.fieldid and t1.formid="+formid + " and (t1.isdetail = '1' or t1.isdetail is not null)";

RecordSet.executeSql(sql);
//tmpcount = 0;
while(RecordSet.next()){
tmpcount += 1;
String id = RecordSet.getString("id");
%><tr class=title >
    <td>
<%
	if(strReportDspField.indexOf(","+id+",")>-1){
%>
      <input type='checkbox' name='isShow'"  value="<%=id%>" <%if((ids.indexOf(""+id)!=-1)&&((String)isShows.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>
<%
    }
%>
    </td>
    <td>
      <input type='checkbox' name='check_con'  value="<%=id%>" <%if((ids.indexOf(""+id)!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>
    </td>
    <td>
      <input type=hidden name="con<%=id%>_id" value="<%=id%>">
      <input type=hidden name="con<%=id%>_ismain" value="0">
      <%
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");

%>
      <%=Util.toScreen("("+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+")"+label,user.getLanguage())%>
      <input type=hidden name="con<%=id%>_colname" value="<%=name%>">
    </td>
    <%
String htmltype = RecordSet.getString("htmltype");
String type = RecordSet.getString("type");
String dbtype = RecordSet.getString("dbtype");
%>
    <input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
    <input type=hidden name="con<%=id%>_type" value="<%=type%>">
    <%
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3>
      <input type=text class=inputstyle size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
    </td>
    <%}
else if(htmltype.equals("1")&& !type.equals("1")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td >
      <input type=text class=inputstyle size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
    </td>
    <td>
      <select class=inputstyle name="con<%=id%>_opt1" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td>
      <input type=text class=inputstyle size=12 name="con<%=id%>_value1"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
    </td>
    <%
}
else if(htmltype.equals("4")){
%>
    <td colspan=4>
      <input type=checkbox value=1 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>
    </td>
    <%}
else if(htmltype.equals("5")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3>
      <select class=inputstyle name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')">
      	<option value=""  <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("")){%> selected <%}%>></option>
        <%
char flag=2;
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
%>
        <option value="<%=tmpselectvalue%>"  <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
        <%}%>
      </select>
    </td>
    <%} else if(htmltype.equals("3") && !type.equals("2")&& !type.equals("18")&& !type.equals("19")&& !type.equals("17") && !type.equals("37") && !type.equals("65")&&!type.equals("162")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3>
         <%
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
            if(type.equals("4") && sharelevel <2) {
                if(sharelevel == 1) browserurl = browserurl.trim() + "?sqlwhere=where subcompanyid1 = " + user.getUserSubCompany1() ;
                else browserurl = browserurl.trim() + "?sqlwhere=where id = " + user.getUserDepartment() ;
            }else if("161".equals(type)){
				browserurl = browserurl.trim() + "?type="+dbtype;
		    }
         %>
        <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <%} else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){ // 增加日期和时间的处理（之间）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
   onclick="onSearchWFDate(con<%=id%>_valuespan,con<%=id%>_value)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_valuespan,con<%=id%>_value)"
<%}%>
 ></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <td >
      <select class=inputstyle name="con<%=id%>_opt1" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td > <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
   onclick="onSearchWFDate(con<%=id%>_value1span,con<%=id%>_value1)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_value1span,con<%=id%>_value1)"
<%}%>
 ></button>
      <input type=hidden name="con<%=id%>_value1" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <span name="con<%=id%>_value1span" id="con<%=id%>_value1span">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("17")){ // 增加多人力资源的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("65")){ 
        // modify by mackjoe at 2005-11-24 td2862 增加多角色的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("18")){ // 增加多客户的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("37")){ // 增加多文档的处理（包含，不包含） %>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("162")){ // 增加多自定义浏览框的处理（包含，不包含） %>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <%
		String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
		browserurl = browserurl.trim() + "?type="+dbtype;
    %>
    <td colspan=3> <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> </td>
    <%}%>
    </tr>
	  <!-- 2012-08-16 ypc 修改-->  
      <tr style="height:2px"><td colSpan=7 class=line1></td></tr>

    <%
 if(linecolor==0) linecolor=1;
          else linecolor=0;}%>


<%}%>
  </table>

</td>
<td  width="20%"   vAlign=top >
      <TABLE class=ListStyle cellspacing=1>
        <COLGROUP> 
		  <COL width="40%">
		  <COL width="40%">
		  <COL width="20%">
        <TBODY>
        <TR class=header>
          <TH    colSpan=3><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></TH>
        </TR>
        <TR class=Line><TD colSpan=3></TD></TR>
        <TR class=DataLight>
          <TD  colSpan=3><a href="ReportCondition.jsp?id=<%=reportid%>"><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%></a></TD>
		 </TR>
<%
    String trClass="DataDark";
	int tempMouldId=-1;
	String tempMouldName="";
    String currentMouldName="";

    RecordSet.executeSql("select id,mouldName from WorkflowRptCondMould where userId="+user.getUID()+" and reportId="+reportid+" order by id asc");
	
	while(RecordSet.next()){
		tempMouldId=Util.getIntValue(RecordSet.getString(1),0);
		tempMouldName=Util.null2String(RecordSet.getString(2));

%>
        <TR class=<%=trClass%>>
          <TD><a href="ReportResult.jsp?reportid=<%=reportid%>&mouldId=<%=tempMouldId%>&searchByMould=1"><%=tempMouldName%></a></TD>
          <TD><a href="ReportConditionMould.jsp?id=<%=reportid%>&mouldId=<%=tempMouldId%>"><%=SystemEnv.getHtmlLabelName(364,user.getLanguage())%></a></TD>
          <TD><a href="ReportConditionEdit.jsp?id=<%=reportid%>&mouldId=<%=tempMouldId%>"><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%></a></TD>
		 </TR>
<%
	    if(trClass.equals("DataDark")){
	        trClass="DataLight";
        }else{
            trClass="DataDark";
		}

		if(mouldId==tempMouldId){
			currentMouldName=tempMouldName;
		}
	}

%>

        <TR class=<%=trClass%>>
          <TD     colSpan=3><input class=InputStyle type="text"  name="newMouldName" value="<%=currentMouldName%>" size=15 onChange="checkinput('newMouldName','newMouldNameSpan')">
          <span id=newMouldNameSpan>
<%
    if(currentMouldName==null||currentMouldName.trim().equals("")){
%>
		  <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
<%
	}
%>
		  </span></TD>
        </TR>
        </TBODY>
      </TABLE>
</td>
</tr>
</table>


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

</FORM>

<!--xwj for td2974 20051026   B E G I N-->
<script type="text/javascript">
function changeclick1(){
document.SearchForm.requestname_check_con.checked = true;
}
function changeclick2(){
document.SearchForm.requestlevel_check_con.checked = true;
}
function changeclick3(){<!--xwj for td2451 20051104 -->
document.SearchForm.requeststatus_check_con.checked = true;
}

function changeclick4(){
document.SearchForm.archiveTime.checked = true;
}

function onEditSaveTemplate(){
	if(check_form(document.SearchForm,'newMouldName')){
			if(document.all("todate").value != "" && document.all("fromdate").value > document.all("todate").value){
				alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
				return;
			}
	    document.SearchForm.operation.value="editSaveTemplate";
	    document.SearchForm.action="ReportConditionOperation.jsp";
	    document.SearchForm.submit();
	}
}


function onSaveAsTemplate(){
	if(check_form(document.SearchForm,'newMouldName')){
			if(document.all("todate").value != "" && document.all("fromdate").value > document.all("todate").value){
				alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
				return;
			}
	    document.SearchForm.operation.value="saveAsTemplate";
	    document.SearchForm.action="ReportConditionOperation.jsp";
	    document.SearchForm.submit();
	}
}

function submit(){
	if(document.all("todate").value != "" && document.all("fromdate").value > document.all("todate").value){
		alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
		return;
	}else{
  document.SearchForm.submit();
	}
}


function onDeleteTemplate(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")){
	    document.SearchForm.operation.value="deleteTemplate";
	    document.SearchForm.action="ReportConditionOperation.jsp";
	    document.SearchForm.submit();
	}
}

function onShowBrowser2(id,url) {
	var url = url + "?selectedids=" + $G("con"+id+"_value").value;
	var id1 = window.showModalDialog(url);
	if (id1 != null && id1 != undefined) {
	    if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
	    	var rid = wuiUtil.getJsonValueByIndex(id1, 0);
	    	var rname = wuiUtil.getJsonValueByIndex(id1, 1);
			if (rname.indexOf(",") == 0) {
				rname = rname.substr(1);
			}
			$G("con"+id+"_valuespan").innerHTML = rname;
			$G("con"+id+"_value").value = rid;
	        $G("con"+id+"_name").value = rname;
	    } else {
	    	$G("con"+id+"_valuespan").innerHTML = "";
	    	$G("con"+id+"_value").value="";
	    	$G("con"+id+"_name").value="";
	    }
	}
}

function onShowBrowser(id,url) {
	var id1 = window.showModalDialog(url + "&selectedids=" + $G("con"+id+"_value").value);

	if (id1 != null) {
		var rid = wuiUtil.getJsonValueByIndex(id1, 0);
		var rname = wuiUtil.getJsonValueByIndex(id1, 1);
	    if (rid != "" && rid != "0") {
			if (rname.indexOf(",") == 0) {
				rname = rname.substr(1);
			}
			$G("con"+id+"_valuespan").innerHTML = rname
			$G("con"+id+"_value").value=rid
	        $G("con"+id+"_name").value=rname
	    } else {
	    	$G("con"+id+"_valuespan").innerHTML = "";
	    	$G("con"+id+"_value").value="";
	    	$G("con"+id+"_name").value="";
	    }
	}
}

function onShowBrowser1(id,url,type1) {
	if (type1 == 1) {
		var id1 = window.showModalDialog(url, "", "dialogHeight:320px;dialogwidth:275px");
		$G("con"+id+"_valuespan").innerHTML = id1;
		$G("con"+id+"_value").value=id1;
	} else if( type1 == 2) {
		var id1 = window.showModalDialog(url, "","dialogHeight:320px;dialogwidth:275px");
		$G("con"+id+"_value1span").innerHTML = id1;
		$G("con"+id+"_value1").value=id1;
	}
}
function changelevel(tmpindex) {
	document.getElementsByName("check_con")[tmpindex - 1].checked = true;
}
function onShowResourceConditionBrowser(id, url, type1) {
	var linkurl = "";
	var ismand=0;
	var tmpids = $GetEle("con" + id+"_value").value;
	var dialogId = window.showModalDialog(url + "?resourceCondition=" + tmpids);
	if ((dialogId)) {
		if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
			var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
			var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
			var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
			var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
			var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
			var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
			var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
			var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);

			var sHtml = "";
			var fileIdValue = "";
			








			var shareTypeValueArray = shareTypeValues.split("~");
			var shareTypeTextArray = shareTypeTexts.split("~");
			var relatedShareIdseArray = relatedShareIdses.split("~");
			var relatedShareNameseArray = relatedShareNameses.split("~");
			var rolelevelValueArray = rolelevelValues.split("~");
			var rolelevelTextArray = rolelevelTexts.split("~");
			var secLevelValueArray = secLevelValues.split("~");
			var secLevelTextArray = secLevelTexts.split("~");
			for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {

				var shareTypeValue = shareTypeValueArray[_i];
				var shareTypeText = shareTypeTextArray[_i];
				var relatedShareIds = relatedShareIdseArray[_i];
				var relatedShareNames = relatedShareNameseArray[_i];
				var rolelevelValue = rolelevelValueArray[_i];
				var rolelevelText = rolelevelTextArray[_i];
				var secLevelValue = secLevelValueArray[_i];
				var secLevelText = secLevelTextArray[_i];
				if (shareTypeValue == "") {
					continue;
				}
				fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
						+ relatedShareIds + "_" + rolelevelValue + "_"
						+ secLevelValue;
				
				if (shareTypeValue == "1") {
					sHtml = sHtml + "," + shareTypeText + "("
							+ relatedShareNames + ")";
				} else if (shareTypeValue == "2") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage()==0?7:user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage()==0?7:user.getLanguage())%>";
				} else if (shareTypeValue == "3") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage()==0?7:user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage()==0?7:user.getLanguage())%>";
				} else if (shareTypeValue == "4") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage()==0?7:user.getLanguage())%>="
							+ rolelevelText
							+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage()==0?7:user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage()==0?7:user.getLanguage())%>";
				} else {
					sHtml = sHtml
							+ ","
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage()==0?7:user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage()==0?7:user.getLanguage())%>";
				}

			}
			
			sHtml = sHtml.substr(1);
			fileIdValue = fileIdValue.substr(1);

			//$GetEle("field" + id).value = fileIdValue;
			//$GetEle("field" + id + "span").innerHTML = sHtml;
			$G("con"+id+"_valuespan").innerHTML = sHtml;
	    	$G("con"+id+"_value").value= fileIdValue;
	    	$G("con"+id+"_name").value=sHtml;
		} else {
			$G("con"+id+"_valuespan").innerHTML = "";
	    	$G("con"+id+"_value").value="";
	    	$G("con"+id+"_name").value="";
	    }
	} 
}
function resetform() {
	document.SearchForm.reset();
	try{
		if($GetEle("newMouldName").value == '') {
			$GetEle("newMouldNameSpan").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		} else {
			$GetEle("newMouldNameSpan").innerHTML="";
		}
	}catch(e){}
}
</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>