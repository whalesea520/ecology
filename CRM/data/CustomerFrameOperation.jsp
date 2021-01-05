
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="java.util.*" %>
<%@page import="weaver.crm.CrmShareBase"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsMain" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsSub" class="weaver.conn.RecordSet" scope="page"/>
<%
int mainType = Util.getIntValue(request.getParameter("mainType"),2);;//客户状态 【0为type；1为description；2为status；3为size】
int subType = Util.getIntValue(request.getParameter("subType"),1);;//客户描述【0为type；1为description；2为status；3为size】
String[] tabArr = {"CRM_CustomerType","CRM_CustomerDesc","CRM_CustomerStatus","CRM_CustomerSize"};
String[] fieldArr = {"type","Description","status","size_n"};
User user = HrmUserVarify.getUser(request , response) ;

String leftMenus="";

rsMain.execute("select id ,fullname from "+tabArr[mainType]+" order by id desc");
	
while(rsMain.next()){
	
	String mainTypeId=rsMain.getString("id");
	String mainTypeName=rsMain.getString("fullname");
	Integer[] mainArr = this.getCountByType(mainType,mainTypeId,-1,null,user.getUID());
	if(mainArr == null){
		continue;
	}
	
	rsSub.execute("select id ,fullname from "+tabArr[subType]+" order by id desc");
	String submenus="";
	while(rsSub.next()){
		String subTypeId=rsSub.getString("id");
		String subTypeName=rsSub.getString("fullname");
		Integer[] subArr = this.getCountByType(mainType,mainTypeId,subType,subTypeId,user.getUID());
		if(subArr == null ){
			continue;
		}
		
		submenus+=",{name:'"+subTypeName+"',"+
					"hasChildren:false,attr:{subTypeId:'"+subTypeId+"',parentid:'"+mainTypeId+"'},"+
					"numbers:{flowAll:"+subArr[0]+(subArr[1]==0?"":",flowNew:"+subArr[1])+"}}";
			
			
	}
	submenus=submenus.length()>0?submenus.substring(1):submenus;
	submenus="["+submenus+"]";
		
	leftMenus+=",{"+
				"name:'"+mainTypeName+"',"+
				"attr:{mainTypeId:'"+mainTypeId+"'},"+
				"numbers:{flowAll:"+mainArr[0]+(mainArr[1]==0?"":",flowNew:"+mainArr[1])+"},"+
				"submenus:"+submenus+"}";
}
	
leftMenus=leftMenus.length()>0?leftMenus.substring(1):leftMenus;
leftMenus="["+leftMenus+"]";
out.print(leftMenus);
%>

<%!

	private Integer[] getCountByType(int mainType ,String mainTypeId, int subType , String subTypeId, int userid){
		Integer[] arr = new Integer[2];
		try{
			CrmShareBase crmShareBase = new CrmShareBase();
			String leftjointable = crmShareBase.getTempTable(userid+"");
			String sql ="select count(DISTINCT id)  from CRM_CustomerInfo t1 left join "+leftjointable+"  t2 on t1.id = t2.relateditemid  where t1.id = t2.relateditemid and deleted=0";
			String[] fieldArr = {"type","Description","status","size_n"};
			
			if(-1 != mainType){
				sql += " and "+fieldArr[mainType] +" = "+mainTypeId;
			}
			
			if(-1 != subType){
				sql += " and "+fieldArr[subType] +" = "+subTypeId;
			}
			
			RecordSet rs = new RecordSet();
			rs.execute(sql);
			rs.next();
			int totalCount = rs.getInt(1);
			if(totalCount == 0){
				return null;
			}
			
			sql = "select count(*) from CRM_CustomerInfo t1 ,CRM_ViewLog2 t2 "+
				  " where (t1.deleted=0 or t1.deleted is null) and t1.id=t2.customerid and t1.manager="+userid;
			if(-1 != mainType){
				sql += " and t1."+fieldArr[mainType] +" = "+mainTypeId;
			}
			
			if(-1 != subType){
				sql += " and t1."+fieldArr[subType] +" = "+subTypeId;
			}
			
			rs.execute(sql);
			rs.next();
			int newCount = rs.getInt(1);
			
			arr[0] = totalCount;
			arr[1] = newCount;
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return arr;
	}

 %>