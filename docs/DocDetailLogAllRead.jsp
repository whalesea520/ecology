
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
String hrmStatusSql = " and a.status in (0,1,2,3,10) ";
int start = Util.getIntValue(request.getParameter("start"),0);
int limit = Util.getIntValue(request.getParameter("limit"),10);

String sharetype = "";
String shareContent = "";
String shareSeclevel = "";

List allreadName = new ArrayList();
List allreadSubject = new ArrayList();
List alloperatetype = new ArrayList();
List allDate = new ArrayList();
List allTag = new ArrayList();
List allAddress = new ArrayList();

String readname = ""; 
String docsubject = "";
String operatedate = "";
String clientaddress = "";
String operatetype = "";

String sqlstr = "select a.id,b.docsubject from hrmresource a,DocDetail b where 1 = 2"+hrmStatusSql;

RecordSet.executeSql("select type,content,seclevel from shareinnerdoc where sourceid ="+docid);
while(RecordSet.next()){
  sharetype = RecordSet.getString("type");
  shareContent = RecordSet.getString("content");
  shareSeclevel = RecordSet.getString("seclevel");
  if("1".equals(sharetype)){
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where a.id="+shareContent+" and b.id="+docid+hrmStatusSql;
  }
  if("2".equals(sharetype)){
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where (a.subcompanyid1="+shareContent+" and a.seclevel >= "+shareSeclevel+") and b.id="+docid+hrmStatusSql;
  }
  if("3".equals(sharetype)){
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where (a.departmentid="+shareContent+" and a.seclevel >= "+shareSeclevel+") and b.id="+docid+hrmStatusSql;
  }
  if("4".equals(sharetype)){  
    /**取shareContent最后一位开始**/
    StringBuffer sb = new StringBuffer(shareContent);   
    String  str = (sb.reverse().toString()).trim();
    String fourstr = str.substring(0,1);
    StringBuffer nb = new StringBuffer(fourstr);
    String fanstr = nb.reverse().toString();
    /**取shareContent最后一位结束**/ 
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where a.id in(select resourceid from hrmrolemembers where roleid ="+shareContent.substring(0,shareContent.length()-1)+" and rolelevel="+fanstr+")  and b.id ="+docid+hrmStatusSql;
  }
  if("5".equals(sharetype)){
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where a.seclevel >= "+shareSeclevel+" and b.id ="+docid+hrmStatusSql;
  }
}

List docallreadName = (ArrayList)session.getAttribute("docallreadName_"+docid);
List docallreadSubject = (ArrayList)session.getAttribute("docallSubject_"+docid);
List docallDate = (ArrayList)session.getAttribute("docallDate_"+docid);
List docallTag = (ArrayList)session.getAttribute("docallTag_"+docid);
List docallAddress = (ArrayList)session.getAttribute("docallAddress_"+docid);
List docalloperatetype = (ArrayList)session.getAttribute("docalloperatetype_"+docid);

JSONObject oJson= new JSONObject();
JSONArray jsonList= new JSONArray();

if(session.getAttribute("docallreadName_"+docid) == null){
  RecordSet.executeSql(sqlstr);
  while(RecordSet.next()){
   readname = sptmForDoc.getName(RecordSet.getString("id"),"1");
   docsubject = RecordSet.getString("docsubject");		
   rs.executeSql("select operatetype,operatedate,operatetime,clientaddress from docdetaillog where docid = "+docid+" and operateuserid ="+RecordSet.getString("id"));
   if(rs.next()){
       allDate.add(docLog.getDateTime(rs.getString("operatedate"),rs.getString("operatetime")));
       allAddress.add(rs.getString("clientaddress"));
       operatetype = "<span><font color=\"red\">"+docLog.getDocStatus(rs.getString("operatetype"),String.valueOf(user.getLanguage()))+"</font></span>";
       alloperatetype.add(operatetype);
   }else{
      allDate.add(operatedate);
      allAddress.add(clientaddress);
      alloperatetype.add(SystemEnv.getHtmlLabelName(21971,user.getLanguage()));
   }
   allTag.add(docLog.getDocId(docid));
   allreadName.add(readname);
   allreadSubject.add(docsubject);
  }
  
  session.setAttribute("docallreadName_"+docid,allreadName);
  session.setAttribute("docallSubject_"+docid,allreadSubject);
  session.setAttribute("docallDate_"+docid,allDate);
  session.setAttribute("docallTag_"+docid,allTag);
  session.setAttribute("docallAddress_"+docid,allAddress);
  session.setAttribute("docalloperatetype_"+docid,alloperatetype);
  
  int starttemp = 10;
  if(allreadName.size()-start <10){
	 starttemp = allreadName.size()-start;
  }															
  for(int i=start;i<start+starttemp;i++){
		JSONObject tempJson= new JSONObject();
		tempJson.put("operatedate",allDate.get(i));
		tempJson.put("operateuserid",allreadName.get(i));
		tempJson.put("operatetype",alloperatetype.get(i));
		tempJson.put("tag",allTag.get(i));
		tempJson.put("subject",allreadSubject.get(i));
		tempJson.put("clientaddress",allAddress.get(i));
		jsonList.put(tempJson);
	}
	oJson.put("totalCount",allreadName.size());
}else{
  int starttemp = 10;
  if(docallreadName.size()-start <10){
	  starttemp = docallreadName.size()-start;
  }															
  for(int i=start;i<start+starttemp;i++){
		JSONObject tempJson= new JSONObject();
		tempJson.put("operatedate",docallDate.get(i));
		tempJson.put("operateuserid",docallreadName.get(i));
		tempJson.put("operatetype",docalloperatetype.get(i));
		tempJson.put("tag",docallTag.get(i));
		tempJson.put("subject",docallreadSubject.get(i));
		tempJson.put("clientaddress",docallAddress.get(i));
		jsonList.put(tempJson);
	}
	oJson.put("totalCount",docallreadName.size());
}

oJson.put("data",jsonList);
out.print(oJson.toString());
%>

