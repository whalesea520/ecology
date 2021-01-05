<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.fna.maintenance.FnaBorrowAmountControl"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FnaBudgetControl" class="weaver.fna.maintenance.FnaBudgetControl" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
String poststr  = Util.null2String(request.getParameter("poststr")).trim();//科目+报销类型+报销单位+报销日期+实报金额
int requestid  = Util.getIntValue(request.getParameter("requestid"),0);//流程id
int workflowid  = Util.getIntValue(request.getParameter("workflowid"),0);//流程id
int isMobile  = Util.getIntValue(request.getParameter("isMobile"),0);

String returnStr = "";
try{
	DecimalFormat df = new DecimalFormat("#################################################0.00");
	
	int fnaFeeWfInfoId = 0; 
	String sql = "select * from fnaFeeWfInfo where workflowid = "+workflowid;
	rs.executeSql(sql);
	if(rs.next()){
		fnaFeeWfInfoId = rs.getInt("id");
		int fnaWfTypeColl = rs.getInt("fnaWfTypeColl");
		int fnaWfTypeReverse = rs.getInt("fnaWfTypeReverse");
	}
	
	StringBuffer poststrNew = new StringBuffer("");
	
	if("".equals(returnStr) && !"".equals(poststr)){
		String fieldIdSubject = "";
		String fieldIdOrgType = "";
		String fieldIdOrgId = "";
		String fieldIdOccurdate = "";
		String fieldIdAmount = "";
		String fieldIdHrmInfo = "";
		String fieldIdDepInfo = "";
		String fieldIdSubInfo = "";
		String fieldIdFccInfo = "";
		
		String fieldIdSubject2 = "";
		String fieldIdOrgType2 = "";
		String fieldIdOrgId2 = "";
		String fieldIdOccurdate2 = "";
		String fieldIdHrmInfo2 = "";
		String fieldIdDepInfo2 = "";
		String fieldIdSubInfo2 = "";
		String fieldIdFccInfo2 = "";
		
		boolean periodCloseFlag = false;
		boolean dateCloseFlag = false;
		
		sql = "select * from fnaFeeWfInfoField where workflowid = "+workflowid;
		rs.executeSql(sql);
		while(rs.next()){
			String fieldType = Util.null2String(rs.getString("fieldType"));
			String fieldId = Util.null2String(rs.getString("fieldId"));
			String dtlNumber = Util.null2String(rs.getString("dtlNumber"));
		
			if(Util.getIntValue(dtlNumber)==1){
				if(Util.getIntValue(fieldType)==1){
					fieldIdSubject = fieldId;
				}else if(Util.getIntValue(fieldType)==2){
					fieldIdOrgType = fieldId;
				}else if(Util.getIntValue(fieldType)==3){
					fieldIdOrgId = fieldId;
				}else if(Util.getIntValue(fieldType)==4){
					fieldIdOccurdate = fieldId;
				}else if(Util.getIntValue(fieldType)==5){
					fieldIdAmount = fieldId;
				}else if(Util.getIntValue(fieldType)==6){
					fieldIdHrmInfo = fieldId;
				}else if(Util.getIntValue(fieldType)==7){
					fieldIdDepInfo = fieldId;
				}else if(Util.getIntValue(fieldType)==8){
					fieldIdSubInfo = fieldId;
				}else if(Util.getIntValue(fieldType)==9){
					fieldIdFccInfo = fieldId;
				}
		
				else if(Util.getIntValue(fieldType)==10){
					fieldIdSubject2 = fieldId;
				}else if(Util.getIntValue(fieldType)==11){
					fieldIdOrgType2 = fieldId;
				}else if(Util.getIntValue(fieldType)==12){
					fieldIdOrgId2 = fieldId;
				}else if(Util.getIntValue(fieldType)==13){
					fieldIdOccurdate2 = fieldId;
				}else if(Util.getIntValue(fieldType)==14){
					fieldIdHrmInfo2 = fieldId;
				}else if(Util.getIntValue(fieldType)==15){
					fieldIdDepInfo2 = fieldId;
				}else if(Util.getIntValue(fieldType)==16){
					fieldIdSubInfo2 = fieldId;
				}else if(Util.getIntValue(fieldType)==17){
					fieldIdFccInfo2 = fieldId;
				}
			}
		}
		
		if(Util.getIntValue(fieldIdSubject2) <= 0){
			fieldIdSubject2 = fieldIdSubject;
		}
		if(Util.getIntValue(fieldIdOrgType2) <= 0){
			fieldIdOrgType2 = fieldIdOrgType;
		}
		if(Util.getIntValue(fieldIdOrgId2) <= 0){
			fieldIdOrgId2 = fieldIdOrgId;
		}
		if(Util.getIntValue(fieldIdOccurdate2) <= 0){
			fieldIdOccurdate2 = fieldIdOccurdate;
		}
		if(Util.getIntValue(fieldIdHrmInfo2) <= 0){
			fieldIdHrmInfo2 = fieldIdHrmInfo;
		}
		if(Util.getIntValue(fieldIdDepInfo2) <= 0){
			fieldIdDepInfo2 = fieldIdDepInfo;
		}
		if(Util.getIntValue(fieldIdSubInfo2) <= 0){
			fieldIdSubInfo2 = fieldIdSubInfo;
		}
		if(Util.getIntValue(fieldIdFccInfo2) <= 0){
			fieldIdFccInfo2 = fieldIdFccInfo;
		}

		String[] fnainfo = poststr.split("\\|");
	    int rowsum = fnainfo.length;
	    for(int i=0;i<rowsum;i++) {
	    	//调整科目+调整报销类型+调整报销单位+调整报销日期+调整金额+调出科目+调出报销类型+调出报销单位+调出报销日期
	    	//poststr += budgetfeetype+","+orgtype+","+orgid+","+applydate+","+applyamount+","+
	    		//budgetfeetype2+","+orgtype2+","+orgid2+","+applydate2+",postStrEnd";
	    	String[] tempStr = fnainfo[i].split(",");
	    	//调整科目
			String subject = "";
			if(tempStr.length >= 1){
				subject = Util.null2String(tempStr[0]);
			}
	    	//调整报销类型 个人部门分部  012-》321
	        int organizationtype = -1;
	        if(tempStr.length >= 2){
	        	organizationtype = Util.getIntValue(tempStr[1],-1);
	        }
	    	//调整报销单位
			int organizationid = 0;
			if(tempStr.length >= 3){
				organizationid = Util.getIntValue(tempStr[2],0);
			}
		    //调整报销日期
			String budgetperiod = "";
			if(tempStr.length >= 4){
				budgetperiod = Util.null2String(tempStr[3]);
			}
			//调整金额
			double applyamount= 0.00;
			if(tempStr.length >= 5){
				applyamount= Util.getDoubleValue(tempStr[4],0);
			}

	    	//调出科目
			String subject2 = "";
			if(tempStr.length >= 6){
				subject2 = Util.null2String(tempStr[5]);
			}
	    	//调出报销类型 个人部门分部  012-》321
	        int organizationtype2 = -1;
	        if(tempStr.length >= 7){
	        	organizationtype2 = Util.getIntValue(tempStr[6],-1);
	        }
	    	//调出报销单位
			int organizationid2 = 0;
			if(tempStr.length >= 8){
				organizationid2 = Util.getIntValue(tempStr[7],0);
			}
		    //调出报销日期
			String budgetperiod2 = "";
			if(tempStr.length >= 9){
				budgetperiod2 = Util.null2String(tempStr[8]);
			}
			
			if(fieldIdSubject.equals(fieldIdSubject2)){
				subject2 = subject;
			}
			if(fieldIdOrgType.equals(fieldIdOrgType2)){
				organizationtype2 = organizationtype;
			}
			if(fieldIdOrgId.equals(fieldIdOrgId2)){
				organizationid2 = organizationid;
			}
			if(fieldIdOccurdate.equals(fieldIdOccurdate2)){
				budgetperiod2 = budgetperiod;
			}
			
			
			//257158
			RecordSet recordset = new RecordSet();
			
			StringBuffer yearBuffer = new StringBuffer();
			yearBuffer.append(" select * from  fnayearsperiods yp ");
			yearBuffer.append(" where yp.startdate <= '").append(budgetperiod).append("'");
			yearBuffer.append(" and yp.enddate >= '").append(budgetperiod).append("'");
			
			recordset.executeSql(yearBuffer.toString());
			
			int status = 0;
			
			if(recordset.next()){
				status = Util.getIntValue(recordset.getString("status"), 0);
			}
			
			if(status == -1){//预算期间关闭，预算变更不可提交
				periodCloseFlag = true;
				//returnStr = "{\"flag\":false,\"errorInfo\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(129921,user.getLanguage()))+"}";
			}
			
			StringBuffer yearBuffer2 = new StringBuffer();
			yearBuffer2.append(" select * from  fnayearsperiods yp ");
			yearBuffer2.append(" where yp.startdate <= '").append(budgetperiod2).append("'");
			yearBuffer2.append(" and yp.enddate >= '").append(budgetperiod2).append("'");
			
			recordset.executeSql(yearBuffer2.toString());
			
			int status2 = 0;
			
			if(recordset.next()){
				status2 = Util.getIntValue(recordset.getString("status"), 0);
			}
			
			if(status2 == -1){//预算期间关闭，预算变更不可提交(调出日期)
				periodCloseFlag = true;
				//returnStr = "{\"flag\":false,\"errorInfo\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(129921,user.getLanguage()))+"}";
			}
			
			
			
			RecordSet rSet = new RecordSet();
			StringBuffer stringBuffer = new StringBuffer();
			stringBuffer.append(" select * from FnaYearsPeriodsList ");
			stringBuffer.append(" where startdate <= '").append(budgetperiod).append("'");
			stringBuffer.append(" and enddate >= '").append(budgetperiod).append("'");
			rSet.executeSql(stringBuffer.toString());
			int status3 = 0;
			if(rSet.next()){
				status3 = rSet.getInt("status");
			}
			if(status3 == 1){
				dateCloseFlag = true;
			}
			
			//总是处理调整预算承担主体：如果调整金额小于0，则拼装字符串进行费控校验（注：调整金额拼装入校验字符串时必须转换成正数）
	    	if(applyamount < 0.00){
	    		if(poststrNew.length() > 0){
	    			poststrNew.append("|");
	    		}
	    		//调整科目+调整报销类型+调整报销单位+调整报销日期+调整金额
				poststrNew.append(subject+","+organizationtype+","+organizationid+","+budgetperiod+","+df.format(applyamount * -1.00)+",postStrEnd");
	    	}
			
			if(fieldIdSubject.equals(fieldIdSubject2) && fieldIdOrgType.equals(fieldIdOrgType2) && fieldIdOrgId.equals(fieldIdOrgId2) && fieldIdOccurdate.equals(fieldIdOccurdate2)){
			}else{
				//如果调出预算承担主体存在则：如果调整金额大于0，则拼装字符串进行费控校验
		    	if(applyamount > 0.00){
		    		if(poststrNew.length() > 0){
		    			poststrNew.append("|");
		    		}
		    		//调整科目+调整报销类型+调整报销单位+调整报销日期+调整金额
					poststrNew.append(subject2+","+organizationtype2+","+organizationid2+","+budgetperiod2+","+df.format(applyamount)+",postStrEnd");
		    	}
			}
			
	    }
	    
	    if(periodCloseFlag){
	    	returnStr = "{\"flag\":false,\"errorInfo\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(129921,user.getLanguage()))+"}";
	    }else if(dateCloseFlag){
	    	returnStr = "{\"flag\":false,\"errorInfo\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(131203,user.getLanguage()))+"}";
	    }else{
	    	 if(poststrNew.length() > 0){
	 			FnaBudgetControl.setFromActionType("FnaChangeifoverJsonAjax");
	 			returnStr = FnaBudgetControl.checkBudgetListForFnaifoverJsonAjax(poststrNew.toString(), workflowid, requestid, user, false);
	 	    }
	    }
	   
	}
	
	if("".equals(returnStr)){
		returnStr = "{\"flag\":true,\"errorInfo\":"+JSONObject.quote("")+"}";
	}
}catch(Exception ex1){
	new BaseBean().writeLog(ex1);
	returnStr = "{\"flag\":false,\"errorInfo\":"+JSONObject.quote(ex1.getMessage())+"}";
}
//new BaseBean().writeLog("returnStr>>>>>>>>>>"+returnStr);
%>
<%=returnStr%>