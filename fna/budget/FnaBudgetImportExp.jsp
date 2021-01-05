<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%>
<%@page import="weaver.file.ExcelRow"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.file.ExcelSheet"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>

<%@page import="weaver.fna.general.FnaLanguage"%><jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
	boolean canEdit = HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user);
	
	if(!canEdit){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	BudgetfeeTypeComInfo btc = new BudgetfeeTypeComInfo();
	FnaBudgetInfoComInfo fnaBudgetInfoComInfo = new FnaBudgetInfoComInfo();
	DecimalFormat df = new DecimalFormat("################################################0.00");

	String fnabudgetinfoid = Util.getIntValue(request.getParameter("fnabudgetinfoid"), -1)+"";//ID
	String budgetperiods = Util.null2String(request.getParameter("budgetperiods"));//期间ID
	int keyWord2 = Util.getIntValue(request.getParameter("keyWord2"), -1);//科目重复验证字段
	
	RecordSet rs = new RecordSet();
	RecordSet rs1 = new RecordSet();

	FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
	boolean showHiddenSubject = 1==Util.getIntValue(fnaSystemSetComInfo.get_showHiddenSubject());
	String separator = Util.null2String(fnaSystemSetComInfo.get_separator());
	
	if("".equals(separator)){
		separator = "/";
	}

	boolean haveRecord = false;
    String organizationid = "";
    String organizationtype = "";
	String revisionName = "";
    if(!"".equals(fnabudgetinfoid)){
    	rs.executeSql(" select revision, status, budgetorganizationid, organizationtype from FnaBudgetInfo where id = "+fnabudgetinfoid);
		if(rs.next()){
			haveRecord = true;
            organizationid = Util.null2String(rs.getString("budgetorganizationid")).trim();
            organizationtype = Util.null2String(rs.getString("organizationtype")).trim();
	        if(rs.getInt("status")==0){
	        	revisionName = SystemEnv.getHtmlLabelName(220,user.getLanguage());//草稿
	        }else if(rs.getInt("status")==1){
	        	revisionName = SystemEnv.getHtmlLabelName(18431,user.getLanguage())+"_V"+rs.getInt("revision");//生效
	        }else if(rs.getInt("status")==2){
	        	revisionName = SystemEnv.getHtmlLabelName(1477,user.getLanguage())+"_V"+rs.getInt("revision");//历史
	        }else if(rs.getInt("status")==3){
	        	revisionName = SystemEnv.getHtmlLabelName(2242,user.getLanguage())+"_V"+rs.getInt("revision");//待审批
	        }
		}
    }

    if(Util.getIntValue(fnabudgetinfoid) > 0 && haveRecord){
		//检查权限
		int right = 0;
		if("0".equals(organizationtype) && FnaBudgetLeftRuleSet.isAllowCmpEdit(user.getUID())){
			right = 1;
		}else if("1".equals(organizationtype)){
			List<String> allowOrgIdEdit_list = new ArrayList<String>();
			boolean allowOrgIdEdit = FnaBudgetLeftRuleSet.getAllowSubCmpIdEdit(user.getUID(), allowOrgIdEdit_list);
			if(allowOrgIdEdit || allowOrgIdEdit_list.contains(organizationid)){
				right = 1;
			}
		}else if("2".equals(organizationtype)){
			List<String> allowOrgIdEdit_list = new ArrayList<String>();
			boolean allowOrgIdEdit = FnaBudgetLeftRuleSet.getAllowDepIdEdit(user.getUID(), allowOrgIdEdit_list);
			if(allowOrgIdEdit || allowOrgIdEdit_list.contains(organizationid)){
				right = 1;
			}
		}else if("3".equals(organizationtype)){
			List<String> __orgId_list = new ArrayList<String>();
			__orgId_list.add(organizationid);
			List<String> allowOrgIdEdit_list = new ArrayList<String>();
			boolean allowOrgIdEdit = FnaBudgetLeftRuleSet.getAllowHrmIdEdit(user.getUID(), null, null, __orgId_list, allowOrgIdEdit_list);
			if(allowOrgIdEdit || allowOrgIdEdit_list.contains(organizationid)){
				right = 1;
			}
		}else if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){
			List<String> allowOrgIdEdit_list = new ArrayList<String>();
			boolean allowOrgIdEdit = FnaBudgetLeftRuleSet.getAllowFccIdEdit(user.getUID(), allowOrgIdEdit_list);
			if(allowOrgIdEdit || allowOrgIdEdit_list.contains(organizationid)){
				right = 1;
			}
		}
	
	    if (right < 1) {//不可编辑
	        response.sendRedirect("/notice/noright.jsp");
	        return;
	    }
    }

	int sqlCondOrgType4ftRul = Util.getIntValue(organizationtype);
	int sqlCondOrgId4ftRul = Util.getIntValue(organizationid);
	if(Util.getIntValue(organizationtype)==3){//个人预算
		sqlCondOrgType4ftRul = 2;
		sqlCondOrgId4ftRul = Util.getIntValue(ResourceComInfo.getDepartmentID(organizationid));
	}
    
	List<HashMap<String, String>> subject_feeperiod1 = new ArrayList<HashMap<String, String>>();
	List<HashMap<String, String>> subject_feeperiod2 = new ArrayList<HashMap<String, String>>();
	List<HashMap<String, String>> subject_feeperiod3 = new ArrayList<HashMap<String, String>>();
	List<HashMap<String, String>> subject_feeperiod4 = new ArrayList<HashMap<String, String>>();

	rs.executeSql("select DISTINCT b2.groupDispalyOrder b2groupDispalyOrder, b2.id b2id, b2.name b2name, b2.codeName b2codeName, b2.feelevel b2feelevel, b2.Archive b2Archive, b2.alertvalue b2Alertvalue, b2.isEditFeeType b2IsEditFeeType, b2.displayOrder b2displayOrder, \n" +
		"	b3.groupDispalyOrder b3groupDispalyOrder, b3.id b3id, b3.name b3name, b3.codeName b3codeName, b3.feelevel b3feelevel, b3.Archive b3Archive, b3.alertvalue b3Alertvalue, b3.isEditFeeType b3IsEditFeeType, b3.displayOrder b3displayOrder, b3.feeperiod b3feeperiod \n" +
		"from Fnabudgetfeetype b2 \n" +
		"join FnaBudgetfeeType b3 on b2.id = b3.groupCtrlId \n" +
		"where b3.isEditFeeType = 1  \n" +
		"order by b3.groupDispalyOrder, b2.feelevel, b2.displayOrder, b2.codeName, b2.name, b3.feelevel, b3.displayOrder, b3.codeName, b3.name ");
	while (rs.next()) {
    	String _id = Util.null2String(rs.getString("b3id")).trim();
    	int _archive = Util.getIntValue(rs.getString("b3Archive"), 0);
    	
    	boolean _flag1 = true;
    	if(_flag1){
    		_flag1 = btc.checkRuleSetRight(sqlCondOrgType4ftRul, sqlCondOrgId4ftRul, Util.getIntValue(_id));
    	}
    	boolean _flag2 = true;
    	if(!showHiddenSubject){
    		_flag2 = _archive!=1;
    	}
		if(_flag1 && _flag2){
	    	String fullName = btc.getSubjectFullName(_id, separator);
	    	int feeperiod = Util.getIntValue(rs.getString("b3feeperiod"));
	    	
	    	HashMap<String, String> hm = new HashMap<String, String>();
	    	hm.put("id", _id);
	    	hm.put("fullName", fullName);
	    	hm.put("feeperiod", feeperiod+"");
	    	
	    	if(feeperiod==1){//1：月度；
	    		subject_feeperiod1.add(hm);
	    	}else if(feeperiod==2){//2：季度；
	    		subject_feeperiod2.add(hm);
	    	}else if(feeperiod==3){//3：半年度；
	    		subject_feeperiod3.add(hm);
	    	}else if(feeperiod==4){//4：年度；
	    		subject_feeperiod4.add(hm);
	    	}
		}
    }
    

	ExcelFile.init();
	
	for(int q1=1;q1<5;q1++){
		List<HashMap<String, String>> subject_list = new ArrayList<HashMap<String, String>>();
    	
    	if(q1==1){//1：月度；
    		subject_list = subject_feeperiod1;
    	}else if(q1==2){//2：季度；
    		subject_list = subject_feeperiod2;
    	}else if(q1==3){//3：半年度；
    		subject_list = subject_feeperiod3;
    	}else if(q1==4){//4：年度；
    		subject_list = subject_feeperiod4;
    	}
	    
	    
		ExcelSheet es = new ExcelSheet();
		
		String sheetname = "";
		if(q1==1) sheetname = FnaLanguage.getYueDuYuSuan(user.getLanguage());//月度预算
		else if(q1==2) sheetname = FnaLanguage.getJiDuYuSuan(user.getLanguage());//季度预算
		else if(q1==3) sheetname = FnaLanguage.getBanNianYuSuan(user.getLanguage());//半年预算
		else if(q1==4) sheetname = FnaLanguage.getNianDuYuSuan(user.getLanguage());//年度预算
		ExcelFile.addSheet(sheetname, es);
		
		ExcelRow er = es.newExcelRow();

    	
		if(keyWord2==1){
			er.addStringValue(SystemEnv.getHtmlLabelName(21108, user.getLanguage()));//科目编码 
		}else{
			er.addStringValue(FnaLanguage.getKmID(user.getLanguage()));//科目ID
		}
		er.addStringValue(FnaLanguage.getKmFullName(user.getLanguage()));//科目全名

		String[] tmpbudget = null;
		if(q1==1) tmpbudget = new String[]{"","","","","","","","","","","",""};
		if(q1==2) tmpbudget = new String[]{"","","",""};
		if(q1==3) tmpbudget = new String[]{"",""};
		if(q1==4) tmpbudget = new String[]{""};
		
		int[] openPeriodsid = new int[]{0,0,0,0,0,0,0,0,0,0,0,0};
		
		RecordSet rSet = new RecordSet();
		StringBuffer buffer = new StringBuffer();
		buffer.append(" select * from FnaYearsPeriodsList where fnayearid = ").append(budgetperiods);
		buffer.append(" order by Periodsid ");
		rSet.executeSql(buffer.toString());
		int m = 0;
		while(rSet.next()){
			int status = rSet.getInt("status");
			int periodsid = rSet.getInt("Periodsid");
			if(periodsid != 13){
				openPeriodsid[m] = status;
			}
			m++;
		}
		
		int qcount = 0;
		if(q1==1){
			for(int i = 0; i < openPeriodsid.length; i ++){
				if(openPeriodsid[i] == 0){
					tmpbudget[i] = String.valueOf(i+1);
				}
			}
			qcount = 13;
		}else if(q1==2){
			for(int i = 1; i < 5 ;i++){
				if(openPeriodsid[3*i-3]==1&&openPeriodsid[3*i-2]==1&&openPeriodsid[3*i-1]==1){
					tmpbudget[i-1] = "";
				}else{
					tmpbudget[i-1] = String.valueOf(i);
				}
			}
			qcount = 5;
		}else if(q1==3){
			for(int i = 0; i < openPeriodsid.length; i ++){
				if(i < 6){
					if(openPeriodsid[i] == 0){
						tmpbudget[0] = "1";
					}
				}else{
					if(openPeriodsid[i] == 0){
						tmpbudget[1] = "2";
					}
				}
			}
			qcount = 3;
		}else if(q1==4){
			for(int i = 0; i < openPeriodsid.length; i ++){
				if(openPeriodsid[i] == 0){
					tmpbudget[0] = "1";
				}
			}
			qcount = 1;
		}
		
		
		for(int q2=1;q2<=qcount;q2++){
		    if(q2<qcount){
		    	if(tmpbudget[q2-1]!=""){
		    		er.addStringValue(q2+FnaLanguage.getQi(user.getLanguage()));
		    	}
		    } else {
				er.addStringValue(FnaLanguage.getQuanNian(user.getLanguage()));
		    }
		}
			
		int subject_list_len = subject_list.size();
        for(int l3=0;l3<subject_list_len;l3++) {
        	HashMap<String, String> hm = subject_list.get(l3);
	    	String _id = hm.get("id");
	    	String fullName = hm.get("fullName");

			er = es.newExcelRow();
        	
			if(keyWord2==1){
				er.addStringValue(btc.getBudgetfeeTypeCodeName(_id));
			}else{
				er.addStringValue(_id);
			}
			er.addStringValue(fullName);

        	Map currentBudgetTypeAmount = fnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid, _id);
        	
        	double tmpcount = 0d;
        	double tmpsum = 0d;
        	for(int q2=1;q2<=qcount;q2++){
			    tmpcount = Util.getDoubleValue(Util.null2String((String)currentBudgetTypeAmount.get(""+q2)), 0.0);
			    tmpsum+=tmpcount;
			    if(q2<qcount){
			    	if(tmpbudget[q2-1]!=""){
			    		er.addStringValue(df.format(tmpcount));
			    	}
			    } else {
					er.addStringValue(df.format(tmpsum));
        		}
    		}
		}
	}
	
	ExcelFile.setFilename("templet2_"+revisionName);
%>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<script type="text/javascript">
var iframe_ExcelOut = document.getElementById("ExcelOut");
iframe_ExcelOut.src = "/weaver/weaver.file.ExcelOut";
</script>