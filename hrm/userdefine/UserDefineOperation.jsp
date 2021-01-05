<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String userid = Util.null2String(request.getParameter("userid"));
String returnurl = Util.null2String(request.getParameter("returnurl"));

String hasresourceid= Util.null2String(request.getParameter("hasresourceid"));
String hasresourcename= Util.null2String(request.getParameter("hasresourcename"));
String hasjobtitle    = Util.null2String(request.getParameter("hasjobtitle"));
String hasactivitydesc= Util.null2String(request.getParameter("hasactivitydesc"));
String hasjobgroup    = Util.null2String(request.getParameter("hasjobgroup"));
String hasjobactivity = Util.null2String(request.getParameter("hasjobactivity"));
String hascostcenter  = Util.null2String(request.getParameter("hascostcenter"));
String hascompetency  = Util.null2String(request.getParameter("hascompetency"));
String hasresourcetype= Util.null2String(request.getParameter("hasresourcetype"));
String hasstatus      = Util.null2String(request.getParameter("hasstatus"));
String hassubcompany  = Util.null2String(request.getParameter("hassubcompany"));
String hasdepartment  = Util.null2String(request.getParameter("hasdepartment"));
String haslocation    = Util.null2String(request.getParameter("haslocation"));
String hasmanager     = Util.null2String(request.getParameter("hasmanager"));
String hasassistant   = Util.null2String(request.getParameter("hasassistant"));
String hasroles       = Util.null2String(request.getParameter("hasroles"));
String hasseclevel    = Util.null2String(request.getParameter("hasseclevel"));
String hasjoblevel    = Util.null2String(request.getParameter("hasjoblevel"));
String hasworkroom    = Util.null2String(request.getParameter("hasworkroom"));
String hastelephone   = Util.null2String(request.getParameter("hastelephone"));
String hasstartdate   = Util.null2String(request.getParameter("hasstartdate"));
String hasenddate     = Util.null2String(request.getParameter("hasenddate"));
String hascontractdate= Util.null2String(request.getParameter("hascontractdate"));
String hasbirthday    = Util.null2String(request.getParameter("hasbirthday"));
String hassex         = Util.null2String(request.getParameter("hassex"));
String hasaccounttype = Util.null2String(request.getParameter("hasaccounttype"));
String hasage         = Util.null2String(request.getParameter("hasage"));
String projectable    = Util.null2String(request.getParameter("projectable"));
String crmable        = Util.null2String(request.getParameter("crmable"));
String itemable       = Util.null2String(request.getParameter("itemable"));
String docable        = Util.null2String(request.getParameter("docable"));
String workflowable   = Util.null2String(request.getParameter("workflowable"));
String subordinateable= Util.null2String(request.getParameter("subordinateable"));
String trainable      = Util.null2String(request.getParameter("trainable"));
String budgetable     = Util.null2String(request.getParameter("budgetable"));
String fnatranable    = Util.null2String(request.getParameter("fnatranable"));
String dspperpage     = Util.null2String(request.getParameter("dspperpage"));
//xiaofeng
String workplanable     = Util.null2String(request.getParameter("workplanable"));

String hasworkcode     = Util.null2String(request.getParameter("hasworkcode"));
String hasjobcall     = Util.null2String(request.getParameter("hasjobcall"));
String hasmobile     = Util.null2String(request.getParameter("hasmobile"));
String hasmobilecall     = Util.null2String(request.getParameter("hasmobilecall"));
String hasfax     = Util.null2String(request.getParameter("hasfax"));
String hasemail     = Util.null2String(request.getParameter("hasemail"));
String hasvirtualdepartment     = Util.null2String(request.getParameter("hasvirtualdepartment"));
String hasfolk     = Util.null2String(request.getParameter("hasfolk"));
String hasregresidentplace     = Util.null2String(request.getParameter("hasregresidentplace"));
String hasnativeplace     = Util.null2String(request.getParameter("hasnativeplace"));
String hascertificatenum     = Util.null2String(request.getParameter("hascertificatenum"));
String hasmaritalstatus     = Util.null2String(request.getParameter("hasmaritalstatus"));
String haspolicy     = Util.null2String(request.getParameter("haspolicy"));
String hasbememberdate     = Util.null2String(request.getParameter("hasbememberdate"));
String hasbepartydate     = Util.null2String(request.getParameter("hasbepartydate"));
String hasislabouunion     = Util.null2String(request.getParameter("hasislabouunion"));
String haseducationlevel     = Util.null2String(request.getParameter("haseducationlevel"));
String hasdegree     = Util.null2String(request.getParameter("hasdegree"));
String hashealthinfo     = Util.null2String(request.getParameter("hashealthinfo"));
String hasheight     = Util.null2String(request.getParameter("hasheight"));
String hasweight     = Util.null2String(request.getParameter("hasweight"));
String hasresidentplace     = Util.null2String(request.getParameter("hasresidentplace"));
String hashomeaddress     = Util.null2String(request.getParameter("hashomeaddress"));
String hastempresidentnumber     = Util.null2String(request.getParameter("hastempresidentnumber"));
String hasusekind     = Util.null2String(request.getParameter("hasusekind"));
String hasbankid1     = Util.null2String(request.getParameter("hasbankid1"));
String hasaccountid1     = Util.null2String(request.getParameter("hasaccountid1"));
String hasaccumfundaccount     = Util.null2String(request.getParameter("hasaccumfundaccount"));
String hasloginid     = Util.null2String(request.getParameter("hasloginid"));
String hassystemlanguage     = Util.null2String(request.getParameter("hassystemlanguage"));
String hasgroup     = Util.null2String(request.getParameter("hasgroup"));

    char separator = Util.getSeparator() ;
  	
	String para = userid         + separator + hasresourceid  + separator + hasresourcename+ separator + 
	              hasjobtitle    + separator + hasactivitydesc+ separator + hasjobgroup    + separator + 
	              hasjobactivity + separator + hascostcenter  + separator + hascompetency  + separator + 
	              hasresourcetype+ separator + hasstatus      + separator + hassubcompany  + separator + 
	              hasdepartment  + separator + haslocation    + separator + hasmanager     + separator + 
	              hasassistant   + separator + hasroles       + separator + hasseclevel    + separator + 
	              hasjoblevel    + separator + hasworkroom    + separator + hastelephone   + separator + 
	              hasstartdate   + separator + hasenddate     + separator + hascontractdate+ separator + 
	              hasbirthday    + separator + hassex         + separator + projectable    + separator + 
	              crmable        + separator + itemable       + separator + docable        + separator + 
	              workflowable   + separator + subordinateable+ separator + trainable      + separator + 
	              budgetable     + separator + fnatranable    + separator + dspperpage     + separator + 	              
	              hasage             + separator + hasworkcode      + separator + hasjobcall           + separator+ 
	              hasmobile          + separator + hasmobilecall    + separator + hasfax + separator   + 
	              hasemail           + separator + hasfolk          + separator + hasregresidentplace  + separator + 
	              hasnativeplace     + separator + hascertificatenum+ separator + hasmaritalstatus     + separator + 
	              haspolicy          + separator + hasbememberdate  + separator + hasbepartydate       + separator + 
	              hasislabouunion    + separator + haseducationlevel+ separator + hasdegree            + separator + 
	              hashealthinfo      + separator + hasheight        + separator + hasweight            + separator + 
	              hasresidentplace   + separator + hashomeaddress   + separator + hastempresidentnumber+ separator + 
	              hasusekind         + separator + hasbankid1       + separator + hasaccountid1        + separator + 
	              hasaccumfundaccount+ separator + hasloginid       + separator + hassystemlanguage    + separator + 
	              hasaccounttype + separator + workplanable+separator + hasvirtualdepartment;
	RecordSet.executeProc("HrmUserDefine_Insert",para);
	
	RecordSet.executeSql(" update hrmuserdefine set hasgroup='"+hasgroup+"' where userid="+userid);
	if(returnurl.equals("my")) response.sendRedirect("/hrm/search/HrmResourceView.jsp?id="+userid);
	else response.sendRedirect("/hrm/search/HrmResourceSearch.jsp");

%>
