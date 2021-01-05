<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.ArrayList,java.net.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable,java.util.*,java.util.Map.Entry" %>
<%
out.clear();
String dtidx = Util.null2String(request.getParameter("dtidx"));
String isbill = Util.null2String(request.getParameter("isbill"));
String formid = Util.null2String(request.getParameter("formid"));
String groupid = Util.null2String(request.getParameter("groupid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String ismodestr = Util.null2String(request.getParameter("ismode"));
String datainputid = Util.null2String(request.getParameter("datainputid"));
String triggerfieldname = Util.null2String(request.getParameter("triggerfieldname"));
String index = Util.null2String(request.getParameter("index"));
int tempdtidx = Util.getIntValue(dtidx)-1 ;
boolean ismode = ismodestr.equals("1")?true:false ;
String wflid=request.getParameter("id");
String rand = Util.null2String(request.getParameter("rand")) ;
//DynamicDataInput DDI = new DynamicDataInput(wflid); //new DynamicDataInput(wflid,triggerfieldname,isbill);
DynamicDataInput DDI = new DynamicDataInput(wflid,triggerfieldname,isbill,"1");
ArrayList outfieldnamelist=new ArrayList();
ArrayList<Hashtable> outdatasList=new ArrayList<Hashtable>();
Hashtable outdatahash=new Hashtable();
try{
	StringBuffer str = new StringBuffer();
	str.append("try{");
	outfieldnamelist = (ArrayList)session.getAttribute("outfieldnamelist_"+groupid+"_"+datainputid+"_"+index);
	//outdatasList = (ArrayList<Hashtable>)session.getAttribute("outdatasList_"+groupid+"_"+datainputid);
	outdatahash = (Hashtable)session.getAttribute("outdatasList_"+groupid+"_"+datainputid+"_"+index);
	//for(int i=0;i<outdatasList.size();i++){
		//outdatahash = outdatasList.get(i);
		for(int j=0; j<outfieldnamelist.size(); j++){
				String tempfieldname = outfieldnamelist.get(j).toString() ;
			    String tempValue = (String)outdatahash.get(tempfieldname);
			    //System.out.println("tempfieldname  = "+tempfieldname+"  tempValue = "+tempValue);
			    tempValue = Util.StringReplace(tempValue,"\n","");
			    tempValue = Util.StringReplace(tempValue,"\r","");
			    tempValue = Util.StringReplace(tempValue,"\t","");
			    tempValue = Util.StringReplace(tempValue,"<","&lt;");
			    tempValue = Util.StringReplace(tempValue,">","&gt;");
			    //tempValue = Util.toExcelData(tempValue);
			    tempValue = Util.StringReplace(tempValue,";","┌weaver┌");
			    String js = DDI.ChangeDetailField(tempfieldname,tempValue,isbill,nodeid,triggerfieldname,tempdtidx,true);
			    
			    js = Util.StringReplace(js,"&quot；","\\\\\\\"");
			    js = Util.StringReplace(js,"\''", "\'");
			    js = Util.StringReplace(js,"┌weaver┌",";");
			    js = js.replaceAll("window.parent.document.getElementById\\(", "getElementByDocument\\(window.parent.document, ");
			    js = Util.StringReplace(js,"\\\"","\"");  
			    js = Util.StringReplace(js,"&lt;","<");
			    js = Util.StringReplace(js,"&gt;",">");
			    js = Util.StringReplace(js,"<br>","\\n");
				js += " window.parent.DataInputByBrowser(\""+tempfieldname+"_"+tempdtidx+"\");";
			    str.append(js);
		}//end outdataslit
	//}
	str.append("}catch(e){ alert(e.message);}");
	out.println(str.toString());
}catch(Exception e){
	out.println("");	
}
%>