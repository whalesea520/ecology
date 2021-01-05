<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("CptCapital:Return", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String sptcount="";
int userid = user.getUID();
int  deparmentid  = user.getUserDepartment();
String olddept ="";
String stateid ="";
String resourceid ="";
String deprestartdate ="";

String method = Util.null2String(request.getParameter("method"));
if("backMyCpt".equalsIgnoreCase(method)){//归还我的资产
	String capitalid = Util.null2String(request.getParameter("capitalid"));
	
	String sql="";
	sql="select sptcount,departmentid,stateid,resourceid,deprestartdate from CptCapital where id="+ capitalid;
	RecordSetM.executeSql(sql);
	RecordSetM.next(); 
	sptcount = RecordSetM.getString("sptcount");
	olddept = RecordSetM.getString("departmentid");
	resourceid = RecordSetM.getString("resourceid");
	stateid = RecordSetM.getString("stateid");
	deprestartdate = RecordSetM.getString("deprestartdate");
	
	char separator = Util.getSeparator() ;
	String para = "";
	
	para = capitalid;
	para +=separator+TimeUtil.getCurrentDateString() ;
	//para +=(separator+""+deparmentid);
	//para +=(separator+""+userid);
	para +=separator+"";
	para +=separator+"";
	para +=separator+"1";
	para +=separator+"";
	para +=separator+"0";
	para +=separator+"";
	para +=separator+"0";
	if(stateid.equals("4")&&!resourceid.equals("0")){
		para +=separator+"2";
	}else{
		para +=separator+"1";
	}
	para +=separator+"";
	para +=separator+"0";
	para +=separator+sptcount;
	para +=separator+olddept;
	RecordSet.executeProc("CptUseLogBack_Insert2",para);
	
	CapitalComInfo.deleteCapitalCache(capitalid);
	CptShare.setCptShareByCpt(capitalid);//更新detail表
	
	//如果资产状态是送修 那么归还的资产应该归还到原使用人名下
	if(stateid.equals("4")&&!resourceid.equals("0")){
		RecordSetM.executeSql("update cptcapital set resourceid = "+resourceid+",departmentid = "+olddept+",deprestartdate='"+deprestartdate+"' where id = "+capitalid+"");
	}

	return;
}


String backdate = "";




String dtinfo = Util.null2String(request.getParameter("dtinfo"));
dtinfo= dtinfo.replaceAll("_[0-9]*\":\"", "\":\"");
//System.out.println("dtinfo:"+dtinfo);
JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
if(dtJsonArray!=null&&dtJsonArray.size()>0){
	for(int i=0;i<dtJsonArray.size();i++){
		JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
		if(dtJsonArray2!=null&&dtJsonArray2.size()>=4){
			String remark= dtJsonArray2.getJSONObject(1).getString("remark");
			backdate= dtJsonArray2.getJSONObject(2).getString("StockInDate");
			String capitalid= dtJsonArray2.getJSONObject(3).getString("capitalid");
			
			String sql="";
			sql="select sptcount,departmentid,stateid,resourceid,deprestartdate from CptCapital where id="+ capitalid;
				RecordSetM.executeSql(sql);
				RecordSetM.next(); 
				sptcount = RecordSetM.getString("sptcount");
			olddept = RecordSetM.getString("departmentid");
			resourceid = RecordSetM.getString("resourceid");
			stateid = RecordSetM.getString("stateid");
			deprestartdate = RecordSetM.getString("deprestartdate");

			char separator = Util.getSeparator() ;
			String para = "";

			para = capitalid;
			para +=separator+backdate;
			//para +=(separator+""+deparmentid);
			//para +=(separator+""+userid);
			para +=separator+"";
			para +=separator+"";
			para +=separator+"1";
			para +=separator+"";
			para +=separator+"0";
			para +=separator+"";
			para +=separator+"0";
			if(stateid.equals("4")&&!resourceid.equals("0")){
				para +=separator+"2";
			}else{
				para +=separator+"1";
			}
			para +=separator+remark;
			para +=separator+"0";
			para +=separator+sptcount;
			para +=separator+olddept;
			RecordSet.executeProc("CptUseLogBack_Insert2",para);
			
			
			CptShare.setCptShareByCpt(capitalid);//更新detail表 

			//如果资产状态是送修 那么归还的资产应该归还到原使用人名下
			if(stateid.equals("4")&&!resourceid.equals("0")){
				RecordSetM.executeSql("update cptcapital set resourceid = "+resourceid+",departmentid = "+olddept+",deprestartdate='"+deprestartdate+"' where id = "+capitalid+"");
			}
		}
	}
	CapitalComInfo.removeCapitalCache();
}


response.sendRedirect("CptCapitalBackTab.jsp");
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">