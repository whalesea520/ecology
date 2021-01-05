<%@page import="weaver.cpt.util.CommonShareManager"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="weaver.common.util.xtree.TreeNode"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="cptgroup" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

if(user==null){
	out.print("[]");
}
String sqlwhere="";
String cpt_mycapital=Util.null2String(request.getParameter("cpt_mycapital"));
String from=Util.null2String(request.getParameter("from"));
int subcompanyid1=Util.getIntValue (request.getParameter("subcompanyid1"),0);
String isdata=Util.null2String(request.getParameter("isdata"));
if("1".equals(cpt_mycapital)&&!"1".equals(isdata)){
	sqlwhere=" and t1.stateid <> 1 and t1.resourceid in("+CommonShareManager.getContainsSubuserids(""+user.getUID())+") ";
}

//分权start==========
int detachable=0;
RecordSet.executeSql("select cptdetachable from SystemSet");
if(RecordSet.next()){
    detachable=RecordSet.getInt("cptdetachable");
}
if(detachable==1&& user.getUID()!=1){
	int belid = user.getUserSubCompany1();
	int userId = user.getUID();
	char flag=Util.getSeparator();
	String rightStr = "";
	String allsubid = "";
	String blonsubcomid = "";
	if(HrmUserVarify.checkUserRight("Capital:Maintenance",user)){
		rightStr = "Capital:Maintenance";
	}
	 if("1".equals(isdata)){
		 int allsubids[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),rightStr);
			for(int i=0;i<allsubids.length;i++){
				if(allsubids[i]>0){
					allsubid += (allsubid.equals("")?"":",") + allsubids[i];
				}	
			}
	}else{
		String sqltmp = "";
		rs2.executeProc("HrmRoleSR_SeByURId", ""+userId+flag+rightStr);
		while(rs2.next()){
		    blonsubcomid=rs2.getString("subcompanyid");
			sqltmp += (", "+blonsubcomid);
		}
		if(!"".equals(sqltmp)){//角色设置的权限
			sqltmp = sqltmp.substring(1);
				sqlwhere += " and t1.blongsubcompany in ("+sqltmp+") ";
		}else{
				sqlwhere += " and t1.blongsubcompany in ("+belid+") ";
		}
	}
}
//分权end==========

JSONArray arr=new JSONArray();
JSONObject obj=new JSONObject();

TreeMap<String,JSONObject> map=new  TreeMap<String,JSONObject>();

cptgroup.setTofirstRow();
while(cptgroup.next()){
	obj=new JSONObject();
	String id=cptgroup.getAssortmentId();
	int subcomid=Util.getIntValue( cptgroup.getSubcompanyid1(),0);
	if(subcompanyid1>0&&subcomid!=subcompanyid1){
		continue;
	}
	JSONObject attr=new JSONObject();
	attr.put("groupid", id);
	
	JSONObject numbers=new JSONObject();
	//numbers.put("data1count", cptgroup.getCapitalCount());
	if(!"cptassortment".equalsIgnoreCase(from)){//非中台资产组设置页面,有数字
		if("1".equals(isdata)){
			numbers.put("data2count", cptgroup.getCapitalData1Count(id));
		}else{
			numbers.put("data2count", cptgroup.getCapitaldata2Count(id,user,sqlwhere));
		}
	}else{
		numbers.put("data2count", "");
	}
	
	obj.put("id",id);
	obj.put("name", cptgroup.getAssortmentName());
	obj.put("pid", cptgroup.getSupAssortmentId());
	obj.put("attr", attr);
	obj.put("numbers", numbers);
	obj.put("submenus", new JSONArray());
	
	if(Util.getIntValue( cptgroup.getSubAssortmentCount(),0)<=0){
		obj.put("hasChildren", false);
	}
	
	map.put(id, obj);
}

Iterator it=map.entrySet().iterator();
while(it.hasNext()){
	Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
	String k= entry.getKey();
	JSONObject v= entry.getValue();
	
	int pid=Util.getIntValue( v.getString("pid"),0);
	JSONObject p=map.get(""+pid);
	if(pid>0){
		if(p!=null){
			((JSONArray)p.get("submenus")).put(v);
		}
	}else{
		arr.put(v);
	}
	
	
	if(p!=null){//资产(资产资料)计数
		JSONObject pObj= ((JSONObject)p.get("numbers"));
		JSONObject sObj= ((JSONObject)v.get("numbers"));
		int cnt= Util.getIntValue((String)sObj.get("data2count"),0)+Util.getIntValue((String)pObj.get("data2count"),0);
		pObj.put("data2count", ""+cnt);
	}
	
}


if("1".equals(cpt_mycapital)||"quick".equalsIgnoreCase(from)){//我的资产剔除没有资产的资产组
	JSONArray arr2=new JSONArray();
	for(int i=0;i<arr.length();i++){
		JSONObject o=(JSONObject) arr.get(i);
		JSONObject o2=o.getJSONObject("numbers");
		if(o2.getInt("data2count")>0){
			arr2.put(o);
		}
	}
	out.println(arr2.toString());
	//System.out.println(arr2.toString());
}else{
	out.print(arr.toString());
}

%>


