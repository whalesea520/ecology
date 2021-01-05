
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="page" />
<html >
<head id="Head1">
	<%
	
		String curSkin=(String)session.getAttribute("SESSION_CURRENT_SKIN");
		int bywhat = Util.getIntValue(request.getParameter("bywhat"),4);
		String userid=user.getUID()+"" ;
		String datenow = Util.null2String(request.getParameter("datenow"));
		boolean cancelRight = HrmUserVarify.checkUserRight("Car:Maintenance",user);
		String cancelString = "0";
		if(cancelRight){
			cancelString = "1";
		}
		int subids = Util.getIntValue(request.getParameter("subids"), -1);
		String content = Util.null2String(request.getParameter("content"));
		int carid = Util.getIntValue(request.getParameter("carid"), 0);
		
		//分权
		RecordSet.executeSql("select carsdetachable from SystemSet");
		int detachable=0;
		if(RecordSet.next()){
   		 	detachable=RecordSet.getInt(1);
		}
		String sqlwhere = "";
		if(detachable==1){
			if(!"".equals(Util.null2String(request.getParameter("subids")))){
				subids = Util.getIntValue(request.getParameter("subids"));
			}
			//operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Car:Maintenance",subCompanyId);
			if(user.getUID()!=1){
				String sqltmp = "";
				String blonsubcomid="";
				char flag=Util.getSeparator();
				rs2.executeProc("HrmRoleSR_SeByURId", ""+user.getUID()+flag+"Car:Maintenance");
				while(rs2.next()){
					blonsubcomid=rs2.getString("subcompanyid");
					sqltmp += (", "+blonsubcomid);
				}
				if(!"".equals(sqltmp)){//角色设置的权限
					sqltmp = sqltmp.substring(1);
					sqlwhere += " and subcompanyid in ("+sqltmp+") ";
				}else{
					sqlwhere += " and subcompanyid="+user.getUserSubCompany1() ;
				}
			}
		}else{
			subids = -1;
		}

		if(!"".equals(content.trim())){
			sqlwhere = " and c1.carNo like '%" + content + "%' ";
		}
		
		if (carid != 0) {
			sqlwhere = " and c1.id = " + carid;
		}	

		
	%>
    <title>	My Calendar </title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <link href="/css/Weaver_wev8.css" rel="stylesheet" type="text/css" /> 
    <link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF" />
	<link type='text/css' rel='stylesheet'  href='/wui/theme/<%=curTheme %>/skins/<%=curSkin %>/wui_wev8.css'/>
    <script type="/js/jquery/ui/ui.dialog_wev8.js"  type="text/javascript"></script>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
<script src="/js/messagejs/highslide/highslide-full_wev8.js" type="text/javascript"></script>
<script src="/js/messagejs/messagejs_wev8.js" type="text/javascript"></script>
<script src="/js/messagejs/simplehrm_wev8.js" type="text/javascript"></script>


</head>
<body scroll="no">
<div id="listdiv">
  <%

   	 String returnStr = "" ;   
        switch (bywhat) {
            case 2 : //月                 
                returnStr=" and  ('"+datenow+"'" +
                        " between SUBSTRING(c2.startdate,1,7) and SUBSTRING(c2.enddate,1,7)) " ;
                break ;
            case 3 : //周
                returnStr=" and ( "   ;   
                for (int h = 0;h<7;h++){                 
                    String newTempDate = TimeUtil.dateAdd(datenow,h) ;
                    returnStr +="('"+newTempDate+"' between c2.startdate and c2.enddate) or" ;         
                }
                returnStr = returnStr.substring(0,returnStr.length()-2);
                returnStr += ") " ;
                break ;                
            case 4 : //日
                returnStr = " and ('"+datenow+"' " +
                        " between c2.startdate and c2.enddate) " ;
						//+ " and ( (c2.endtime between '"+Util.add0(0,2)+"' and '"+Util.add0(23,2)+"') or (c2.starttime between '"+Util.add0(0,2)+"' and '"+Util.add0(23,2)+"'))";
                break ;      
        }
        
        if ((RecordSet.getDBType()).equals("oracle")) {
            returnStr = Util.StringReplace(returnStr,"SUBSTRING","substr");   
        }
        returnStr = returnStr + sqlwhere;
        String C2 = "";
        if ((RecordSet.getDBType()).equals("oracle")) {
        	C2 += "(select id,requestid,to_number(carId) as carId,to_number(driver) as driver,to_number(userid) as userid,startdate,starttime,enddate,endtime,cancel,'CarUseApprove' as tablename,'cancel' as fieldname from CarUseApprove";
        } else {
        	C2 += "(select id,requestid,carId,driver,userid,startdate,starttime,enddate,endtime,cancel,'CarUseApprove' as tablename,'cancel' as fieldname from CarUseApprove";
        }
        RecordSet.executeSql("select id,formid,workflowid from carbasic where formid!=163 and isuse = 1");
        while (RecordSet.next()) {
        	String mainid = RecordSet.getString("id");
        	String _formid = RecordSet.getString("formid");
        	String _tablename = FormManager.getTablename(_formid);
        	String workflowid=RecordSet.getString("workflowid");
        	C2 += " union all select id,requestid,";
        	Map _map = new HashMap();
        	rs2.executeSql("select carfieldid,modefieldid,fieldname from mode_carrelatemode c,workflow_billfield b where c.modefieldid=b.id and mainid="+mainid);
        	while (rs2.next()) {
        		String carfieldid = rs2.getString("carfieldid");
        		String modefieldid = rs2.getString("modefieldid");
        		String fieldname = rs2.getString("fieldname");
        		_map.put(carfieldid,fieldname);
        	}
        	
        	if ((RecordSet.getDBType()).equals("oracle")) {
        		C2 += "to_number("+Util.null2s(Util.null2String(_map.get("627")),"0") +") as carId,";
            	C2 += "to_number("+Util.null2s(Util.null2String(_map.get("628")),"0") +") as driver,";
            	C2 += "to_number("+Util.null2s(Util.null2String(_map.get("629")),"0") +") as userid,";
        	} else {
        		C2 += Util.null2s(Util.null2String(_map.get("627")),"0") +" as carId,";
	        	C2 += Util.null2s(Util.null2String(_map.get("628")),"0") +" as driver,";
	        	C2 += Util.null2s(Util.null2String(_map.get("629")),"0") +" as userid,";

        	}
        	C2 += Util.null2s(Util.null2String(_map.get("634")),"''") +" as startDate,";
        	C2 += Util.null2s(Util.null2String(_map.get("635")),"''") +" as startTime,";
        	C2 += Util.null2s(Util.null2String(_map.get("636")),"''") +" as endDate,";
        	C2 += Util.null2s(Util.null2String(_map.get("637")),"''") +" as endTime,";
        	C2 += Util.null2s(Util.null2String(_map.get("639")),"'0'") +" as cancel,";
        	C2 += "'"+_tablename +"' as tablename,";
        	C2 += "'" + Util.null2String(_map.get("639")) +"' as fieldname";
        	C2 += " from " + _tablename;
        	C2 +=" where (select max(workflowid) from workflow_requestbase where requestid="+_tablename+".requestid)="+workflowid;
        }
        C2 += ")";
        
		String backfields = "c1.id,c2.id aid,c1.carNo,c2.driver,c2.userid,c2.startdate,c2.starttime,c2.enddate,c2.endtime,c3.requestid,c3.requestname,c.id as tid, c.name as typename,c3.currentnodetype,c2.cancel,c2.tablename,c2.fieldname ";
		
		String fromSql = "  Carinfo c1 left join "+C2+" c2 on c2.carId = c1.id left join workflow_requestbase c3 on c2.requestid=c3.requestid left join CarType c on c1.cartype = c.id ";

		String whereSql = " where c3.currentnodetype<>0 and c3.workflowid not in (select workflowid from carbasic where isuse=0)" + returnStr;
    
        String orderby = " c2.startdate ,c2.starttime , c1.id" ;
        
        String param = "column:requestid+"+user.getLanguage()+"+"+cancelString+"+column:tablename+column:fieldname";
     int  perpage=10;
     
     String tableString = "";
   	        tableString = " <table instanceid=\"carTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+ 
                          "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\"  sqlwhere=\""+Util.toHtmlForSplitPage(whereSql)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"c1.id\" sqlsortway=\"Desc\" />"+
                          "			<head>"+//车牌
                          "				<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(21028,user.getLanguage())+"\" column=\"carNo\" orderkey=\"carNo\" transmethod=\"weaver.car.Maint.CarTransMethod.getCarinfoHref\" otherpara=\"column:id\" />"+
                          				//用车请求
                          "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(82288,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\" transmethod=\"weaver.car.Maint.CarTransMethod.getUseCarRequestHref\" otherpara=\"column:requestid\" />"+
                          				//用车人
                          "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(17670,user.getLanguage())+"\" column=\"userid\" orderkey=\"userid\" transmethod=\"weaver.car.Maint.CarTransMethod.getUsername\" />"+
                          				//状态
                          "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"requestid\" orderkey=\"requestid\" transmethod=\"weaver.workflow.request.RequestComInfo.getRequestStatus\" />"+
                          				//开始时间
           				  "				<col width=\"14%\" text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"startdate\"  orderkey=\"startdate,starttime\" transmethod=\"weaver.car.Maint.CarTransMethod.getUsecarStartdatetime\" otherpara=\"column:starttime\"/>"+
           				  				//结束时间
           				  "				<col width=\"14%\" text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"enddate\"  orderkey=\"enddate,endtime\" transmethod=\"weaver.car.Maint.CarTransMethod.getUsecarEnddatetime\" otherpara=\"column:endtime\"/>"+
           				  				//撤销状态
           				  "				<col width=\"12%\" text=\"\" column=\"aid\" orderkey=\"aid\" transmethod=\"weaver.car.Maint.CarTransMethod.getCarStatus\" otherpara=\""+param+"\" />"+
                          "			</head>"+
                          "</table>";
  %>
  <wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="true"  mode="run" />
</div>

</body>
</html>
<script type="text/javascript">
jQuery(document).ready(function(){
	setTimeout(function(){
		window.parent.setWindowSize(window.parent.document);
	},200);
});

function afterDoWhenLoaded(){
	setTimeout(function(){
		window.parent.setWindowSize(window.parent.document);
	},200);
}
document.oncontextmenu=function(){
	   return false;
	}
	
function doCancel(id,tablename,cancelname){
	window.parent.doCancel(id,tablename,cancelname);
}

var diag_vote;
function view(id)
{
	if(id!="0" && id !=""){
		if(window.top.Dialog){
			diag_vote = new window.top.Dialog();
		} else {
			diag_vote = new Dialog();
		}
		diag_vote.currentWindow = window;
		diag_vote.Width = 800;
		diag_vote.Height = 550;
		diag_vote.Modal = true;
		diag_vote.maxiumnable = true;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(20316,user.getLanguage())%>";//车辆信息
		diag_vote.URL = "/car/CarInfoViewTab.jsp?fg=1&flag=1&id="+id;
		diag_vote.show();
	}
}

function view2(id)
{
	if(id!="0" && id !=""){
		if(window.top.Dialog){
			diag_vote = new window.top.Dialog();
		} else {
			diag_vote = new Dialog();
		}
		diag_vote.currentWindow = window;
		diag_vote.Width = 800;
		diag_vote.Height = 550;
		diag_vote.Modal = true;
		diag_vote.maxiumnable = true;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82292,user.getLanguage())%>";//查看车辆使用
		diag_vote.URL = "/workflow/request/ViewRequest.jsp?requestid="+id+"&isovertime=0";
		//diag_vote.URL = "/workflow/request/ManageRequestNoFormBill.jsp?fromFlowDoc=&fromPDA=&requestid="+id+"&message=&topage=&docfileid=&newdocid=&isovertime=0&isrequest=0&isaffirmance=&reEdit=1&seeflowdoc=0&isworkflowdoc=0&isfromtab=false";
		diag_vote.show();
	}
}


function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	doSearchsubmit();
}
function pointerXY(event,doc)  
{  
	 var evt = event||window.event;
	 bodySize[0] = jQuery(window).width();
	 bodySize[1] = jQuery(window).height();
	 clickSize[0] = jQuery(evt.srcElement).offset().left;
	 clickSize[1] = jQuery(evt.srcElement).offset().top + $("#tablediv",window.parent.document).height() + 200;
	 clickSize[2] = jQuery(evt.srcElement).height();
} 

</script>
