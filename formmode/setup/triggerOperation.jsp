<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.* "%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="org.json.JSONArray,org.json.JSONObject" %>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
		response.sendRedirect("/notice/noright.jsp");
  	return;
	}
%>
<%!
public void deleteEntryById(int entryID,int modeId,RecordSet rs1)
{
	if(entryID>0) {
   		rs1.executeSql("select id from modeDataInputentry where modeid="+modeId+" and id = "+entryID);
   		String entryIDs = ",";
   		while(rs1.next()){
   			entryIDs += rs1.getInt("id")+",";
   		}
   		//rs1.executeSql("delete from modeDataInputentry where modeid="+modeId+" and id="+entryID);
   		
   		ArrayList entryIDsArr = Util.TokenizerString(entryIDs,",");
   		String DataInputIDs = ",";
   		for(int i=0;i<entryIDsArr.size();i++){
   			rs1.executeSql("select id from modeDataInputmain where entryID="+entryID);
   			while(rs1.next()){
   				DataInputIDs += rs1.getInt("id")+",";
   			}
   			rs1.executeSql("delete from modeDataInputmain where entryID="+entryID);
   		}
   		
   		ArrayList DataInputIDsArr = Util.TokenizerString(DataInputIDs,",");
   		for(int i=0;i<DataInputIDsArr.size();i++){
   			String DataInputID = (String)DataInputIDsArr.get(i);
   			rs1.executeSql("delete from modeDataInputtable where DataInputID="+DataInputID);
   			rs1.executeSql("delete from modeDataInputfield where DataInputID="+DataInputID);
   		}
   	}
}
%>
<%	
	int modeId = Util.getIntValue(Util.null2String(request.getParameter("modeId")),0);//模块id
	int entryID = Util.getIntValue(Util.null2String(request.getParameter("entryID")),0);//联动id
	String srcfrom = Util.null2String(request.getParameter("srcfrom"));//来源
	int modeformid = 0;
	rs1.executeSql("select formid from modeinfo where id="+modeId);
	if(rs1.next()) modeformid = Util.getIntValue(rs1.getString("formid"),0);
	String errormsg = "";
	if(modeId!=0){
		ConnStatement statement = null;
		try
		{
			if("entry".equals(srcfrom))
			{
				deleteEntryById(entryID,modeId,rs1);
				
				statement = new ConnStatement();
				//再添加
				String txtUserUse = Util.null2String(request.getParameter("txtUserUse"));//启动字段联动
				if(txtUserUse.equals("1"))
				{
					int triggerNum = Util.getIntValue(Util.null2String(request.getParameter("triggerNum")),0);
					for(int i=0;i<triggerNum;i++){
						String triggerName = Util.null2String(request.getParameter("triggerName"+i));//触发字段
						String triggerField = Util.null2String(request.getParameter("triggerField"+i));//触发字段
						if(triggerField.equals("")) continue;
						String triggerFieldType = Util.null2String(request.getParameter("triggerFieldType"+i));//触发字段类型
						String detailindex = Util.null2String(request.getParameter("detailindex"+i));//触发字段类型
						int entryId = 0;
						if(entryID<1){
							statement.setStatementSql("insert into modeDataInputentry(modeid,triggerName,triggerfieldname,type,detailindex) values(?,?,?,?,?)");
							statement.setInt(1,modeId);
							statement.setString(2,triggerName);
							statement.setString(3,"field"+triggerField);
							statement.setString(4,triggerFieldType);
							statement.setString(5,detailindex);
							statement.executeUpdate();
							
							statement.setStatementSql("select max(id) as entryId from modedatainputentry");
							statement.executeQuery();
							if(statement.next()){
								entryId = statement.getInt("entryId");
							}
						}else{
							entryId = entryID ;
							statement.setStatementSql("update modeDataInputentry set triggerName=?,triggerfieldname=?,type=?,detailindex=?  where id=?");
							statement.setString(1,triggerName);
							statement.setString(2,"field"+triggerField);
							statement.setString(3,triggerFieldType);
							statement.setString(4,detailindex);
							statement.setInt(5, entryId);
							statement.executeUpdate();
						}
						
						int triggerSettingRows = Util.getIntValue(Util.null2String(request.getParameter("triggerSettingRows"+i)),0);
						
						for(int j=0;j<triggerSettingRows;j++){
							if(null==request.getParameter("triggerSetting"+j))
							{
								continue;
							}
							String tabletype = Util.null2String(request.getParameter("tabletype"+j+i));//联动字段所属表类型
							String tableralations = Util.null2String(request.getParameter("tableralations"+j+i));//表之间关联条件
							String datasourcename = Util.null2String(request.getParameter("datasource"+j+i));//数据源
							statement.setStatementSql("insert into modeDataInputmain(entryID,WhereClause,IsCycle,OrderID,datasourcename) values(?,?,?,?,?)");
							statement.setInt(1,entryId);
							statement.setString(2,tableralations);
							statement.setInt(3,1);
							statement.setInt(4,(j+1));
							statement.setString(5,datasourcename);
							statement.executeUpdate();
							
							int DataInputID = 0;
							statement.setStatementSql("select max(id) as DataInputID from modeDataInputmain");	
							statement.executeQuery();
							if(statement.next()) DataInputID = statement.getInt("DataInputID");
							int tableTableRows = Util.getIntValue(Util.null2String(request.getParameter("tableTableRowsNum"+j+i)),0);
							for(int m=0;m<tableTableRows;m++){
								String tableTableName = Util.null2String(request.getParameter("tablename"+j+i+"_"+m));//引用数据库表名
								if(tableTableName.equals(""))continue;
								String tableTableByName = Util.null2String(request.getParameter("tablebyname"+j+i+"_"+m));//别名
								String formid = Util.null2String(request.getParameter("formid"+j+i+"_"+m));//表单id
								if(!tableTableName.equals("")||!tableTableByName.equals(""))
								{
								    statement.setStatementSql("insert into modeDataInputtable(DataInputID,TableName,Alias,FormId) values(?,?,?,?)");
									statement.setInt(1,DataInputID);
									statement.setString(2,tableTableName);
									statement.setString(3,tableTableByName);
									statement.setString(4,formid);
									statement.executeUpdate();
								}
							}
							
							int detailidx = Util.getIntValue(detailindex);
							
							int parameterTableRows = Util.getIntValue(Util.null2String(request.getParameter("parameterTableRowsNum"+j+i)),0);
							for(int m=0;m<parameterTableRows;m++){
								String parafieldname = Util.null2String(request.getParameter("parafieldname"+j+i+"_"+m));//取值参数-〉参数字段
								String parawfField = Util.null2String(request.getParameter("parawfField"+j+i+"_"+m));//取值参数-〉流程字段
								String treenodeid = Util.null2String(request.getParameter("treenodeid"+j+i+"_"+m));//树形节点
								if(parafieldname.equals("")||parawfField.equals("")) continue;
								String parafieldtablename = Util.null2String(request.getParameter("parafieldtablename"+j+i+"_"+m));//字段所属表名
								
								int TableID = 0;
								int pagefieldindex = Util.getIntValue(request.getParameter("pfieldindex"+j+i+"_"+m),0);
								if(detailidx > 0&&pagefieldindex!=detailidx){
									continue ;
								}
								statement.setStatementSql("select id from modeDataInputtable where DataInputID="+DataInputID+" and TableName='"+parafieldtablename+"'");
								statement.executeQuery();
								if(statement.next()) TableID = statement.getInt("id");
								statement.setStatementSql("insert into modeDataInputfield(DataInputID,TableID,Type,DBFieldName,PageFieldName,treenodeid,pagefieldindex) values("+DataInputID+","+TableID+",1,"+"'"+parafieldname+"'"+",'field"+parawfField+"'"+",'"+treenodeid+"',"+pagefieldindex+")");
								statement.executeUpdate();
							}
							
							String evaluatewfFields = "";
							int evaluateTableRows = Util.getIntValue(Util.null2String(request.getParameter("evaluateTableRowsNum"+j+i)),0);
							for(int m=0;m<evaluateTableRows;m++){
								String evaluatefieldname = Util.null2String(request.getParameter("evaluatefieldname"+j+i+"_"+m));//取值参数-〉参数字段
								String evaluatewfField = Util.null2String(request.getParameter("evaluatewfField"+j+i+"_"+m));//取值参数-〉流程字段
								String evaluatewftablegroupid = Util.null2String(request.getParameter("evaluatewftablegroupid"+j+i+"_"+m));//取值参数-〉流程字段 主表或者明细表标识
								int pagefieldindex = Util.getIntValue(request.getParameter("fieldindex"+j+i+"_"+m),0);
								if(detailidx > 0&&pagefieldindex!=detailidx){
									continue ;
								}
								if(evaluatefieldname.equals("")||evaluatewfField.equals("")) continue;
								evaluatewfFields += evaluatewfField + ",";
								String evaluatefieldtablename = Util.null2String(request.getParameter("evaluatefieldtablename"+j+i+"_"+m));//字段所属表名
								int TableID = 0;
								statement.setStatementSql("select id from modeDataInputtable where DataInputID="+DataInputID+" and TableName='"+evaluatefieldtablename+"'");
								statement.executeQuery();
								if(statement.next()) TableID = statement.getInt("id");
								statement.setStatementSql("insert into modeDataInputfield(DataInputID,TableID,Type,DBFieldName,PageFieldName,pagefieldindex) values("+DataInputID+","+TableID+",2,"+"'"+evaluatefieldname+"'"+",'field"+evaluatewfField+"',"+pagefieldindex+")");
								statement.executeUpdate();
								
							}
							if(!evaluatewfFields.equals("")){//判断在一个触发设置中，触发字段和被触发字段是否属于同组（同为主字段或为同一明细）
							    evaluatewfFields += triggerField;
							    rs1.executeSql("select distinct groupId from workflow_formfield where formid="+modeformid+" and fieldid in ("+evaluatewfFields+")");
							    if(rs1.getCounts()>1)
							    {
							    	//ModeLinkageInfo.deleteEntryById(entryID,modeId,rs1);
							    	//errormsg = SystemEnv.getHtmlLabelName(22428,user.getLanguage());
							    }
							}
							
						}
					}
				}
			}
			else
			{
				String entryIDs = "0";
				String fieldEntryIDs = request.getParameter("entryId");
				if(null!=fieldEntryIDs&&fieldEntryIDs.length()>0)
				{
					String[] fieldEntryIDsList = fieldEntryIDs.split(",");
					for(int i = 0;i<fieldEntryIDsList.length;i++)
					{
						entryID =  Util.getIntValue(fieldEntryIDsList[i],0);
						if(entryID>0)
						{
							entryIDs += entryIDs.equals("")?(""+entryID):(","+entryID);
						}
					}
				}
				if(!"".equals(entryIDs))
				{
					String delEntryIDs = entryIDs;
					if(!"".equals(delEntryIDs))
					{
						rs1.executeSql("delete from modeDataInputentry where modeId="+modeId+" and id in ("+delEntryIDs+")");
						
						ArrayList entryIDsArr = Util.TokenizerString(delEntryIDs,",");
						String DataInputIDs = ",";
						for(int i=0;i<entryIDsArr.size();i++)
						{
							entryID = Util.getIntValue((String)entryIDsArr.get(i),0);
							rs1.executeSql("select id from modeDataInputmain where entryID="+entryID);
							while(rs1.next())
							{
								DataInputIDs += rs1.getInt("id")+",";
							}
							rs1.executeSql("delete from modeDataInputmain where entryID="+entryID);
						}
						
						ArrayList DataInputIDsArr = Util.TokenizerString(DataInputIDs,",");
						for(int i=0;i<DataInputIDsArr.size();i++)
						{
							String DataInputID = (String)DataInputIDsArr.get(i);
							rs1.executeSql("delete from modeDataInputtable where DataInputID="+DataInputID);
							rs1.executeSql("delete from modeDataInputfield where DataInputID="+DataInputID);
						}
					}
				}
				JSONObject result = new JSONObject();
				result.put("result",1);
				out.println(result.toString());
			}
		}catch(Exception exception){
		}finally{
			if(null!=statement){
				try{
					statement.close();
					statement = null;
				}catch(Exception e){
					
				}
			}
		}
	}
	if(!"entry".equals(srcfrom)){
		response.sendRedirect("fieldTrigger.jsp?ajax=1&modeId="+modeId);
	}else{
		/*if(!"".equals(errormsg)){
			out.println("<script language=javascript>alert('"+errormsg+"');</script>");
		}
		out.println("<script language=javascript>window.parent.close();</script>");*/
		if(!"".equals(errormsg)){
			response.sendRedirect("fieldTriggerEntry.jsp?errormsg=1&dialog=1&ajax=1&modeId="+modeId);
		}else{
			response.sendRedirect("fieldTriggerEntry.jsp?isclose=1&dialog=1&ajax=1&modeId="+modeId);
		}
	}
%>


