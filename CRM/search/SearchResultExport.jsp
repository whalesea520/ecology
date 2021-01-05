
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.ExcelSheet,
                 weaver.file.ExcelRow" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />

<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil"></jsp:useBean>
<%
try{
    
    String selectType = Util.null2String(CRMSearchComInfo.getSelectType());//mine 我的客户 ，share批量共享
    ExcelSheet sheet = new ExcelSheet();
    
	//检查是否有客户导出权限项
	if(!user.getLogintype().equals("2")&&HrmUserVarify.checkUserRight("EditCustomer:Delete", user)){

	}else{
		response.sendRedirect("/notice/noright.jsp") ;
	}
	
    //添加判断权限的内容--new--begin
    String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
    if ("share".equals(selectType)) {//批量共享，加上编辑权限限制
        leftjointable = leftjointable.replace("deleted =0", "deleted =0 and sharelevel>=2 ");
    }
    String backFields = "";
    String sqlFrom = "";
	String sqlWhere = "";
	ExcelRow row = sheet.newExcelRow();
	List fieldList = new ArrayList();
	Map browMap = new HashMap();
	Map selectMap = new HashMap();
	List checkList = new ArrayList();
	Map<String,String> dmlMap = new HashMap<String,String>();
	
	String sql = "select id, fieldlabel, fieldname , fieldhtmltype , type  ,groupid,dmlurl  from CRM_CustomerDefinField "+
	" where usetable = 'CRM_CustomerInfo' and isopen = 1 and isexport=1 and fieldhtmltype <>6 ORDER BY dsporder ASC ,id ASC ";
	rs.execute(sql);
	while(rs.next()){
		String fieldname = rs.getString("fieldname");
		String asFieldname = fieldname;
		
		fieldList.add(asFieldname);
		if(3 == rs.getInt("fieldhtmltype")){
			browMap.put(asFieldname , rs.getString("type"));
			dmlMap.put(asFieldname, rs.getString("dmlurl"));
		}
		if(4 == rs.getInt("fieldhtmltype")){
			checkList.add(asFieldname);
		}
		if(5 == rs.getInt("fieldhtmltype")){
			selectMap.put(asFieldname , rs.getString("id"));
		}
		
		row.addStringValue(SystemEnv.getHtmlLabelName(rs.getInt("fieldlabel"),user.getLanguage()));//设置标题
		sheet.addColumnwidth(4000);
		
		if(4 != rs.getInt("groupid")){
			backFields +="t1."+rs.getString("fieldname")+",";
			continue;
		}
		
		fieldname = fieldname.equals("contacteremail")?"email":fieldname;
		
		if(rs.getDBType().equals("oracle")){
			backFields += "(select t3."+fieldname+" from (select "+fieldname+" , customerid from CRM_CustomerContacter ORDER BY main desc,id desc) t3"+
					" where t3.customerid = t1.id and rownum=1 ) "+asFieldname+",";
		}else{
			backFields += "(select TOP 1 "+fieldname+" from CRM_CustomerContacter where customerid = t1.id  ORDER BY main desc,id desc) "+asFieldname+",";
		}
	}
    
	if(!backFields.equals("")){
		backFields = backFields.substring(0 , backFields.length()-1);
	}
	
	
	if(user.getLogintype().equals("1")){
	    //客户监控导出所有
	    if("monitor".equals(selectType)){
	        sqlFrom="from CRM_CustomerInfo t1";
	        sqlWhere=" t1.deleted=0 ";
	    }else {
	        sqlFrom = " from CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid left join HrmResource on t1.manager=HrmResource.id";
	        sqlWhere =" t1.id = t2.relateditemid"+" and "+CRMSearchComInfo.FormatSQLSearch(user.getLanguage(),false);
	    }
	}else{
		sqlFrom = " from CRM_CustomerInfo t1";
		sqlWhere = CRMSearchComInfo.FormatSQLSearch(user.getLanguage(),false)+" and t1.agent="+user.getUID();
	}
    rs.executeSql("select "+backFields+" "+sqlFrom+" where "+sqlWhere+" order by t1.id desc");
	while(rs.next()){
		row = sheet.newExcelRow();
		for(int i=0; i <fieldList.size(); i++){
			String fieldName = fieldList.get(i)+"";
			if(browMap.containsKey(fieldName)){
				row.addStringValue(CrmUtil.getFieldvalue(user,Util.getIntValue(browMap.get(fieldName)+""),rs.getString(fieldName),dmlMap.get(fieldName)));	 
			}else if(selectMap.containsKey(fieldName)){
				row.addStringValue(CrmUtil.getFieldvalue(selectMap.get(fieldName)+"",rs.getString(fieldName)));	
			}else if(checkList.contains(fieldName)){
				row.addStringValue(rs.getString(fieldName).equals("1")?"是":"否");	
			}else{
				row.addStringValue(rs.getString(fieldName));	
			}
		}
	}

    ExcelFile.init() ;
    ExcelFile.setFilename("客户资料") ;
    ExcelFile.addSheet("客户", sheet) ;
}catch(Exception e){
	e.printStackTrace();
}
%>
success
<script language="javascript">
    window.location="/weaver/weaver.file.ExcelOut";
</script>

