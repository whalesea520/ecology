
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.json.*" %>
<%@page import="weaver.hrm.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="sptmForDoc" class="weaver.splitepage.transform.SptmForDoc" scope="page"/>
<jsp:useBean id="docLog" class="weaver.docs.DocDetailLogTransMethod" scope="page"/>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String docid = request.getParameter("docid");

int start = Util.getIntValue(request.getParameter("start"),0);
int limit = Util.getIntValue(request.getParameter("limit"),10);

String sharetype = "";
String shareContent = "";
String shareSeclevel = "";

List dlName = new ArrayList();
List dlSubject = new ArrayList();
List dloperatetype = new ArrayList();
List dlDate = new ArrayList();
List dlTag = new ArrayList();
List dlAddress = new ArrayList();

String readname = ""; 
String docsubject = "";
String operatedate = "";
String clientaddress = "";
String operatetype = "";

String sqlstr = "select a.id,b.docsubject from hrmresource a,DocDetail b where 1 = 2";

RecordSet.executeSql("select type,content,seclevel from shareinnerdoc where sourceid ="+docid);
while(RecordSet.next()){
  sharetype = RecordSet.getString("type");
  shareContent = RecordSet.getString("content");
  shareSeclevel = RecordSet.getString("seclevel");
  if("1".equals(sharetype)){
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where a.id="+shareContent+" and b.id="+docid;
  }
  if("2".equals(sharetype)){
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where (a.subcompanyid1="+shareContent+" and a.seclevel >= "+shareSeclevel+") and b.id="+docid; 
  }
  if("3".equals(sharetype)){
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where (a.departmentid="+shareContent+" and a.seclevel >= "+shareSeclevel+") and b.id="+docid; 
  }
  if("4".equals(sharetype)){  
    /**取shareContent最后一位开始**/
    StringBuffer sb = new StringBuffer(shareContent);   
    String  str = (sb.reverse().toString()).trim();
    String fourstr = str.substring(0,1);
    StringBuffer nb = new StringBuffer(fourstr);
    String fanstr = nb.reverse().toString();
    /**取shareContent最后一位结束**/ 
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where a.id in(select resourceid from hrmrolemembers where roleid ="+shareContent.substring(0,shareContent.length()-1)+" and rolelevel="+fanstr+")  and b.id ="+docid;
  }
  if("5".equals(sharetype)){
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where a.seclevel >= "+shareSeclevel+" and b.id ="+docid;
  }
}

List docdlName = (ArrayList)session.getAttribute("docdlName_"+docid);
List docdlSubject = (ArrayList)session.getAttribute("docdlSubject_"+docid);
List docdlDate = (ArrayList)session.getAttribute("docdlDate_"+docid);
List docdlTag = (ArrayList)session.getAttribute("docdlTag_"+docid);
List docdlAddress = (ArrayList)session.getAttribute("docdlAddress_"+docid);
List docdloperatetype = (ArrayList)session.getAttribute("docdloperatetype_"+docid);

JSONObject oJson= new JSONObject();
JSONArray jsonList= new JSONArray();

if(session.getAttribute("docdlName_"+docid) == null){
  RecordSet.executeSql(sqlstr);
  while(RecordSet.next()){
   readname = sptmForDoc.getName(RecordSet.getString("id"),"1");
   docsubject = RecordSet.getString("docsubject");      
   rs.executeSql("select operatetype,operatedate,operatetime,clientaddress from docdetaillog where docid = "+docid+" and operateuserid ="+RecordSet.getString("id") + " and operatetype='22'");
   while(rs.next()){
       dlDate.add(docLog.getDateTime(rs.getString("operatedate"),rs.getString("operatetime")));
       dlAddress.add(rs.getString("clientaddress"));
      dloperatetype.add(SystemEnv.getHtmlLabelName(258,user.getLanguage()));
      dlTag.add(docLog.getDocId(docid));
      dlName.add(readname);
      dlSubject.add(docsubject);
   }
  }
  
  session.setAttribute("docdlName_"+docid,dlName);
  session.setAttribute("docdlSubject_"+docid,dlSubject);
  session.setAttribute("docdlDate_"+docid,dlDate);
  session.setAttribute("docdlTag_"+docid,dlTag);
  session.setAttribute("docdlAddress_"+docid,dlAddress);
  session.setAttribute("docdloperatetype_"+docid,dloperatetype);
  
  int starttemp = 10;
  if(dlName.size()-start <10){
     starttemp = dlName.size()-start;
  }                                                         
  for(int i=start;i<start+starttemp;i++){
        JSONObject tempJson= new JSONObject();
        tempJson.put("operatedate",dlDate.get(i));
        tempJson.put("operateuserid",dlName.get(i));
        tempJson.put("operatetype",dloperatetype.get(i));
        tempJson.put("tag",dlTag.get(i));
        tempJson.put("subject",dlSubject.get(i));
        tempJson.put("clientaddress",dlAddress.get(i));
        jsonList.put(tempJson);
    }
    oJson.put("totalCount",dlName.size());
}else{
  int starttemp = 10;
  if(docdlName.size()-start <10){
      starttemp = docdlName.size()-start;
  }                                                         
  for(int i=start;i<start+starttemp;i++){
        JSONObject tempJson= new JSONObject();
        tempJson.put("operatedate",docdlDate.get(i));
        tempJson.put("operateuserid",docdlName.get(i));
        tempJson.put("operatetype",docdloperatetype.get(i));
        tempJson.put("tag",docdlTag.get(i));
        tempJson.put("subject",docdlSubject.get(i));
        tempJson.put("clientaddress",docdlAddress.get(i));
        jsonList.put(tempJson);
    }
    oJson.put("totalCount",docdlName.size());
}

oJson.put("data",jsonList);
out.print(oJson.toString());
%>
