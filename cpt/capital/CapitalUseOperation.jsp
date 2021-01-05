<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CptDwrUtil" class="weaver.cpt.util.CptDwrUtil" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("CptCapital:Use", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

char flag=2;
String para = "";

String capitalid = "";
String capitalnum = "";
String resourceid = "";
String departmentid = "";
String remark = "";
String sptcount = "";
String location="";
boolean isoracle = RecordSet.getDBType().equals("oracle");
String sqltemp="";
String useddate = "";

int totaldetail = Util.getIntValue(request.getParameter("totaldetail"),0);


String dtinfo = Util.null2String(request.getParameter("dtinfo"));
dtinfo= dtinfo.replaceAll("_[0-9]*\":\"", "\":\"");
//System.out.println("dtinfo:"+dtinfo);
JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
if(dtJsonArray!=null&&dtJsonArray.size()>0){
	for(int i=0;i<dtJsonArray.size();i++){
		JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
		if(dtJsonArray2!=null&&dtJsonArray2.size()>=8){
			capitalnum= dtJsonArray2.getJSONObject(2).getString("capitalnum");
			location= dtJsonArray2.getJSONObject(3).getString("location");
			remark= dtJsonArray2.getJSONObject(4).getString("remark");
			useddate= dtJsonArray2.getJSONObject(5).getString("StockInDate");
			capitalid= dtJsonArray2.getJSONObject(6).getString("capitalid");
			resourceid= dtJsonArray2.getJSONObject(7).getString("hrmid");
			
			departmentid = ResourceComInfo.getDepartmentID(resourceid);
			sptcount =CptDwrUtil.getCptInfoMap(capitalid).get("sptcount");
			
			if(!capitalid.equals("")){
			    if(sptcount.equals("1")){
			        para = capitalid;
			        para +=flag+useddate;
			        para +=flag+departmentid;
			        para +=flag+resourceid;
			        para +=flag+"1";
			        //para +=flag+userequest;
			        para +=flag+"";
			        para +=flag+"0";
			        para +=flag+"2";
			        para +=flag+remark;
			        para +=flag+location;
			        para +=flag+sptcount;

			        RecordSet.executeProc("CptUseLogUse_Insert",para);
			    }else{ 
			        para = capitalid;
			        para +=flag+useddate;
			        para +=flag+departmentid;
			        para +=flag+resourceid;
			        para +=flag+capitalnum;
			        // para +=separator+userequest; 
			        para +=flag+"";    
			        para +=flag+"0";  
			        para +=flag+"2";
			        para +=flag+remark;
			        para +=flag+location;
			        para +=flag+"0";

			        RecordSet.executeProc("CptUseLogUse_Insert",para);
			        RecordSet.next();
			        String rtvalue = RecordSet.getString(1);    
			        //数量错误
			        if(rtvalue.equals("-1")){
			           response.sendRedirect("CptCapitalUse.jsp?capitalid="+capitalid+"&msgid=1"); 
			        } 
			    }

			    RecordSet.executeProc("HrmInfoStatus_UpdateCapital",""+resourceid);
			    CapitalComInfo.removeCapitalCache();
			    CptShare.setCptShareByCpt(capitalid);//更新detail表
			    
			    if(!location.equals("")){
			        RecordSet.executeSql("update CptCapital set location='"+location+"' where id="+capitalid);
			    }

			    //更新折旧开始时间
			if("1".equals(sptcount)){
			    if(!isoracle){
			        sqltemp="update CptCapital set deprestartdate='"+useddate+"' where id="+capitalid+" and (deprestartdate is null or deprestartdate='')";
			    }else{
			        sqltemp="update CptCapital set deprestartdate='"+useddate+"' where id="+capitalid+" and deprestartdate is null";
			    }
			    RecordSet.executeSql(sqltemp);
			    }
			}
			
			
		}
	}
}

response.sendRedirect("CptCapitalUseTab.jsp");

%>
