
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>

<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="deptVirComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="subComVirComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<jsp:useBean id="WorkflowCodeSeqReservedManager" class="weaver.workflow.workflow.WorkflowCodeSeqReservedManager" scope="page" />


<%

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
int userid=user.getUID();                   //当前用户id

String operation=Util.null2String(request.getParameter("operation"));
String ismand=Util.null2String(request.getParameter("ismand"));

String returnCodeStr="";

if(operation.equals("CreateCodeAgain")){

	int requestId = Util.getIntValue(request.getParameter("requestId"),0);

	int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
	int formId = Util.getIntValue(request.getParameter("formId"),0);
	String isBill = Util.null2String(request.getParameter("isBill"));
	String createrdepartmentid = Util.null2String(request.getParameter("createrdepartmentid"));

	CodeBuild cbuild = new CodeBuild(formId,isBill,workflowId);	
	CoderBean cb = cbuild.getFlowCBuild();
	String fieldCode=Util.null2String(cb.getCodeFieldId());
	String workflowSeqAlone=cb.getWorkflowSeqAlone();

	ArrayList memberList = cb.getMemberList();
	//判断是否是E8新版保存
    boolean isE8Save = false;
    String E8sql = "select 1 from workflow_codeRegulate where concreteField  = '8' "+
		 " and ((formId="+formId+" and isBill='"+isBill+"') or workflowId="+workflowId+" ) ";
    RecordSet.execute(E8sql);
    if(RecordSet.next()){
	  isE8Save = true;
    }
    //end

	String departmentFieldId="-1";
	String subCompanyFieldId="-1";
	String supSubCompanyFieldId="-1";

			
	for (int i=0;i<memberList.size();i++){
		String[] codeMembers = (String[])memberList.get(i);
		String codeMemberName = codeMembers[0];
		String codeMemberValue = codeMembers[1];
		if("22753".equals(codeMemberName)){
			supSubCompanyFieldId=codeMemberValue;
		}else if("141".equals(codeMemberName)){
			subCompanyFieldId=codeMemberValue;
		}else if("124".equals(codeMemberName)){
			departmentFieldId=codeMemberValue;
		}
	}


	String yearId = Util.null2String(request.getParameter("yearId"));
	String monthId = Util.null2String(request.getParameter("monthId"));
	String dateId = Util.null2String(request.getParameter("dateId"));
	String fieldId = Util.null2String(request.getParameter("fieldId"));
	String supSubCompanyId = Util.null2String(request.getParameter("supSubCompanyId"));
	String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
	String departmentId = Util.null2String(request.getParameter("departmentId"));
	String fieldValue = Util.null2String(request.getParameter("fieldValue"));
	String departmentFieldValue="";
	String subCompanyFieldValue="";
	String supSubCompanyFieldValue="";
	
	departmentFieldValue=departmentId;
	subCompanyFieldValue=subCompanyId;
	supSubCompanyFieldValue=supSubCompanyId;
	
	Map valueOfField=cbuild.getValueOfFieldForCode(requestId,workflowId);
	
	//默认值
	if(subCompanyFieldValue.equals("-1")){
		subCompanyFieldValue=DepartmentComInfo.getSubcompanyid1(""+createrdepartmentid);				
	}
	if(supSubCompanyFieldValue.equals("-1")){
		supSubCompanyFieldValue=Util.null2String(SubCompanyComInfo.getSupsubcomid(""+DepartmentComInfo.getSubcompanyid1(""+createrdepartmentid)));	
		if(supSubCompanyFieldValue.equals("")){
			supSubCompanyFieldValue=DepartmentComInfo.getSubcompanyid1(""+createrdepartmentid);//若上级分部为空，则认为上级分部为分部
		}
	}

    WorkflowCodeSeqReservedManager.setYearIdDefault(yearId);
    WorkflowCodeSeqReservedManager.setMonthIdDefault(monthId);
    WorkflowCodeSeqReservedManager.setDateIdDefault(dateId);
    WorkflowCodeSeqReservedManager.setFieldIdDefault(fieldId);
    WorkflowCodeSeqReservedManager.setFieldValueDefault(fieldValue);
    WorkflowCodeSeqReservedManager.setSupSubCompanyIdDefault(supSubCompanyId);
    WorkflowCodeSeqReservedManager.setSubCompanyIdDefault(subCompanyId);
    WorkflowCodeSeqReservedManager.setDepartmentIdDefault(departmentId);


	int recordId = Util.getIntValue(request.getParameter("recordId"),0);
	int sequenceId=1;
	if(recordId<=0){
		int tempWorkflowId=-1;
		int tempFormId=-1;
		String tempIsBill="0";
		String tempYearId="-1";
		String tempMonthId="-1";
		String tempDateId="-1";
	
		String tempFieldId="-1";
		String tempFieldValue="-1";
	
		String tempSupSubCompanyId="-1";
		String tempSubCompanyId="-1";
		String tempDepartmentId="-1";
	
		int tempRecordId=-1;
		int tempSequenceId=1;
	
		String dateSeqAlone=cb.getDateSeqAlone();
		String dateSeqSelect=cb.getDateSeqSelect();
		String fieldSequenceAlone=cb.getFieldSequenceAlone();
		String struSeqAlone=cb.getStruSeqAlone();
		String struSeqSelect=cb.getStruSeqSelect();
	
		if("1".equals(workflowSeqAlone)){
			tempWorkflowId=workflowId;
		}else{
			tempFormId=formId;
		    tempIsBill=isBill;
		}
	
		if("1".equals(dateSeqAlone)&&"1".equals(dateSeqSelect)){
			tempYearId=yearId;
		}else if("1".equals(dateSeqAlone)&&"2".equals(dateSeqSelect)){
			tempYearId=yearId;
			tempMonthId=monthId;						
		}else if("1".equals(dateSeqAlone)&&"3".equals(dateSeqSelect)){
			tempYearId=yearId;						
			tempMonthId=monthId;	
			tempDateId=dateId;							
		}
					
		if("1".equals(fieldSequenceAlone)&&!fieldId.equals("-1") ){
			tempFieldId=fieldId;
			tempFieldValue=fieldValue;
			List<String> sltFieldIdList = Util.splitString2List(fieldId, ",");
			if (!"".equals(cb.getSelectCorrespondField()) && sltFieldIdList.size()>1) {
			    int i0 = sltFieldIdList.indexOf(cb.getSelectCorrespondField());
			    if (i0 != -1) {
			        List<String> tempFieldValueList = Util.splitString2List(tempFieldValue, ",");
			        tempFieldId =  cb.getSelectCorrespondField();
			        tempFieldValue = tempFieldValueList.get(i0);
			    }
			}
		}
		
		if("1".equals(struSeqAlone)&&"1".equals(struSeqSelect)){
		    //tempSupSubCompanyId=supSubCompanyId;
			tempSubCompanyId="-1";
			tempDepartmentId="-1";
			String strCorrespondField =  cb.getCorrespondField();
			if(!"-2".equals(strCorrespondField)){
				//tempSupSubCompanyId = strCorrespondField;
				tempSupSubCompanyId= String.valueOf(Util.getIntValue((String)valueOfField.get("field"+strCorrespondField),-1));
			}else{
				tempSupSubCompanyId=Util.null2String(SubCompanyComInfo.getSupsubcomid(""+DepartmentComInfo.getSubcompanyid1(""+createrdepartmentid)));	
				if(tempSupSubCompanyId.equals("")){
					tempSupSubCompanyId=DepartmentComInfo.getSubcompanyid1(""+createrdepartmentid);//若上级分部为空，则认为上级分部为分部
				}
			}
		}
		if("1".equals(struSeqAlone)&&"2".equals(struSeqSelect)){
			tempSupSubCompanyId="-1";
			//tempSubCompanyId=subCompanyId;
			tempDepartmentId="-1";
			String strCorrespondField =  cb.getCorrespondField();
			if(!"-2".equals(strCorrespondField)){
				//tempSubCompanyId = strCorrespondField;
				tempSubCompanyId= String.valueOf(Util.getIntValue((String)valueOfField.get("field"+strCorrespondField),-1));
			}else{
				tempSubCompanyId=DepartmentComInfo.getSubcompanyid1(""+createrdepartmentid);
			}
		}
		if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){
			tempSupSubCompanyId="-1";
			tempSubCompanyId="-1";
			//tempDepartmentId=departmentId;
			String strCorrespondField =  cb.getCorrespondField();
			if(!"-2".equals(strCorrespondField)){
				//tempDepartmentId = strCorrespondField;
				tempDepartmentId= String.valueOf(Util.getIntValue((String)valueOfField.get("field"+strCorrespondField),-1));
			}else{
				tempDepartmentId = createrdepartmentid;
			}
		}

		String allversionwfid = "";
		if("1".equals(workflowSeqAlone)){
			allversionwfid = WorkflowVersion.getVersionStringByWfid(""+tempWorkflowId);
		}else{
			allversionwfid = ""+tempWorkflowId;
		}
		RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId in("+allversionwfid+")  and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

		int ctempRecordId = -1;
		int ctempSequenceId = -1;
		while(RecordSet.next()){
			ctempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
			ctempSequenceId = Util.getIntValue(RecordSet.getString("sequenceId"),1);
			if(ctempSequenceId > tempSequenceId){
				tempSequenceId = ctempSequenceId;
			}
			if(ctempRecordId > tempRecordId){
				tempRecordId = ctempRecordId;
			}
		}
		//if(RecordSet.next()){
		//	tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
		//	tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
		//}

	    if(tempRecordId>0){
			recordId = tempRecordId;
			sequenceId = tempSequenceId;
		}else{
			RecordSet.executeSql("insert into workflow_codeSeq(yearId,sequenceId,formId,isBill,monthId,dateId,workflowId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId)" +
			" values("+tempYearId+","+tempSequenceId+","+tempFormId+",'"+tempIsBill+"',"+tempMonthId+","+tempDateId+","+tempWorkflowId+","+tempFieldId+","+tempFieldValue+","+tempSupSubCompanyId+","+tempSubCompanyId+","+tempDepartmentId+")");
			RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId in("+allversionwfid+") and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

			if(RecordSet.next()){
			    //tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
			    //tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);	
			    
			    ctempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
				ctempSequenceId = Util.getIntValue(RecordSet.getString("sequenceId"),1);
				if(ctempSequenceId > tempSequenceId){
					tempSequenceId = ctempSequenceId;
				}
				if(ctempRecordId > tempRecordId){
					tempRecordId = ctempRecordId;
				}
			    
			}
			if(tempRecordId>0){
			    recordId = tempRecordId;
			    sequenceId = tempSequenceId;
			}
		}
	}else{
		RecordSet.executeSql("select sequenceId from workflow_codeSeq where id="+recordId);

		if(RecordSet.next()){
			sequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
		}
	}

    //先将现有流程编号记入预留编号表
	int reservedId=-1;
	int codeSeqReservedId=-1;
	RecordSet.executeSql("select sequenceId,codeSeqReservedId from workflow_codeSeqRecord where requestId="+requestId+" and codeSeqId="+recordId+" order by id desc");
	if(RecordSet.next()){
		reservedId=Util.getIntValue(RecordSet.getString("sequenceId"),-1);
		codeSeqReservedId=Util.getIntValue(RecordSet.getString("codeSeqReservedId"),-1);
	}

	if(reservedId>=1){
		if(codeSeqReservedId>=1){
			RecordSet.executeSql("update workflow_codeSeqReserved set hasUsed='0',hasDeleted='0' where id="+codeSeqReservedId);
		}else{
		    List<String> hisReservedIdList=new ArrayList<String>();
		    StringBuffer hisReservedIdSb=new StringBuffer();
		    hisReservedIdSb.append(" select reservedId ")
		                   .append("   from workflow_codeSeqReserved ")
		                   .append("  where codeSeqId=").append(recordId)
		                   .append("    and (hasDeleted is null or hasDeleted='0') ")
		                   .append("  order by reservedId asc,id asc ")		               
		                   ;
		    RecordSet.executeSql(hisReservedIdSb.toString());
		    while(RecordSet.next()){
		    	hisReservedIdList.add(Util.null2String(RecordSet.getString("reservedId")));
		    }
		    

		    	RecordSet.executeSql("update workflow_codeSeqReserved set hasUsed='0',hasDeleted='0' where codeSeqId="+recordId + " and reservedid=" + reservedId);
		}
	}


			String tablename="workflow_form";
			String fieldName="";
			
			
			if (!fieldCode.equals("")){
				String sql="select fieldName  from workflow_formdict where id="+fieldCode;
				if (isBill.equals("1")) {
					sql="select fieldName  from workflow_billfield where id="+fieldCode;
					RecordSet.executeSql("select tablename from workflow_bill where id = " + formId); // 查询工作流单据表的信息
					if (RecordSet.next()){
						tablename = Util.null2String(RecordSet.getString("tablename"));          // 获得单据的主表
					}
				}
			    RecordSet.executeSql(sql);
			    if (RecordSet.next()){ 
			    	fieldName=Util.null2String(RecordSet.getString(1));
			    }	
            }


			int tempStruValue=0;
			String tempAbbr =null;
			
			Map subComAbbrDefMap=new HashMap();
			RecordSet.executeSql("select * from workflow_subComAbbrDef");
			while(RecordSet.next()){
				tempStruValue=Util.getIntValue(RecordSet.getString("subCompanyId"));
				tempAbbr=Util.null2String(RecordSet.getString("abbr"));
				subComAbbrDefMap.put(""+tempStruValue,tempAbbr);
			}

			Map deptAbbrDefMap=new HashMap();
			RecordSet.executeSql("select * from workflow_deptAbbrDef");
			while(RecordSet.next()){
				tempStruValue=Util.getIntValue(RecordSet.getString("departmentId"));
				tempAbbr=Util.null2String(RecordSet.getString("abbr"));
				deptAbbrDefMap.put(""+tempStruValue,tempAbbr);
			}
			
			String enableDeptcode = "";
			String enableSubcode = "";
			String enableSupSubcode = "";
			RecordSet.executeSql("select enableDeptcode from workflow_deptAbbr where workflowId="+workflowId+" and enableDeptcode=1");
			if(RecordSet.next())enableDeptcode="1";
			
			RecordSet.executeSql("select enableSubcode from workflow_subComAbbr where workflowId="+workflowId+" and enableSubcode=1");
			if(RecordSet.next())enableSubcode="1";
			
			RecordSet.executeSql("select enableSupSubcode from workflow_supSubComAbbr where workflowId="+workflowId+" and enableSupSubcode=1");
			if(RecordSet.next())enableSupSubcode="1";
			
			if(!isE8Save){//E8前
				for (int i=0;i<memberList.size();i++){
					String[] members = (String[])memberList.get(i);
					String text = members[0];
					String value = members[1];
					
					if ("18729".equals(text)){
						returnCodeStr+=value;
					}else if("20571".equals(text)){
						returnCodeStr+=value;					
					}else if("20572".equals(text)){
						returnCodeStr+=value;					
					}else if("20573".equals(text)){
						returnCodeStr+=value;					
					}else if("20574".equals(text)){
						returnCodeStr+=value;					
					}else if("20575".equals(text)){
						returnCodeStr+=value;					
					}else if("20770".equals(text)){
						returnCodeStr+=value;					
					}else if("20771".equals(text)){
						returnCodeStr+=value;					
					}else if ("445".equals(text)){
						if (("-2".equals(value)||Util.getIntValue(value,-1)>0)&&!yearId.equals("-1")){
							returnCodeStr+=Util.add0(Integer.parseInt(yearId),4);
						} 
					}else if ("6076".equals(text)){
						if (("-2".equals(value)||Util.getIntValue(value,-1)>0)&&!monthId.equals("-1")){
							returnCodeStr+=Util.add0(Integer.parseInt(monthId),2);
						}
					} else if ("390".equals(text)||"16889".equals(text)){
						if (("-2".equals(value)||Util.getIntValue(value,-1)>0)&&!dateId.equals("-1")){
							returnCodeStr+=Util.add0(Integer.parseInt(dateId),2);
						}
					} else if ("22755".equals(text)){
						String shortNameSettingSql=null;
						String shortNameSetting="";
						if("1".equals(workflowSeqAlone)){
							shortNameSettingSql="select shortNameSetting from workflow_shortNameSetting  where workflowId="+workflowId+" and fieldId="+fieldId+" and fieldValue="+fieldValue;
						}else{
							shortNameSettingSql="select shortNameSetting from workflow_shortNameSetting  where formId="+formId+" and isBill="+isBill+" and fieldId="+fieldId+" and fieldValue="+fieldValue;
						}
						RecordSet.executeSql(shortNameSettingSql);
						if(RecordSet.next()){
							shortNameSetting=Util.null2String(RecordSet.getString("shortNameSetting"));
						}
						
						if("".equals(shortNameSetting)){
							RecordSet.executeSql("select selectName from workflow_selectitem where fieldId="+fieldId+" and isBill='"+isBill+"' and selectValue="+fieldValue);
							if(RecordSet.next()){
								shortNameSetting=Util.null2String(RecordSet.getString("selectName"));
							}						
						}
						returnCodeStr+=shortNameSetting;
					} else if ("22753".equals(text)&&!"-1".equals(value)&&supSubCompanyId!=subCompanyId){//上级分部
						String abbrSql=null;
						String abbr="";
						RecordSet.executeSql("select supsubcomid from HrmSubCompanyAllView where id = "+supSubCompanyId);
						if(RecordSet.next()){
							String supSubComId=Util.null2String(RecordSet.getString("supsubcomid"));
							if(!supSubComId.equals("")){
								supSubCompanyId = supSubComId;
								
							}
						}
						if("1".equals(workflowSeqAlone)){
							abbrSql="select abbr from workflow_supSubComAbbr  where workflowId="+workflowId+" and fieldId="+supSubCompanyFieldId+" and fieldValue="+supSubCompanyId;
						}else{
							abbrSql="select abbr from workflow_supSubComAbbr  where formId="+formId+" and isBill="+isBill+" and fieldId="+supSubCompanyFieldId+" and fieldValue="+supSubCompanyId;
						}
						RecordSet.executeSql(abbrSql);
						if(RecordSet.next()){
							abbr=Util.null2String(RecordSet.getString("abbr"));
						}
						
						if("".equals(abbr)){
							abbr=Util.null2String((String)subComAbbrDefMap.get(""+supSubCompanyId));						
						}
						
						if("".equals(abbr)){
							if(Integer.parseInt(supSubCompanyId) < -1){
								abbr=Util.null2String(subComVirComInfo.getSubCompanyname(""+supSubCompanyId));	
							}else{
								abbr=Util.null2String(SubCompanyComInfo.getSubCompanyname(""+supSubCompanyId));
							}
						}
						if("1".equals(enableSupSubcode)){
							abbr = "";
							abbrSql = "select subcompanycode from HrmSubCompanyAllView where id="+supSubCompanyId;
							RecordSet.executeSql(abbrSql);
							if(RecordSet.next()){
								abbr=Util.null2String(RecordSet.getString("subcompanycode"));
							}
						}					
						returnCodeStr+=abbr;
					} else if ("141".equals(text)&&!"-1".equals(value)){//分部
						String abbrSql=null;
						String abbr="";
						if("1".equals(workflowSeqAlone)){
							abbrSql="select abbr from workflow_subComAbbr  where workflowId="+workflowId+" and fieldId="+subCompanyFieldId+" and fieldValue="+subCompanyId;
						}else{
							abbrSql="select abbr from workflow_subComAbbr  where formId="+formId+" and isBill="+isBill+" and fieldId="+subCompanyFieldId+" and fieldValue="+subCompanyId;
						}
						RecordSet.executeSql(abbrSql);
						if(RecordSet.next()){
							abbr=Util.null2String(RecordSet.getString("abbr"));
						}
						
						if("".equals(abbr)){
							abbr=Util.null2String((String)subComAbbrDefMap.get(""+subCompanyId));						
						}
						
						if("".equals(abbr)){
							if(Integer.parseInt(subCompanyId) < -1){
								abbr=Util.null2String(subComVirComInfo.getSubCompanyname(""+subCompanyId));	
							}else{
								abbr=Util.null2String(SubCompanyComInfo.getSubCompanyname(""+subCompanyId));
							}
						}
						if("1".equals(enableSubcode)){
							abbr = "";
							abbrSql = "select subcompanycode from HrmSubCompanyAllView where id="+subCompanyId;
							RecordSet.executeSql(abbrSql);
							if(RecordSet.next()){
								abbr=Util.null2String(RecordSet.getString("subcompanycode"));
							}
						}
						returnCodeStr+=abbr;
					} else if ("124".equals(text)&&!"-1".equals(value)){//部门
						String abbrSql=null;
						String abbr="";
						if("1".equals(workflowSeqAlone)){
							abbrSql="select abbr from workflow_deptAbbr  where workflowId="+workflowId+" and fieldId="+departmentFieldId+" and fieldValue="+departmentId;
						}else{
							abbrSql="select abbr from workflow_deptAbbr  where formId="+formId+" and isBill="+isBill+" and fieldId="+departmentFieldId+" and fieldValue="+departmentId;
						}
						RecordSet.executeSql(abbrSql);
						if(RecordSet.next()){
							abbr=Util.null2String(RecordSet.getString("abbr"));
						}
						
						if("".equals(abbr)){
							abbr=Util.null2String((String)deptAbbrDefMap.get(""+departmentId));						
						}
						
						if("".equals(abbr)){
							if(Integer.parseInt(departmentId) < -1){
								abbr=Util.null2String(deptVirComInfo.getDepartmentname(""+departmentId));						
							}else{
								abbr=Util.null2String(DepartmentComInfo.getDepartmentname(""+departmentId));
							}
						}
						if("1".equals(enableDeptcode)){
							abbr = "";
							abbrSql = "select departmentcode from HrmDepartmentAllView where id="+departmentId;
							RecordSet.executeSql(abbrSql);
							if(RecordSet.next()){
								abbr=Util.null2String(RecordSet.getString("departmentcode"));
							}
						}
						returnCodeStr+=abbr;
					}else if ("18811".equals(text)){
						int tempRecordId=recordId;
						int tempSequenceId=sequenceId;					
		
	
						if(tempRecordId>0){
							List reservedIdList=new ArrayList();
							StringBuffer reservedIdSb=new StringBuffer();
							reservedIdSb.append(" select reservedId  ")
							            .append("   from workflow_codeSeqReserved  ")
							            .append("  where codeSeqId=").append(tempRecordId)
							            .append("    and (hasDeleted is null or hasDeleted='0') ")
							            .append("  order by reservedId asc,id asc ")					            
							            ;
							RecordSet.executeSql(reservedIdSb.toString());
							while(RecordSet.next()){
								reservedIdList.add(Util.null2String(RecordSet.getString("reservedId")));
							}
							
							while(reservedIdList.indexOf(""+tempSequenceId)>-1){//跳过预留号
								tempSequenceId++;
							}
						}					
						
						if(Util.getIntValue(value)<=(""+tempSequenceId).length())
							returnCodeStr += tempSequenceId;
						else{
							for(int j=0;j<(Util.getIntValue(value)-(""+tempSequenceId).length());j++){
								returnCodeStr += "0";
							}
							returnCodeStr += tempSequenceId;
						}
						
						sequenceId=tempSequenceId;
						tempSequenceId++;
						
						if(tempRecordId>0){
							RecordSet.executeSql("update workflow_codeSeq set sequenceId="+tempSequenceId+" where id="+tempRecordId);
							recordId=tempRecordId;
						}
						
					}
				}
			}else{//E8

				int strindex = 0;//字符串字段
				int selectindex = 0;//选择框字段
				int deptindex = 0;//部门字段
				int subindex = 0;//分部字段
				int supsubindex = 0;//上级分部字段
				int yindex = 0;//年字段
				int mindex = 0;//月字段
				int dindex = 0;//日字段
				for (int i=0;i<memberList.size();i++){
					String[] codeMembers = (String[])memberList.get(i);
					String codeMemberName = codeMembers[0];
					String codeMemberValue = codeMembers[1];
					String codeMemberType = codeMembers[2];
					String concreteField = codeMembers[3];
					String enablecode = codeMembers[4];
				
					//7:input字符串
					if ("2".equals(codeMemberType) && !"".equals(codeMemberValue) && codeMemberValue != null && "7".equals(concreteField)){   
			
					returnCodeStr+=codeMemberValue;
					
					//strindex++;
					//0:选择框字段
					}else if(codeMemberType.equals("5") && concreteField.equals("0")){
						String shortNameSettingSql=null;
						String shortNameSetting="";
						if(fieldValue.indexOf(",")>-1){

							if("1".equals(workflowSeqAlone)){
								shortNameSettingSql="select shortNameSetting from workflow_shortNameSetting  where workflowId="+workflowId+" and fieldId="+codeMemberValue+" and fieldValue="+fieldValue.split(",")[selectindex];
							}else{
								shortNameSettingSql="select shortNameSetting from workflow_shortNameSetting  where formId="+formId+" and isBill="+isBill+" and fieldId="+codeMemberValue+" and fieldValue="+fieldValue.split(",")[selectindex];
							}
							RecordSet.executeSql(shortNameSettingSql);
							if(RecordSet.next()){
								shortNameSetting=Util.null2String(RecordSet.getString("shortNameSetting"));
							}
							
							if("".equals(shortNameSetting)){
								RecordSet.executeSql("select selectName from workflow_selectitem where fieldId="+codeMemberValue+" and isBill='"+isBill+"' and selectValue="+fieldValue.split(",")[selectindex]);
								if(RecordSet.next()){
									shortNameSetting=Util.null2String(RecordSet.getString("selectName"));
								}
							}
							if(shortNameSetting.equals("") && !"-1".equals(fieldValue.split(",")[selectindex])){
								shortNameSetting = fieldValue.split(",")[selectindex];
							}
						}else{
							if("1".equals(workflowSeqAlone)){
								shortNameSettingSql="select shortNameSetting from workflow_shortNameSetting  where workflowId="+workflowId+" and fieldId="+codeMemberValue+" and fieldValue="+fieldValue;
							}else{
								shortNameSettingSql="select shortNameSetting from workflow_shortNameSetting  where formId="+formId+" and isBill="+isBill+" and fieldId="+codeMemberValue+" and fieldValue="+fieldValue;
							}
							RecordSet.executeSql(shortNameSettingSql);
							if(RecordSet.next()){
								shortNameSetting=Util.null2String(RecordSet.getString("shortNameSetting"));
							}
							
							if("".equals(shortNameSetting)){
								RecordSet.executeSql("select selectName from workflow_selectitem where fieldId="+codeMemberValue+" and isBill='"+isBill+"' and selectValue="+fieldValue);
								if(RecordSet.next()){
									shortNameSetting=Util.null2String(RecordSet.getString("selectName"));
								}						
							}
							if(shortNameSetting.equals("") && !"-1".equals(fieldValue)){
								shortNameSetting = fieldValue;
							}
						}
						returnCodeStr+=shortNameSetting;
						selectindex++;
					//1:部门
					}else if(codeMemberType.equals("5") && concreteField.equals("1")){

						String abbrSql=null;
						String abbr="";
						String nowdeptvalue = "";
						if(departmentFieldValue.indexOf(",")>-1){
							if(departmentFieldValue.split(",")[deptindex].equals("-1")){
								nowdeptvalue = createrdepartmentid;
							}else{
								nowdeptvalue = departmentFieldValue.split(",")[deptindex];
							}
							if("1".equals(workflowSeqAlone)){
								abbrSql="select abbr from workflow_deptAbbr  where workflowId="+workflowId+" and fieldId="+codeMemberValue+" and fieldValue="+nowdeptvalue;
							}else{
								abbrSql="select abbr from workflow_deptAbbr  where formId="+formId+" and isBill="+isBill+" and fieldId="+codeMemberValue+" and fieldValue="+nowdeptvalue;
							}
							RecordSet.executeSql(abbrSql);
							if(RecordSet.next()){
								abbr=Util.null2String(RecordSet.getString("abbr"));
							}
							
							if("".equals(abbr)){
								abbr=Util.null2String((String)deptAbbrDefMap.get(""+nowdeptvalue));						
							}
							
							if("".equals(abbr)){
								if(Integer.parseInt(nowdeptvalue) < -1){
									abbr=Util.null2String(deptVirComInfo.getDepartmentname(""+nowdeptvalue));						
								}else{
									abbr=Util.null2String(DepartmentComInfo.getDepartmentname(""+nowdeptvalue));
								}
							}
							if("1".equals(enablecode)){
								abbr = "";
								abbrSql = "select departmentcode from HrmDepartmentAllView where id="+nowdeptvalue;
								RecordSet.executeSql(abbrSql);
								if(RecordSet.next()){
									abbr=Util.null2String(RecordSet.getString("departmentcode"));
								}
							}
						}else{
							if(departmentFieldValue.equals("-1")){
								departmentFieldValue = createrdepartmentid;
							}
							if("1".equals(workflowSeqAlone)){
								abbrSql="select abbr from workflow_deptAbbr  where workflowId="+workflowId+" and fieldId="+codeMemberValue+" and fieldValue="+departmentFieldValue;
							}else{
								abbrSql="select abbr from workflow_deptAbbr  where formId="+formId+" and isBill="+isBill+" and fieldId="+codeMemberValue+" and fieldValue="+departmentFieldValue;
							}
							RecordSet.executeSql(abbrSql);
							if(RecordSet.next()){
								abbr=Util.null2String(RecordSet.getString("abbr"));
							}
							
							if("".equals(abbr)){
								abbr=Util.null2String((String)deptAbbrDefMap.get(""+departmentFieldValue));						
							}
							
							if("".equals(abbr)){
								if(Integer.parseInt(departmentFieldValue) < -1){
									abbr=Util.null2String(deptVirComInfo.getDepartmentname(""+departmentFieldValue));						
								}else{
									abbr=Util.null2String(DepartmentComInfo.getDepartmentname(""+departmentFieldValue));
								}
							}
							if("1".equals(enablecode)){
								abbr = "";
								abbrSql = "select departmentcode from HrmDepartmentAllView where id="+departmentFieldValue;
								RecordSet.executeSql(abbrSql);
								if(RecordSet.next()){
									abbr=Util.null2String(RecordSet.getString("departmentcode"));
								}
							}
						}
						returnCodeStr+=abbr;
						deptindex++;
					//2:分部
					}else if(codeMemberType.equals("5") && concreteField.equals("2")){
						String abbrSql=null;
						String abbr="";
						
						String nowsubcomvalue = "";
						if(subCompanyFieldValue.indexOf(",")>-1){
							if(subCompanyFieldValue.split(",")[subindex].equals("-1")){
								nowsubcomvalue=DepartmentComInfo.getSubcompanyid1(""+createrdepartmentid);
							}else{
								nowsubcomvalue = subCompanyFieldValue.split(",")[subindex];
							}
						
							if("1".equals(workflowSeqAlone)){
								abbrSql="select abbr from workflow_subComAbbr  where workflowId="+workflowId+" and fieldId="+codeMemberValue+" and fieldValue="+nowsubcomvalue;
							}else{
								abbrSql="select abbr from workflow_subComAbbr  where formId="+formId+" and isBill="+isBill+" and fieldId="+codeMemberValue+" and fieldValue="+nowsubcomvalue;
							}
							RecordSet.executeSql(abbrSql);
							if(RecordSet.next()){
								abbr=Util.null2String(RecordSet.getString("abbr"));
							}
							
							if("".equals(abbr)){
								abbr=Util.null2String((String)subComAbbrDefMap.get(""+nowsubcomvalue));						
							}
		
											
							if("".equals(abbr)){
								if(Integer.parseInt(nowsubcomvalue) < -1){
									abbr=Util.null2String(subComVirComInfo.getSubCompanyname(""+nowsubcomvalue));	
								}else{
									abbr=Util.null2String(SubCompanyComInfo.getSubCompanyname(""+nowsubcomvalue));
								}
							}
							if("1".equals(enablecode)){
								abbr = "";
								abbrSql = "select subcompanycode from HrmSubCompanyAllView where id="+nowsubcomvalue;
								RecordSet.executeSql(abbrSql);
								if(RecordSet.next()){
									abbr=Util.null2String(RecordSet.getString("subcompanycode"));
								}
							}
						}else{
							if("1".equals(workflowSeqAlone)){
								abbrSql="select abbr from workflow_subComAbbr  where workflowId="+workflowId+" and fieldId="+codeMemberValue+" and fieldValue="+subCompanyFieldValue;
							}else{
								abbrSql="select abbr from workflow_subComAbbr  where formId="+formId+" and isBill="+isBill+" and fieldId="+codeMemberValue+" and fieldValue="+subCompanyFieldValue;
							}
							RecordSet.executeSql(abbrSql);
							if(RecordSet.next()){
								abbr=Util.null2String(RecordSet.getString("abbr"));
							}
							
							if("".equals(abbr)){
								abbr=Util.null2String((String)subComAbbrDefMap.get(""+subCompanyFieldValue));						
							}
		
											
							if("".equals(abbr)){
								if(Integer.parseInt(subCompanyFieldValue) < -1){
									abbr=Util.null2String(subComVirComInfo.getSubCompanyname(""+subCompanyFieldValue));	
								}else{
									abbr=Util.null2String(SubCompanyComInfo.getSubCompanyname(""+subCompanyFieldValue));
								}
							}
							if("1".equals(enablecode)){
								abbr = "";
								abbrSql = "select subcompanycode from HrmSubCompanyAllView where id="+subCompanyFieldValue;
								RecordSet.executeSql(abbrSql);
								if(RecordSet.next()){
									abbr=Util.null2String(RecordSet.getString("subcompanycode"));
								}
							}
						}
						
						returnCodeStr+=abbr;
						subindex++;
					//3:上级分部
					}else if(codeMemberType.equals("5") && concreteField.equals("3")){
						//上级分部
						String abbrSql=null;
						String abbr="";
						
						String nowsupsubvalue = "";
						if(supSubCompanyFieldValue.indexOf(",")>-1){
							if(supSubCompanyFieldValue.split(",")[supsubindex].equals("-1")){
								nowsupsubvalue=Util.null2String(SubCompanyComInfo.getSupsubcomid(""+DepartmentComInfo.getSubcompanyid1(""+createrdepartmentid)));	
								if(nowsupsubvalue.equals("")){
									nowsupsubvalue=DepartmentComInfo.getSubcompanyid1(""+createrdepartmentid);//若上级分部为空，则认为上级分部为分部
								}
							}else{
								nowsupsubvalue = supSubCompanyFieldValue.split(",")[supsubindex];
								RecordSet.executeSql("select supsubcomid from HrmSubCompanyAllView where id = "+nowsupsubvalue);
								if(RecordSet.next()){
									String supSubComId=Util.null2String(RecordSet.getString("supsubcomid"));
									if(!supSubComId.equals("")){
										nowsupsubvalue = supSubComId;
									}
								}
							}
						
							if("1".equals(workflowSeqAlone)){
								abbrSql="select abbr from workflow_supSubComAbbr  where workflowId="+workflowId+" and fieldId="+codeMemberValue+" and fieldValue="+nowsupsubvalue;
							}else{
								abbrSql="select abbr from workflow_supSubComAbbr  where formId="+formId+" and isBill="+isBill+" and fieldId="+codeMemberValue+" and fieldValue="+nowsupsubvalue;
							}
							RecordSet.executeSql(abbrSql);
							if(RecordSet.next()){
								abbr=Util.null2String(RecordSet.getString("abbr"));
							}
							
							if("".equals(abbr)){
								abbr=Util.null2String((String)subComAbbrDefMap.get(""+nowsupsubvalue));						
							}
							
							
							if("".equals(abbr)){
								if(Integer.parseInt(nowsupsubvalue) < -1){
									abbr=Util.null2String(subComVirComInfo.getSubCompanyname(""+nowsupsubvalue));	
								}else{
									abbr=Util.null2String(SubCompanyComInfo.getSubCompanyname(""+nowsupsubvalue));
								}
							}	
							if("1".equals(enablecode)){
								abbr = "";
								abbrSql = "select subcompanycode from HrmSubCompanyAllView where id="+nowsupsubvalue;
								RecordSet.executeSql(abbrSql);
								if(RecordSet.next()){
									abbr=Util.null2String(RecordSet.getString("subcompanycode"));
								}
							}
						}else{
							
							if(!supSubCompanyId.equals("-1")){
								RecordSet.executeSql("select supsubcomid from HrmSubCompanyAllView where id = "+supSubCompanyFieldValue);
								if(RecordSet.next()){
									String supSubComId=Util.null2String(RecordSet.getString("supsubcomid"));
									if(!supSubComId.equals("")){
										supSubCompanyFieldValue = supSubComId;
									}
								}
							}
							if("1".equals(workflowSeqAlone)){
								abbrSql="select abbr from workflow_supSubComAbbr  where workflowId="+workflowId+" and fieldId="+codeMemberValue+" and fieldValue="+supSubCompanyFieldValue;
							}else{
								abbrSql="select abbr from workflow_supSubComAbbr  where formId="+formId+" and isBill="+isBill+" and fieldId="+codeMemberValue+" and fieldValue="+supSubCompanyFieldValue;
							}
							RecordSet.executeSql(abbrSql);
							if(RecordSet.next()){
								abbr=Util.null2String(RecordSet.getString("abbr"));
							}
							
							if("".equals(abbr)){
								abbr=Util.null2String((String)subComAbbrDefMap.get(""+supSubCompanyFieldValue));						
							}
							
							
							if("".equals(abbr)){
								if(Integer.parseInt(supSubCompanyFieldValue) < -1){
									abbr=Util.null2String(subComVirComInfo.getSubCompanyname(""+supSubCompanyFieldValue));	
								}else{
									abbr=Util.null2String(SubCompanyComInfo.getSubCompanyname(""+supSubCompanyFieldValue));
								}
							}	
							if("1".equals(enablecode)){
								abbr = "";
								abbrSql = "select subcompanycode from HrmSubCompanyAllView where id="+supSubCompanyFieldValue;
								RecordSet.executeSql(abbrSql);
								if(RecordSet.next()){
									abbr=Util.null2String(RecordSet.getString("subcompanycode"));
								}
							}					
						}
						returnCodeStr+=abbr;
						supsubindex++;
					//4:年
					}else if(codeMemberType.equals("5") && concreteField.equals("4")){
						if(yearId.indexOf(",") > -1){
							if(!yearId.split(",")[yindex].equals("-1")){
								returnCodeStr+=yearId.split(",")[yindex];
							}
						}else{
							if (("-2".equals(codeMemberValue)||Util.getIntValue(codeMemberValue,-1)>0)&&!yearId.equals("-1")){
								returnCodeStr+=Util.add0(Integer.parseInt(yearId),4);
							} 
						}
						yindex++;
					//5:月
					}else if(codeMemberType.equals("5") && concreteField.equals("5")){
						if(monthId.indexOf(",") > -1){
							if(!monthId.split(",")[mindex].equals("-1")){
								returnCodeStr+=monthId.split(",")[mindex];
							}
						}else{
							if (("-2".equals(codeMemberValue)||Util.getIntValue(codeMemberValue,-1)>0)&&!monthId.equals("-1")){
								returnCodeStr+=Util.add0(Integer.parseInt(monthId),2);
							} 
						}
						mindex++;
					//6:日
					}else if(codeMemberType.equals("5") && concreteField.equals("6")){
						if(dateId.indexOf(",") > -1){
							if(!dateId.split(",")[dindex].equals("-1")){
								returnCodeStr+=dateId.split(",")[dindex];
							}
						}else{
							if (("-2".equals(codeMemberValue)||Util.getIntValue(codeMemberValue,-1)>0)&&!dateId.equals("-1")){
								returnCodeStr+=Util.add0(Integer.parseInt(dateId),2);
							} 
						}
	
						dindex++;
					//8:流水号位数
					}else if(concreteField.equals("8")){
						int tempRecordId=recordId;
						int tempSequenceId=sequenceId;					
		
						if(tempRecordId>0){
							List reservedIdList=new ArrayList();
							StringBuffer reservedIdSb=new StringBuffer();
							reservedIdSb.append(" select reservedId  ")
							            .append("   from workflow_codeSeqReserved  ")
							            .append("  where codeSeqId=").append(tempRecordId)
							            .append("    and (hasDeleted is null or hasDeleted='0') ")
							            .append("  order by reservedId asc,id asc ")					            
							            ;
							RecordSet.executeSql(reservedIdSb.toString());
							while(RecordSet.next()){
								reservedIdList.add(Util.null2String(RecordSet.getString("reservedId")));
							}
							
							while(reservedIdList.indexOf(""+tempSequenceId)>-1){//跳过预留号
								tempSequenceId++;
							}
						}					
						
						if(Util.getIntValue(codeMemberValue)<=(""+tempSequenceId).length())
							returnCodeStr += tempSequenceId;
						else{
							for(int j=0;j<(Util.getIntValue(codeMemberValue)-(""+tempSequenceId).length());j++){
								returnCodeStr += "0";
							}
							returnCodeStr += tempSequenceId;
						}
						
						sequenceId=tempSequenceId;
						tempSequenceId++;
						
						if(tempRecordId>0){
							RecordSet.executeSql("update workflow_codeSeq set sequenceId="+tempSequenceId+" where id="+tempRecordId);
							recordId=tempRecordId;
						}
						
					}else if(concreteField.equals("9")){
						returnCodeStr+=codeMemberValue;
					}
				}
			}
			
			if (!fieldCode.equals("")){
				RecordSet.executeSql("update "+tablename+" set "+fieldName+"='"+returnCodeStr+"' where requestid="+requestId);
                RecordSet.executeSql("update workflow_requestbase set requestmark='"+returnCodeStr+"' where requestid="+requestId);
                //workflow_codeSeqReserved提到workflow_codeSeqRecord前插入数据，获取ID
                RecordSet.executeSql("insert into workflow_codeSeqReserved(codeSeqId,reservedId,reservedCode,reservedDesc,hasUsed,hasDeleted) values("+recordId+","+sequenceId+",'"+Util.toHtml100(returnCodeStr)+"','','1','0')");
                RecordSet.executeSql("SELECT ID FROM workflow_codeSeqReserved WHERE codeSeqId=" + recordId + " and reservedId=" + sequenceId + " and reservedCode='" + Util.toHtml100(returnCodeStr) + "'");
                String strCodeSeqReservedId = "-1";
                if(RecordSet.next()) {
                	strCodeSeqReservedId = RecordSet.getString("id");
                }
                RecordSet.executeSql("insert into workflow_codeSeqRecord(requestId,codeSeqId,sequenceId,codeSeqReservedId,workflowCode) " +
                		"values("+requestId+","+recordId+","+sequenceId+"," + strCodeSeqReservedId + ",'"+Util.toHtml100(returnCodeStr)+"')");

                
                
                String codeidsql="select id  from workflow_codeSeqReserved where codeSeqId="+recordId +" and reservedId = "+sequenceId +" and hasUsed = 1";
                RecordSet.executeSql(codeidsql);
                String coderemarkid = "";
                if (RecordSet.next()){
                	coderemarkid = Util.null2String(RecordSet.getInt("id"));
				}
                session.setAttribute(userid+"_"+requestId+"coderemarkid",coderemarkid);
                session.setAttribute(userid+"_"+requestId+"requestmark",returnCodeStr);
                
            }

}else if(operation.equals("chooseReservedCode")){
	
	int requestId = Util.getIntValue(request.getParameter("requestId"),0);

	int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
	int formId = Util.getIntValue(request.getParameter("formId"),0);
	String isBill = Util.null2String(request.getParameter("isBill"));
	String createrdepartmentid = Util.null2String(request.getParameter("createrdepartmentid"));

	CodeBuild cbuild = new CodeBuild(formId,isBill,workflowId);	
	CoderBean cb = cbuild.getFlowCBuild();
	String fieldCode=Util.null2String(cb.getCodeFieldId());
	
    String codeSeqReservedIdAndCode=Util.null2String(request.getParameter("codeSeqReservedIdAndCode"));
	int codeSeqReservedId=0;
	String reservedCode="";
	String[] codeSeqReservedIdAndCodeList=codeSeqReservedIdAndCode.split("~~wfcodecon~~");
	
	if(codeSeqReservedIdAndCodeList.length>=2){
		codeSeqReservedId=Util.getIntValue((String)codeSeqReservedIdAndCodeList[0],-1);
		reservedCode=Util.null2String((String)codeSeqReservedIdAndCodeList[1]);
	}

	String coderemarkid2 = Util.null2String((String) session.getAttribute(userid+"_"+requestId+"coderemarkid"));
	String stringremark = Util.null2String((String) session.getAttribute(userid+"_"+requestId+"requestmark"));

	if("".equals(coderemarkid2)){
		coderemarkid2 = "0";
	}
	if("".equals(stringremark)){
		stringremark = "0";
	}
	
	RecordSet.executeSql("update workflow_codeSeqReserved set hasUsed=0,hasDeleted=0 where id="+ Integer.parseInt(coderemarkid2));
	
	if(codeSeqReservedId>0){
		String coderemarkid1 = ""+codeSeqReservedId;
		returnCodeStr=reservedCode;
		if(!returnCodeStr.equals("")){
			//session.setAttribute(userid+"_"+requestId+"codeSeqId",recordId);
			session.setAttribute(userid+"_"+requestId+"coderemarkid",coderemarkid1);
			session.setAttribute(userid+"_"+requestId+"requestmark",returnCodeStr);

			String tablename="workflow_form";
			String fieldName="";
			
			if (!fieldCode.equals("")){
				String sql="select fieldName  from workflow_formdict where id="+fieldCode;
				if (isBill.equals("1")) {
					sql="select fieldName  from workflow_billfield where id="+fieldCode;
					RecordSet.executeSql("select tablename from workflow_bill where id = " + formId); // 查询工作流单据表的信息
					if (RecordSet.next()){
						tablename = Util.null2String(RecordSet.getString("tablename"));          // 获得单据的主表
					}
				}
			    RecordSet.executeSql(sql);
			    if (RecordSet.next()){ 
			    	fieldName=Util.null2String(RecordSet.getString(1));
			    }	
            }

			if (!fieldCode.equals("")){
				RecordSet.executeSql("update "+tablename+" set "+fieldName+"='"+returnCodeStr+"' where requestid="+requestId);
                RecordSet.executeSql("update workflow_requestbase set requestmark='"+returnCodeStr+"' where requestid="+requestId);
                
            }

		}
		
		
		int recordId=-1;
		int sequenceId=-1;
		RecordSet.executeSql("select codeSeqId,reservedId from workflow_codeSeqReserved where id="+codeSeqReservedId);
		if(RecordSet.next()){
			recordId=Util.getIntValue(RecordSet.getString("codeSeqId"),-1);
			sequenceId=Util.getIntValue(RecordSet.getString("reservedId"),-1);
		}

		//先将现有流程编号记入预留编号表
		int reservedId=-1;
		int codeSeqReservedIdHis=-1;
		RecordSet.executeSql("select sequenceId,codeSeqReservedId from workflow_codeSeqRecord where requestId="+requestId+" and codeSeqId="+recordId+" order by id desc");
		if(RecordSet.next()){
		    reservedId=Util.getIntValue(RecordSet.getString("sequenceId"),-1);
		    codeSeqReservedIdHis=Util.getIntValue(RecordSet.getString("codeSeqReservedId"),-1);
		}
		if(reservedId>=1){
			if(codeSeqReservedIdHis>=1){
				//RecordSet.executeSql("update workflow_codeSeqReserved set hasUsed='0',hasDeleted='0' where id="+codeSeqReservedIdHis);
			}else{
				List hisReservedIdList=new ArrayList();
			    StringBuffer hisReservedIdSb=new StringBuffer();
			    hisReservedIdSb.append(" select reservedId ")
		                       .append("   from workflow_codeSeqReserved ")
		                       .append("  where codeSeqId=").append(recordId)
		                       .append("    and (hasDeleted is null or hasDeleted='0') ")
		                       .append("  order by reservedId asc,id asc ")		               
		                       ;
			    RecordSet.executeSql(hisReservedIdSb.toString());
			    while(RecordSet.next()){
				    hisReservedIdList.add(Util.null2String(RecordSet.getString("reservedId")));
			    }
			    if(hisReservedIdList.indexOf(""+reservedId)==-1){
				    hisReservedIdList.add(""+reservedId);
				    //reservedCode=WorkflowCodeSeqReservedManager.getReservedCode(workflowId,formId,isBill,recordId,-1,reservedId,createrdepartmentid);
				    reservedCode=stringremark;
			        reservedCode=Util.toHtml100(reservedCode);
			        //RecordSet.executeSql("insert into workflow_codeSeqReserved(codeSeqId,reservedId,reservedCode,reservedDesc,hasUsed,hasDeleted) values("+recordId+","+reservedId+",'"+reservedCode+"','','0','0')");
			    }	
			}
		}

        //在将记录存放在当前编号表
		RecordSet.executeSql("update workflow_codeSeqReserved set hasUsed='1' where id="+codeSeqReservedId);


		if(recordId>=1&&sequenceId>=1){
			RecordSet.executeSql("insert into workflow_codeSeqRecord(requestId,codeSeqId,sequenceId,codeSeqReservedId,workflowCode) " +
                		      "values("+requestId+","+recordId+","+sequenceId+","+codeSeqReservedId+",'"+Util.toHtml100(returnCodeStr)+"')");
		}
	}
//手动变更编号(TD18867)
} else if(operation.equals("ChangeCode")){

	int requestId = Util.getIntValue(request.getParameter("requestId"),0);

	int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
	int formId = Util.getIntValue(request.getParameter("formId"),0);
	String isBill = Util.null2String(request.getParameter("isBill"));
	String createrdepartmentid = Util.null2String(request.getParameter("createrdepartmentid"));

	CodeBuild cbuild = new CodeBuild(formId,isBill,workflowId);	
	CoderBean cb = cbuild.getFlowCBuild();
	String fieldCode=Util.null2String(cb.getCodeFieldId());
	String workflowSeqAlone=cb.getWorkflowSeqAlone();
	Map valueOfField=cbuild.getValueOfFieldForCode(requestId,workflowId);
	ArrayList memberList = cb.getMemberList();

	int departmentFieldId=-1;
	int subCompanyFieldId=-1;
	int supSubCompanyFieldId=-1;

	for (int i=0;i<memberList.size();i++){
		String[] codeMembers = (String[])memberList.get(i);
		String codeMemberName = codeMembers[0];
		String codeMemberValue = codeMembers[1];
		if("22753".equals(codeMemberName)){
			supSubCompanyFieldId=Util.getIntValue(codeMemberValue,-1);
		}else if("141".equals(codeMemberName)){
			subCompanyFieldId=Util.getIntValue(codeMemberValue,-1);
		}else if("124".equals(codeMemberName)){
			departmentFieldId=Util.getIntValue(codeMemberValue,-1);
		}
	}

	String yearId = Util.null2String(request.getParameter("yearId"));
	String monthId = Util.null2String(request.getParameter("monthId"));
	String dateId = Util.null2String(request.getParameter("dateId"));
	String fieldId = Util.null2String(request.getParameter("fieldId"));
	String fieldValue = Util.null2String(request.getParameter("fieldValue"));
	String supSubCompanyId = Util.null2String(request.getParameter("supSubCompanyId"));
	String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
	String departmentId = Util.null2String(request.getParameter("departmentId"));

    WorkflowCodeSeqReservedManager.setYearIdDefault(yearId);
    WorkflowCodeSeqReservedManager.setMonthIdDefault(monthId);
    WorkflowCodeSeqReservedManager.setDateIdDefault(dateId);
    WorkflowCodeSeqReservedManager.setFieldIdDefault(fieldId);
    WorkflowCodeSeqReservedManager.setFieldValueDefault(fieldValue);
    WorkflowCodeSeqReservedManager.setSupSubCompanyIdDefault(supSubCompanyId);
    WorkflowCodeSeqReservedManager.setSubCompanyIdDefault(subCompanyId);
    WorkflowCodeSeqReservedManager.setDepartmentIdDefault(departmentId);

	int recordId = Util.getIntValue(request.getParameter("recordId"),0);
	int sequenceId=1;
	if(recordId<=0){
		int tempWorkflowId=-1;
		int tempFormId=-1;
		String tempIsBill="0";
		String tempYearId="-1";
		String tempMonthId="-1";
		String tempDateId="-1";
	
		String tempFieldId="-1";
		String tempFieldValue="-1";
	
		String tempSupSubCompanyId="-1";
		String tempSubCompanyId="-1";
		String tempDepartmentId="-1";
	
		int tempRecordId=-1;
		int tempSequenceId=1;
	
		String dateSeqAlone=cb.getDateSeqAlone();
		String dateSeqSelect=cb.getDateSeqSelect();
		String fieldSequenceAlone=cb.getFieldSequenceAlone();
		String struSeqAlone=cb.getStruSeqAlone();
		String struSeqSelect=cb.getStruSeqSelect();
	
		if("1".equals(workflowSeqAlone)){
			tempWorkflowId=workflowId;
		}else{
			tempFormId=formId;
		    tempIsBill=isBill;
		}
	
		if("1".equals(dateSeqAlone)&&"1".equals(dateSeqSelect)){
			tempYearId=yearId;
		}else if("1".equals(dateSeqAlone)&&"2".equals(dateSeqSelect)){
			tempYearId=yearId;
			tempMonthId=monthId;						
		}else if("1".equals(dateSeqAlone)&&"3".equals(dateSeqSelect)){
			tempYearId=yearId;						
			tempMonthId=monthId;	
			tempDateId=dateId;							
		}
					
		if("1".equals(fieldSequenceAlone)&&!fieldId.equals("-1") ){
			tempFieldId=fieldId;
			tempFieldValue=fieldValue;
			//tempFieldId=fieldId;
            //tempFieldValue=fieldValue;
            List<String> sltFieldIdList = Util.splitString2List(fieldId, ",");
            if (!"".equals(cb.getSelectCorrespondField()) && sltFieldIdList.size()>1) {
                int i0 = sltFieldIdList.indexOf(cb.getSelectCorrespondField());
                if (i0 != -1) {
                    List<String> tempFieldValueList = Util.splitString2List(tempFieldValue, ",");
                    tempFieldId =  cb.getSelectCorrespondField();
                    tempFieldValue = tempFieldValueList.get(i0);
                }
            }
		}
		
					
		if("1".equals(struSeqAlone)&&"1".equals(struSeqSelect)){
			//tempSupSubCompanyId=supSubCompanyId;
			tempSubCompanyId="-1";
			tempDepartmentId="-1";
			String strCorrespondField =  cb.getCorrespondField();
			if(!"-2".equals(strCorrespondField)){
				//tempSupSubCompanyId = strCorrespondField;
				tempSupSubCompanyId= String.valueOf(Util.getIntValue((String)valueOfField.get("field"+strCorrespondField),-1));
			}else{
				tempSupSubCompanyId=Util.null2String(SubCompanyComInfo.getSupsubcomid(""+DepartmentComInfo.getSubcompanyid1(""+createrdepartmentid)));	
				if(tempSupSubCompanyId.equals("")){
					tempSupSubCompanyId=DepartmentComInfo.getSubcompanyid1(""+createrdepartmentid);//若上级分部为空，则认为上级分部为分部
				}
			}
		}
		if("1".equals(struSeqAlone)&&"2".equals(struSeqSelect)){
			tempSupSubCompanyId="-1";
			//tempSubCompanyId=subCompanyId;
			tempDepartmentId="-1";
			String strCorrespondField =  cb.getCorrespondField();
			if(!"-2".equals(strCorrespondField)){
				//tempSubCompanyId = strCorrespondField;
				tempSubCompanyId= String.valueOf(Util.getIntValue((String)valueOfField.get("field"+strCorrespondField),-1));
			}else{
				tempSubCompanyId=DepartmentComInfo.getSubcompanyid1(""+createrdepartmentid);
			}
		}
		if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){
			tempSupSubCompanyId="-1";
			tempSubCompanyId="-1";
			//tempDepartmentId=departmentId;	
			String strCorrespondField =  cb.getCorrespondField();
			if(!"-2".equals(strCorrespondField)){
				//tempDepartmentId = strCorrespondField;
				tempDepartmentId= String.valueOf(Util.getIntValue((String)valueOfField.get("field"+strCorrespondField),-1));
			}else{
				tempDepartmentId = createrdepartmentid;
			}
		}

		String allversionwfid = "";
		if("1".equals(workflowSeqAlone)){
			allversionwfid = WorkflowVersion.getVersionStringByWfid(""+tempWorkflowId);
		}else{
			allversionwfid = ""+tempWorkflowId;
		}
		RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId in("+allversionwfid+") and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

		//if(RecordSet.next()){
		//	tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
		//	tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
		//}
		int ctempRecordId = -1;
		int ctempSequenceId = -1;
		while(RecordSet.next()){
			ctempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
			ctempSequenceId = Util.getIntValue(RecordSet.getString("sequenceId"),1);
			if(ctempSequenceId > tempSequenceId){
				tempSequenceId = ctempSequenceId;
			}
			if(ctempRecordId > tempRecordId){
				tempRecordId = ctempRecordId;
			}
		}

	    if(tempRecordId>0){
			recordId = tempRecordId;
			sequenceId = tempSequenceId;
		}else{
			RecordSet.executeSql("insert into workflow_codeSeq(yearId,sequenceId,formId,isBill,monthId,dateId,workflowId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId)" +
			" values("+tempYearId+","+tempSequenceId+","+tempFormId+",'"+tempIsBill+"',"+tempMonthId+","+tempDateId+","+tempWorkflowId+","+tempFieldId+","+tempFieldValue+","+tempSupSubCompanyId+","+tempSubCompanyId+","+tempDepartmentId+")");
			RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId in("+allversionwfid+") and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

			if(RecordSet.next()){
			    //tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
			    //tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);
			    
			    ctempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
				ctempSequenceId = Util.getIntValue(RecordSet.getString("sequenceId"),1);
				if(ctempSequenceId > tempSequenceId){
					tempSequenceId = ctempSequenceId;
				}
				if(ctempRecordId > tempRecordId){
					tempRecordId = ctempRecordId;
				}
			}
			if(tempRecordId>0){
			    recordId = tempRecordId;
			    sequenceId = tempSequenceId;
			}
		}
	}else{
		RecordSet.executeSql("select sequenceId from workflow_codeSeq where id="+recordId);

		if(RecordSet.next()){
			sequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
		}
	}

    //先将现有流程编号记入预留编号表
	int reservedId=-1;
	int codeSeqReservedId=-1;
	RecordSet.executeSql("select sequenceId,codeSeqReservedId from workflow_codeSeqRecord where requestId="+requestId+" and codeSeqId="+recordId+" order by id desc");
	if(RecordSet.next()){
		reservedId=Util.getIntValue(RecordSet.getString("sequenceId"),-1);
		codeSeqReservedId=Util.getIntValue(RecordSet.getString("codeSeqReservedId"),-1);
	}

	if(reservedId>=1){
		if(codeSeqReservedId>=1){
			RecordSet.executeSql("update workflow_codeSeqReserved set hasUsed='0',hasDeleted='0' where id="+codeSeqReservedId);
		}else{
		    List hisReservedIdList=new ArrayList();
		    StringBuffer hisReservedIdSb=new StringBuffer();
		    hisReservedIdSb.append(" select reservedId ")
		                   .append("   from workflow_codeSeqReserved ")
		                   .append("  where codeSeqId=").append(recordId)
		                   .append("    and (hasDeleted is null or hasDeleted='0') ")
		                   .append("  order by reservedId asc,id asc ")		               
		                   ;
		    RecordSet.executeSql(hisReservedIdSb.toString());
		    while(RecordSet.next()){
		    	hisReservedIdList.add(Util.null2String(RecordSet.getString("reservedId")));
		    }
		    if(hisReservedIdList.indexOf(""+reservedId)==-1){
		    	hisReservedIdList.add(""+reservedId);
		    	String  reservedCode=WorkflowCodeSeqReservedManager.getReservedCode(workflowId,formId,isBill,recordId,-1,reservedId,createrdepartmentid);
		    	reservedCode=Util.toHtml100(reservedCode);
		    	RecordSet.executeSql("insert into workflow_codeSeqReserved(codeSeqId,reservedId,reservedCode,reservedDesc,hasUsed,hasDeleted) values("+recordId+","+reservedId+",'"+reservedCode+"','','0','0')");
		    }
		}
	}

	//修改前后的编号是否在预留号中,存在则更新
	String oldCodeStr = Util.null2String(request.getParameter("oldCodeStr"));
	RecordSet.executeSql("update workflow_codeSeqReserved set hasUsed='0' where id in (select id from workflow_codeSeqReserved where codeSeqId= " + recordId + " and hasUsed='1' and (hasDeleted is null or hasDeleted='0') and reservedcode ='" + oldCodeStr + "')");
	returnCodeStr = Util.null2String(request.getParameter("returnCodeStr"));
	returnCodeStr = weaver.general.Escape.unescape(returnCodeStr);
	RecordSet.executeSql("update workflow_codeSeqReserved set hasUsed='1' where id in (select id from workflow_codeSeqReserved where codeSeqId= " + recordId + " and (hasUsed is null or hasUsed='0') and (hasDeleted is null or hasDeleted='0') and reservedcode ='" + returnCodeStr + "')");

	String tablename="workflow_form";
	String fieldName="";
	
	if (!fieldCode.equals("")){
		String sql="select fieldName  from workflow_formdict where id="+fieldCode;
		if (isBill.equals("1")) {
			sql="select fieldName  from workflow_billfield where id="+fieldCode;
			RecordSet.executeSql("select tablename from workflow_bill where id = " + formId); // 查询工作流单据表的信息
			if (RecordSet.next()){
				tablename = Util.null2String(RecordSet.getString("tablename"));          // 获得单据的主表
			}
		}
	    RecordSet.executeSql(sql);
	    if (RecordSet.next()){ 
	    	fieldName=Util.null2String(RecordSet.getString(1));
	    }	
    }

	if (!fieldCode.equals("")){
		RecordSet.executeSql("update "+tablename+" set "+fieldName+"='"+returnCodeStr+"' where requestid="+requestId);
        RecordSet.executeSql("update workflow_requestbase set requestmark='"+returnCodeStr+"' where requestid="+requestId);
        
        RecordSet.executeSql("insert into workflow_codeSeqRecord(requestId,codeSeqId,sequenceId,codeSeqReservedId,workflowCode) " +
        		"values("+requestId+","+recordId+","+sequenceId+",-1,'"+Util.toHtml100(returnCodeStr)+"')");
	    session.setAttribute(userid+"_"+requestId+"requestmark",returnCodeStr);
        
    }
}

%>
<script language="javascript">

<%if(operation.equals("CreateCodeAgain") || operation.equals("ChangeCode")){%>

window.parent.onCreateCodeAgainReturn("<%=returnCodeStr%>","<%=ismand%>");

<%}else if(operation.equals("chooseReservedCode")){%>

window.parent.onCreateCodeAgainReturn("<%=returnCodeStr%>","<%=ismand%>");

<%}%>
</script>