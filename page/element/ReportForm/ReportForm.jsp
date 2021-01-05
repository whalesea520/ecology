
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ page import="weaver.general.ColorUtil" %>
<%@ page import="org.apache.commons.configuration.Configuration" %>
<%@page import="weaver.general.GCONST"%>
<%@page import="weaver.general.Util"%>
<%@page import="org.apache.commons.configuration.XMLConfiguration"%>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<%@page import="org.w3c.dom.Document"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page"/>
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page"/>
<jsp:useBean id="dc" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="soc" class="weaver.synergy.SynergyOperatChart" scope="page"/>
<%
	/*
		基本信息
		--------------------------------------
		hpid:表首页ID
		subCompanyId:首页所属分部的分部ID
		eid:元素ID
		ebaseid:基本元素ID
		styleid:样式ID
		
		条件信息
		--------------------------------------
		String sqlWhere 格式为 条件1^,^条件2...
		int perpage  显示页数
		String linkmode 查看方式  1:当前页 2:弹出页

		
		字段信息
		--------------------------------------
		fieldIdList
		fieldColumnList
		fieldIsDate
		fieldTransMethodList
		fieldWidthList
		linkurlList
		valuecolumnList
		isLimitLengthList

		样式信息
		----------------------------------------
		String hpsb.getEsymbol() 列首图标
		String hpsb.getEsparatorimg()   行分隔线 
	*/

%>

<%
String reportFormId = "";
String reportFormTitle = "";
String reportFormHeight="";
String reportFormWidth="";
String reportFormSql = "";
String reportPoint="";
String reportFormPoint="";
String tabId = Util.null2String(request.getParameter("tabId"));
String sqlWhere = "";
//更新当前tab信息
String updateSql ="";
if(loginuser != null){

	updateSql = "update  hpcurrenttab set currenttab =? where eid=? and userid=? and usertype=?";
		
	rs.executeUpdate(updateSql,tabId,eid,loginuser.getUID(),loginuser.getType());

}

String chartSql = "select sqlWhere,tabTitle from hpNewsTabInfo where eid=? and tabId=?";
rs.executeQuery(chartSql,eid,tabId);
if(rs.next()){
	sqlWhere = rs.getString("sqlWhere");
	reportFormTitle = rs.getString("tabTitle");
}

if(!"".equals(sqlWhere)){
	int tempPos=sqlWhere.indexOf("^,^");
	if(tempPos!=-1){
		String[] arySqlWhere = sqlWhere.split("\\^,\\^",-1);
		if(arySqlWhere.length>5){
			reportFormId=arySqlWhere[0].trim();
			reportFormPoint=arySqlWhere[1].trim();
			reportFormWidth= arySqlWhere[2].trim();
			reportFormHeight = arySqlWhere[3].trim();
			reportPoint= arySqlWhere[4].trim();
			reportFormSql=arySqlWhere[5].trim();
		}else{
			reportFormId=arySqlWhere[0].trim();
			reportFormWidth= arySqlWhere[1].trim();
			reportFormHeight = arySqlWhere[2].trim();
			reportPoint= arySqlWhere[3].trim();
			reportFormSql=arySqlWhere[4].trim();
		}
		reportFormSql = weaver.general.Util.stringReplace4DocDspExt(reportFormSql);
		if(loginuser != null){
			int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
			reportFormSql = soc.getChartSql(eid,reportFormSql,loginuser,hpid,requestid);
		}	
	} 
}

if(Util.getIntValue(reportFormPoint)<0||Util.getIntValue(reportFormPoint)>10) reportFormPoint="0";
if(Util.getIntValue(reportFormId)<=11){
String reportFormSrc = "";
rs.executeQuery("select * from hpReportFormType where id =?",reportFormId);

if(rs.next()){
	reportFormSrc = "/FusionChartsFree/Charts/"+rs.getString("src");
	
}


            String strXML="";
            if(!reportPoint.equals("") && !reportPoint.equals("localhost")){
				//外部数据源
            	strXML =  hpes.getReportFormContentForHighChartWithDs(eid,reportFormId,reportFormTitle,reportFormSql,reportFormSrc,reportPoint,reportFormPoint);
            }else{
            	strXML =  hpes.getReportFormContentForHighChart(eid,reportFormId,reportFormTitle,reportFormSql,reportFormSrc,reportFormPoint);
            }
			strXML=strXML.replaceAll("&","＆");//如果部门字段中有特殊字符‘&’，会导致报表无法解析。
//TD34803 lv start           
String newReportFormSrc = "";
//对strXML进行解析，得到正确的图表可用xml及新的图表swf文件路径。
if(strXML.indexOf("^^^,^^^")>-1){
	newReportFormSrc = strXML.substring(strXML.indexOf("^^^,^^^")+7);
	strXML = strXML.substring(0,strXML.indexOf("^^^,^^^"));
}

//TD34803 lv end    
//baseBean.writeLog("reportFormSrc="+reportFormSrc+"\n"+"newReportFormSrc="+newReportFormSrc+"\n"+"strXML="+strXML);
if(!"".equals(reportFormSql.trim())){
			if("".equals(strXML))strXML="<graph></graph>";
			session.setAttribute(eid,strXML);
            response.setContentType("text/html;charset=utf-8");
			
            %> 
        <CENTER>
            <% 				
				if(reportFormWidth.indexOf("%")<0){
				  reportFormWidth=reportFormWidth+"px";
				}
				if(reportFormHeight.indexOf("%")<0){
				  reportFormHeight=reportFormHeight+"px";
				}
				%>
             <div style='width:<%=reportFormWidth%>;height:<%=reportFormHeight%>;' id='reportformchart_<%=eid%>'> 
			 <iframe src="/page/element/ReportForm/chartshow.jsp"   id="chartmainFrame_<%=eid%>" align="top" border="0" frameborder="no" noresize="NORESIZE" height="100%" width="100%" scrolling="auto" style="height:100%;width:100%;"></iframe>
			 </div>
			 <script>
				    function checkonLoad_<%=eid%>(){
					    try{
			
					    	var frameData ;
					    	
						    try{
						    
						    	frameData =jQuery("#chartmainFrame_<%=eid%>")[0].contentDocument.body;
						    }catch(e){
						   		frameData =jQuery("#chartmainFrame_<%=eid%>")[0].contentWindow.document.body;
							} 	
				  			var container=jQuery(frameData).find(".chartarea");
				  			
				  		
						    if(container.length>0){
						    
								  container.css("width",$("#reportformchart_<%=eid%>").width()-20);
		                          container.css("height",$("#reportformchart_<%=eid%>").height()-20);
								  container.css("overflow","hidden");
							      var chartwin=$("#chartmainFrame_<%=eid%>")[0].contentWindow;
		                          chartwin.generatorSimpechart('<%=reportFormId%>',<%=strXML%>,'<%=reportFormPoint%>');
							  //console.dir(<%=strXML%>);
							  }else{
							    setTimeout(function(){
								   checkonLoad_<%=eid%>(); 
								},500);
							  }
						}catch(e){
							setTimeout(function(){
								   checkonLoad_<%=eid%>(); 
								},500);
		
						}	 
					}

					checkonLoad_<%=eid%>();
			 </script>
        </CENTER>

<%}}%>