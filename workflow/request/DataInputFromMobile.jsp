
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%-- 本页面专用于Mobile版的字段联动 --%>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Hashtable" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.workflow.WorkflowComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsObj" class="weaver.conn.RecordSet" scope="page" />
<%
String workflowId = request.getParameter("id");
String strTrgFieldNames = request.getParameter("trg");
String nodenumstr = request.getParameter("nodenumstr");
WorkflowComInfo wfComInfo = new WorkflowComInfo();
String fformid = wfComInfo.getFormId(workflowId);
String isbill = wfComInfo.getIsBill(workflowId);
String nodeid = request.getParameter("node");

//获取当前节点所有可见字段的类型信息。
Map<String, String[]> mapFieldInfos = DynamicDataInput.getFieldInfos(workflowId, nodeid, isbill);
//用于设值的字段(字段id号 字段值)列表
List lstValues = new ArrayList();
//用于设置前端显示的(浏览按钮)字段(字段id号 字段值)列表
List lstDisplays = new ArrayList();
List lstGroupIds = new ArrayList();
List lstDetailDisplays = new ArrayList();
List lstDetailValues = new ArrayList();

ArrayList arrTrgFieldNames = Util.TokenizerString(strTrgFieldNames, ",");
Map<String,String> gropIdMap = new HashMap<String,String>();
Map<String,String> dsiplayGropIdMap = new HashMap<String,String>();
for(int temp=0; temp<arrTrgFieldNames.size(); temp++){
	String trgFieldName = Util.null2String((String)arrTrgFieldNames.get(temp));
	String suffixField = "";
	if(trgFieldName.indexOf("_")>=0){
		String[] trgFieldNames = trgFieldName.split("_");
		trgFieldName = trgFieldNames[0];
        if(trgFieldNames.length==3){
        	suffixField = "_"+trgFieldNames[1]+"_"+trgFieldNames[2];
        }else if(trgFieldNames.length==2){
        	suffixField = "_"+trgFieldNames[1];
        }
	}
	if(trgFieldName != null && !trgFieldName.trim().equals("") ){
		DynamicDataInput DDI = new DynamicDataInput(workflowId,trgFieldName,isbill);

		//查询将当前字段作为取值参数的所有联动信息
		String sql="select id from Workflow_DataInput_entry where WorkFlowID=? and TriggerFieldName=? ";
		rs.executeQuery(sql,workflowId,trgFieldName);
		String entryid = "";
		String datainputid = "";
		Hashtable outdatahash = new Hashtable();
		Hashtable detailoutdatahash = new Hashtable();
		while(rs.next()){
			entryid = rs.getString("id");
			rsObj.executeSql("select id,IsCycle,WhereClause from Workflow_DataInput_main where entryID="+entryid+" order by orderid");

			ArrayList outdatasList=new ArrayList();
			ArrayList outfieldnamelist=new ArrayList();
			ArrayList detailoutdatasList=new ArrayList();
			ArrayList detailoutfieldnamelist=new ArrayList();
			 ArrayList groupids = null ;
			while(rsObj.next()){
				datainputid = rsObj.getString("id");
				
				groupids = DDI.GetOutFieldIndex(datainputid);//查询出明细个数
				//获取联动信息中的 所有取值字段名称 及 取值字段值。
				ArrayList infieldnamelist = DDI.GetInFieldName(datainputid);
				for(int i=0;i<infieldnamelist.size();i++){
					String paramName = datainputid+"|"+(String)infieldnamelist.get(i)+suffixField;
					String inputFieldValue = Util.null2String(request.getParameter(paramName));
					if(!"".equals(suffixField)&&"".equals(inputFieldValue)){
                          inputFieldValue = Util.null2String(request.getParameter(paramName+"_d"));      
					}
					//记录日志信息
					//System.out.println("The 'paramName' value:\t" + paramName);
					//System.out.println("The 'inputFieldValue' value:\t" + inputFieldValue);
					DDI.SetInFields((String)infieldnamelist.get(i),inputFieldValue);
				}
				//获取联动信息中的 所有条件字段名称 及 条件字段值。
				ArrayList conditionfieldnameList = DDI.GetConditionFieldName(datainputid);
				for(int j=0;j<conditionfieldnameList.size();j++){
					DDI.SetConditonFields((String)conditionfieldnameList.get(j),Util.null2String(request.getParameter(datainputid+"|"+(String)conditionfieldnameList.get(j)+suffixField)));
				}
		        DDI.GetOutData(datainputid);
		        outfieldnamelist = DDI.GetOutFieldNameList();
		        outdatasList = DDI.GetOutDataList();
		        
		      	//赋值字段为主表字段的更新
				if(DDI.GetIsCycle().equals("1")){
					//当赋值字段为主表字段时， outdatasList仅包含一个元素。
				 	for(int i=0;i<outdatasList.size();i++){
				 		outdatahash = (Hashtable)outdatasList.get(i);
				 		
				 		List tempObj = new ArrayList();
				 		//对赋值字段进行循环。
				 		for(int j=0; j<outfieldnamelist.size(); j++){
				 			String fieldName = (String)outfieldnamelist.get(j);
				 		    String fieldValue = (String)outdatahash.get(fieldName);
				 		   	fieldValue = Util.toExcelData(fieldValue);
				 		   	
				 		   	//判断当前字段是否支持编辑
				 		   	String[] fieldType = DynamicDataInput.getFieldType(fieldName, mapFieldInfos);
				 		   	if(fieldType != null){
				 		   		Map fieldObj = DynamicDataInput.getChangeFieldMobile(fieldName+suffixField, fieldValue, fieldType);
						 		tempObj.add(fieldObj);
				 		   	}
				 		}
				 		lstValues.add(tempObj);
	       			}
					
					//获取此次取值所需要设置前端值的列表
					List tempObj = DynamicDataInput.getBrowserButtonValue(outfieldnamelist, outdatasList, mapFieldInfos,isbill);
					if(tempObj != null){
						if(!"".equals(suffixField)){
							for(int i=0;i<tempObj.size();i++){
								Map map=(Map)tempObj.get(i);
								map.put("fieldId",map.get("fieldId")+suffixField);
							}
						}
						lstDisplays.add(tempObj);
										}
					try{
						if("".equals(suffixField)){
							for(int dtidx = 0 ; dtidx < groupids.size() ; dtidx++){
					   			Map mopObj = new HashMap();
								int tmpgroupid = Util.getIntValue(groupids.get(dtidx).toString(),1) ;
				      			int groupid = getNewGroupid(Util.getIntValue(fformid,0),tmpgroupid);
				      			int jsgroupid = groupid -1 ;
				      			detailoutfieldnamelist = DDI.GetOutFieldNameListWithIndex(datainputid,tmpgroupid+"") ;
				      			detailoutdatasList = DDI.GetOutDataWithIndex(datainputid,tmpgroupid+"");
				      			int addRowCount=detailoutdatasList.size();
				      			int defaultsum = 0;
				      		    if(!"".equals(nodenumstr)){
				      		    	String[] nodenumArray=Util.splitString(nodenumstr,",");
				      		    	for(int detnodei=0;detnodei<nodenumArray.length;detnodei++){
				      		    		if(jsgroupid == Util.getIntValue(Util.splitString(nodenumArray[detnodei],"-")[0],-1)){
				      		    			defaultsum =Util.getIntValue(Util.splitString(nodenumArray[detnodei],"-")[1],0);
				      		    			break;
				      		    		}
				      		    	}
				      		    }
								if(gropIdMap.get((jsgroupid+""))!=null&&!"".equals(Util.null2String(gropIdMap.get((jsgroupid+""))))){
								       defaultsum = Util.getIntValue(gropIdMap.get((jsgroupid+"")));
								}
				      			for(int dtirow=0;dtirow<addRowCount;dtirow++){
				      				int detailsum =defaultsum+ dtirow;
				      				detailoutdatahash = (Hashtable)detailoutdatasList.get(dtirow);
				      				List detailtempObj = new ArrayList();
							 		//对赋值字段进行循环。
							 		for(int j=0; j<detailoutfieldnamelist.size(); j++){
							 			String fieldName = (String)detailoutfieldnamelist.get(j);
							 		    String fieldValue = (String)detailoutdatahash.get(fieldName);
							 		   	fieldValue = Util.toExcelData(fieldValue);
							 		   	
							 		   	//判断当前字段是否支持编辑
							 		   	String[] fieldType = DynamicDataInput.getFieldType(fieldName, mapFieldInfos);
							 		   	if(fieldType != null){
							 		   		Map fieldObj = DynamicDataInput.getChangeFieldMobile(fieldName+"_"+detailsum+"", fieldValue, fieldType);
							 		   	    detailtempObj.add(fieldObj);
							 		   	}
							 		}
							 		lstDetailValues.add(detailtempObj);
				      			}
							    if(gropIdMap.get((jsgroupid+""))==null||"".equals(Util.null2String(gropIdMap.get((jsgroupid+""))))){
                                          gropIdMap.put(""+jsgroupid,addRowCount+"");
								}
				      			
				      			List detailDtempObj = DynamicDataInput.getBrowserButtonValue(detailoutfieldnamelist, detailoutdatasList, mapFieldInfos,isbill,nodenumstr,jsgroupid,dsiplayGropIdMap);
								if(detailDtempObj != null){
										for(int i=0;i<detailDtempObj.size();i++){
											Map map=(Map)detailDtempObj.get(i);
											map.put("fieldId",map.get("fieldId")+suffixField);
										}
									lstDetailDisplays.add(detailDtempObj);
								}
								
								mopObj.put("values",lstDetailValues);
								mopObj.put("displays", lstDetailDisplays);
				      			mopObj.put("groupid",jsgroupid);
				      			mopObj.put("rowcount",addRowCount);
				      			lstGroupIds.add(mopObj);
							}
						}
					}catch(Exception e){
					}
		       	} 
			}
		}
	}
}

//必填字段的状态修改。
String[] arrInputChecks = DynamicDataInput.getIsMandatoryField(workflowId, nodeid, isbill);
//赋值字段的列表，赋值之前先清空字段值。
List<String> arrayList=new ArrayList<String>();
for(int temp=0; temp<arrTrgFieldNames.size(); temp++){
	String suffixField = "";
	String trgFieldName = Util.null2String((String)arrTrgFieldNames.get(temp));
	if(trgFieldName.indexOf("_")>=0){
		String[] trgFieldNames = trgFieldName.split("_");
		trgFieldName = trgFieldNames[0];
        if(trgFieldNames.length==3){
        	suffixField = "_"+trgFieldNames[1]+"_"+trgFieldNames[2];
        }else if(trgFieldNames.length==2){
        	suffixField = "_"+trgFieldNames[1];
        }
	}
	String[] arrOutputFields = DynamicDataInput.getTriggerOutputFieldName(workflowId, trgFieldName, mapFieldInfos);
	for(int k=0;k<arrOutputFields.length;k++){
		if(!"".equals(suffixField)){
			String arroutputfield = arrOutputFields[k];
			if(arroutputfield.indexOf("_span")>=0){
				if(!trgFieldName.equals(arroutputfield.replace("_span",""))){
				  arroutputfield = arroutputfield.replace("_span","")+suffixField+"_span";
				  arrayList.add(arroutputfield);
				}
			}else{
				if(!trgFieldName.equals(arroutputfield)){
					arroutputfield = arroutputfield+suffixField;
					arrayList.add(arroutputfield);
				}
			}
		}else{
			String arroutputfield = arrOutputFields[k];
			if(arroutputfield.indexOf("_span")>=0){
				if(!trgFieldName.equals(arroutputfield.replace("_span",""))){
				  arroutputfield = arroutputfield.replace("_span","")+suffixField+"_span";
				  arrayList.add(arroutputfield);
				}
			}else{
				if(!trgFieldName.equals(arroutputfield)){
					arroutputfield = arroutputfield+suffixField;
					arrayList.add(arroutputfield);
				}
			}
		}
	}
}
String[] arrOutputFields = (String[])arrayList.toArray(new String[arrayList.size()]);
Map mapResult = new HashMap();
mapResult.put("groupids",lstGroupIds);
mapResult.put("values",lstValues);
mapResult.put("mandField",arrInputChecks);
mapResult.put("displays", lstDisplays);
mapResult.put("clearField", arrOutputFields);

JSONObject jsonObj = JSONObject.fromObject(mapResult);
String strResult = jsonObj.toString();
out.println(strResult);
%>
<%!

public int getNewGroupid(int billid,int groupid){
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	int newgroupid = 0 ;
	String sql = "";
	if(rs.getDBType().equals("oracle")){
		sql = " SELECT t.rid FROM (select rownum as rid,orderid from (SELECT tablename, orderid FROM Workflow_billdetailtable  WHERE billid = ? order by id) t1) t WHERE t.orderid=?" ;
	}else{
		sql = "SELECT t.rowid FROM (SELECT ROW_NUMBER() OVER (ORDER BY ORDERid) AS rowid ,tablename,orderid FROM Workflow_billdetailtable WHERE billid=? ) t WHERE t.orderid=?" ;
	}
	rs.executeQuery(sql,billid+"",groupid+"");
	if(rs.next()){
		newgroupid = rs.getInt(1);
	}else{
		newgroupid = groupid ;
	}

	return newgroupid ;
}
%>