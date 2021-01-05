<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList,java.net.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="weaver.formmode.datainput.DynamicDataInput"%>
<%
out.clear();
String dtidx = Util.null2String(request.getParameter("dtidx"));
String formid = Util.null2String(request.getParameter("formid"));
String groupid = Util.null2String(request.getParameter("groupid"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
String fieldvalue = Util.null2String(request.getParameter("fieldvalue"));
String triggerfieldname = Util.null2String(request.getParameter("triggerfieldname"));
int layoutid = Util.getIntValue(request.getParameter("layoutid"), 0);
int type = Util.getIntValue(request.getParameter("type"),0);

String modeid = Util.null2String(request.getParameter("id"));
DynamicDataInput DDI = new DynamicDataInput(modeid,triggerfieldname);
DDI.setType(type);
DDI.setLayoutid(layoutid);

int tempdtidx = Util.getIntValue(dtidx)-1 ;
String js = DDI.ChangeDetailField(fieldname,fieldvalue,"",tempdtidx);
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
js = Util.StringReplace(js,"&quot;","\\\"");
//js = Util.StringReplace(js,"<br>","\\n");
//要返回原来的index
out.println(tempdtidx+";"+js);
%>