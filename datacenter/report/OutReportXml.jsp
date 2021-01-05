<%@ page import="java.util.*,weaver.datacenter.*,weaver.hrm.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String xmlstring = "" ;
OutReportManage OutReportManage = (OutReportManage)session.getAttribute("weaveroutreportmanager") ;
int reportrowcount = OutReportManage.getReportRowCount() ;
int outrepcolumn = OutReportManage.getReportColumnCount() ;

ArrayList crmgroupinfos = OutReportManage.getCrmgroupinfos() ;

xmlstring = "<?xml version='1.0' encoding='GBK'?>" + "\n" ;
xmlstring += "<data>" + "\n" ;

int rowindex = 0;
int year;

for(int j=1 ; j<= reportrowcount ; j++ ) {
    String groupstr = (String) crmgroupinfos.get(j-1) ;
    xmlstring += "<row" + j + ">" + "\n";
    xmlstring += "<level>" + groupstr + "</level>" + "\n";

    for(int i=1 ; i<= outrepcolumn ; i++ ) {
        String thevalue = OutReportManage.getReportValue(j,i) ;
        xmlstring += "<"+i+">" + thevalue + "</"+i+">" + "\n";
    }

    xmlstring += "</row" + j + ">" + "\n";
}
xmlstring += "<count>" + reportrowcount + "</count>\n" ;        
xmlstring += "</data>" + "\n" ;
out.print(xmlstring);

%>


