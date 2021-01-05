<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="weaver.general.Util,weaver.file.ExcelSheet,weaver.file.ExcelRow"%>
<%@ page import="weaver.secondary.file.ExcelStyle" %>
<jsp:useBean id="PR_DATAEXPORT" class="weaver.secondary.file.ExcelFile" scope="session" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/workrelate/comm/WorkerReportUtil.jsp"%>
<%@ include file="WorkerUtil.jsp"%>
<%
	String year = Util.null2String(request.getParameter("year"));
	String type = Util.null2String(request.getParameter("type"));
	String hrmids = Util.null2String(request.getParameter("hrmids"));
	String subcompanyids = Util.null2String(request.getParameter("subcompanyids"));
	String departmentids = Util.null2String(request.getParameter("departmentids"));
	String cpyincludesub = null2String(request.getParameter("cpyincludesub"),"3");
	String deptincludesub = null2String(request.getParameter("deptincludesub"),"3");
	int currYear = Calendar.getInstance().get(Calendar.YEAR);
	
	//得到人员id
	String pageHrmids = getPageHrmids(hrmids, subcompanyids, departmentids, cpyincludesub, deptincludesub, 1,10000,10000);


	String sql = "";
	ExcelSheet es = new ExcelSheet();
	ExcelRow er = null;
	
	if("month".equals(type)){
		es.addColumnwidth(3000);
		es.addColumnwidth(6000);
		es.addColumnwidth(6000);
		for(int i=1;i<=12;i++){
			es.addColumnwidth(3000);
		}
		es.addColumnwidth(3000);
		
		
		ExcelRow title = es.newExcelRow();
		title.setHight(22);
		
		title.addStringValue("人员", "title");
		title.addStringValue("分部", "title");
		title.addStringValue("部门", "title");
		for(int i=1;i<=12;i++){
			title.addStringValue(i+"月", "title");
		}
		title.addStringValue("完成率", "title");
		
		sql = getSearchSql(year,"week".equals(type)?"2":"1",pageHrmids);
        rs.execute(sql);
        LinkedHashMap<String,LinkedHashMap<String,String>> map= getWorkerResult(rs);
        
        rs.execute("SELECT hrm.id, "+
                "          hrm.lastname,"+
                "          cpy.subcompanyname,"+
                "          dept.departmentname"+
                "   FROM   HrmResource hrm,"+
                "          HrmSubCompany cpy,"+
                "          HrmDepartment dept"+
                "   WHERE  hrm.departmentid = dept.id"+
                "          AND status<=3 "+
                "          AND dept.subcompanyid1 = cpy.id"+
                "          AND hrm.id in("+pageHrmids+") order by hrm.dsporder");
        //人员信息集合
        LinkedHashMap<String,LinkedHashMap<String,String>> hrmInfoMap = getHrmInfo(rs);
        int currMonth = Calendar.getInstance().get(Calendar.MONTH)+1;
        if(Integer.parseInt(year) < currYear){
        	currMonth = 12;
        }
        //得到展示数据
        setData(map,hrmInfoMap,currMonth);
        LinkedHashMap<String,String> curMap = null;
        for (Entry<String,LinkedHashMap<String,String>> obj : hrmInfoMap.entrySet()) {
            curMap = obj.getValue();
            
            er = es.newExcelRow();
    		er.setHight(22);
    		er.addStringValue(Util.null2String(curMap.get("lastname")),"normal");
    		er.addStringValue(Util.null2String(curMap.get("subcompanyname")),"normal");
    		er.addStringValue(Util.null2String(curMap.get("departmentname")),"normal");
    		
    		String tempMonth = null;
            for(int i=1;i<=12;i++){
                tempMonth = "month" + i;
                er.addValue(getStatusName(Util.null2String(curMap.get(tempMonth))),"style"+Util.null2String(curMap.get(tempMonth)));
            }
            er.addValue(Util.null2String(curMap.get("rate")),"normal");
        }
	}else{
		int currWeek = Calendar.getInstance().get(Calendar.WEEK_OF_YEAR)-1;
    	if(Integer.parseInt(year) < currYear){
    		currWeek = TimeUtil.getMaxWeekNumOfYear(currYear);
    	}
    	String weekSql = getWeekSearchSql(year,currWeek,pageHrmids);
    	rs.execute(weekSql);
    	LinkedHashMap<String,LinkedHashMap<String, String>> map = getWorkerWeekResult(rs,currWeek);
		
    	es.addColumnwidth(3000);
		es.addColumnwidth(6000);
		es.addColumnwidth(6000);
		for(int i=currWeek; i>0;i--){
			es.addColumnwidth(3000);
		}
		
		ExcelRow title = es.newExcelRow();
		title.setHight(22);
		
		title.addStringValue("人员", "title");
		title.addStringValue("分部", "title");
		title.addStringValue("部门", "title");
		for(int i=currWeek; i>0;i--){
			title.addStringValue("第"+i+"周", "title");
		}
		
    	
        LinkedHashMap<String,String> curMap = null;
        for (Entry<String,LinkedHashMap<String,String>> obj : map.entrySet()) {
            curMap = obj.getValue();
            
            er = es.newExcelRow();
    		er.setHight(22);
    		er.addStringValue(Util.null2String(curMap.get("lastname")),"normal");
    		er.addStringValue(Util.null2String(curMap.get("subcompanyname")),"normal");
    		er.addStringValue(Util.null2String(curMap.get("departmentname")),"normal");
    		
			for(int i=currWeek; i>0;i--){
				er.addValue(getStatusName(Util.null2String(curMap.get("week" + i))),"style"+Util.null2String(curMap.get("week" + i)));
			}
        }
	}
	
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
	
	ExcelStyle style0 = PR_DATAEXPORT.newExcelStyle("style0");
	style0.setFontcolor(ExcelStyle.ORANGE_Color);
	style0.setValign(ExcelStyle.VALIGN_CENTER);
	style0.setFontheight(9);
	
	ExcelStyle style1 = PR_DATAEXPORT.newExcelStyle("style1");
	style1.setFontcolor(ExcelStyle.BLUE_Color);
	style1.setValign(ExcelStyle.VALIGN_CENTER);
	style1.setFontheight(9);
	
	ExcelStyle style2 = PR_DATAEXPORT.newExcelStyle("style2");
	style2.setFontcolor(ExcelStyle.RED_Color);
	style2.setValign(ExcelStyle.VALIGN_CENTER);
	style2.setFontheight(9);
	
	ExcelStyle style3 = PR_DATAEXPORT.newExcelStyle("style3");
	style3.setFontcolor(ExcelStyle.GREEN_Color);
	style3.setValign(ExcelStyle.VALIGN_CENTER);
	style3.setFontheight(9);
	
	ExcelStyle style4 = PR_DATAEXPORT.newExcelStyle("stylen");
	style4.setFontcolor(ExcelStyle.BLACK_Color);
	style4.setValign(ExcelStyle.VALIGN_CENTER);
	style4.setFontheight(9);
	
	ExcelStyle style5 = PR_DATAEXPORT.newExcelStyle("style-1");
	style5.setFontcolor(ExcelStyle.BLACK_Color);
	style5.setValign(ExcelStyle.VALIGN_CENTER);
	style5.setFontheight(9);
	
	ExcelStyle style = PR_DATAEXPORT.newExcelStyle("style");
	style.setFontcolor(ExcelStyle.BROWN_Color);
	style.setValign(ExcelStyle.VALIGN_CENTER);
	style.setFontheight(9);
	
	String filetitle = "按人员统计"+year+"年"+("month".equals(type)?"月报":"周报");
	
	filetitle += "-" + TimeUtil.getCurrentTimeString().replaceAll("-","").replaceAll(":","").replaceAll(" ","");
	//System.out.println("filetitle"+filetitle);
	PR_DATAEXPORT.setFilename(filetitle);
	PR_DATAEXPORT.addSheet(filetitle, es);
%>
<%!
/**
 * 
 * 得到状态图片src
 * @param status
 * @return
 */
public String getStatusName(String status){
    String src = null;
    if("0".equals(status)){//草稿
        src = "草稿";
    }else if("1".equals(status)){//审批中
        src = "审批中";
    }else if("2".equals(status)){//退回
        src = "退回";
    }else if("3".equals(status)){//已完成
        src = "已完成";
    }else if("n".equals(status) || "-1".equals(status)){//无数据
    	src = "无数据";
    }else{//未开始
        src = "未开始";
    }
    return src;
}
%>

<script language="javascript">
	try{
		parent.hideLoad();
	}catch(e){}
    window.location="/weaver/weaver.secondary.file.ExcelOut?excelfile=PR_DATAEXPORT";
</script>