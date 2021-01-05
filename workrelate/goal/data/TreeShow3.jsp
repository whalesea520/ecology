<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.hrm.company.*"%>
<%@ page import="weaver.hrm.resource.*"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<link type="text/css" href="/workrelate/js/jit/base.css" rel="stylesheet" />
<link type="text/css" href="/workrelate/js/jit/Hypertree.css" rel="stylesheet" />
<link type="text/css" href="/workrelate/js/jit/Spacetree.css" rel="stylesheet" />
<style type="text/css">
	html,body{background: #fff;}
	#center-container{cursor: move;}
	#right-container{width: 70px;height: auto;border-right: 1px #EFEFEF solid;border-bottom: 1px #EFEFEF solid;overflow: hidden;
		top: 0px;left: 0px;right: auto;bottom: auto;}
	.root,.box{width: 140px;height: 60px;text-align: left;font-size: 12px;background: url(/workrelate/images/trans.png) repeat;}
	.root{text-align: center;line-height: 60px;}
	.datatable{width: 100%;table-layout: fixed;margin: 0px;}
	.info1,.info{line-height: 20px;empty-cells: show;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;
		padding-left: 4px;padding-right: 4px;color: #333333;}
	.info1{text-align: right;color: #838383;}	
	
</style>
<%
	String condtype = Util.null2String(request.getParameter("condtype"));
	String hrmid = Util.null2String(request.getParameter("hrmid"));
	if(hrmid.equals("") || hrmid.equals("0")) hrmid = user.getUID()+"";
	boolean showall = false;
	String rootname = "";
	if(condtype.equals("2")){
		rootname = "公司目标";//泛微目标总纲
		if(user.getUID()==2){
			showall = true;
		}else{
			rs.executeSql("select goalmaint,iscgoal from GM_BaseSetting");
			if(rs.next()){
				String goalmaint = Util.null2String(rs.getString("goalmaint"));
				int iscgoal = Util.getIntValue(rs.getString("iscgoal"),0);
				if(goalmaint.indexOf(","+user.getUID()+",")>-1){
					showall = true;
				}else if(iscgoal==1){
					showall = true;
				}
			}
			hrmid = "";
			rs.executeSql("select hrmid from GM_RightSetting where orgid=1 and type=1");
			while(rs.next()){
				hrmid += "," + Util.null2String(rs.getString(1));
			}
			if(!hrmid.equals("")) hrmid = hrmid.substring(1);
		}
	}else{
		showall = true;
		rootname = ResourceComInfo.getLastname(hrmid)+"的目标";
	}

	int status = Util.getIntValue(request.getParameter("status"),1);
	int period = Util.getIntValue(request.getParameter("period"),3);
	int periody = Util.getIntValue(request.getParameter("periody"),Integer.parseInt(TimeUtil.getCurrentDateString().substring(0,4)));
	int periodm = Util.getIntValue(request.getParameter("periodm"),Integer.parseInt(TimeUtil.getCurrentDateString().substring(5,7)));
	int periods = Util.getIntValue(request.getParameter("periods"),Integer.parseInt(TimeUtil.getCurrentSeason()));
	String datefrom = "";
	String dateto = "";
	if(period==1){//月度
		datefrom = TimeUtil.getYearMonthFirstDay(periody,periodm);
		dateto = TimeUtil.getYearMonthEndDay(periody,periodm);
	}else if(period==2){//季度
		if(periods==1){
			datefrom = TimeUtil.getYearMonthFirstDay(periody,1);
			dateto = TimeUtil.getYearMonthEndDay(periody,3);
		}else if(periods==2){
			datefrom = TimeUtil.getYearMonthFirstDay(periody,4);
			dateto = TimeUtil.getYearMonthEndDay(periody,6);
		}else if(periods==3){
			datefrom = TimeUtil.getYearMonthFirstDay(periody,7);
			dateto = TimeUtil.getYearMonthEndDay(periody,9);
		}else if(periods==4){
			datefrom = TimeUtil.getYearMonthFirstDay(periody,10);
			dateto = TimeUtil.getYearMonthEndDay(periody,12);
		}
	}else if(period==3){//年度
		datefrom = TimeUtil.getYearMonthFirstDay(periody,1);
		dateto = TimeUtil.getYearMonthEndDay(periody,12);
	}else if(period==4){//三年
		
	}else if(period==5){//五年
		
	}
	
	String str = (String)staticobj.getRecordFromObj("GM_GOALSHOW","GM_GOAL_"+hrmid+"_"+period+"_"+datefrom+"_"+dateto+"_"+showall);
	//str = null;
	//System.out.println("str:"+str);
	if(str==null){
		str = "var json = {";
	    str += "id: '-1',";
	    str += "name: '"+"<div class=\"root\">"+rootname+""+"</div>"+"',";
	    str += "data: {},";
	    str += "children: [";
	    str += this.getInfo(hrmid,period,datefrom,dateto,showall);
	    str += "]";
	    str += "};";
	    
	    staticobj.putRecordToObj("GM_GOALSHOW","GM_GOAL_"+hrmid+"_"+period+"_"+datefrom+"_"+dateto+"_"+showall,str);
	}
	
%>
<%@ include file="/secondwev/common/head.jsp" %>
	</head>
<body onload="init(json);">
	<script type="text/javascript">
		<%=str%>

		var show = "#F5D8B6";//"#DFA46A";//展开颜色
		var showinfo1 = "#b67434";
		var showinfo2 = "#fbeee0";
		var showinfo3 = "#ffffff";
		var showinfo33 = "#d69a60";
		
		var hassub = "#D1E3F7";//"#91B6DF";//含下级颜色
		var hassubinfo1 = "#668bb5";
		var hassubinfo2 = "#ffffff";
		var hassubinfo3 = "#ffffff";
		var hassubinfo33 = "#6196D1";
		
		var nosub = "#F2F2F2";//"#F9F9F9";//不含下级颜色
		var nosubinfo1 = "#9d9d9d";
		var nosubinfo2 = "#333333";
		var nosubinfo3 = "#E84C4C";
		var nosubinfo33 = "#f2f2f2";

		var cinit = 1;
		<%if(condtype.equals("2")){%>cinit = 1;<%}%>
	</script>
	<script language="javascript" type="text/javascript" src="/workrelate/js/jit/jit.js"></script>
	<script language="javascript" type="text/javascript" src="/workrelate/js/jit/excanvas.js"></script>
	<script language="javascript" type="text/javascript" src="/workrelate/js/jit/Hypertree.js"></script>
	<div id="center-container">
    <div id="infovis"></div>
	</div>
	<div id="right-container" style="">
		<table class="tableStyle">
		    <tr>
		        <td>
		        <div id="log"></div>
		        </td>
		    </tr>
		</table>
	</div>
	
</body>
</html>
<%!
	private String getInfo(String userid,int period,String datefrom,String dateto,boolean showall) throws Exception{
		if(userid.equals("")) return "";
		StringBuffer nowNode = new StringBuffer();
		RecordSet rs = new RecordSet();
		StringBuffer sql = new StringBuffer();
		sql.append("select t1.id,t1.name,t1.status,t1.creater,t1.principalid,t1.attribute,t1.target,t1.tunit,t2.orgId,t2.type"
				+" from GM_GoalInfo t1 left join GM_RightSetting t2 on t1.principalid=t2.hrmId"
				+" where (t1.deleted=0 or t1.deleted is null) and t1.principalid in ("+userid+")"
				+" and not exists(select 1 from GM_GoalInfo t3 where t1.parentid=t3.id and t3.principalid in ("+userid+"))"
		);
		
		if(period!=0){
			sql.append(" and t1.period="+period);
		}
		if(!datefrom.equals("")){
			sql.append(" and t1.enddate>='"+datefrom+"'");
		}
		if(!dateto.equals("")){
			sql.append(" and t1.enddate<='"+dateto+"'");
		}
		sql.append(" order by t1.showorder,t1.id");
		String goalname = "";
		double target = 0;
		String tunit = "";
		String orgid = "";
		int type = 0;
		rs.executeSql(sql.toString());
		String dataid = "";
		while(rs.next()){
			goalname = Util.null2String(rs.getString("name")); 
			target = Util.getDoubleValue(rs.getString("target"),0);
			tunit = Util.null2String(rs.getString("tunit")); 
			orgid = Util.null2String(rs.getString("orgId")); 
			type = Util.getIntValue(rs.getString("type"),0);
			dataid = String.valueOf(UUID.randomUUID());
			nowNode.append("{");
			nowNode.append("id: '" + UUID.randomUUID() + "',");
			//nowNode.append("name: '<div id=\"box"+dataid+"\" class=\"box\">" + this.getGoalTitle(userid,goalname,target,tunit,orgid,type) + "</div>',");
			nowNode.append("name: '"+goalname+"',");
			nowNode.append("data: {},");
			if(showall){
				nowNode.append("children: [" + this.getTree(Util.null2String(rs.getString("id")),period,datefrom,dateto) + "]");
			}
			nowNode.append("},");
			
		}
		String jsonstr = nowNode.toString();
	    if (jsonstr.lastIndexOf(",") != -1) {
	      return jsonstr.substring(0, jsonstr.length() - 1);
	    }
	    return jsonstr;
	}
	private String getTree(String supid,int period,String datefrom,String dateto) throws Exception{
		StringBuffer nowNode = new StringBuffer();
		RecordSet rs = new RecordSet();
		StringBuffer sql = new StringBuffer();
		sql.append("select t1.id,t1.name,t1.status,t1.creater,t1.principalid,t1.attribute,t1.target,t1.tunit,t2.orgId,t2.type"
				+" from GM_GoalInfo t1 left join GM_RightSetting t2 on t1.principalid=t2.hrmId"
				+" where (t1.deleted=0 or t1.deleted is null) and t1.id<>"+supid+" and t1.parentid="+supid);
		if(period!=0){
			sql.append(" and t1.period="+period);
		}
		if(!datefrom.equals("")){
			sql.append(" and t1.enddate>='"+datefrom+"'");
		}
		if(!dateto.equals("")){
			sql.append(" and t1.enddate<='"+dateto+"'");
		}
		sql.append(" order by t1.showorder,t1.id");
		String userid = "";
		String goalname = "";
		double target = 0;
		String tunit = "";
		String orgid = "";
		int type = 0;
		rs.executeSql(sql.toString());
		String dataid = "";
		while(rs.next()){
			userid = Util.null2String(rs.getString("principalid"));
			goalname = Util.null2String(rs.getString("name")); 
			target = Util.getDoubleValue(rs.getString("target"),0);
			tunit = Util.null2String(rs.getString("tunit")); 
			orgid = Util.null2String(rs.getString("orgId")); 
			type = Util.getIntValue(rs.getString("type"),0);
			dataid = String.valueOf(UUID.randomUUID());
			nowNode.append("{");
			nowNode.append("id: '" + UUID.randomUUID() + "',");
			//nowNode.append("name: '<div id=\"box"+dataid+"\" class=\"box\">" + this.getGoalTitle(userid,goalname,target,tunit,orgid,type) + "</div>',");
			nowNode.append("name: '"+goalname+"',");
			nowNode.append("data: {},");
			nowNode.append("children: [" + this.getTree(Util.null2String(rs.getString("id")),period,datefrom,dateto) + "]");
			nowNode.append("},");
		}
		String jsonstr = nowNode.toString();
	    if (jsonstr.lastIndexOf(",") != -1) {
	      return jsonstr.substring(0, jsonstr.length() - 1);
	    }
	    return jsonstr;
	}

	private String getGoalTitle(String userid,String goalname,double target,String tunit,String orgid,int type) throws Exception{
		StringBuffer title = new StringBuffer();
		String orgname = "";
		String titleinfo = "";
		ResourceComInfo ResourceComInfo = new ResourceComInfo();
		if(!orgid.equals("")){
			if(type==1){
				CompanyComInfo CompanyComInfo = new CompanyComInfo();
				orgname = CompanyComInfo.getCompanyname(orgid);
			}else if(type==2){
				SubCompanyComInfo SubCompanyComInfo = new SubCompanyComInfo();
				orgname = SubCompanyComInfo.getSubCompanyname(orgid);
			}else if(type==3){
				DepartmentComInfo DepartmentComInfo = new DepartmentComInfo();
				orgname = DepartmentComInfo.getDepartmentname(orgid);
			}
			titleinfo = orgname+"["+ResourceComInfo.getLastname(userid)+"]\\n";
		}else{
			orgname = ResourceComInfo.getLastname(userid);
			titleinfo = orgname + "\\n";
		}
		titleinfo += goalname;
		if(target!=0){
			titleinfo += "\\n"+target;
			if(!tunit.equals("")){
				titleinfo += " "+tunit;
			}
		}
		title.append("<table class=\"datatable\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" title=\""+titleinfo+"\">");
		title.append("<tr><td class=\"info1\">"+orgname+"</td></tr>");
		title.append("<tr><td class=\"info info2\" >"+goalname+"</td></tr>");
		if(target!=0){
			title.append("<tr><td class=\"info info3\">");
			title.append(target);
			if(!tunit.equals("")){
				title.append(" "+tunit);
			}
			title.append("</td></tr>");
		}
		return title.toString();
	}
%>