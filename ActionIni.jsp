
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<%
String sql="SELECT * FROM workflow_addinoperate  ORDER BY id";
RecordSet.executeSql(sql);
new weaver.general.BaseBean().writeLog("初始接口数据＝＝＝");
new weaver.general.BaseBean().writeLog("sql="+sql);
while(RecordSet.next()){
	String isnewsap="0";
	isnewsap=RecordSet.getString("isnewsap");
	String id=RecordSet.getString("id");
	new weaver.general.BaseBean().writeLog("isnewsap="+isnewsap);
	new weaver.general.BaseBean().writeLog("id="+id);
	if(isnewsap.equals("1")){
		String objid=RecordSet.getString("objid");
		String isnode=RecordSet.getString("isnode");
		String workflowid=RecordSet.getString("workflowid");
		String fieldid=RecordSet.getString("fieldid");
		String fieldop1id=RecordSet.getString("fieldop1id");
		String fieldop2id=RecordSet.getString("fieldop2id");
		String operation=RecordSet.getString("operation");
		String customervalue=RecordSet.getString("customervalue");
		String rules=RecordSet.getString("rules");
		String type=RecordSet.getString("type");
		String ispreadd=RecordSet.getString("ispreadd");
		String wftomodesetid=RecordSet.getString("wftomodesetid");
		//String isnewsap=RecordSet.getString("isnewsap");
		String wftofinancesetid=RecordSet.getString("wftofinancesetid");
		String istriggerreject=RecordSet.getString("istriggerreject");
		
		String sqltemp="SELECT * FROM workflow_addinoperate where objid='"+objid+"' and isnode='"+isnode+"' and workflowid='"+workflowid+"' and ispreadd='"+ispreadd+"' and isnewsap='0' ";
			new weaver.general.BaseBean().writeLog("sqltemp:"+sqltemp);
			
		RecordSet1.executeSql(sqltemp);
		if(RecordSet1.next()){  //有，则不需要处理。
			
		}else{ //没有，需要修改isnewsap为1,执行统一逻辑
			//插入一条isnewsap='0' 的数据　
			
			//String sql1="update workflow_addinoperate set isnewsap='0' where id='"+id+"'";
			String sql1="insert into workflow_addinoperate(ID,OBJID,ISNODE,WORKFLOWID,FIELDID,FIELDOP1ID,FIELDOP2ID,OPERATION,CUSTOMERVALUE,RULES,TYPE,ISPREADD,WFTOMODESETID,ISNEWSAP,WFTOFINANCESETID,ISTRIGGERREJECT) "+ 
			"values('100000','"+objid+"','"+isnode+"','"+workflowid+"','"+fieldid+"','"+fieldop1id+"','"+fieldop2id+"','"+operation+"','"+customervalue+"','"+rules+"','"+type+"','"+ispreadd+"','"+wftomodesetid+"','0','"+wftofinancesetid+"','"+istriggerreject+"')";
			new weaver.general.BaseBean().writeLog("sql1:"+sql1);
			RecordSet2.executeSql(sql1);
		}
	}
}
out.print("处理完成!");
%>


