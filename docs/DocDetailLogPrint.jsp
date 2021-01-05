
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

List printName = new ArrayList();
List printSubject = new ArrayList();
List printoperatetype = new ArrayList();
List printDate = new ArrayList();
List printTag = new ArrayList();
List printAddress = new ArrayList();

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

List docprintName = (ArrayList)session.getAttribute("docprintName_"+docid);
List docprintSubject = (ArrayList)session.getAttribute("docprintSubject_"+docid);
List docprintDate = (ArrayList)session.getAttribute("docprintDate_"+docid);
List docprintTag = (ArrayList)session.getAttribute("docprintTag_"+docid);
List docprintAddress = (ArrayList)session.getAttribute("docprintAddress_"+docid);
List docprintoperatetype = (ArrayList)session.getAttribute("docprintoperatetype_"+docid);

JSONObject oJson= new JSONObject();
JSONArray jsonList= new JSONArray();

if(session.getAttribute("docprintName_"+docid) == null){
  RecordSet.executeSql(sqlstr);
  while(RecordSet.next()){
   readname = sptmForDoc.getName(RecordSet.getString("id"),"1");
   docsubject = RecordSet.getString("docsubject");		
   rs.executeSql("select operatetype,operatedate,operatetime,clientaddress from docdetaillog where docid = "+docid+" and operateuserid ="+RecordSet.getString("id") + " and operatetype='21'");
   while(rs.next()){
       printDate.add(docLog.getDateTime(rs.getString("operatedate"),rs.getString("operatetime")));
       printAddress.add(rs.getString("clientaddress"));
      printoperatetype.add(SystemEnv.getHtmlLabelName(257,user.getLanguage()));
      printTag.add(docLog.getDocId(docid));
      printName.add(readname);
      printSubject.add(docsubject);
   }
  }
  
  session.setAttribute("docprintName_"+docid,printName);
  session.setAttribute("docprintSubject_"+docid,printSubject);
  session.setAttribute("docprintDate_"+docid,printDate);
  session.setAttribute("docprintTag_"+docid,printTag);
  session.setAttribute("docprintAddress_"+docid,printAddress);
  session.setAttribute("docprintoperatetype_"+docid,printoperatetype);
  
  int starttemp = 10;
  if(printName.size()-start <10){
	 starttemp = printName.size()-start;
  }															
  for(int i=start;i<start+starttemp;i++){
		JSONObject tempJson= new JSONObject();
		tempJson.put("operatedate",printDate.get(i));
		tempJson.put("operateuserid",printName.get(i));
		tempJson.put("operatetype",printoperatetype.get(i));
		tempJson.put("tag",printTag.get(i));
		tempJson.put("subject",printSubject.get(i));
		tempJson.put("clientaddress",printAddress.get(i));
		jsonList.put(tempJson);
	}
	oJson.put("totalCount",printName.size());
}else{
  int starttemp = 10;
  if(docprintName.size()-start <10){
	  starttemp = docprintName.size()-start;
  }															
  for(int i=start;i<start+starttemp;i++){
		JSONObject tempJson= new JSONObject();
		tempJson.put("operatedate",docprintDate.get(i));
		tempJson.put("operateuserid",docprintName.get(i));
		tempJson.put("operatetype",docprintoperatetype.get(i));
		tempJson.put("tag",docprintTag.get(i));
		tempJson.put("subject",docprintSubject.get(i));
		tempJson.put("clientaddress",docprintAddress.get(i));
		jsonList.put(tempJson);
	}
	oJson.put("totalCount",docprintName.size());
}

oJson.put("data",jsonList);
out.print(oJson.toString());
%>

