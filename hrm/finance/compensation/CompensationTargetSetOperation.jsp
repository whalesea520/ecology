
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
String option=Util.null2String(request.getParameter("option"));
int subcompanyid=Util.getIntValue(request.getParameter("subcompanyid"));
String TargetName=Util.fromScreen(request.getParameter("TargetName"),user.getLanguage());
String Explain=Util.fromScreen(request.getParameter("Explain"),user.getLanguage());
int AreaType=Util.getIntValue(request.getParameter("AreaType"),1);
int Targetid=Util.getIntValue(request.getParameter("Targetid"));
String Areaids=Util.null2String(request.getParameter("Areaids"));
if(Areaids.length()==0)Areaids="-1";
String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
double showOrder = Util.getDoubleValue(request.getParameter("showOrder"),0);
if(option.equals("add")) {
    RecordSet.executeSql("insert into HRM_CompensationTargetSet(subcompanyid,TargetName,Explain,AreaType,memo,showOrder) values("+subcompanyid+",'"+TargetName+"','"+Explain+"',"+AreaType+",'"+memo+"',"+showOrder+")");
    RecordSet.executeSql("select max(id) from HRM_CompensationTargetSet");
    if(RecordSet.next())
    Targetid=RecordSet.getInt(1);
    if(Targetid>0){
        ArrayList templist=Util.TokenizerString(Areaids,",");
        for(int i=0;i<templist.size();i++){
            RecordSet.executeSql("insert into HRM_ComTargetSetDetail(Targetid,companyordeptid) values("+Targetid+","+templist.get(i)+")");
        }
        response.sendRedirect("CompensationTargetSetEdit.jsp?isclose=1&id="+Targetid+"&subCompanyId="+subcompanyid);
    }else
    response.sendRedirect("CompensationTargetSetEdit.jsp?isclose=1&id="+Targetid+"&subCompanyId="+subcompanyid);
    return;
}
if(option.equals("edit")) {
    RecordSet.executeSql("delete from HRM_ComTargetSetDetail where Targetid="+Targetid);
    RecordSet.executeSql("update HRM_CompensationTargetSet set TargetName='"+TargetName+"',Explain='"+Explain+"',AreaType="+AreaType+",memo='"+memo+"',showOrder='"+showOrder+"',subcompanyid = '"+subcompanyid+"' where id="+Targetid);
    ArrayList templist=Util.TokenizerString(Areaids,",");
    for(int i=0;i<templist.size();i++){
        RecordSet.executeSql("insert into HRM_ComTargetSetDetail(Targetid,companyordeptid) values("+Targetid+","+templist.get(i)+")");
    }
    response.sendRedirect("CompensationTargetSetEdit.jsp?isclose=1&id="+Targetid+"&subCompanyId="+subcompanyid);
}
if(option.equals("delete")) {
   RecordSet.executeSql("delete from HRM_CompensationTargetSet where id="+Targetid);
   RecordSet.executeSql("delete from HRM_ComTargetSetDetail where Targetid="+Targetid);
   response.sendRedirect("CompensationTargetSet.jsp?subCompanyId="+subcompanyid);
}
%>
