
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="DeptFieldManager0" class="weaver.proj.util.PrjFieldManager" scope="page"/>
<%
String flag=Util.null2String( request.getParameter("flag"));

if("initprjtypefield".equals(flag)){
	ProjectTypeComInfo.setTofirstRow();
	while(ProjectTypeComInfo.next()){
		int prjtype=Util.getIntValue( ProjectTypeComInfo.getProjectTypeid(),0);
		if(prjtype>0){
			DeptFieldManager0.syncDefinedFields(prjtype);
		}
	}

}

if("initcptuser".equals(flag)){
	//初始化资产使用人,创建人
	String sql1="select id,resourceid,createrid,stateid from cptcapital where isdata=2 and sptcount=1 and stateid<>1 and (resourceid is not null or resourceid!='') ";
	RecordSet.executeSql(sql1);
	while(RecordSet.next()){
		int cptid=RecordSet.getInt("id");
		int resourceid=RecordSet.getInt("resourceid");
		int createrid=RecordSet.getInt("createrid");
		if(resourceid>0){
			RecordSet2.executeSql("INSERT INTO CptCapitalShareInfo(relateditemid,sharetype,sharelevel,userid,isdefault) VALUES ("+cptid+",'6','2','"+resourceid+"','1')");
		}
		if(createrid>0){
			RecordSet2.executeSql("INSERT INTO CptCapitalShareInfo(relateditemid,sharetype,sharelevel,userid,isdefault) VALUES ("+cptid+",'7','2','"+createrid+"','1')");
		}
		
	}
}

if("nousecpttmp".equals(flag)){
	RecordSet.executeSql("update cus_formsetting set status='1' where module='cpt' ");
}
if("usecpttmp".equals(flag)){
	RecordSet.executeSql("update cus_formsetting set status='2' where module='cpt' ");
}

if("nouseprjtmp".equals(flag)){
	RecordSet.executeSql("update cus_formsetting set status='1' where module='prj' ");
}

if("useprjtmp".equals(flag)){
	RecordSet.executeSql("update cus_formsetting set status='2' where module='prj' ");
}



out.println("初始化完成!");

%>


<HTML>
<HEAD>

</HEAD>

<body>
	
	
</body>
</HTML>
