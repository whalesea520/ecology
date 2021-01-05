<%@ page import="java.util.*,weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
String outrepcategory = Util.null2String(request.getParameter("outrepcategory"));
String resultpage = "OutReportResult.jsp" ;
String usertype = user.getLogintype() ;
int crmnum = 0 ;
%>

<HTML>
<head>
<title></title>
  <script language=javascript><!--
  document.write('<div id=loadDiv style="padding-top:50; padding-left:50"><table border="1" cellpadding="1" cellspacing="1"><tr><td>'+
                 '正在生成报表，请等待<span id="loading"></span></td></tr></table></div>');
  var setInterval1 = setInterval("loading.innerText += '.'", 1000);
  var setInterval2 = setInterval("loading.innerText = ''", 15000);
  // --></script>
</head> 
<BODY onload='searchtemp.submit ()'>
<FORM name=searchtemp method=post action='<%=resultpage%>'>

<%
ArrayList crmsyskeynames = new ArrayList() ;
crmsyskeynames.add("crm") ;
for(int i=1; i<=10 ; i++) {
    crmsyskeynames.add("crm"+i) ;
}

String outrepid = Util.null2String(request.getParameter("outrepid"));
String moduleid = Util.null2String(request.getParameter("moduleid"));
String modulename= Util.null2String(request.getParameter("modulename")) ;


// 前面查询条件的值
Enumeration eu = request.getParameterNames() ;
while(eu.hasMoreElements() ) {
    String keyname = (String)eu.nextElement() ;
    String keyvalue = "" ;
    String tempfileddspname = "" ;
    
    if(moduleid.equals("") && (keyname.toUpperCase()).indexOf("CRM")==0 && crmsyskeynames.indexOf(keyname) == -1 ) {
        ArrayList tempfileddspnames = new ArrayList() ;
        ArrayList tempfileddspvalues = new ArrayList() ;
        rs.executeSql("select * from T_ConditionDetail where conditionid in (select conditionid from T_OutReportCondition where outrepid = " + outrepid + " ) " ) ;
        while(rs.next()) {
            String conditiondsp = Util.null2String(rs.getString("conditiondsp")) ;
            String conditionendsp = Util.null2String(rs.getString("conditionendsp")) ;
            if(user.getLanguage() == 8 && !conditionendsp.equals("")) conditiondsp = conditionendsp ;
            String conditionvalue = Util.null2String(rs.getString("conditionvalue")) ;
            tempfileddspnames.add(conditiondsp) ;
            tempfileddspvalues.add(conditionvalue) ;
        }

        String tempfiledvalues[] = request.getParameterValues(keyname) ;
        if(tempfiledvalues!=null) {
            for(int i=0 ; i<tempfiledvalues.length; i++) {
                String thefiledvalue = tempfiledvalues[i] ;
                int filedvalueindex = tempfileddspvalues.indexOf(thefiledvalue) ;
                if( filedvalueindex == -1 ) continue ;
                else {
                    if(tempfileddspname.equals("")) tempfileddspname = (String)tempfileddspnames.get(filedvalueindex) ;
                    else tempfileddspname += ","+(String)tempfileddspnames.get(filedvalueindex) ;
                }

                if(keyvalue.equals("")) keyvalue = tempfiledvalues[i] ;
                else keyvalue += ","+tempfiledvalues[i] ;
            }
        }
%>
        <input type="hidden" name="<%=keyname%>" value="<%=keyvalue%>">
        <input type="hidden" name="name_<%=keyname%>" value="<%=tempfileddspname%>">
 <%
    }
    else {
        keyvalue = Util.fromScreen(request.getParameter(keyname),user.getLanguage()) ;
        if(keyname.indexOf("crm")==0) crmnum ++ ;
        if(keyname.indexOf("crm")>=0 && usertype.equals("2") && crmnum > 0) continue ; 
%>
        <input type="hidden" name="<%=keyname%>" value="<%=keyvalue%>">
<%
    }    
}

// 模板中取出来的值
if(!moduleid.equals("")){
    rs.executeSql("select conditionname,conditionvalue from modulecondition where moduleid = " + moduleid + " and isuserdefine=0");
    while(rs.next() ) {
        String conditionname=Util.null2String(rs.getString("conditionname")) ;
        String conditionvalue=Util.toScreen(rs.getString("conditionvalue"),user.getLanguage()) ;

        if(conditionname.indexOf("crm")==0) crmnum ++ ;
        if(conditionname.indexOf("crm")>=0 && usertype.equals("2") && crmnum > 0) continue ; 

        if(conditionvalue.indexOf("7_")==0) {
        	if(user.getLanguage()==7||user.getLanguage()==9) conditionvalue = conditionvalue.substring(2) ;
            else continue ;
        }

        if(conditionvalue.indexOf("8_")==0) {
            if(user.getLanguage()==8) conditionvalue = conditionvalue.substring(2) ;
            else continue ;
        }
%>
    <input type="hidden" name="<%=conditionname%>" value="<%=conditionvalue%>">
<%
    }
}

if(usertype.equals("2") && crmnum > 0) {
%>
    <input type="hidden" name="crm" value="<%=user.getUID()%>">
    <input type="hidden" name="name_crm" value="<%=user.getUsername()%>">
<%}%>

    <input type="hidden" name="modulename" value="<%=modulename%>">
    <input type="hidden" name="outrepcategory" value="<%=outrepcategory%>">
</FORM>
</BODY>
</HTML>