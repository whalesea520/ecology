
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="java.util.*,weaver.hrm.common.*" %>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%

String cmd = Util.null2String(request.getParameter("cmd"));
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));//分部
int departmentid = Util.getIntValue(request.getParameter("departmentid"));//部门



//取自己分部
/*if(subcompanyid<=0&&departmentid<=0){
	boolean isAdmin = false;
	RecordSet.executeSql("select * from hrmresourcemanager where id = "+user.getUID());
	if(RecordSet.next()){
		isAdmin = true;
	}
	if(isAdmin){
		RecordSet.executeSql("select id from hrmsubcompany WHERE (canceled IS NULL OR  canceled=0) ORDER BY showorder asc");
		if(RecordSet.next()){
			subcompanyid = RecordSet.getInt("id");
		}
	}else{
		RecordSet.executeSql("select subcompanyid1 from hrmresource where id = "+user.getUID());
		if(RecordSet.next()){
			subcompanyid = RecordSet.getInt("subcompanyid1");
		}
	}
}*/
if(subcompanyid!=-1||departmentid!=0)cmd="f";

int[] subcomids=CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"AnnualLeave:All");
boolean HasRight=false;
for(int i=0;i<subcomids.length;i++){
   if(subcomids[i]==subcompanyid){ HasRight=true;}
}
if(user.getUID()!=1 && !HasRight){
   response.sendRedirect("/notice/noright.jsp");
   return;
}

String annualyear = Util.null2String(request.getParameter("annualyear"));
Calendar today = Calendar.getInstance() ; 
String currentyear = Util.add0(today.get(Calendar.YEAR),4) ;
String currentdate = Util.add0(today.get(Calendar.YEAR),4) + "-" + Util.add0(today.get(Calendar.MONTH)+1,2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH),2);
String tempyear = currentyear;
if(!annualyear.equals("")){
   session.setAttribute("annualyear",annualyear);
}
if(session.getAttribute("annualyear")!=null){
   tempyear = session.getAttribute("annualyear").toString();
}

String showname="";
String excelname="";
String sql="";
if(departmentid>0){
   subcompanyid=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+departmentid));
   showname=DepartmentComInfo.getDepartmentname(""+departmentid)+"<b>("+SystemEnv.getHtmlLabelName(124,user.getLanguage())+")</b>";
   excelname=DepartmentComInfo.getDepartmentname(""+departmentid);
   sql = "select distinct a.*,b.annualyear,b.annualdays from (select workcode,id,lastname,subcompanyid1,departmentid,jobtitle,dsporder,startdate,enddate from hrmresource where departmentid = " + departmentid + "  and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmannualmanagement b on a.id = b.resourceid and annualyear = '" + tempyear + "' and b.status <> 0 order by dsporder,lastname,a.id";
}else{
   showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid)+"<b>("+SystemEnv.getHtmlLabelName(141,user.getLanguage())+")</b>";
   excelname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
   sql = "select distinct a.*,b.annualyear,b.annualdays from (select workcode,id,lastname,subcompanyid1,departmentid,jobtitle,dsporder,startdate,enddate from hrmresource where 1=1 "+((cmd.length()==0||subcompanyid==-1)?"":("and subcompanyid1 = " + subcompanyid))+" and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10) a left join hrmannualmanagement b on a.id = b.resourceid and annualyear = '" + tempyear + "' and b.status <> 0 order by dsporder,lastname,a.id";
}
String annualperiod = "";
try{annualperiod = HrmAnnualManagement.getAnnualPeriod(subcompanyid+"",tempyear);}catch(Exception e){}
String enddate = Util.TokenizerString2(annualperiod,"#")[1];

String navName = "";
//if(departmentid!=-1) navName = DepartmentComInfo.getDepartmentName(""+departmentid);
//else if(subcompanyid!=-1) navName = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);

if(departmentid !=-1){
	navName =DepartmentComInfo.getDepartmentName(""+departmentid);
}else if(subcompanyid!=-1){
	if(cmd.length()==0){
		navName =SystemEnv.getHtmlLabelName(21600,user.getLanguage());
	}else{
		navName = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
	}
	
}




%>

<%    
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(21600,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
jQuery(document).ready(function(){
<%if(navName.length()>0){%>
 parent.setTabObjName('<%=navName%>')
 <%}%>
});
</script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(cmd.length()>0&&HrmUserVarify.checkUserRight("AnnualLeave:All", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32940,user.getLanguage())+",javascript:onLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
if(enddate.compareTo(currentdate)>-1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id=frmmain name=frmmain method=post action="HrmSalaryManageView.jsp">
<input class=inputstyle type="hidden" name="method" value="">
<input class=inputstyle type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="subCompanyId" value="<%=subcompanyid%>">
<input type="hidden" name="departmentid" value="<%=departmentid%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(cmd.length()>0&&HrmUserVarify.checkUserRight("AnnualLeave:All", user)){ %>
				<input type=button class="e8_btn_top" onclick="onEdit();" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(21602,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></wea:item>
	  <wea:item>
	    <select id=annualyear name=annualyear onchange="changeyear(this)">
	    <%//输出的列表为，2005年到当前年加10年，
	     int length = Integer.parseInt(currentyear)-2005+10;           
	     for(int i=0;i<length;i++){
	        String str = "<option value="+(2005+i)+">"+(2005+i)+"</option>";   
	        if(2005+i==Integer.parseInt(tempyear)) str="<option value="+(2005+i)+" selected>"+(2005+i)+"</option>";
	        out.println(str);
	     } 
	    %>   
	    </select>
    </wea:item>
    <%--<wea:item><%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%></wea:item>
    <wea:item><SPAN id=jobtitlespan><%=showname%></SPAN></wea:item>--%>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21602,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">
	<wea:item attributes="{'isTableList':'true'}">
		<wea:layout type="table" attributes="{'cols':'5','cws':'20%,20%,20%,20%,20%'}">
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
		    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
		    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		    <wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("33611,15878",user.getLanguage())%></wea:item>
		    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19517,user.getLanguage())%></wea:item>
  <%
    ExcelFile.init();
    ExcelSheet es = new ExcelSheet();

    ExcelRow er = es.newExcelRow ();

    er.addStringValue(SystemEnv.getHtmlLabelName(1867,user.getLanguage())+"ID");
    er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(141,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelNames("33611,15878",user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(21602,user.getLanguage())+SystemEnv.getHtmlLabelName(445,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(19517,user.getLanguage()));
    
    RecordSet.executeSql(sql);
    boolean color = false;
    while(RecordSet.next()){
        String workcode = Util.null2String(RecordSet.getString("workcode"));
        String id = RecordSet.getString("id");
        String lastname = RecordSet.getString("lastname");
        String tempsubcompanyid = RecordSet.getString("subcompanyid1");
        String tempdepartmentid = RecordSet.getString("departmentid");
        String jobtitle = Util.null2String(RecordSet.getString("jobtitle"));
		String workStartDate = Tools.vString(RecordSet.getString("startdate"));
		String workyear = "0.0";
		if(Tools.isNotNull(workStartDate)){
			String[] currentDate = Tools.getCurrentDate().split("-");
			if(currentDate[0].compareTo(tempyear) > 0) {
				currentDate[1] = "12";
				currentDate[2] = "31";
			}
			double _wy = Tools.round(Tools.compDate(workStartDate, tempyear + "-" + currentDate[1] + "-" + currentDate[2])/365, 1);
			if(_wy < 0){
				_wy = 0;
			}
			workyear = String.valueOf(_wy);
		}
        String tempannualdays = Util.round(Util.null2String(RecordSet.getString("annualdays")),2);

    if(departmentid>0){
       if(!tempdepartmentid.equals(departmentid+"")) continue;
    }else{
		if(cmd.length()!=0&&subcompanyid!=-1){
			if(!tempsubcompanyid.equals(subcompanyid+"")) continue;
		}
    }
    
    if(jobtitle.equals("")) continue;
    
    er = es.newExcelRow () ;

    er.addStringValue(id);
    er.addStringValue(lastname);
    er.addStringValue(SubCompanyComInfo.getSubCompanyname(tempsubcompanyid));
    er.addStringValue(DepartmentComInfo.getDepartmentname(tempdepartmentid));
    er.addStringValue(workyear);
    er.addStringValue(tempyear);
    er.addStringValue(Util.getFloatValue(tempannualdays,0)+"");
        
    color = !color;
     
  %>
  <%
    if(color) out.println("<tr class='datalight'>");
    else out.println("<tr class='datadark'>");
  %>
     <wea:item><a href=javascript:this.openFullWindowForXtable('/hrm/HrmTab.jsp?_fromURL=HrmResource&id=<%=id%>')><%=lastname%></a></wea:item>
     <wea:item><a href=javascript:this.openFullWindowForXtable('/hrm/HrmTab.jsp?_fromURL=HrmDepartment&subcompanyid=<%=tempsubcompanyid%>')><%=SubCompanyComInfo.getSubCompanyname(tempsubcompanyid)%></a></wea:item>
     <wea:item><a href=javascript:this.openFullWindowForXtable('/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp&id=<%=tempdepartmentid%>')><%=DepartmentComInfo.getDepartmentname(tempdepartmentid)%></a></wea:item>
     <wea:item><%=workyear%></wea:item>
     <wea:item><%=Util.getFloatValue(tempannualdays,0)%></wea:item>
  <%
    }
   ExcelFile.setFilename(Util.formatMultiLang(excelname, ""+user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+tempyear+SystemEnv.getHtmlLabelName(445,user.getLanguage())+SystemEnv.getHtmlLabelName(21602,user.getLanguage())) ;
   ExcelFile.addSheet(Util.formatMultiLang(excelname, ""+user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(21602,user.getLanguage()),es) ;
    
  %>
			</wea:group>
		</wea:layout>
	</wea:item>
  </wea:group>
</wea:layout>
</form>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="10%" width="10%" scrolling=no></iframe>
<script language=javascript>
function onEdit(){
    frmmain.action="AnnualManagementEdit.jsp";
    frmmain.submit();
}
function onLog(){
	 frmmain.action="AnnualManagementViewLog.jsp";
	 frmmain.submit();
}
function changeyear(){
    frmmain.action="AnnualManagementView.jsp";
    frmmain.submit();
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
