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
	
	.info3 a{float: right;}
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
	String  str = (String)staticobj.getRecordFromObj("GM_GOALSHOW","GM_GOAL_"+hrmid+"_"+period+"_"+datefrom+"_"+dateto+"_"+showall+"_"+condtype);
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
	    
	    staticobj.putRecordToObj("GM_GOALSHOW","GM_GOAL_"+hrmid+"_"+period+"_"+datefrom+"_"+dateto+"_"+showall+"_"+condtype,str);
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
	<script language="javascript" type="text/javascript" src="/workrelate/js/jit/spacetree.js"></script>
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
	
	<div style="width: 100%;line-height: 40px;height: 40px;font-size: 14px;color: #23A4FF;text-align: center;">展现方向</div>
	<table style="">
	    <tr>
	        <td>
	            <label for="r-left">左</label>
	        </td>
	        <td>
	            <input type="radio" id="r-left" name="orientation" checked="checked" value="left" />
	        </td>
	    </tr>
	    <tr>
	         <td>
	            <label for="r-top">上</label>
	         </td>
	         <td>
	            <input type="radio" id="r-top" name="orientation"  value="top" />
	         </td>
	    </tr>
	    <tr>
	         <td>
	            <label for="r-bottom">下</label>
	          </td>
	          <td>
	            <input type="radio" id="r-bottom" name="orientation" value="bottom" />
	          </td>
	    </tr>
	    <tr>
	          <td>
	            <label for="r-right">右</label>
	          </td> 
	          <td> 
	           <input type="radio" id="r-right" name="orientation" value="right" />
	          </td>
	    </tr>
	    <tr>
	    </tr>
	</table>
</div>
<div id="bg" style='display:none;z-index:10000;width:100%;height:100%;position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background: url(/workrelate/images/bg_ahp.png) repeat;' align='center'>
</div>
<div id="detail" style="width: 540px;height: auto;position: absolute;z-index: 10001;display: none;border: 1px #F2F2F2 solid;
border-radius: 4px;-moz-border-radius: 4px;-webkit-border-radius: 4px;">
	<div id="" style="width: 100%;height: 40px;position: relative;background: #F2F2F2;border-bottom: 1px #E8E8E8 solid;display: none;">
		<div style="position: absolute;left: 0px;line-height: 40px;margin-left: 5px;font-weight: bold;">目标明细</div>
		<div style="width: 30px;height: 40px;background: url('../images/btn_close.png') center no-repeat;cursor: pointer;
			position: absolute;right: 0px;" title="关闭" onclick="closeDetail()"></div>
	</div>
	<div style="width: 30px;height: 40px;background: url('../images/btn_close.png') center no-repeat;cursor: pointer;
			position: absolute;right: 2px;" title="关闭" onclick="closeDetail()"></div>
<iframe id="detailframe" style="width:100%;height:100%;" frameborder="0"></iframe>
</div>
<script type="text/javascript">
$(document).ready(function(){
 $(".jNiceRadio").click(function(){
    changeOperation($(this).parent().find("input[type='radio']"));
 });
});
	function showDetail(dataid){
		var goalid = $("#box"+dataid).attr("_goalid");
		//openOperateWindow("Main.jsp?showdetail=1&goalid="+goalid);
		
		
		var width = $(window).width();
		var height = $(window).height();
		
		
		var w = Math.round(width*0.6);
		var h = Math.round(height*0.8);
		var left = (width-w)/2;
		var top = (height-h)/2;
		
		//alert(height+"_"+h+"_"+top);
		
		$("#bg").show();
		$("#detailframe").height(h).attr("src","Main.jsp?showdetail=1&goalid="+goalid);
		$("#detail").css({"width":w,"height":h,"top":top,"left":left}).fadeIn(500);
	}
	function closeDetail(){
		
		$("#detail").fadeOut(500,function(){
			$("#bg").hide();
			$("#detailframe").attr("src","");
		});
	}
	
	function openOperateWindow(url){
		//openFullWindowHaveBar(url);
		
		  var redirectUrl = url ;
		  var width = screen.width ;
		  var height = screen.height ;
		  var top = height/2 - 260;
		  //alert(height+'-'+top);
		  var left = width/2 - 455;
		  var width = 910 ;
		  var height = 500 ;
		  var szFeatures = "" ;
		  szFeatures +="top="+top+"," ; 
		  szFeatures +="left="+left+"," ;
		  szFeatures +="width="+width+"," ;
		  szFeatures +="height="+height+"," ;
		  //szFeatures +="directories=no," ;
		  szFeatures +="status=yes,toolbar=no,location=no," ;
		  //szFeatures +="menubar=no," ;
		  szFeatures +="scrollbars=yes," ;
		  szFeatures +="resizable=yes" ; 
		  window.open(redirectUrl,"",szFeatures) ;
		  
	}
</script>
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
		String goalid = "";
		while(rs.next()){
			goalname = Util.null2String(rs.getString("name")); 
			target = Util.getDoubleValue(rs.getString("target"),0);
			tunit = Util.null2String(rs.getString("tunit")); 
			orgid = Util.null2String(rs.getString("orgId")); 
			type = Util.getIntValue(rs.getString("type"),0);
			dataid = String.valueOf(UUID.randomUUID());
			goalid = Util.null2String(rs.getString("id")); 
			nowNode.append("{");
			nowNode.append("id: '" + dataid + "',");
			nowNode.append("name: '<div id=\"box"+dataid+"\" class=\"box\"_goalid=\""+goalid+"\">" + this.getGoalTitle(userid,goalname,target,tunit,orgid,type,dataid) + "</div>',");
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
		String goalid = "";
		while(rs.next()){
			userid = Util.null2String(rs.getString("principalid"));
			goalname = Util.null2String(rs.getString("name")); 
			target = Util.getDoubleValue(rs.getString("target"),0);
			tunit = Util.null2String(rs.getString("tunit")); 
			orgid = Util.null2String(rs.getString("orgId")); 
			type = Util.getIntValue(rs.getString("type"),0);
			dataid = String.valueOf(UUID.randomUUID());
			goalid = Util.null2String(rs.getString("id")); 
			nowNode.append("{");
			nowNode.append("id: '" + dataid + "',");
			nowNode.append("name: '<div id=\"box"+dataid+"\" class=\"box\" _goalid=\""+goalid+"\">" + this.getGoalTitle(userid,goalname,target,tunit,orgid,type,dataid) + "</div>',");
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

	private String getGoalTitle(String userid,String goalname,double target,String tunit,String orgid,int type,String dataid) throws Exception{
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
		title.append("<tr><td class=\"info1\">"+orgname+"</a></td></tr>");
		title.append("<tr><td class=\"info info2\" >"+goalname+"</td></tr>");
		
		title.append("<tr><td class=\"info info3\">");
		if(target!=0){	
			title.append(target);
			if(!tunit.equals("")){
				title.append(" "+tunit);
			}
		}
		title.append("<a href=javascript:showDetail(\""+dataid+"\")>查看</a>");
		title.append("</td></tr>");
		
		title.append("</table>");
		return title.toString();
	}
%>