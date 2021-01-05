<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptDwrUtil" class="weaver.cpt.util.CptDwrUtil" scope="page"/>
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("CptCapital:Discard", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String capitalid = "";
String discarddate = Util.fromScreen(request.getParameter("StockInDate"),user.getLanguage());
String capitalnum = "";
String fee = "";
String remark = "";
String sptcount = "";
String operator = "";
String olddept ="";
String dtinfo = Util.null2String(request.getParameter("dtinfo"));
dtinfo= dtinfo.replaceAll("_[0-9]*\":\"", "\":\"");
JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
if(dtJsonArray!=null&&dtJsonArray.size()>0){
	for(int i=0;i<dtJsonArray.size();i++){
		JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
		if(dtJsonArray2!=null&&dtJsonArray2.size()>=8){
			capitalnum= dtJsonArray2.getJSONObject(2).getString("capitalnum");
			fee= ""+Util.getDoubleValue( dtJsonArray2.getJSONObject(3).getString("cost"),0);
			remark= dtJsonArray2.getJSONObject(4).getString("remark");
			operator= dtJsonArray2.getJSONObject(5).getString("operator");
			discarddate= dtJsonArray2.getJSONObject(6).getString("StockInDate");
			capitalid= dtJsonArray2.getJSONObject(7).getString("capitalid");
			
			String sql="";
			sql="select departmentid from CptCapital where id="+ capitalid;
			RecordSetM.executeSql(sql);
			RecordSetM.next(); 
			olddept = RecordSetM.getString("departmentid");

			sptcount=Util.null2String(CptDwrUtil.getCptInfoMap(capitalid).get("sptcount"));
			if ("".equals( sptcount)){
				sptcount="0" ;
			}
			
			char separator = Util.getSeparator() ;
			String para = "";
			if(sptcount.equals("1")){
			para = capitalid;
			para +=separator+discarddate;
			para +=separator+"0";
			//para +=separator+"0";
			para +=separator+operator;
			para +=separator+"1";
			para +=separator+"";
			para +=separator+"0";
			para +=separator+"";
			para +=separator+fee;
			para +=separator+"5";
			para +=separator+remark;
			para +=separator+sptcount;
			para +=separator+olddept;
			RecordSet.executeProc("CptUseLogDiscard_Insert2",para);
			}
			else
			{
			para = capitalid;
			para +=separator+discarddate;
			para +=separator+"0";
			//para +=separator+"0";
			para +=separator+operator;
			para +=separator+capitalnum;
			para +=separator+"";
			para +=separator+"0";
			para +=separator+"";
			para +=separator+fee;
			para +=separator+"5";
			para +=separator+remark;
			para +=separator+sptcount;
			para +=separator+olddept;

			RecordSet.executeProc("CptUseLogDiscard_Insert2",para);
			RecordSet.next();
			String rtvalue = RecordSet.getString(1);    
				//数量错误
			    if(rtvalue.equals("-1"))
				{
			       response.sendRedirect("CptCapitalDiscardTab.jsp?capitalid="+capitalid+"&msgid=1"); 
				} 
			}
			
		}
	}
}

CapitalComInfo.removeCapitalCache();
response.sendRedirect("CptCapitalDiscardTab.jsp");
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">