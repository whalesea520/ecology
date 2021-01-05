
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CarTypeComInfo" class="weaver.car.CarTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}
</script>
<%
int userId=0, subCompanyId=0;
userId = user.getUID();
RecordSet.executeSql("select carsdetachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
    detachable=RecordSet.getInt(1);
   
}
String sqlwhere = " where 1=1";
//int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);

//if(detachable==1){
//subCompanyId = user.getUserSubCompany1();
//}
//else
//{
//  subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
//}

if(detachable==1){
	if(!"".equals(Util.null2String(request.getParameter("subCompanyId")))){
		subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
	}
	//operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Car:Maintenance",subCompanyId);
	if(userId!=1){
		String sqltmp = "";
		String blonsubcomid="";
		char flag=Util.getSeparator();
		rs2.executeProc("HrmRoleSR_SeByURId", ""+userId+flag+"Car:Maintenance");
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
	subCompanyId = -1;
}


String carNo = Util.null2String(request.getParameter("carNo"));
String carType = Util.null2String(request.getParameter("carType"));
String factoryNo = Util.null2String(request.getParameter("factoryNo"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));

if(!carNo.equals("")){
	sqlwhere += " and carNo like '%"+carNo+"%'";
}
if(!carType.equals("")){
	sqlwhere += " and carType="+carType+"";
}
if(!factoryNo.equals("")){
	sqlwhere += " and factoryNo like '%"+factoryNo+"%'";
}
if(!startdate.equals("")){
	sqlwhere += " and buyDate >= '"+startdate+"'";
}
if(!enddate.equals("")){
	sqlwhere += " and buyDate <= '"+enddate+"'";
}

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
%>

<BODY style="overflow:hidden;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="car"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("920",user.getLanguage()) %>'/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top}";//清除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_top}" ;//取消
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;"><!-- 搜索 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top"  onclick="submitData()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CarInfoBrowser.jsp" method=post>
  <input type="hidden" id="pagenum" name="pagenum" value="<%=pagenum%>">

<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'><!-- 查询条件 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(20318,user.getLanguage())%></wea:item><!-- 厂牌型号 -->
		<wea:item><input class=InputStyle  name=factoryNo value='<%=factoryNo%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(20319,user.getLanguage())%></wea:item><!-- 车牌号 -->
		<wea:item><input class=InputStyle  name=carNo value='<%=carNo%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage())%></wea:item><!-- 类型 -->
		<wea:item>
			<select name="carType">
				<option value="">
       			<%
       			RecordSet.executeProc("CarType_Select","");
       			while(RecordSet.next()){
       			%>
       			<option value="<%=RecordSet.getString("id")%>" <%if(carType.equals(RecordSet.getString("id"))){%>selected<%}%>><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>
       			<%}%>
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></wea:item><!-- 购置日期 -->
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>&nbsp;&nbsp;<!-- 从 -->
			<BUTTON type="button" class=Calendar onclick="getDate(startdatespan,startdate)"></BUTTON> 
			<SPAN id=startdatespan><%=startdate%></SPAN> 
			<input type="hidden" name="startdate" value="<%=startdate%>">
			<%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>&nbsp;&nbsp;<!-- 到 -->
			<BUTTON type="button" class=Calendar onclick="getDate(enddatespan,enddate)"></BUTTON> 
			<SPAN id=enddatespan><%=enddate%></SPAN> 
			<input type="hidden" name="enddate" value="<%=enddate%>">
		</wea:item>
	</wea:group>
</wea:layout>
<%
String orderby =" id ";
String tableString = "";
int perpage=6;
String backfields = " id,factoryno,carno,cartype,driver,buydate";
String fromSql  = " CarInfo ";
//out.println("select "+backfields+fromSql+sqlwhere);

tableString =   " <table instanceid=\"BrowseTable\" id=\"BrowseTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"0%\"  text=\""+"ID"+"\" column=\"id\"    />"+
                "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(20319,user.getLanguage())+"\" column=\"carno\" orderkey=\"carno\" />"+ //车牌号
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(20318,user.getLanguage())+"\" column=\"factoryno\" orderkey=\"factoryno\"   />"+ //厂牌型号
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(22256,user.getLanguage())+"\" column=\"cartype\" orderkey=\"cartype\" transmethod='weaver.car.CarTypeComInfo.getCarTypename'  />"+ //类型
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17649,user.getLanguage())+"\" column=\"driver\" orderkey=\"driver\" transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename'  />"+ //司机
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16914,user.getLanguage())+"\" column=\"buydate\" orderkey=\"buydate\" />"+ //购置日期
                "       </head>"+
                " </table>";
                //System.out.println("---tableString---"+tableString);
%>
<wea:SplitPageTag tableString='<%=tableString%>' mode="run"></wea:SplitPageTag>
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="btnclear_onclick();"> <!-- 清除 -->
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();"> <!-- 取消 -->
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</body>
<script language="javascript">
function btnclear_onclick(){
	if(dialog){
		var returnjson={id:"",name:""};
		try{
            dialog.callback(returnjson);
       }catch(e){}
	  	try{
	       dialog.close(returnjson);
	   }catch(e){}
	}else{
		window.parent.returnValue = {id:"",name:""};
		window.parent.close();
	}
}
function submitData()
{
	if (check_form(SearchForm,'')){
		document.getElementById("pagenum").value = "1";
		SearchForm.submit();
	}
}

function submitClear()
{
	btnclear_onclick();
}

function nextPage(){
	document.getElementById("pagenum").value=parseInt(document.getElementById("pagenum").value)+1 ;
	SearchForm.submit();	
}

function perPage(){
	document.getElementById("pagenum").value=parseInt(document.getElementById("pagenum").value)-1 ;
	SearchForm.submit();
}



jQuery(document).ready(function(){
	$("#_xTable").find("table.ListStyle").live('click',BrowseTable_onclick);
})
function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
	   
	   if(dialog){
			var returnjson={id:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()};
			try{
	            dialog.callback(returnjson);
	       }catch(e){}
		  	try{
		       dialog.close(returnjson);
		   }catch(e){}
		}else{
     		window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()};
	 		window.parent.parent.close();
		}
	}
}
</script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
