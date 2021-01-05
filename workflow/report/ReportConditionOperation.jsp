
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportConditionMouldManager" class="weaver.workflow.report.ReportConditionMouldManager" scope="page" />


<%@ include file="/systeminfo/init_wev8.jsp" %>


<%
String operation = Util.null2String(request.getParameter("operation"));
//另存为模板
if(operation.equals("saveAsTemplate"))
{
    //报表id
    String reportId = Util.null2String(request.getParameter("reportid"));
    //新模板的名称
    String newMouldName = Util.null2String(request.getParameter("newMouldName"));
	//新模板的id
	int mouldId=ReportConditionMouldManager.getNextMouldId();
    //用户id
	int userId=user.getUID();

    RecordSet.executeSql("insert into WorkflowRptCondMould(id,mouldName,userId,reportId) values("+mouldId+",'"+newMouldName+"',"+userId+","+reportId+")");

	////往明细表插入数据
    //获得需要插入数据的字段id
	String[] checkConds = request.getParameterValues("check_con");
    String[] isShows=request.getParameterValues("isShow");


	String fieldId="";
    List fieldIdList=new ArrayList();
    List fieldIdCheckCondList=new ArrayList();
    List fieldIdIsShowList=new ArrayList();

    if(checkConds!=null){
	    for(int i=0;i<checkConds.length;i++){
		    fieldId=checkConds[i];
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdList.indexOf(fieldId)==-1){
			    fieldIdList.add(fieldId);
		    }
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdCheckCondList.indexOf(fieldId)==-1){
			    fieldIdCheckCondList.add(fieldId);
		    }
	    }
    }

    if(isShows!=null){
	    for(int i=0;i<isShows.length;i++){
		    fieldId=isShows[i];
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdList.indexOf(fieldId)==-1){
			    fieldIdList.add(fieldId);
		    }
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdIsShowList.indexOf(fieldId)==-1){
			    fieldIdIsShowList.add(fieldId);
		    }
	    }
	}

	String isMain="";
	String isShow="";
	String isCheckCond="";
	String colName="";
	String htmlType="";
	String type="";
	String optionFirst="";
	String valueFirst="";
	String nameFirst="";
	String optionSecond="";
	String valueSecond="";

	for(int i=0;i<fieldIdList.size();i++){
		fieldId=(String)fieldIdList.get(i);
		isMain = ""+Util.null2String(request.getParameter("con"+fieldId+"_ismain"));

		if(fieldIdIsShowList.indexOf(fieldId)>-1){
			isShow="1";
		}else{
			isShow="0";
		}

		if(fieldIdCheckCondList.indexOf(fieldId)>-1){
			isCheckCond="1";
		    colName = ""+Util.null2String(request.getParameter("con"+fieldId+"_colname"));
		    htmlType = ""+Util.null2String(request.getParameter("con"+fieldId+"_htmltype"));
		    type = ""+Util.null2String(request.getParameter("con"+fieldId+"_type"));
		    if(type.equals("")){
			    type="-1";
		    }
		    optionFirst = ""+Util.null2String(request.getParameter("con"+fieldId+"_opt"));
		    valueFirst = ""+Util.null2String(request.getParameter("con"+fieldId+"_value"));
		    nameFirst = ""+Util.null2String(request.getParameter("con"+fieldId+"_name"));
		    optionSecond = ""+Util.null2String(request.getParameter("con"+fieldId+"_opt1"));
		    valueSecond = ""+Util.null2String(request.getParameter("con"+fieldId+"_value1"));

		}else{
			isCheckCond="0";
		    colName = "";
		    htmlType = "";
			type="-1";
		    optionFirst = "";
		    valueFirst = "";
			nameFirst="";
		    optionSecond = "";
		    valueSecond = "";
		}
        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+","+fieldId+",'"+isMain+"','"+isShow+"','"+isCheckCond+"','"+colName+"','"+htmlType+"',"+type+",'"+optionFirst+"','"+valueFirst+"','"+nameFirst+"','"+optionSecond+"','"+valueSecond+"')");

	}

	////考虑请求说明、紧急程度、工作流程状态三个特殊的字段
    //请求说明，fieldId指定为-1，isMain指定为'1'
    String requestNameIsShow = Util.null2String(request.getParameter("requestNameIsShow"));
    String requestNameCheckCond = Util.null2String(request.getParameter("requestname_check_con"));
    optionFirst = Util.null2String(request.getParameter("requestname"));
    valueFirst = Util.null2String(request.getParameter("requestnamevalue"));

    if(requestNameIsShow.equals("1")||requestNameCheckCond.equals("1")){
		if(!requestNameIsShow.equals("1")){
			requestNameIsShow="0";
		}

		if(!requestNameCheckCond.equals("1")){
			requestNameCheckCond="0";
            optionFirst = "";
            valueFirst = "";
		}

        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-1,'1','"+requestNameIsShow+"','"+requestNameCheckCond+"','','',-1,'"+optionFirst+"','"+valueFirst+"','','','')");
	}

	//紧急程度，fieldId指定为-2，isMain指定为'1'
    String requestLevelIsShow = Util.null2String(request.getParameter("requestLevelIsShow"));
    String requestLevelCheckCond = Util.null2String(request.getParameter("requestlevel_check_con"));
    valueFirst = Util.null2String(request.getParameter("requestlevelvalue"));

    if(requestLevelIsShow.equals("1")||requestLevelCheckCond.equals("1")){
		if(!requestLevelIsShow.equals("1")){
			requestLevelIsShow="0";
		}

		if(!requestLevelCheckCond.equals("1")){
			requestLevelCheckCond="0";
            valueFirst = "";
		}

        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-2,'1','"+requestLevelIsShow+"','"+requestLevelCheckCond+"','','',-1,'','"+valueFirst+"','','','')");
	}

	//工作流程状态，fieldId指定为-3，isMain指定为'1'
    /*String requestStatusIsShow = Util.null2String(request.getParameter("requestStatusIsShow"));
    String requestStatusCheckCond = Util.null2String(request.getParameter("requeststatus_check_con"));
    valueFirst = Util.null2String(request.getParameter("requeststatusvalue"));

    if(requestStatusIsShow.equals("1")||requestStatusCheckCond.equals("1")){
		if(!requestStatusIsShow.equals("1")){
			requestStatusIsShow="0";
		}

		if(!requestStatusCheckCond.equals("1")){
			requestStatusCheckCond="0";
            optionFirst = "";
            valueFirst = "";
		}

        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-3,'1','"+requestStatusIsShow+"','"+requestStatusCheckCond+"','','',-1,'','"+valueFirst+"','','','')");
	}*/
	
	//归档时间，fieldId指定为-4，isMain指定为'1'
	//if(requestStatusCheckCond.equals("1")&&valueFirst.equals("1")){
		/*String archiveTime = Util.null2String(request.getParameter("archiveTime"));
		String archiveTimeFrom = "";
		String archiveTimeTo = "";
		if(archiveTime.equals("1")){
		  archiveTimeFrom = ""+Util.null2String(request.getParameter("fromdate"));
		  archiveTimeTo = ""+Util.null2String(request.getParameter("todate"));
		  RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-4,'1','1','"+archiveTime+"','','',-1,'','"+archiveTimeFrom+"','','','"+archiveTimeTo+"')");
		}*/
	//}
	
	/****新增八个字段  创建人、创建日期、工作流、当前节点、接收日期、未操作者、流程状态、签字意见；*****/
	
	// 创建人-10
		String createmanIsShow = Util.null2String(request.getParameter("createmanIsShow"));
	    String createmanCheckCond = Util.null2String(request.getParameter("createman_check_con"));
	    optionFirst = Util.null2String(request.getParameter("createmanselected"));
	    valueFirst = Util.null2String(request.getParameter("con-10_value"));
	    nameFirst = ""+Util.null2String(request.getParameter("con-10_name"));
	    
	    if(createmanIsShow.equals("1")||createmanCheckCond.equals("1")){
			if(!createmanIsShow.equals("1")){
				createmanIsShow="0";
			}

			if(!createmanCheckCond.equals("1")){
				createmanCheckCond="0";
	            optionFirst = "";
	            valueFirst = "";
	            nameFirst = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-10,'1','"+createmanIsShow+"','"+createmanCheckCond+"','','',-1,'"+optionFirst+"','"+valueFirst+"','"+nameFirst+"','','')");
		}
	// 创建日期-11
	    String createdateIsShow = Util.null2String(request.getParameter("createdateIsShow"));
	    String createdateCheckCond = Util.null2String(request.getParameter("createdate_check_con"));
	    optionFirst = Util.null2String(request.getParameter("SelectCreateDate"));
	    valueFirst = Util.null2String(request.getParameter("createdate"));
	    valueSecond = Util.null2String(request.getParameter("createdateend"));
	    
	    if(createdateIsShow.equals("1")||createdateCheckCond.equals("1")){
			if(!createdateIsShow.equals("1")){
				createdateIsShow="0";
			}

			if(!createdateCheckCond.equals("1")){
				createdateCheckCond="0";
	            valueFirst = "";
	            valueSecond = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-11,'1','"+createdateIsShow+"','"+createdateCheckCond+"','','',-1,'','"+valueFirst+"','','','"+valueSecond+"')");
		}
	// 工作流-12
	    String workflowtoIsShow = Util.null2String(request.getParameter("workflowtoIsShow"));
	    String workflowtoCheckCond = Util.null2String(request.getParameter("workflowto_check_con"));
	    optionFirst = Util.null2String(request.getParameter("workflowto_value"));
	    valueFirst = Util.null2String(request.getParameter("con-12_value"));
	    nameFirst = ""+Util.null2String(request.getParameter("con-12_name"));

	    if(workflowtoIsShow.equals("1")||workflowtoCheckCond.equals("1")){
			if(!workflowtoIsShow.equals("1")){
				workflowtoIsShow="0";
			}

			if(!workflowtoCheckCond.equals("1")){
				workflowtoCheckCond="0";
	            optionFirst = "";
	            valueFirst = "";
	            nameFirst = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-12,'1','"+workflowtoIsShow+"','"+workflowtoCheckCond+"','','',-1,'"+optionFirst+"','"+valueFirst+"','"+nameFirst+"','','')");
		}
	// 当前节点-13
	    String currentnodeIsShow = Util.null2String(request.getParameter("currentnodeIsShow"));
	    String currentnodeCheckCond = Util.null2String(request.getParameter("currentnode_check_con"));
	    optionFirst = Util.null2String(request.getParameter("currentnode_value"));
	    valueFirst = Util.null2String(request.getParameter("con-13_value"));
	    nameFirst = ""+Util.null2String(request.getParameter("con-13_name"));

	    if(currentnodeIsShow.equals("1")||currentnodeCheckCond.equals("1")){
			if(!currentnodeIsShow.equals("1")){
				currentnodeIsShow="0";
			}

			if(!currentnodeCheckCond.equals("1")){
				currentnodeCheckCond="0";
	            optionFirst = "";
	            valueFirst = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-13,'1','"+currentnodeIsShow+"','"+currentnodeCheckCond+"','','',-1,'"+optionFirst+"','"+valueFirst+"','"+nameFirst+"','','')");
		}

	// 未操作者-14
	    String nooperatorIsShow = Util.null2String(request.getParameter("nooperatorIsShow"));
	    String nooperatorCheckCond = Util.null2String(request.getParameter("nooperator_check_con"));
	    optionFirst = Util.null2String(request.getParameter("nooperator_opt"));
	    valueFirst = Util.null2String(request.getParameter("con-14_value"));
	    nameFirst = ""+Util.null2String(request.getParameter("con-14_name"));

	    if(nooperatorIsShow.equals("1")||nooperatorCheckCond.equals("1")){
			if(!nooperatorIsShow.equals("1")){
				nooperatorIsShow="0";
			}

			if(!nooperatorCheckCond.equals("1")){
				nooperatorCheckCond="0";
	            optionFirst = "";
	            valueFirst = "";
	            nameFirst = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-14,'1','"+nooperatorIsShow+"','"+nooperatorCheckCond+"','','',-1,'"+optionFirst+"','"+valueFirst+"','"+nameFirst+"','','')");
		}
	// 流程状态-15
	    String requeststatusIsShow = Util.null2String(request.getParameter("requeststatusIsShow"));;
	    String requeststatusCheckCond = Util.null2String(request.getParameter("requeststatus_check_con"));
	    valueFirst = Util.null2String(request.getParameter("requeststatusvalue"));

	    if(requeststatusIsShow.equals("1")||requeststatusCheckCond.equals("1")){
	    	if(!requeststatusIsShow.equals("1")){
	    		requeststatusIsShow="0";
			}
			if(!requeststatusCheckCond.equals("1")){
				requeststatusCheckCond="0";
		        valueFirst = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-15,'1','"+requeststatusIsShow+"','"+requeststatusCheckCond+"','','',-1,'','"+valueFirst+"','','','')");
		}
	//归档时间
		String filingdateIsShow = Util.null2String(request.getParameter("filingdateIsShow"));
	    String filingdateCheckCond = Util.null2String(request.getParameter("filingdate_check_con"));
	    valueFirst = Util.null2String(request.getParameter("filingdate"));
	    valueSecond = Util.null2String(request.getParameter("filingdateend"));
	    
	    if(filingdateIsShow.equals("1")||filingdateCheckCond.equals("1")){
			if(!filingdateIsShow.equals("1")){
				filingdateIsShow="0";
			}
			if(!filingdateCheckCond.equals("1")){
				filingdateCheckCond="0";
	            valueFirst = "";
	            valueSecond = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-16,'1','"+filingdateIsShow+"','"+filingdateCheckCond+"','','',-1,'','"+valueFirst+"','','','"+valueSecond+"')");
		}
		
	// 签字意见
	 /*   String requestNameIsShow = Util.null2String(request.getParameter("requestNameIsShow"));
	    String requestNameCheckCond = Util.null2String(request.getParameter("requestname_check_con"));
	    optionFirst = Util.null2String(request.getParameter("requestname"));
	    valueFirst = Util.null2String(request.getParameter("requestnamevalue"));

	    if(requestNameIsShow.equals("1")||requestNameCheckCond.equals("1")){
			if(!requestNameIsShow.equals("1")){
				requestNameIsShow="0";
			}

			if(!requestNameCheckCond.equals("1")){
				requestNameCheckCond="0";
	            optionFirst = "";
	            valueFirst = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-17,'1','"+requestNameIsShow+"','"+requestNameCheckCond+"','','',-1,'"+optionFirst+"','"+valueFirst+"','','','')");
		}

	*/
	
	response.sendRedirect("ReportCondition.jsp?id="+reportId+"&mouldId="+mouldId+"&newMouldName="+newMouldName);
	return ;
}


//删除模板
if(operation.equals("deleteTemplate"))
{
    //报表id
    String reportId = Util.null2String(request.getParameter("reportid"));

	//模板id
    int mouldId = Util.getIntValue(request.getParameter("mouldId"),0) ;

    //删除工作流报表条件模板明细表数据
    RecordSet.executeSql("delete from WorkflowRptCondMouldDetail where mouldId="+mouldId);

    //删除工作流报表条件模板表数据
    RecordSet.executeSql("delete from WorkflowRptCondMould where id="+mouldId);
    out.println("1");
	//response.sendRedirect("ReportCondition.jsp?id="+reportId);
	//return ;
}


//保存编辑模板
if(operation.equals("editSaveTemplate"))
{
    //报表id
    String reportId = Util.null2String(request.getParameter("reportid"));
    //新模板的名称
    String newMouldName = Util.null2String(request.getParameter("newMouldName"));
	//模板的id
    int mouldId = Util.getIntValue(request.getParameter("mouldId"),0) ;
    //用户id
	int userId=user.getUID();

//System.out.println("newMouldName = "+newMouldName);

    RecordSet.executeSql("update WorkflowRptCondMould set mouldName='"+newMouldName+"' where id="+mouldId);

    //删除工作流报表条件模板明细表数据
    RecordSet.executeSql("delete from WorkflowRptCondMouldDetail where mouldId="+mouldId);

	////往明细表插入数据
    //获得需要插入数据的字段id
	String[] checkConds = request.getParameterValues("check_con");
    String[] isShows=request.getParameterValues("isShow");


	String fieldId="";
    List fieldIdList=new ArrayList();
    List fieldIdCheckCondList=new ArrayList();
    List fieldIdIsShowList=new ArrayList();

    if(checkConds!=null){
	    for(int i=0;i<checkConds.length;i++){
		    fieldId=checkConds[i];
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdList.indexOf(fieldId)==-1){
			    fieldIdList.add(fieldId);
		    }
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdCheckCondList.indexOf(fieldId)==-1){
			    fieldIdCheckCondList.add(fieldId);
		    }
	    }
    }

    if(isShows!=null){
	    for(int i=0;i<isShows.length;i++){
		    fieldId=isShows[i];
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdList.indexOf(fieldId)==-1){
			    fieldIdList.add(fieldId);
		    }
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdIsShowList.indexOf(fieldId)==-1){
			    fieldIdIsShowList.add(fieldId);
		    }
	    }
	}

	String isMain="";
	String isShow="";
	String isCheckCond="";
	String colName="";
	String htmlType="";
	String type="";
	String optionFirst="";
	String valueFirst="";
	String nameFirst="";
	String optionSecond="";
	String valueSecond="";

	for(int i=0;i<fieldIdList.size();i++){
		fieldId=(String)fieldIdList.get(i);
		isMain = ""+Util.null2String(request.getParameter("con"+fieldId+"_ismain"));

		if(fieldIdIsShowList.indexOf(fieldId)>-1){
			isShow="1";
		}else{
			isShow="0";
		}

		if(fieldIdCheckCondList.indexOf(fieldId)>-1){
			isCheckCond="1";
		    colName = ""+Util.null2String(request.getParameter("con"+fieldId+"_colname"));
		    htmlType = ""+Util.null2String(request.getParameter("con"+fieldId+"_htmltype"));
		    type = ""+Util.null2String(request.getParameter("con"+fieldId+"_type"));
		    if(type.equals("")){
			    type="-1";
		    }
		    optionFirst = ""+Util.null2String(request.getParameter("con"+fieldId+"_opt"));
		    valueFirst = ""+Util.null2String(request.getParameter("con"+fieldId+"_value"));
		    nameFirst = ""+Util.null2String(request.getParameter("con"+fieldId+"_name"));
		    optionSecond = ""+Util.null2String(request.getParameter("con"+fieldId+"_opt1"));
		    valueSecond = ""+Util.null2String(request.getParameter("con"+fieldId+"_value1"));

		}else{
			isCheckCond="0";
		    colName = "";
		    htmlType = "";
			type="-1";
		    optionFirst = "";
		    valueFirst = "";
			nameFirst="";
		    optionSecond = "";
		    valueSecond = "";
		}



        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+","+fieldId+",'"+isMain+"','"+isShow+"','"+isCheckCond+"','"+colName+"','"+htmlType+"',"+type+",'"+optionFirst+"','"+valueFirst+"','"+nameFirst+"','"+optionSecond+"','"+valueSecond+"')");


	}

	////考虑请求说明、紧急程度、工作流程状态三个特殊的字段
    //请求说明，fieldId指定为-1，isMain指定为'1'
    String requestNameIsShow = Util.null2String(request.getParameter("requestNameIsShow"));
    String requestNameCheckCond = Util.null2String(request.getParameter("requestname_check_con"));
    optionFirst = Util.null2String(request.getParameter("requestname"));
    valueFirst = Util.null2String(request.getParameter("requestnamevalue"));

    if(requestNameIsShow.equals("1")||requestNameCheckCond.equals("1")){
		if(!requestNameIsShow.equals("1")){
			requestNameIsShow="0";
		}

		if(!requestNameCheckCond.equals("1")){
			requestNameCheckCond="0";
            optionFirst = "";
            valueFirst = "";
		}

        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-1,'1','"+requestNameIsShow+"','"+requestNameCheckCond+"','','',-1,'"+optionFirst+"','"+valueFirst+"','','','')");
	}

	//紧急程度，fieldId指定为-2，isMain指定为'1'
    String requestLevelIsShow = Util.null2String(request.getParameter("requestLevelIsShow"));
    String requestLevelCheckCond = Util.null2String(request.getParameter("requestlevel_check_con"));
    valueFirst = Util.null2String(request.getParameter("requestlevelvalue"));

    if(requestLevelIsShow.equals("1")||requestLevelCheckCond.equals("1")){
		if(!requestLevelIsShow.equals("1")){
			requestLevelIsShow="0";
		}

		if(!requestLevelCheckCond.equals("1")){
			requestLevelCheckCond="0";
            valueFirst = "";
		}

        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-2,'1','"+requestLevelIsShow+"','"+requestLevelCheckCond+"','','',-1,'','"+valueFirst+"','','','')");
	}

	//工作流程状态，fieldId指定为-3，isMain指定为'1'
    /*String requestStatusIsShow = Util.null2String(request.getParameter("requestStatusIsShow"));
    String requestStatusCheckCond = Util.null2String(request.getParameter("requeststatus_check_con"));
    valueFirst = Util.null2String(request.getParameter("requeststatusvalue"));

    if(requestStatusIsShow.equals("1")||requestStatusCheckCond.equals("1")){
		if(!requestStatusIsShow.equals("1")){
			requestStatusIsShow="0";
		}

		if(!requestStatusCheckCond.equals("1")){
			requestStatusCheckCond="0";
            optionFirst = "";
            valueFirst = "";
		}

        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-3,'1','"+requestStatusIsShow+"','"+requestStatusCheckCond+"','','',-1,'','"+valueFirst+"','','','')");
	}
	
	//归档时间，fieldId指定为-4，isMain指定为'1'
	//if(requestStatusCheckCond.equals("1")&&valueFirst.equals("1")){
		String archiveTime = Util.null2String(request.getParameter("archiveTime"));
		String archiveTimeFrom = "";
		String archiveTimeTo = "";
		if(archiveTime.equals("1")){
		  archiveTimeFrom = ""+Util.null2String(request.getParameter("fromdate"));
		  archiveTimeTo = ""+Util.null2String(request.getParameter("todate"));
		  RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-4,'1','1','"+archiveTime+"','','',-1,'','"+archiveTimeFrom+"','','','"+archiveTimeTo+"')");
		}
	//}*/
	
		/****新增八个字段  创建人、创建日期、工作流、当前节点、未操作者、流程状态、签字意见；*****/

	// 创建人-10
		String createmanIsShow = Util.null2String(request.getParameter("createmanIsShow"));
	    String createmanCheckCond = Util.null2String(request.getParameter("createman_check_con"));
	    optionFirst = Util.null2String(request.getParameter("createmanselected"));
	    valueFirst = Util.null2String(request.getParameter("con-10_value"));
	    nameFirst = ""+Util.null2String(request.getParameter("con-10_name"));
	    
	    if(createmanIsShow.equals("1")||createmanCheckCond.equals("1")){
			if(!createmanIsShow.equals("1")){
				createmanIsShow="0";
			}

			if(!createmanCheckCond.equals("1")){
				createmanCheckCond="0";
	            optionFirst = "";
	            valueFirst = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-10,'1','"+createmanIsShow+"','"+createmanCheckCond+"','','',-1,'"+optionFirst+"','"+valueFirst+"','"+nameFirst+"','','')");
		}
	// 创建日期-11
	    String createdateIsShow = Util.null2String(request.getParameter("createdateIsShow"));
	    String createdateCheckCond = Util.null2String(request.getParameter("createdate_check_con"));
	    optionFirst = Util.null2String(request.getParameter("SelectCreateDate"));
	    valueFirst = Util.null2String(request.getParameter("createdate"));
	    valueSecond = Util.null2String(request.getParameter("createdateend"));
	    
	    if(createdateIsShow.equals("1")||createdateCheckCond.equals("1")){
			if(!createdateIsShow.equals("1")){
				createdateIsShow="0";
			}

			if(!createdateCheckCond.equals("1")){
				createdateCheckCond="0";
	            valueFirst = "";
	            valueSecond = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-11,'1','"+createdateIsShow+"','"+createdateCheckCond+"','','',-1,'','"+valueFirst+"','','','"+valueSecond+"')");
		}
	// 工作流-12
	    String workflowtoIsShow = Util.null2String(request.getParameter("workflowtoIsShow"));
	    String workflowtoCheckCond = Util.null2String(request.getParameter("workflowto_check_con"));
	    optionFirst = Util.null2String(request.getParameter("workflowto_value"));
	    valueFirst = Util.null2String(request.getParameter("con-12_value"));
	    nameFirst = ""+Util.null2String(request.getParameter("con-12_name"));

	    if(workflowtoIsShow.equals("1")||workflowtoCheckCond.equals("1")){
			if(!workflowtoIsShow.equals("1")){
				workflowtoIsShow="0";
			}

			if(!workflowtoCheckCond.equals("1")){
				workflowtoCheckCond="0";
	            optionFirst = "";
	            valueFirst = "";
	            nameFirst = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-12,'1','"+workflowtoIsShow+"','"+workflowtoCheckCond+"','','',-1,'"+optionFirst+"','"+valueFirst+"','"+nameFirst+"','','')");
		}
	// 当前节点-13
	    String currentnodeIsShow = Util.null2String(request.getParameter("currentnodeIsShow"));
	    String currentnodeCheckCond = Util.null2String(request.getParameter("currentnode_check_con"));
	    optionFirst = Util.null2String(request.getParameter("currentnode_value"));
	    valueFirst = Util.null2String(request.getParameter("con-13_value"));
	    nameFirst = ""+Util.null2String(request.getParameter("con-13_name"));

	    if(currentnodeIsShow.equals("1")||currentnodeCheckCond.equals("1")){
			if(!currentnodeIsShow.equals("1")){
				currentnodeIsShow="0";
			}

			if(!currentnodeCheckCond.equals("1")){
				currentnodeCheckCond="0";
	            optionFirst = "";
	            valueFirst = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-13,'1','"+currentnodeIsShow+"','"+currentnodeCheckCond+"','','',-1,'"+optionFirst+"','"+valueFirst+"','"+nameFirst+"','','')");
		}

	// 未操作者-14
	    String nooperatorIsShow = Util.null2String(request.getParameter("nooperatorIsShow"));
	    String nooperatorCheckCond = Util.null2String(request.getParameter("nooperator_check_con"));
	    optionFirst = Util.null2String(request.getParameter("nooperator_opt"));
	    valueFirst = Util.null2String(request.getParameter("con-14_value"));
	    nameFirst = ""+Util.null2String(request.getParameter("con-14_name"));

	    if(nooperatorIsShow.equals("1")||nooperatorCheckCond.equals("1")){
			if(!nooperatorIsShow.equals("1")){
				nooperatorIsShow="0";
			}

			if(!nooperatorCheckCond.equals("1")){
				nooperatorCheckCond="0";
	            optionFirst = "";
	            valueFirst = "";
	            nameFirst = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-14,'1','"+nooperatorIsShow+"','"+nooperatorCheckCond+"','','',-1,'"+optionFirst+"','"+valueFirst+"','"+nameFirst+"','','')");
		}
	// 流程状态-15
	    String requeststatusIsShow = Util.null2String(request.getParameter("requeststatusIsShow"));;
	    String requeststatusCheckCond = Util.null2String(request.getParameter("requeststatus_check_con"));
	    valueFirst = Util.null2String(request.getParameter("requeststatusvalue"));

	    if(requeststatusIsShow.equals("1")||requeststatusCheckCond.equals("1")){
	    	if(!requeststatusIsShow.equals("1")){
	    		requeststatusIsShow="0";
			}
			if(!requeststatusCheckCond.equals("1")){
				requeststatusCheckCond="0";
		        valueFirst = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-15,'1','"+requeststatusIsShow+"','"+requeststatusCheckCond+"','','',-1,'','"+valueFirst+"','','','')");
		}
	//归档时间
		String filingdateIsShow = Util.null2String(request.getParameter("filingdateIsShow"));
	    String filingdateCheckCond = Util.null2String(request.getParameter("filingdate_check_con"));
	    valueFirst = Util.null2String(request.getParameter("filingdate"));
	    valueSecond = Util.null2String(request.getParameter("filingdateend"));
	    
	    if(filingdateIsShow.equals("1")||filingdateCheckCond.equals("1")){
			if(!filingdateIsShow.equals("1")){
				filingdateIsShow="0";
			}
			if(!filingdateCheckCond.equals("1")){
				filingdateCheckCond="0";
	            valueFirst = "";
	            valueSecond = "";
			}

	        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-16,'1','"+filingdateIsShow+"','"+filingdateCheckCond+"','','',-1,'','"+valueFirst+"','','','"+valueSecond+"')");
		}
	response.sendRedirect("ReportCondition.jsp?id="+reportId+"&mouldId="+mouldId+"&newMouldName="+newMouldName);
	return ;
}
%>