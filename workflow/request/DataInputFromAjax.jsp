<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.ArrayList,java.net.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable" %>
<%
out.clear();
String dtidx = Util.null2String(request.getParameter("dtidx"));
String isbill = Util.null2String(request.getParameter("isbill"));
String formid = Util.null2String(request.getParameter("formid"));
String groupid = Util.null2String(request.getParameter("groupid"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
String fieldvalue = Util.null2String(request.getParameter("fieldvalue"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String ismodestr = Util.null2String(request.getParameter("ismode"));
String triggerfieldname = Util.null2String(request.getParameter("triggerfieldname"));

boolean ismode = ismodestr.equals("1")?true:false ;
String wflid=request.getParameter("id");
DynamicDataInput DDI = new DynamicDataInput(wflid,triggerfieldname,isbill,"1");

int tempdtidx = Util.getIntValue(dtidx)-1 ;
String js = DDI.ChangeDetailField(fieldname,fieldvalue,isbill,nodeid,"",tempdtidx,ismode);
String inputchecks=DDI.GetNeedCheckStr();
String resultdata = "";
js = Util.StringReplace(js,"&quot；","\\\\\\\"");
js = Util.StringReplace(js,"\''", "\'");
js = Util.StringReplace(js,"┌weaver┌",";");
js = js.replaceAll("window.parent.document.getElementById\\(", "getElementByDocument\\(window.parent.document, ");
js = Util.StringReplace(js,"\\\"","\"");
js += "try{ "+
	  "	var trgelement = getElementByDocument(window.parent.document, '"+fieldname+"_"+tempdtidx+"');"+
	  " window.parent.jQuery(trgelement).attr('onafterpaste','');" +
	  "	window.parent.jQuery(trgelement).trigger('change');"+
	  //"	window.parent.jQuery(trgelement).focus();"+
	  //"	window.parent.jQuery(trgelement).blur();"+
	  //" window.parent.hoverShowNameSpan('.e8_showNameClass');"+
	  "}catch(e){}";
js = Util.StringReplace(js,"┌weaver┌",";");	  
js = Util.StringReplace(js,"&lt;","<");
js = Util.StringReplace(js,"&gt;",">");
//js = Util.StringReplace(js,"<br>","\\n");
//要返回原来的index
out.println(tempdtidx+";"+js);
%>