<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CptDwrUtil" class="weaver.cpt.util.CptDwrUtil" scope="page"/>
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("CptCapital:Loss", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String capitalid = "";
String sptcount = "";
String capitalnum = "";
String lossdate = "";
String resourceid = "";
String departmentid = "" ;
String fee = "";
String remark = "";
String olddept ="";
String dtinfo = Util.null2String(request.getParameter("dtinfo"));
dtinfo= dtinfo.replaceAll("_[0-9]*\":\"", "\":\"");
//System.out.println("dtinfo:"+dtinfo);
JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
if(dtJsonArray!=null&&dtJsonArray.size()>0){
	for(int i=0;i<dtJsonArray.size();i++){
		JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
		if(dtJsonArray2!=null&&dtJsonArray2.size()>=8){
			capitalnum= dtJsonArray2.getJSONObject(2).getString("capitalnum");
			fee= ""+Util.getDoubleValue( dtJsonArray2.getJSONObject(3).getString("cost"),0);
			remark= dtJsonArray2.getJSONObject(4).getString("remark");
			resourceid= dtJsonArray2.getJSONObject(5).getString("operator");
			lossdate= dtJsonArray2.getJSONObject(6).getString("StockInDate");
			capitalid= dtJsonArray2.getJSONObject(7).getString("capitalid");
			departmentid = ResourceComInfo.getDepartmentID(resourceid) ;
			
			sptcount=Util.null2String(CptDwrUtil.getCptInfoMap(capitalid).get("sptcount"));
			
			String sql="";
			sql="select departmentid from CptCapital where id="+ capitalid;
			RecordSetM.executeSql(sql);
			RecordSetM.next(); 
			olddept = RecordSetM.getString("departmentid");

			char separator = Util.getSeparator() ;
			String para = "";

			if(sptcount.equals("1")){
			    para = capitalid;
			    para +=separator+lossdate;
			    para +=separator+departmentid;
			    para +=separator+resourceid;
			    para +=separator+"1";
			    para +=separator+"";
			    para +=separator+"0";
			    para +=separator+"";
			    para +=separator+fee;
			    para +=separator+"-7";
			    para +=separator+remark;
			    para +=separator+"0";
			    para +=separator+sptcount;
				para +=separator+olddept;

			    RecordSet.executeProc("CptUseLogLoss_Insert2",para);
			}else{
				sptcount="0";
			    para = capitalid;
			    para +=separator+lossdate;
			    para +=separator+departmentid;
			    para +=separator+resourceid;
			    para +=separator+capitalnum;
			    para +=separator+"";
			    para +=separator+"0";
			    para +=separator+"";
			    para +=separator+fee;
			    para +=separator+"-7";
			    para +=separator+remark;
			    para +=separator+"0";
			    para +=separator+sptcount;
				para +=separator+olddept;
			    
			    RecordSet.executeProc("CptUseLogLoss_Insert2",para);
			    RecordSet.next();
			    String rtvalue = RecordSet.getString(1);
			    //数量错误
			    if(rtvalue.equals("-1")){
			        response.sendRedirect("CptCapitalLossTab.jsp?capitalid="+capitalid+"&sptcount="+sptcount+"&msgid=1");
			    }
			}
			
		}
	}
}


CapitalComInfo.removeCapitalCache();
response.sendRedirect("CptCapitalLossTab.jsp");

%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">