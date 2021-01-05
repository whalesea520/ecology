
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="EvaluationComInfo" class="weaver.crm.Maint.EvaluationComInfo" scope="page" />
<jsp:useBean id="EvaluationLevelComInfo" class="weaver.crm.Maint.EvaluationLevelComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<% 
String CustomerID = Util.null2String(request.getParameter("CustomerID"));

if(!"".equals(CustomerID)){
	boolean canedit=false;
	//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();
	//RecordSet.executeSql(ViewSql);
	//if(RecordSet.next()){
	//	 if(RecordSet.getString("sharelevel").equals("2")){
	//		canedit=true;
	//	 }else if (RecordSet.getString("sharelevel").equals("3") || RecordSet.getString("sharelevel").equals("4")){
	//		canedit=true;
	//	 }
	//}
	int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
	if(sharelevel>1) canedit=true;
	if(!canedit){
	  response.sendRedirect("/notice/noright.jsp");
	  return;
	}
}

String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"),"-1");
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String proportion = Util.fromScreen(request.getParameter("proportion"),user.getLanguage());
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;

if (method.equals("add"))
{
	if(!HrmUserVarify.checkUserRight("CRM_EvaluationAdd:Add", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	boolean insertSuccess = false ;
	insertSuccess = RecordSet.executeProc("CRM_Evaluation_Insert",name+flag+proportion);
	int cid=0;
	if(insertSuccess)
	{
		RecordSet.executeSql("Select Max(id) as maxid FROM CRM_Evaluation");
	    RecordSet.first();
	    cid = RecordSet.getInt(1);
		//设置OrderKey 排序字段为自动生成的ID(存储过程返回的ID);
		RecordSet.execute("update CRM_Evaluation set orderkey='"+cid+"' where id='"+cid+"'");
	}

	EvaluationComInfo.removeEvaluationCache();
	response.sendRedirect("/CRM/Maint/AddEvaluation.jsp?isclose=1");
}
else if (method.equals("edit"))
{
	if(!HrmUserVarify.checkUserRight("CRM_EvaluationEdit:Edit",user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	RecordSet.executeProc("CRM_Evaluation_Update",id+flag+name+flag+proportion);

	EvaluationComInfo.removeEvaluationCache();
	response.sendRedirect("/CRM/Maint/EditEvaluation.jsp?isclose=1");
}
else if (method.equals("delete"))
{	
	if(!HrmUserVarify.checkUserRight("CRM_EvaluationDelete:Delete", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	RecordSet.executeProc("CRM_Evaluation_Delete",id);
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		response.sendRedirect("/CRM/Maint/EvaluationList.jsp?msgid=20");
		return;
	}
	EvaluationComInfo.removeEvaluationCache();
	response.sendRedirect("/CRM/Maint/EvaluationListInner.jsp");
}
else if(method.equals("sort"))
{
	String tableids = Util.null2String(request.getParameter("ids"));
	String[] _tableid = Util.TokenizerString2(tableids,"_");
	//循环更新，用for循环不是很好，但貌似没有更好的办法，一般称呼的话数据量也不多
	for(int i=0;i<_tableid.length;i++)
	{
		RecordSet.execute("update CRM_Evaluation set orderkey='"+i+"' where id='"+_tableid[i]+"'");
	}
	
}
else if (method.equals("getvalue")) {	
	String level[] = request.getParameterValues("level");
	String proportionstr[] = request.getParameterValues("proportion");
	String evaluationID[] = request.getParameterValues("evaluationID");
	
	String ProcPara = "";
	char flag=2;
	double totallevel = 0;
	double tempvalue = 0;
	boolean checkLevel = false;
	String evaId = "";
	if (!CustomerID.equals("")) {
		for (int i = 0; i < level.length; i++) {   
		    RecordSet.executeSql("select id from CRM_Evaluation_LevelDetail where customerID = "+CustomerID+ " and evaluationID = "+evaluationID[i]);		  
		    if(RecordSet.next()){
		        checkLevel = true;		    
		    }else{
		        checkLevel = false;
		    } 
		    if(checkLevel){
		      rs.executeSql("update CRM_Evaluation_LevelDetail set levelID = "+level[i]+" where customerID = "+CustomerID+" and evaluationID = "+evaluationID[i]);
		    }else{
		      rs.executeSql("insert into CRM_Evaluation_LevelDetail (customerID,evaluationID,levelID) values ('"+CustomerID+ "','"+evaluationID[i]+"','"+level[i]+"')");
		    }
			tempvalue = Util.getDoubleValue(level[i],0)*(Util.getDoubleValue(proportionstr[i],0)/100);	
			totallevel += tempvalue; 
		}

        //boolean exist = false;
		double levelint = 0;
		while (EvaluationLevelComInfo.next()) {
			levelint = Util.getDoubleValue(EvaluationLevelComInfo.getEvaluationLevellevelvalue(),0);
			if (totallevel <= levelint) {
                evaId = EvaluationLevelComInfo.getEvaluationLevelid();
                //exist = true;
				break;
			}
		}

        //if (!exist)
		ProcPara = CustomerID;
		ProcPara += flag + ""+evaId;
		RecordSet.executeProc("CRM_CustomerEvaluationUpdate",ProcPara);
	}
	
	if(!isfromtab){
		response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID);
	}else{
		response.sendRedirect("/CRM/data/GetEvaluation.jsp?CustomerID="+CustomerID+"&isfromtab="+isfromtab);
	}
	
}else if(method.equals("getSumproportion"))
{
	RecordSet.execute("select SUM(proportion) as sumporport FROM CRM_Evaluation where id !="+id);
	RecordSet.first();
	int sumporport = RecordSet.getInt(1);
	if(sumporport + Util.getIntValue(proportion) > 100)
	{
		out.clear();
		out.print("overMax");
	}
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
%>