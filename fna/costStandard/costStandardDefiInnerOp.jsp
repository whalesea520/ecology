<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="weaver.fna.costStandard.CostStandard"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.encrypt.Des"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.util.Calendar"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_FnaCostStandard" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

if(!HrmUserVarify.checkUserRight("CostStandardSetting:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
		Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
		Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
		Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
		Util.add0(today.get(Calendar.SECOND), 2);

String operation = Util.null2String(request.getParameter("operation"));

if(operation.equals("doSave")){//保存
	String sql = "select * \n" +
			" from FnaCostStandard a \n" +
			" where a.enabled = 1 \n" +
			" order by a.orderNumber, a.name ";
	rs_FnaCostStandard.executeQuery(sql);
	
	//先处理新增行
	int rowindex112233 = Util.getIntValue(request.getParameter("rowindex112233"));
	if(rowindex112233 >= 0){

		StringBuffer insert_batchSql_FnaCostStandardDefi = new StringBuffer();
		List<String> insert_batchSql_FnaCostStandardDefi_list = new ArrayList<String>();
		int insert_batchSql_FnaCostStandardDefi_cnt = 0;

		StringBuffer insert_batchSql_FnaCostStandardDefiDtl = new StringBuffer();
		List<String> insert_batchSql_FnaCostStandardDefiDtl_list = new ArrayList<String>();
		int insert_batchSql_FnaCostStandardDefiDtl_cnt = 0;
		
		for(int i=0;i<=rowindex112233;i++){
			String fnew_fcsdName = Util.null2String(request.getParameter("fnew_fcsdName_"+i)).trim();//费用标准名称
			if(!"".equals(fnew_fcsdName)){
				String fcsdGuid1 = FnaCommon.getPrimaryKeyGuid1();
				
				String fnew_csAmount = Util.null2String(request.getParameter("fnew_csAmount_"+i));//费用标准

				
            	if(insert_batchSql_FnaCostStandardDefi_cnt > 5000){
            		insert_batchSql_FnaCostStandardDefi_list.add(insert_batchSql_FnaCostStandardDefi.toString());
            		insert_batchSql_FnaCostStandardDefi_cnt = 0;
            		insert_batchSql_FnaCostStandardDefi = new StringBuffer();
            	}
            	insert_batchSql_FnaCostStandardDefi_cnt++;
            	
				if(insert_batchSql_FnaCostStandardDefi.length() > 0){
					insert_batchSql_FnaCostStandardDefi.append("\n union all \n");
				}
				insert_batchSql_FnaCostStandardDefi.append(" select ");
				insert_batchSql_FnaCostStandardDefi.append("'"+StringEscapeUtils.escapeSql(fcsdGuid1)+"', ");
				insert_batchSql_FnaCostStandardDefi.append("'"+StringEscapeUtils.escapeSql(fnew_fcsdName)+"', ");
				insert_batchSql_FnaCostStandardDefi.append("'"+StringEscapeUtils.escapeSql(fnew_csAmount)+"', ");
				insert_batchSql_FnaCostStandardDefi.append("0 ");
				if("oracle".equals(rs.getDBType())){
					insert_batchSql_FnaCostStandardDefi.append(" from dual ");
				}
				
				rs_FnaCostStandard.beforFirst();
				while(rs_FnaCostStandard.next()){
					String fcsGuid1 = Util.null2String(rs_FnaCostStandard.getString("guid1"));
					String name = Util.null2String(rs_FnaCostStandard.getString("name"));
					int paramtype = Util.getIntValue(rs_FnaCostStandard.getString("paramtype"), -1);
					int browsertype = Util.getIntValue(rs_FnaCostStandard.getString("browsertype"), -1);
					int compareoption1 = Util.getIntValue(rs_FnaCostStandard.getString("compareoption1"), -1);
	
					String valChar = Util.null2String(request.getParameter("fnew_"+fcsGuid1+"_"+i)).trim();
					
					if("".equals(valChar)){
						valChar = "NULL";
					}else{
						valChar = "'"+StringEscapeUtils.escapeSql(valChar)+"'";
					}
	
					String guid1 = FnaCommon.getPrimaryKeyGuid1();
	
					
	            	if(insert_batchSql_FnaCostStandardDefiDtl_cnt > 5000){
	            		insert_batchSql_FnaCostStandardDefiDtl_list.add(insert_batchSql_FnaCostStandardDefiDtl.toString());
	            		insert_batchSql_FnaCostStandardDefiDtl_cnt = 0;
	            		insert_batchSql_FnaCostStandardDefiDtl = new StringBuffer();
	            	}
	            	insert_batchSql_FnaCostStandardDefiDtl_cnt++;
	            	
					if(insert_batchSql_FnaCostStandardDefiDtl.length() > 0){
						insert_batchSql_FnaCostStandardDefiDtl.append("\n union all \n");
					}
					insert_batchSql_FnaCostStandardDefiDtl.append(" select ");
					insert_batchSql_FnaCostStandardDefiDtl.append("'"+StringEscapeUtils.escapeSql(guid1)+"', ");
					insert_batchSql_FnaCostStandardDefiDtl.append("'"+StringEscapeUtils.escapeSql(fcsGuid1)+"', ");
					insert_batchSql_FnaCostStandardDefiDtl.append("'"+StringEscapeUtils.escapeSql(fcsdGuid1)+"', ");
					insert_batchSql_FnaCostStandardDefiDtl.append(valChar);
					if("oracle".equals(rs.getDBType())){
						insert_batchSql_FnaCostStandardDefiDtl.append(" from dual ");
					}
				}
			}
		}
		
		if(insert_batchSql_FnaCostStandardDefi.length() > 0){
    		insert_batchSql_FnaCostStandardDefi_list.add(insert_batchSql_FnaCostStandardDefi.toString());
		}
		int insert_batchSql_FnaCostStandardDefi_list_len = insert_batchSql_FnaCostStandardDefi_list.size();
        if(insert_batchSql_FnaCostStandardDefi_list_len > 0){
			for (int j = 0; j < insert_batchSql_FnaCostStandardDefi_list_len; j++) {
	        	String executeSql = "insert into FnaCostStandardDefi(guid1, fcsdName, csAmount, orderNumber) \n"+
	        			insert_batchSql_FnaCostStandardDefi_list.get(j);
				rs.executeUpdate(executeSql);
			}
        }
		
		if(insert_batchSql_FnaCostStandardDefiDtl.length() > 0){
    		insert_batchSql_FnaCostStandardDefiDtl_list.add(insert_batchSql_FnaCostStandardDefiDtl.toString());
		}
		int insert_batchSql_FnaCostStandardDefiDtl_list_len = insert_batchSql_FnaCostStandardDefiDtl_list.size();
        if(insert_batchSql_FnaCostStandardDefiDtl_list_len > 0){
			for (int j = 0; j < insert_batchSql_FnaCostStandardDefiDtl_list_len; j++) {
	        	String executeSql = "insert into FnaCostStandardDefiDtl(guid1, fcsGuid1, fcsdGuid1, valChar) \n"+
	        			insert_batchSql_FnaCostStandardDefiDtl_list.get(j);
				rs.executeUpdate(executeSql);
			}
        }
	}
	
	

	//再处理更新行
	String[] fold_fcsdGuid1s_array = request.getParameterValues("fold_fcsdGuid1s_array");
	if(fold_fcsdGuid1s_array!=null){
		
		HashMap<String, HashMap<String, String>> fnaCostStandardDefiDtl_hm = new HashMap<String, HashMap<String, String>>();
		rs.executeQuery("select * from FnaCostStandardDefiDtl a");
		while(rs.next()){
			String guid1 = Util.null2String(rs.getString("guid1")).trim();
			String fcsGuid1 = Util.null2String(rs.getString("fcsGuid1")).trim();
			String fcsdGuid1 = Util.null2String(rs.getString("fcsdGuid1")).trim();
			String valChar = Util.null2String(rs.getString("valChar")).trim();
			
			String key = fcsGuid1+"_"+fcsdGuid1;
			
			HashMap<String, String> hm = new HashMap<String, String>();
			fnaCostStandardDefiDtl_hm.put(key, hm);

			hm.put("guid1", guid1);
			hm.put("fcsGuid1", fcsGuid1);
			hm.put("fcsdGuid1", fcsdGuid1);
			hm.put("valChar", valChar);
		}
		
		
		
		List<String> del_guid1_list = new ArrayList<String>();
		List<String> del_guid2_list = new ArrayList<String>();


		StringBuffer insert_batchSql_FnaCostStandardDefi = new StringBuffer();
		List<String> insert_batchSql_FnaCostStandardDefi_list = new ArrayList<String>();
		int insert_batchSql_FnaCostStandardDefi_cnt = 0;

		StringBuffer insert_batchSql_FnaCostStandardDefiDtl = new StringBuffer();
		List<String> insert_batchSql_FnaCostStandardDefiDtl_list = new ArrayList<String>();
		int insert_batchSql_FnaCostStandardDefiDtl_cnt = 0;

		
		int fold_fcsdGuid1s_arrayLen = fold_fcsdGuid1s_array.length;
		for(int i=0;i<fold_fcsdGuid1s_arrayLen;i++){
			String fcsdGuid1 = fold_fcsdGuid1s_array[i];
			
			String fnew_fcsdName = Util.null2String(request.getParameter("fold_fcsdName_"+fcsdGuid1)).trim();//费用标准名称
			String fnew_csAmount = Util.null2String(request.getParameter("fold_csAmount_"+fcsdGuid1));//费用标准


			
        	if(insert_batchSql_FnaCostStandardDefi_cnt > 5000){
        		insert_batchSql_FnaCostStandardDefi_list.add(insert_batchSql_FnaCostStandardDefi.toString());
        		insert_batchSql_FnaCostStandardDefi_cnt = 0;
        		insert_batchSql_FnaCostStandardDefi = new StringBuffer();
        	}
        	insert_batchSql_FnaCostStandardDefi_cnt++;
        	
			if(insert_batchSql_FnaCostStandardDefi.length() > 0){
				insert_batchSql_FnaCostStandardDefi.append("\n union all \n");
			}
			insert_batchSql_FnaCostStandardDefi.append(" select ");
			insert_batchSql_FnaCostStandardDefi.append("'"+StringEscapeUtils.escapeSql(fcsdGuid1)+"', ");
			insert_batchSql_FnaCostStandardDefi.append("'"+StringEscapeUtils.escapeSql(fnew_fcsdName)+"', ");
			insert_batchSql_FnaCostStandardDefi.append("'"+StringEscapeUtils.escapeSql(fnew_csAmount)+"', ");
			insert_batchSql_FnaCostStandardDefi.append("0 ");
			if("oracle".equals(rs.getDBType())){
				insert_batchSql_FnaCostStandardDefi.append(" from dual ");
			}
			
			del_guid1_list.add("'"+StringEscapeUtils.escapeSql(fcsdGuid1)+"'");
			
			
			rs_FnaCostStandard.beforFirst();
			while(rs_FnaCostStandard.next()){
				String fcsGuid1 = Util.null2String(rs_FnaCostStandard.getString("guid1"));
				String name = Util.null2String(rs_FnaCostStandard.getString("name"));
				int paramtype = Util.getIntValue(rs_FnaCostStandard.getString("paramtype"), -1);
				int browsertype = Util.getIntValue(rs_FnaCostStandard.getString("browsertype"), -1);
				int compareoption1 = Util.getIntValue(rs_FnaCostStandard.getString("compareoption1"), -1);

				String valChar = Util.null2String(request.getParameter("fold_"+fcsGuid1+"_"+fcsdGuid1)).trim();
				
				if("".equals(valChar)){
					valChar = "NULL";
				}else{
					valChar = "'"+StringEscapeUtils.escapeSql(valChar)+"'";
				}
				
				String key = fcsGuid1+"_"+fcsdGuid1;

				String guid1 = "";
				if(fnaCostStandardDefiDtl_hm.containsKey(key)){
					guid1 = fnaCostStandardDefiDtl_hm.get(key).get("guid1");
					del_guid2_list.add("'"+StringEscapeUtils.escapeSql(guid1)+"'");
				}else{
					guid1 = FnaCommon.getPrimaryKeyGuid1();
				}

				
				
            	if(insert_batchSql_FnaCostStandardDefiDtl_cnt > 5000){
            		insert_batchSql_FnaCostStandardDefiDtl_list.add(insert_batchSql_FnaCostStandardDefiDtl.toString());
            		insert_batchSql_FnaCostStandardDefiDtl_cnt = 0;
            		insert_batchSql_FnaCostStandardDefiDtl = new StringBuffer();
            	}
            	insert_batchSql_FnaCostStandardDefiDtl_cnt++;
            	
				if(insert_batchSql_FnaCostStandardDefiDtl.length() > 0){
					insert_batchSql_FnaCostStandardDefiDtl.append("\n union all \n");
				}
				insert_batchSql_FnaCostStandardDefiDtl.append(" select ");
				insert_batchSql_FnaCostStandardDefiDtl.append("'"+StringEscapeUtils.escapeSql(guid1)+"', ");
				insert_batchSql_FnaCostStandardDefiDtl.append("'"+StringEscapeUtils.escapeSql(fcsGuid1)+"', ");
				insert_batchSql_FnaCostStandardDefiDtl.append("'"+StringEscapeUtils.escapeSql(fcsdGuid1)+"', ");
				insert_batchSql_FnaCostStandardDefiDtl.append(valChar);
				if("oracle".equals(rs.getDBType())){
					insert_batchSql_FnaCostStandardDefiDtl.append(" from dual ");
				}
			}
		}
		
		
		List<String> del_guid1_list_condList = FnaCommon.initData1(del_guid1_list);
		int del_guid1_list_condList_len = del_guid1_list_condList.size();
		for(int i=0;i<del_guid1_list_condList_len;i++){
			rs.executeUpdate("delete from FnaCostStandardDefi where guid1 in ("+del_guid1_list_condList.get(i)+")");
		}
		
		
		List<String> del_guid2_list_condList = FnaCommon.initData1(del_guid2_list);
		int del_guid2_list_condList_len = del_guid2_list_condList.size();
		for(int i=0;i<del_guid2_list_condList_len;i++){
			rs.executeUpdate("delete from FnaCostStandardDefiDtl where guid1 in ("+del_guid2_list_condList.get(i)+")");
		}
		
		
		if(insert_batchSql_FnaCostStandardDefi.length() > 0){
    		insert_batchSql_FnaCostStandardDefi_list.add(insert_batchSql_FnaCostStandardDefi.toString());
		}
		int insert_batchSql_FnaCostStandardDefi_list_len = insert_batchSql_FnaCostStandardDefi_list.size();
        if(insert_batchSql_FnaCostStandardDefi_list_len > 0){
			for (int j = 0; j < insert_batchSql_FnaCostStandardDefi_list_len; j++) {
	        	String executeSql = "insert into FnaCostStandardDefi(guid1, fcsdName, csAmount, orderNumber) \n"+
	        			insert_batchSql_FnaCostStandardDefi_list.get(j);
				rs.executeUpdate(executeSql);
			}
        }
		
		if(insert_batchSql_FnaCostStandardDefiDtl.length() > 0){
    		insert_batchSql_FnaCostStandardDefiDtl_list.add(insert_batchSql_FnaCostStandardDefiDtl.toString());
		}
		int insert_batchSql_FnaCostStandardDefiDtl_list_len = insert_batchSql_FnaCostStandardDefiDtl_list.size();
        if(insert_batchSql_FnaCostStandardDefiDtl_list_len > 0){
			for (int j = 0; j < insert_batchSql_FnaCostStandardDefiDtl_list_len; j++) {
	        	String executeSql = "insert into FnaCostStandardDefiDtl(guid1, fcsGuid1, fcsdGuid1, valChar) \n"+
	        			insert_batchSql_FnaCostStandardDefiDtl_list.get(j);
				rs.executeUpdate(executeSql);
			}
        }
		
	}

	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
	out.flush();
	return;
	
}else if(operation.equals("doCopy")){
	String sql = "select * \n" +
			" from FnaCostStandard a \n" +
			" where a.enabled = 1 \n" +
			" order by a.orderNumber, a.name ";
	rs_FnaCostStandard.executeSql(sql);
	
	CostStandard costStandard = new CostStandard();
	StringBuilder extDataRecordArray = new StringBuilder("[");
	
	int _idx1 = 0;
	
	String[] fold_fcsdGuid1s_copyArray = request.getParameterValues("fold_fcsdGuid1s_copyArray");
	if(fold_fcsdGuid1s_copyArray!=null){
		int fold_fcsdGuid1s_copyArrayLen = fold_fcsdGuid1s_copyArray.length;
		for(int i=0;i<fold_fcsdGuid1s_copyArrayLen;i++){
			String fcsdGuid1_copy = fold_fcsdGuid1s_copyArray[i];

			StringBuffer extDataRecord = new StringBuffer("{");


			String fcsdName = Util.null2String(request.getParameter("fold_fcsdName_"+fcsdGuid1_copy)).trim();//费用标准名称
			String csAmount = Util.null2String(request.getParameter("fold_csAmount_"+fcsdGuid1_copy));//费用标准
			extDataRecord.append("\"fcsdName\":"+JSONObject.quote(costStandard.getEdit(fcsdName, "fnew_fcsdName"+"+"+"0+-1+ +#rowindex112233#+"+user.getLanguage()))+",");
			extDataRecord.append("\"csAmount\":"+JSONObject.quote(costStandard.getEdit(csAmount, "fnew_csAmount"+"+"+"2+-1+ +#rowindex112233#+"+user.getLanguage()))+",");

			int idx = -1;
			rs_FnaCostStandard.beforFirst();
			while(rs_FnaCostStandard.next()){
				idx++;
				
				String fcsGuid1 = Util.null2String(rs_FnaCostStandard.getString("guid1"));
				String name = Util.null2String(rs_FnaCostStandard.getString("name"));
				int paramtype = Util.getIntValue(rs_FnaCostStandard.getString("paramtype"), -1);
				int browsertype = Util.getIntValue(rs_FnaCostStandard.getString("browsertype"), -1);
				int compareoption1 = Util.getIntValue(rs_FnaCostStandard.getString("compareoption1"), -1);
				String definebroswerType = Util.null2String(rs_FnaCostStandard.getString("definebroswerType"));
				String fielddbtype = Util.null2String(rs_FnaCostStandard.getString("fielddbtype")).trim();
				if("".equals(definebroswerType)){
					definebroswerType = " ";
				}
				
				String valChar = Util.null2String(request.getParameter("fold_"+fcsGuid1+"_"+fcsdGuid1_copy)).trim();
				extDataRecord.append("\"valChar_"+idx+"\":"+JSONObject.quote(costStandard.getEdit(valChar, "fnew_"+fcsGuid1+"+"+paramtype+"+"+browsertype+"+"+definebroswerType+"+#rowindex112233#+"+user.getLanguage()+"+"+fielddbtype))+",");
			}

			extDataRecord.append("\"endFlagName\":0}");
			
			if(_idx1 > 0){
				extDataRecordArray.append(",");
			}
			extDataRecordArray.append(JSONObject.quote(extDataRecord.toString()));
			
			_idx1++;
		}
	}
	
	String[] fnew_fcsdGuid1s_copyArray = request.getParameterValues("fnew_fcsdGuid1s_copyArray");
	if(fnew_fcsdGuid1s_copyArray!=null){
		int fnew_fcsdGuid1s_copyArrayLen = fnew_fcsdGuid1s_copyArray.length;
		for(int i=0;i<fnew_fcsdGuid1s_copyArrayLen;i++){
			String fcsdGuid1_copy = fnew_fcsdGuid1s_copyArray[i];

			StringBuffer extDataRecord = new StringBuffer("{");


			String fcsdName = Util.null2String(request.getParameter("fnew_fcsdName_"+fcsdGuid1_copy)).trim();//费用标准名称
			String csAmount = Util.null2String(request.getParameter("fnew_csAmount_"+fcsdGuid1_copy));//费用标准
			extDataRecord.append("\"fcsdName\":"+JSONObject.quote(costStandard.getEdit(fcsdName, "fnew_fcsdName"+"+"+"0+-1+ +#rowindex112233#+"+user.getLanguage()))+",");
			extDataRecord.append("\"csAmount\":"+JSONObject.quote(costStandard.getEdit(csAmount, "fnew_csAmount"+"+"+"2+-1+ +#rowindex112233#+"+user.getLanguage()))+",");
			

			int idx = -1;
			rs_FnaCostStandard.beforFirst();
			while(rs_FnaCostStandard.next()){
				idx++;
				
				String fcsGuid1 = Util.null2String(rs_FnaCostStandard.getString("guid1"));
				String name = Util.null2String(rs_FnaCostStandard.getString("name"));
				int paramtype = Util.getIntValue(rs_FnaCostStandard.getString("paramtype"), -1);
				int browsertype = Util.getIntValue(rs_FnaCostStandard.getString("browsertype"), -1);
				int compareoption1 = Util.getIntValue(rs_FnaCostStandard.getString("compareoption1"), -1);
				String definebroswerType = Util.null2String(rs_FnaCostStandard.getString("definebroswerType"));
				String fielddbtype = Util.null2String(rs_FnaCostStandard.getString("fielddbtype")).trim();
				if("".equals(definebroswerType)){
					definebroswerType = " ";
				}
				
				String valChar = Util.null2String(request.getParameter("fnew_"+fcsGuid1+"_"+fcsdGuid1_copy)).trim();
				extDataRecord.append("\"valChar_"+idx+"\":"+JSONObject.quote(costStandard.getEdit(valChar, "fnew_"+fcsGuid1+"+"+paramtype+"+"+browsertype+"+"+definebroswerType+"+#rowindex112233#+"+user.getLanguage()+"+"+fielddbtype))+",");
			}

			extDataRecord.append("\"endFlagName\":0}");
			
			if(_idx1 > 0){
				extDataRecordArray.append(",");
			}
			extDataRecordArray.append(JSONObject.quote(extDataRecord.toString()));
			
			_idx1++;
		}
	}
	
	extDataRecordArray.append("]");
	
	//new BaseBean().writeLog(extDataRecordArray.toString());

	out.println("{\"flag\":true,\"extDataRecordArray\":"+extDataRecordArray.toString()+"}");//复制成功
	out.flush();
	return;
	
}else if(operation.equals("doDel")){
	String[] fold_fcsdGuid1s_array = request.getParameterValues("fold_fcsdGuid1s_array");
	if(fold_fcsdGuid1s_array!=null){
		int fold_fcsdGuid1s_arrayLen = fold_fcsdGuid1s_array.length;
		List<String> fcsdGuid1_list = new ArrayList<String>();
		for(int i=0;i<fold_fcsdGuid1s_arrayLen;i++){
			String fcsdGuid1 = fold_fcsdGuid1s_array[i];
			fcsdGuid1_list.add("'"+StringEscapeUtils.escapeSql(fcsdGuid1)+"'");
		}
		List<String> del_guid1_list_condList = FnaCommon.initData1(fcsdGuid1_list);
		int del_guid1_list_condList_len = del_guid1_list_condList.size();
		for(int i=0;i<del_guid1_list_condList_len;i++){
			rs.executeUpdate("delete from FnaCostStandardDefiDtl where fcsdGuid1 in ("+del_guid1_list_condList.get(i)+")");
			rs.executeUpdate("delete from FnaCostStandardDefi where guid1 in ("+del_guid1_list_condList.get(i)+")");
		}
	}

	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(20461,user.getLanguage()))+"}");//删除成功
	out.flush();
	return;
	
}















































%>
