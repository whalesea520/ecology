<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String whereclause="";
String orderclause="";
String orderclause2="";
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;

boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;

String method=Util.null2String(request.getParameter("method"));

SearchClause.resetClause();
if(method.equals("viewhrm")){
	String resourceid=Util.null2String(request.getParameter("resourceid"));
	
    if( isoracle ) {
	    whereclause+=" ( concat(concat(',' , TO_CHAR(t1.hrmids)), ',') LIKE '%,"+resourceid+",%') ";
    }
    else {
        whereclause+=" (',' + CONVERT(varchar,t1.hrmids) + ',' LIKE '%,"+resourceid+",%') ";
    }
	
	SearchClause.setWhereClause(whereclause);
	response.sendRedirect("HomePageWFSearchResult.jsp?start=1&perpage=10");
	return;

}
if(method.equals("all")){
	String complete=Util.null2String(request.getParameter("complete"));

	//whereclause +=" t1.creater = "+userid+" and t1.creatertype = " + usertype;
	if(complete.equals("0")){
	    whereclause += " t2.isremark in( '0','1','5','7','8','9')" ;
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> 3 ";
	}
	else if(complete.equals("1")){
		whereclause += " (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = 3 ";
	}
	SearchClause.setWhereClause(whereclause);
	response.sendRedirect("HomePageWFSearchResult.jsp?start=1&perpage=10");
	return;
}
if(method.equals("myall")){
	String complete=Util.null2String(request.getParameter("complete"));
	
	//whereclause +=" t1.creater = "+userid+" and t1.creatertype = " + usertype;
	whereclause +="  t1.creater = "+userid+" and t1.creatertype = " + usertype;
	if(complete.equals("0")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> 3 ";
	}
	else if(complete.equals("1")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = 3 ";
	}
	SearchClause.setWhereClause(whereclause);
	response.sendRedirect("HomePageWFSearchResult.jsp?start=1&perpage=10");
	return;
}
if(method.equals("myreqeustbywftype")){
	String wftype=Util.null2String(request.getParameter("wftype"));
	String complete=Util.null2String(request.getParameter("complete"));
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") ";
	}
	else {
		whereclause +=" and t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") ";
	}
	whereclause +=" and t1.creater = "+userid+" and t1.creatertype = " + usertype;
	if(complete.equals("0")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> 3 ";
	}
	else if(complete.equals("1")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = 3 ";
	}
	SearchClause.setWhereClause(whereclause);
	response.sendRedirect("HomePageWFSearchResult.jsp?start=1&perpage=10");
	return;
}
if(method.equals("myreqeustbywfid")){
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	String complete=Util.null2String(request.getParameter("complete"));
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid = "+workflowid+" ";
	}
	else {
		whereclause +=" and t1.workflowid = "+workflowid+" ";
	}
	
	whereclause +=" and t1.creater = "+userid+" and t1.creatertype = " + usertype;
	
	if(complete.equals("0")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> 3 ";
	}
	else if(complete.equals("1")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = 3 ";
	}
	SearchClause.setWhereClause(whereclause);
	response.sendRedirect("HomePageWFSearchResult.jsp?start=1&perpage=10");
	return;
}

if(method.equals("reqeustbywftype")){
	String wftype=Util.null2String(request.getParameter("wftype"));
	String complete=Util.null2String(request.getParameter("complete"));
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") ";
	}
	else {
		whereclause +=" and t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") ";
	}
	
	if(complete.equals("0")){
		whereclause +=" and t2.isremark in( '0','1','5','7','8','9') ";
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> 3 ";
	}
	else if(complete.equals("1")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = 3 ";
	}
	SearchClause.setWhereClause(whereclause);
	response.sendRedirect("HomePageWFSearchResult.jsp?start=1&perpage=10");
	return;
}
if(method.equals("reqeustbywfid")){
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	String complete=Util.null2String(request.getParameter("complete"));
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid = "+workflowid+" ";
	}
	else {
		whereclause +=" and t1.workflowid = "+workflowid+" ";
	}
	
	if(complete.equals("0")){
		whereclause +=" and t2.isremark in( '0','1','5','7','8','9') ";
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> 3 ";
	}
	else if(complete.equals("1")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = 3 ";
	}
	SearchClause.setWhereClause(whereclause);
	response.sendRedirect("HomePageWFSearchResult.jsp?start=1&perpage=10");
	return;
}
String createrid=Util.null2String(request.getParameter("createrid"));
String docids=Util.null2String(request.getParameter("docids"));
String crmids=Util.null2String(request.getParameter("crmids"));
String hrmids=Util.null2String(request.getParameter("hrmids"));
String prjids=Util.null2String(request.getParameter("prjids"));
String creatertype=Util.null2String(request.getParameter("creatertype"));
String workflowid=Util.null2String(request.getParameter("workflowid"));
String nodetype=Util.null2String(request.getParameter("nodetype"));
String fromdate=Util.null2String(request.getParameter("fromdate"));
String todate=Util.null2String(request.getParameter("todate"));
String lastfromdate=Util.null2String(request.getParameter("lastfromdate"));
String lasttodate=Util.null2String(request.getParameter("lasttodate"));
int during=Util.getIntValue(request.getParameter("during"),0);
int order=Util.getIntValue(request.getParameter("order"),0);
int isdeleted=Util.getIntValue(request.getParameter("isdeleted"),0);
String requestname=Util.fromScreen(request.getParameter("requestname"),user.getLanguage());
int subday1=Util.getIntValue(request.getParameter("subday1"),0);
int subday2=Util.getIntValue(request.getParameter("subday2"),0);
int maxday=Util.getIntValue(request.getParameter("maxday"),0);
int state=Util.getIntValue(request.getParameter("state"),0);
String requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());

Calendar now = Calendar.getInstance();
String today=Util.add0(now.get(Calendar.YEAR), 4) +"-"+
	Util.add0(now.get(Calendar.MONTH) + 1, 2) +"-"+
        Util.add0(now.get(Calendar.DAY_OF_MONTH), 2) ;
int year=now.get(Calendar.YEAR);
int month=now.get(Calendar.MONTH);
int day=now.get(Calendar.DAY_OF_MONTH);

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

if(!createrid.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.creater='"+createrid+"'";}
	else {whereclause+=" and t1.creater='"+createrid+"'";}
	if(!creatertype.equals("")){
		if(whereclause.equals("")) {whereclause+=" t1.creatertype='"+creatertype+"'";}
		else {whereclause+=" and t1.creatertype='"+creatertype+"'";}
	}
}

if( isoracle ) {
    if(!docids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , To_char(t1.docids) ), ',') LIKE '%,"+docids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , to_char(t1.docids)) , ',') LIKE '%,"+docids+",%') ";}
    }
    if(!crmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , TO_CHAR(t1.crmids) ), ',') LIKE '%,"+crmids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , TO_CHAR(t1.crmids) ), ',' LIKE '%,"+crmids+",%') ";}
    }
    if(!hrmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , TO_CHAR(t1.hrmids) ), ',') LIKE '%,"+hrmids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , TO_CHAR(t1.hrmids) ), ',') LIKE '%,"+hrmids+",%') ";}
    }
    if(!prjids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , TO_CHAR(t1.prjids) ), ',') LIKE '%,"+prjids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , TO_CHAR(t1.prjids) ), ',') LIKE '%,"+prjids+",%') ";}
    }
}
else {
    if(!docids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (',' + CONVERT(varchar,t1.docids) + ',' LIKE '%,"+docids+",%') ";}
        else {whereclause+=" and (',' + CONVERT(varchar,t1.docids) + ',' LIKE '%,"+docids+",%') ";}
    }
    if(!crmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (',' + CONVERT(varchar,t1.crmids) + ',' LIKE '%,"+crmids+",%') ";}
        else {whereclause+=" and (',' + CONVERT(varchar,t1.crmids) + ',' LIKE '%,"+crmids+",%') ";}
    }
    if(!hrmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (',' + CONVERT(varchar,t1.hrmids) + ',' LIKE '%,"+hrmids+",%') ";}
        else {whereclause+=" and (',' + CONVERT(varchar,t1.hrmids) + ',' LIKE '%,"+hrmids+",%') ";}
    }
    if(!prjids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (',' + CONVERT(varchar,t1.prjids) + ',' LIKE '%,"+prjids+",%') ";}
        else {whereclause+=" and (',' + CONVERT(varchar,t1.prjids) + ',' LIKE '%,"+prjids+",%') ";}
    }
}
if(!workflowid.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.workflowid in("+workflowid+")";}
	else {whereclause+=" and t1.workflowid in("+workflowid+")";}
}
if(!requestname.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.requestname like '%"+requestname+"%'";}
	else {whereclause+=" and t1.requestname like '%"+requestname+"%'";}
}
if(!nodetype.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype='"+nodetype+"'";}
	else {whereclause+=" and t1.currentnodetype='"+nodetype+"'";}
}

if(!lastfromdate.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.lastoperatedate>='"+lastfromdate+"'";}
	else {whereclause+=" and t1.lastoperatedate>='"+lastfromdate+"'";}
}
if(!lasttodate.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.lastoperatedate<='"+lasttodate+"'";}
	else {whereclause+=" and t1.lastoperatedate<='"+lasttodate+"'";}
}
if(during==0){
	if(!fromdate.equals("")){
		if(whereclause.equals("")){whereclause+=" t1.createdate>='"+fromdate+"'";}
		else {whereclause+=" and t1.createdate>='"+fromdate+"'";}
	}
	if(!todate.equals("")){
		if(whereclause.equals("")){whereclause+=" t1.createdate<='"+todate+"'";}
		else {whereclause+=" and t1.createdate<='"+todate+"'";}
	}
}
else{
	if(during==1){
		if(whereclause.equals(""))	whereclause+=" t1.createdate='"+today+"'";
		else  whereclause+=" and t1.createdate='"+today+"'";
	}
	if(during==2){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-1);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        /* 刘煜 2004－05－08 修改，原来or 之间没有括号，造成系统死机 */
		if(whereclause.equals(""))	
			whereclause+=" ((t1.createdate='"+today+"' and t1.createtime<='"+CurrentTime+"')"+
			 " or (t1.createdate='"+lastday+"' and t1.createtime>='"+CurrentTime+"'))";
		else  
			whereclause+=" and ((t1.createdate='"+today+"' and t1.createtime<='"+CurrentTime+"')"+
			 " or (t1.createdate='"+lastday+"' and t1.createtime>='"+CurrentTime+"'))";
	}
	if(during==3){
		int days=now.getTime().getDay();
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-days);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==4){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-7);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==5){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,1);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==6){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-30);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==7){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,0,1);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==8){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-365);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
		
}

if( isoracle ) {
    if(subday1!=0){
        if(whereclause.equals(""))	
            whereclause+="  (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))>"+subday1;
        else
            whereclause+=" and (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))>"+subday1;
    }

    if(subday2!=0){
        if(whereclause.equals(""))	
            whereclause+="  (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))<="+subday2;
        else
            whereclause+=" and (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))<="+subday2;
    }

    if(maxday!=0){
        if(whereclause.equals(""))	
            whereclause+="  (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))="+maxday;
        else
            whereclause+=" and (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))="+maxday;
    }
}
else {
    if(subday1!=0){
        if(whereclause.equals(""))	
            whereclause+="  (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))>"+subday1;
        else
            whereclause+=" and (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))>"+subday1;
    }

    if(subday2!=0){
        if(whereclause.equals(""))	
            whereclause+="  (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))<="+subday2;
        else
            whereclause+=" and (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))<="+subday2;
    }

    if(maxday!=0){
        if(whereclause.equals(""))	
            whereclause+=" (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))="+maxday;
        else
            whereclause+=" and (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))="+maxday;
    }
}


if(state==1){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype='3'";}
	else {whereclause+=" and t1.currentnodetype='3'";}
}
if(state==2){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype<>'3'";}
	else {whereclause+=" and t1.currentnodetype<>'3'";}
}

if(isdeleted!=2){
	if(whereclause.equals(""))	whereclause+=" t1.deleted="+isdeleted;
	else	whereclause+=" and t1.deleted="+isdeleted;
}

if(!requestlevel.equals("")){
	if(whereclause.equals(""))	whereclause+=" t1.requestlevel="+requestlevel;
	else	whereclause+=" and t1.requestlevel="+requestlevel;
}

if(order==0)    order=3;

if(order==1){
	orderclause="order by t1.requestid desc";
	orderclause2="order by t1.requestid";	
}
if(order==2){
	orderclause="order by t1.requestid";
	orderclause2="order by t1.requestid desc";
}
if(order==3){
	orderclause="order by t1.createdate desc";
	orderclause2="order by t1.createdate";
}
if(order==4){
	orderclause="order by t1.createdate";
	orderclause2="order by t1.createdate desc";
}
if(order==5){
	orderclause="order by t1.lastoperatedate desc";
	orderclause2="order by t1.lastoperatedate";
}
if(order==6){
	orderclause="order by t1.lastoperatedate";
	orderclause2="order by t1.lastoperatedate desc";
}
if(order==7){
	orderclause="order by t1.creater";
	orderclause2="order by t1.creater desc";
}
if(order==8){
	orderclause="order by t1.requestname";
	orderclause2="order by t1.requestname desc";
}

//  out.print(whereclause);
//  out.print(orderclause);

SearchClause.setOrderClause(orderclause);
SearchClause.setOrderClause2(orderclause2);
SearchClause.setWhereClause(whereclause);
response.sendRedirect("HomePageWFSearchResult.jsp?start=1&perpage=10");
%>