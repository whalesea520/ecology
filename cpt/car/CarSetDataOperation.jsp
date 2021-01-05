<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ include file="/formmode/pub_init.jsp"%>
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page"/>
<jsp:useBean id="ModeDataIdUpdate" class="weaver.formmode.data.ModeDataIdUpdate" scope="page"/>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="page" />

<%
String action = Util.null2String(request.getParameter("action"));
int userid = user.getUID();
int usertype = (user.getLogintype()).equals("1") ? 0 : 1;

boolean isright = true;
if(user.getUID() == 1){ //系统管理员除外
	 isright = true;
}
//权限控制 通过sql脚本生成readCarReport:View （角色-功能权限下使用）
if(HrmUserVarify.checkUserRight("Car:Maintenance", user)){
	isright = true;
}
if(!isright) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
} 
if("getData".equals(action)){
	int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
	String sql = "select isremind,remindtype from mode_carremindset";
	RecordSet.executeSql(sql);
	int isremind = 0;
	int remindtype = 0;
	if(RecordSet.next()){
		isremind = RecordSet.getInt("isremind");
		remindtype = RecordSet.getInt("remindtype");
	}
	JSONArray array = new JSONArray();
	JSONObject object = new JSONObject();
	if(isremind <= 0){
		object.put("iscontinue","no");
		object.put("remindtype",remindtype);
	}else{
		sql = "select id from carbasic where workflowid ='"+workflowid+"' and isuse=1";
		RecordSet.executeSql(sql);
		int id = 0;
		if(RecordSet.next()){
			id = RecordSet.getInt("id");
		}
		sql = "select carfieldid,modefieldid from mode_carrelatemode where mainid="+id;
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
			int carfieldid = RecordSet.getInt("carfieldid");
			int modefieldid = RecordSet.getInt("modefieldid");
			switch(carfieldid)
	        {
	            case 627:
	            	object.put("field627",modefieldid); //车辆
	                break;
	            case 628:
	            	object.put("field628",modefieldid); //司机
	                break;
	            case 629:
	            	object.put("field629",modefieldid); //用车人
	                break;
	            case 634:
	            	object.put("field634",modefieldid); //开始日期
	                break;
	            case 635:
	            	object.put("field635",modefieldid); //开始时间
		            break;    
	            case 636:
	            	object.put("field636",modefieldid); //结束日期
	            	break;
	            case 637:
	            	object.put("field637",modefieldid); //结束时间
	            	break;
	            case 639:
	            	object.put("field639",modefieldid); //撤销
	            	break;
	            default:
	              break;
	        }
		}
		object.put("iscontinue","yes");
		object.put("remindtype",remindtype);
	}
	array.add(object);
	//PrintWriter writer = response.getWriter();
	//writer.print(array.toString());
	out.print(array.toString());
    out.flush();
    out.close();
    return;
}else if("getDataSys".equals(action)){ // 128307
	int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
	String sql = "select isremind,remindtype from mode_carremindset";
	RecordSet.executeSql(sql);
	int isremind = 0;
	int remindtype = 0;
	if(RecordSet.next()){
		isremind = RecordSet.getInt("isremind");
		remindtype = RecordSet.getInt("remindtype");
	}
	JSONArray array = new JSONArray();
	JSONObject object = new JSONObject();
	if(isremind <= 0){
		object.put("iscontinue","no");
		object.put("remindtype",remindtype);
	}else{
      	object.put("field627","627"); //车辆
      	object.put("field628","628"); //司机
      	object.put("field629","629"); //用车人
      	object.put("field634","634"); //开始日期
      	object.put("field635","635"); //开始时间
      	object.put("field636","636"); //结束日期
      	object.put("field637","637"); //结束时间
      	object.put("field639","639"); //撤销
		object.put("iscontinue","yes");
		object.put("remindtype",remindtype);
	}
	array.add(object);
	//PrintWriter writer = response.getWriter();
	//writer.print(array.toString());
	out.print(array.toString());
    out.flush();
    out.close();
    return;
}else if("checkData".equals(action)){
	JSONArray array = new JSONArray();
	JSONObject object = new JSONObject();
	int requestid = Util.getIntValue(Util.null2String(request.getParameter("requestid"),"0"),0);
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	String field627 = Util.null2String(request.getParameter("field627")); //车辆
	String field634 = Util.null2String(request.getParameter("field634")); //开始日期
	String field635 = Util.null2String(request.getParameter("field635")); //开始时间
	String field636 = Util.null2String(request.getParameter("field636")); //结束日期
	String field637 = Util.null2String(request.getParameter("field637")); //结束时间
	
	/*begin 查询条件拼装*/
  	String returnStr = " and c1.id='"+field627+"' ";
  	if((RecordSet.getDBType()).equals("oracle")){
  		returnStr += " and ((c2.startDate ||' '||c2.startTime >= '"+field634+" "+field635+"' AND c2.startDate ||' '||c2.startTime <= '"+field636+" "+field637+"') OR"+
  		" (c2.startDate ||' '||c2.startTime <= '"+field634+" "+field635+"' AND c2.endDate||' '||c2.endTime >= '"+field636+" "+field637+"') OR"+
  		//" (c2.startDate||' '||c2.startTime >= '"+field634+" "+field635+"' AND c2.endDate||' '||c2.endTime >= '"+field636+" "+field637+"') OR"+
  		" (c2.endDate||' '||c2.endTime >= '"+field634+" "+field635+"' AND c2.endDate||' '||c2.endTime <= '"+field636+" "+field637+"')) ";
  	}else{
  		returnStr += " and ((c2.startDate +' '+c2.startTime >= '"+field634+" "+field635+"' AND c2.startDate +' '+c2.startTime <= '"+field636+" "+field637+"') OR"+
  		" (c2.startDate +' '+c2.startTime <= '"+field634+" "+field635+"' AND c2.endDate+' '+c2.endTime >= '"+field636+" "+field637+"') OR"+
  		//" (c2.startDate+' '+c2.startTime >= '"+field634+" "+field635+"' AND c2.endDate+' '+c2.endTime >= '"+field636+" "+field637+"') OR"+
  		" (c2.endDate+' '+c2.endTime >= '"+field634+" "+field635+"' AND c2.endDate+' '+c2.endTime <= '"+field636+" "+field637+"')) ";
  	}
  	returnStr += " and (c2.cancel =0 or c2.cancel is null) and c3.requestid != '"+requestid+"' ";
    if ((RecordSet.getDBType()).equals("oracle")) {
        returnStr = Util.StringReplace(returnStr,"SUBSTRING","substr");   
    }
    /*end 查询条件拼装*/
    
    String C2 = "";
    if ((RecordSet.getDBType()).equals("oracle")) {
     	C2 += "(select id,requestid,to_number(carId) as carId,to_number(driver) as driver,to_number(userid) as userid,startdate,starttime,enddate,endtime,cancel,'CarUseApprove' as tablename,'cancel' as fieldname from CarUseApprove";
    } else {
     	C2 += "(select id,requestid,carId,driver,userid,startdate,starttime,enddate,endtime,cancel,'CarUseApprove' as tablename,'cancel' as fieldname from CarUseApprove";
    }
    RecordSet.executeSql("select id,formid from carbasic where formid!=163 and isuse = 1");
    while (RecordSet.next()) {
     	String mainid = RecordSet.getString("id");
     	String _formid = RecordSet.getString("formid");
     	String _tablename = FormManager.getTablename(_formid);
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
    }
    C2 += ")";
     
    String backfields = "c1.id,c2.id aid,c1.carNo,c2.driver,c2.userid,c2.startdate,c2.starttime,c2.enddate,c2.endtime,c3.requestid,c3.requestname,c.id as tid, c.name as typename,c3.currentnodetype,c2.cancel,c2.tablename,c2.fieldname ";
	String fromSql = "  Carinfo c1 left join "+C2+" c2 on c2.carId = c1.id left join workflow_requestbase c3 on c2.requestid=c3.requestid left join CarType c on c1.cartype = c.id ";
	String whereSql = " where c3.currentnodetype<>0 and c3.workflowid not in (select workflowid from carbasic where isuse=0)" + returnStr;
    String orderby = " c2.startdate ,c2.starttime , c1.id" ;
     
    //System.out.println("select "+backfields+" from "+fromSql+" "+whereSql);
    RecordSet.executeSql("select "+backfields+" from "+fromSql+" "+whereSql);
    if(RecordSet.next()){
    	object.put("iscontinue","no");
    }else{
    	object.put("iscontinue","yes");
    }
	array.add(object);
	//PrintWriter writer = response.getWriter();
	//writer.print(array.toString());
	out.print(array.toString());
    out.flush();
    out.close();
    return;
}
%>