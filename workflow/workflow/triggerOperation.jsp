
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.conn.*"%>
<%@page import="weaver.workflow.workflow.WorkflowDynamicDataComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<%!
public void deleteEntryById(int entryID,int wfid,RecordSet rs1)
{
	if(entryID>0)
	{
		//先删除
		rs1.executeSql("select id from Workflow_DataInput_entry where WorkFlowID="+wfid+" and id = "+entryID);
		String entryIDs = ",";
		while(rs1.next()){
			entryIDs += rs1.getInt("id")+",";
		}
		//rs1.executeSql("delete from Workflow_DataInput_entry where WorkFlowID="+wfid+" and id="+entryID);
		
		ArrayList entryIDsArr = Util.TokenizerString(entryIDs,",");
		String DataInputIDs = ",";
		for(int i=0;i<entryIDsArr.size();i++){
			rs1.executeSql("select id from Workflow_DataInput_main where entryID="+entryID);
			while(rs1.next()){
				DataInputIDs += rs1.getInt("id")+",";
			}
			rs1.executeSql("delete from Workflow_DataInput_main where entryID="+entryID);
		}
		
		ArrayList DataInputIDsArr = Util.TokenizerString(DataInputIDs,",");
		for(int i=0;i<DataInputIDsArr.size();i++){
			String DataInputID = (String)DataInputIDsArr.get(i);
			rs1.executeSql("delete from Workflow_DataInput_table where DataInputID="+DataInputID);
			rs1.executeSql("delete from Workflow_DataInput_field where DataInputID="+DataInputID);
		}
	}
}
%>
<%
int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0); 
WfRightManager wfrm = new WfRightManager();
boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
	response.sendRedirect("/notice/noright.jsp");
		return;
}
%>
<%
	int entryID = Util.getIntValue(Util.null2String(request.getParameter("entryID")),0);//联动id
	String srcfrom = Util.null2String(request.getParameter("srcfrom"));//来源
	String dialog = Util.null2String(request.getParameter("dialog"));
	int wokflowformid = 0;
	rs1.executeSql("select formid from workflow_base where id="+wfid);
	if(rs1.next()) wokflowformid = Util.getIntValue(rs1.getString("formid"),0);
	String errormsg = "";
	if(wfid!=0){
		ConnStatement statement = null;
		try
		{
			if("entry".equals(srcfrom))
			{
				deleteEntryById(entryID,wfid,rs1);
				
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
						//RecordSetTrans.executeSql("insert into Workflow_DataInput_entry(workflowid,triggerName,triggerfieldname,type) values("+wfid+",'"+triggerName+"','field"+triggerField+"'"+",'"+triggerFieldType+"'"+")");
						int entryId = 0;
						if(entryID<1){
							statement.setStatementSql("insert into Workflow_DataInput_entry(workflowid,triggerName,triggerfieldname,type,detailindex) values(?,?,?,?,?)");
							statement.setInt(1,wfid);
							statement.setString(2,triggerName);
							statement.setString(3,"field"+triggerField);
							statement.setString(4,triggerFieldType);
							statement.setString(5,detailindex);
							statement.executeUpdate();
							
							statement.setStatementSql("select max(id) as entryId from Workflow_DataInput_entry");
							statement.executeQuery();
							if(statement.next()){
								entryId = statement.getInt("entryId");
							}
						}else{
							entryId = entryID ;
							statement.setStatementSql("update Workflow_DataInput_entry set triggerName=?,triggerfieldname=?,type=?,detailindex=?  where id=?");
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
							//RecordSetTrans.executeSql("insert into Workflow_DataInput_main(entryID,WhereClause,IsCycle,OrderID,datasourcename) values("+entryId+",'"+tableralations+"'"+",1,"+(i+1)+",'"+datasourcename+"')");
							statement.setStatementSql("insert into Workflow_DataInput_main(entryID,WhereClause,IsCycle,OrderID,datasourcename) values(?,?,?,?,?)");
							statement.setInt(1,entryId);
							statement.setString(2,tableralations);
							statement.setInt(3,1);
							statement.setInt(4,(j+1));
							statement.setString(5,datasourcename);
							statement.executeUpdate();
							
							int DataInputID = 0;
							statement.setStatementSql("select max(id) as DataInputID from Workflow_DataInput_main");	
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
								    //RecordSetTrans.executeSql("insert into Workflow_DataInput_table(DataInputID,TableName,Alias,FormId) values("+DataInputID+",'"+tableTableName+"'"+",'"+tableTableByName+"','"+formid+"')");
								    statement.setStatementSql("insert into Workflow_DataInput_table(DataInputID,TableName,Alias,FormId) values(?,?,?,?)");
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
								if(parafieldname.equals("")||parawfField.equals("")) continue;
								String parafieldtablename = Util.null2String(request.getParameter("parafieldtablename"+j+i+"_"+m));//字段所属表名
								int TableID = 0;
								int pagefieldindex = Util.getIntValue(request.getParameter("pfieldindex"+j+i+"_"+m),0);
								if(pagefieldindex!=detailidx){
									continue ;
								}
								String[] _arr = parafieldname.split("\\.");
								String alias = ""; 
								if(_arr.length > 1){
								    alias = _arr[0];
									parafieldname = _arr[1];
								}
								//RecordSetTrans.executeSql("select id from Workflow_DataInput_table where DataInputID="+DataInputID+" and TableName='"+parafieldtablename+"'");
								statement.setStatementSql("select id,alias from Workflow_DataInput_table where DataInputID="+DataInputID+" and TableName='"+parafieldtablename+"'");	
                                statement.executeQuery();
								while(statement.next()){
                                    TableID = statement.getInt("id");
                                    String _alias  = Util.null2String(statement.getString("alias"));
                                    if("".equals(_alias) || alias.equals(_alias)){
                                        break;
                                    }
                                }   
								rs1.executeSql("insert into Workflow_DataInput_field(DataInputID,TableID,Type,DBFieldName,PageFieldName,pagefieldindex) values("+DataInputID+","+TableID+",1,"+"'"+parafieldname+"'"+",'field"+parawfField+"'"+","+pagefieldindex+")");
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
								String[] _arr = evaluatefieldname.split("\\.");
								String alias = ""; 
								if(_arr.length > 1){
								    alias = _arr[0];
									evaluatefieldname = _arr[1];
								}
								if(evaluatefieldname.equals("")||evaluatewfField.equals("")) continue;
								evaluatewfFields += evaluatewfField + ",";
								String evaluatefieldtablename = Util.null2String(request.getParameter("evaluatefieldtablename"+j+i+"_"+m));//字段所属表名
								int TableID = 0;
                                statement.setStatementSql("select id,alias from Workflow_DataInput_table where DataInputID="+DataInputID+" and TableName='"+evaluatefieldtablename+"'" );
                                statement.executeQuery();
								while(statement.next()) {
                                    TableID = statement.getInt("id");
                                    String _alias  = Util.null2String(statement.getString("alias"));
                                    if("".equals(_alias) || alias.equals(_alias)){
                                        break;
                                    }
                                }    
								rs1.executeSql("insert into Workflow_DataInput_field(DataInputID,TableID,Type,DBFieldName,PageFieldName,pagefieldindex) values("+DataInputID+","+TableID+",2,"+"'"+evaluatefieldname+"'"+",'field"+evaluatewfField+"'"+","+pagefieldindex+")");
							}
							if(!evaluatewfFields.equals("")){//判断在一个触发设置中，触发字段和被触发字段是否属于同组（同为主字段或为同一明细）
							    evaluatewfFields += triggerField;
							    rs1.executeSql("select distinct groupId from workflow_formfield where formid="+wokflowformid+" and fieldid in ("+evaluatewfFields+")");
							    if(rs1.getCounts()>1)
							    {
							    	//deleteEntryById(entryID,wfid,rs1);
							    	//errormsg = SystemEnv.getHtmlLabelName(22428,user.getLanguage());
							    	//字段不属于同一组
							        //RecordSetTrans.rollback();
							        //response.sendRedirect("fieldTrigger.jsp?ajax=1&wfid="+wfid+"&message=reset");
							        //return;
							    }
							}
							
						}
					}
				}
			}
			else
			{
				String entryIDs = "0";
				String[] fieldEntryIDs = request.getParameterValues("fieldEntryID");
                String[] deleteEntryIDs = request.getParameterValues("checkbox_TriggerField");
				if(null!=deleteEntryIDs&&deleteEntryIDs.length>0)
				{
					for(int i = 0;i<deleteEntryIDs.length;i++)
					{
						entryID =  Util.getIntValue(deleteEntryIDs[i],0);
						if(entryID>0)
						{
							entryIDs += entryIDs.equals("")?(""+entryID):(","+entryID);
						}
					}
				}
				if(!"".equals(entryIDs))
				{
					String delEntryIDs = "";
					//删除
					rs1.executeSql("select id from Workflow_DataInput_entry where WorkFlowID="+wfid+" and id in ("+entryIDs+")");
					while(rs1.next()){
						delEntryIDs += delEntryIDs.equals("")?(""+rs1.getInt("id")):(","+rs1.getInt("id"));
					}
					if(!"".equals(delEntryIDs))
					{
						rs1.executeSql("delete from Workflow_DataInput_entry where WorkFlowID="+wfid+" and id in ("+delEntryIDs+")");
						
						ArrayList entryIDsArr = Util.TokenizerString(delEntryIDs,",");
						String DataInputIDs = ",";
						for(int i=0;i<entryIDsArr.size();i++)
						{
							entryID = Util.getIntValue((String)entryIDsArr.get(i),0);
							rs1.executeSql("select id from Workflow_DataInput_main where entryID="+entryID);
							while(rs1.next())
							{
								DataInputIDs += rs1.getInt("id")+",";
							}
							rs1.executeSql("delete from Workflow_DataInput_main where entryID="+entryID);
						}
						
						ArrayList DataInputIDsArr = Util.TokenizerString(DataInputIDs,",");
						for(int i=0;i<DataInputIDsArr.size();i++)
						{
							String DataInputID = (String)DataInputIDsArr.get(i);
							rs1.executeSql("delete from Workflow_DataInput_table where DataInputID="+DataInputID);
							rs1.executeSql("delete from Workflow_DataInput_field where DataInputID="+DataInputID);
						}
					}
				}
			}
		}
		catch(Exception exception)
		{   
		}
		finally
		{
			if(null!=statement)
			{
				try
				{
					statement.close();
					statement = null;
				}
				catch(Exception e)
				{
					
				}
			}
		}
	}

	WorkflowDynamicDataComInfo workflowDymcominfo = new WorkflowDynamicDataComInfo();
	//更新缓存
	workflowDymcominfo.updateDynamicDataInputCache(wfid + "");
	

	if(!"entry".equals(srcfrom)){
		response.sendRedirect("fieldTrigger.jsp?ajax=1&wfid="+wfid);
	}else{
		/*if(!"".equals(errormsg))
		{
			out.println("<script language=javascript>top.Dialog.alert('"+errormsg+"');</script>");
		}
		out.println("<script language=javascript>window.parent.close();dialogArguments.tab12ref();</script>");
		*/
		if(!"".equals(errormsg)){
			response.sendRedirect("fieldTriggerEntry.jsp?errormsg=1&dialog=1&ajax=1&wfid="+wfid);
		}else{
			response.sendRedirect("fieldTriggerEntry.jsp?isclose=1&dialog=1&ajax=1&wfid="+wfid);
		}
	}
	//response.sendRedirect("fieldTrigger.jsp?ajax=1&wfid="+wfid);
	//out.println("<script language=javascript>window.parent.close();dialogArguments.tab12ref();</script>");
%>


