<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.general.Util,weaver.file.ExcelSheet,weaver.file.ExcelRow"%>
<%@ page import="weaver.secondary.file.ExcelStyle" %>
<jsp:useBean id="PR_DATAEXPORT" class="weaver.secondary.file.ExcelFile" scope="session" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="Util.jsp" %>
<%@ include file="/workrelate/comm/SubcpyDeptUtil.jsp" %>
<%@ include file="SubcpyUtil.jsp" %>
<%
	String sql = "";
	ExcelSheet es = new ExcelSheet();
	
	es.addColumnwidth(3000);
	es.addColumnwidth(6000);
	es.addColumnwidth(3000);
	es.addColumnwidth(3000);
	es.addColumnwidth(3000);
	es.addColumnwidth(3000);
	es.addColumnwidth(3000);
	es.addColumnwidth(3000);
	es.addColumnwidth(3000);
	es.addColumnwidth(3000);
	es.addColumnwidth(3000);
	
	ExcelRow title = es.newExcelRow();
	title.setHight(22);
	title.addStringValue("类型", "title");
	title.addStringValue("分部", "title");
	title.addStringValue("需提交", "title");
	title.addStringValue("未提交", "title");
	title.addStringValue("草稿(处理中)", "title");
	title.addStringValue("审批中(处理中)", "title");
	title.addStringValue("退回(处理中)", "title");
	title.addStringValue("已完成", "title");
	title.addStringValue("草稿(已过期)", "title");
	title.addStringValue("审批中(已过期)", "title");
	title.addStringValue("退回(已过期)", "title");
	
	//ExcelRow er = null;
	
	String year = Util.null2String(request.getParameter("year"));
	String month = Util.null2String(request.getParameter("month"));
	String week = Util.null2String(request.getParameter("week"));
	String week1 = Util.null2String(request.getParameter("week"));
	String week2 = Util.null2String(request.getParameter("week2"));
	if(!week2.equals("") && !week2.equals(week)) week += "," + week2;
	String type = Util.null2String(request.getParameter("type"));
	
	boolean  isSqlServer = rs.getDBType().equals("sqlserver");
	
    //查询所有分部的数据
    sql = getSubcpySearchSql(year,month,week,"week".equals(type)?"2":"1",isSqlServer);
    //sql += " where sc.id in (1)";
    rs.execute(sql);
    LinkedHashMap<String,LinkedHashMap<String, String>> subDataMap = getWorkerResult(rs);
    //查询分部树及对应的code,通过函数获得
    rs.execute(getSubCpyTree(isSqlServer));
    LinkedHashMap<String,LinkedHashMap<String, String>> subTreeMap = getTreeMapResult(rs);
    
  	//得到所有部门的数据
    sql = getDeptSearchSql(year,month,week,"week".equals(type)?"2":"1",isSqlServer);
    //sql += " where dept.id=259 or dept.supdepid=259 or dept.id=8 or dept.supdepid=8";
    rs.execute(sql);
    LinkedHashMap<String,LinkedHashMap<String, String>> deptDataMap = getWorkerResult(rs);
    //查询部门树及对应的code
    rs.execute(getDeptTree(isSqlServer));
    LinkedHashMap<String,LinkedHashMap<String, String>> deptTreeMap = getDeptTreeMapResult(rs);
    
    
    getSubcpyShowMap(subDataMap,subTreeMap);
    getDeptShowMap(deptDataMap,deptTreeMap);
    this.makedate("","subcpy",subDataMap,subTreeMap,deptDataMap,deptTreeMap,es);
	
	PR_DATAEXPORT.init();

	ExcelStyle titleStyle = PR_DATAEXPORT.newExcelStyle("title");
	titleStyle.setGroundcolor(ExcelStyle.LIGHT_BLUE_Color);
	titleStyle.setFontcolor(ExcelStyle.WHITE_Color);
	titleStyle.setFontheight(9);
	titleStyle.setFontbold(ExcelStyle.Strong_Font);
	titleStyle.setAlign(ExcelStyle.ALIGN_CENTER);
	titleStyle.setValign(ExcelStyle.VALIGN_CENTER);

	ExcelStyle normalStyle = PR_DATAEXPORT.newExcelStyle("normal");
	//normalStyle.setAlign(ExcelStyle.ALIGN_CENTER);
	normalStyle.setValign(ExcelStyle.VALIGN_CENTER);
	normalStyle.setFontheight(9);
	
	String filetitle = "按组织统计"+year+"年";
	
	if("week".equals(type)){
		if(week1.equals(week2)){
			filetitle += week1+"周";
		}else{
			filetitle += week1;
			if(!"".equals(week2)) filetitle += "-"+week2+"周";
		}
	}else{
		filetitle += month+"月";
	}
	filetitle += "-" + TimeUtil.getCurrentTimeString().replaceAll("-","").replaceAll(":","").replaceAll(" ","");
	//System.out.println("filetitle"+filetitle);
	PR_DATAEXPORT.setFilename(filetitle);
	PR_DATAEXPORT.addSheet(filetitle, es);
%>
<%!

	public void makedate(String subcompanyid,String curtype
			,LinkedHashMap<String,LinkedHashMap<String, String>> subDataMap
			,LinkedHashMap<String,LinkedHashMap<String, String>> subTreeMap
			,LinkedHashMap<String,LinkedHashMap<String, String>> deptDataMap
			,LinkedHashMap<String,LinkedHashMap<String, String>> deptTreeMap
			,ExcelSheet es){
		ExcelRow er = null;
		
		LinkedHashMap<String,LinkedHashMap<String, String>> showMap = getShowMap2(subDataMap,subTreeMap,subcompanyid);
		//System.out.println("showMap:"+showMap.size());
		if(showMap!=null && showMap.size()>0){
			//setIsContainSub(showMap);
		   	LinkedHashMap<String,String> curMap = null;
		   	ListIterator<Map.Entry<String,LinkedHashMap<String,String>>> i=new ArrayList<Map.Entry<String,LinkedHashMap<String,String>>>(showMap.entrySet()).listIterator(showMap.size());
		    while(i.hasPrevious()) {
		    	Entry<String,LinkedHashMap<String,String>> obj=i.previous();
		        curMap = obj.getValue();
		        
		        er = es.newExcelRow();
				er.setHight(22);
		        er.addStringValue("分部","normal");
		        er.addStringValue(Util.null2String(curMap.get("showname")),"normal");
				er.addValue(Util.null2String(curMap.get("exist"),"0"),"normal");
				er.addValue(Util.null2String(curMap.get("without"),"0"),"normal");
				er.addValue(Util.null2String(curMap.get("scoring"),"0"),"normal");
				er.addValue(Util.null2String(curMap.get("assessing"),"0"),"normal");
				er.addValue(Util.null2String(curMap.get("back"),"0"),"normal");
				er.addValue(Util.null2String(curMap.get("finish"),"0"),"normal");
				er.addValue(Util.null2String(curMap.get("oscoring"),"0"),"normal");
				er.addValue(Util.null2String(curMap.get("oassessing"),"0"),"normal");
				er.addValue(Util.null2String(curMap.get("oback"),"0"),"normal");
				
				this.makedate2(Util.null2String(curMap.get("id")),curtype,subDataMap,subTreeMap,deptDataMap,deptTreeMap,es);
		    }
		}
	}
	public void makedate2(String subcompanyid,String curtype
			,LinkedHashMap<String,LinkedHashMap<String, String>> subDataMap
			,LinkedHashMap<String,LinkedHashMap<String, String>> subTreeMap
			,LinkedHashMap<String,LinkedHashMap<String, String>> deptDataMap
			,LinkedHashMap<String,LinkedHashMap<String, String>> deptTreeMap
			,ExcelSheet es){
		ExcelRow er = null;
		//组合展示集合
		
		LinkedHashMap<String,LinkedHashMap<String, String>> subShowMap = null;
		if("subcpy".equals(curtype)){
			subShowMap = getSubcpyShowMap2(subDataMap,subTreeMap,subcompanyid);
		}
		
	    LinkedHashMap<String,LinkedHashMap<String, String>> deptShowMap = getDeptShowMap2(deptDataMap,deptTreeMap,subcompanyid,curtype);
	    
	    List<LinkedHashMap<String, String>> showList = new ArrayList<LinkedHashMap<String, String>>();
        if(subShowMap != null){
            showList.addAll(subShowMap.values());
        }
        
        
        //System.out.println("deptShowMap:"+deptShowMap.size());
        showList.addAll(deptShowMap.values());
        
        LinkedHashMap<String,String> curMap = null;
        for (int i=0;i<showList.size();i++) {
            curMap = showList.get(i);
            //System.out.println("showname:"+curMap.get("showname"));
            er = es.newExcelRow();
			er.setHight(22);
			if("subcpy".equals(Util.null2String(curMap.get("curtype")))){
	        	er.addStringValue("分部","normal");
			}else{
				er.addStringValue("部门","normal");
			}
	        er.addStringValue(Util.null2String(curMap.get("showname")),"normal");
			er.addValue(Util.null2String(curMap.get("exist"),"0"),"normal");
			er.addValue(Util.null2String(curMap.get("without"),"0"),"normal");
			er.addValue(Util.null2String(curMap.get("scoring"),"0"),"normal");
			er.addValue(Util.null2String(curMap.get("assessing"),"0"),"normal");
			er.addValue(Util.null2String(curMap.get("back"),"0"),"normal");
			er.addValue(Util.null2String(curMap.get("finish"),"0"),"normal");
			er.addValue(Util.null2String(curMap.get("oscoring"),"0"),"normal");
			er.addValue(Util.null2String(curMap.get("oassessing"),"0"),"normal");
			er.addValue(Util.null2String(curMap.get("oback"),"0"),"normal");
			
			this.makedate2(Util.null2String(curMap.get("id")),Util.null2String(curMap.get("curtype")),subDataMap,subTreeMap,deptDataMap,deptTreeMap,es);
        }
	}

%>

<script language="javascript">
	try{
		parent.hideLoad();
	}catch(e){}
    window.location="/weaver/weaver.secondary.file.ExcelOut?excelfile=PR_DATAEXPORT";
</script>