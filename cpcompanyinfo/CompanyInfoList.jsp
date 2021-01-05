
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.company.CompanyUtil"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/cpcompanyinfo/style/Business_wev8.css" rel="stylesheet"  type="text/css" />
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@page import="java.util.*"%>
<%@page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs01" class="weaver.conn.RecordSet" scope="page" />
<%
String flowTitle=Util.null2String(request.getParameter("flowTitle"));
String c_id = Util.null2String(request.getParameter("c_id"));
String openNew = Util.null2String(request.getParameter("openNew"));
String maintFlag = Util.null2String(request.getParameter("maintFlag"));
String titlename = SystemEnv.getHtmlLabelNames("30905",user.getLanguage());
String COMPANYNAME=Util.null2String(request.getParameter("COMPANYNAME"));
String COMPANYENAME=Util.null2String(request.getParameter("COMPANYENAME"));
String COMPANYREGION=Util.null2String(request.getParameter("COMPANYREGION"));
String CORPORATION=Util.null2String(request.getParameter("CORPORATION"));
String GENERALMANAGER=Util.null2String(request.getParameter("GENERALMANAGER"));
String THEBOARD=Util.null2String(request.getParameter("THEBOARD"));
String BOARDVISITORS=Util.null2String(request.getParameter("BOARDVISITORS"));

rs01.executeSql("select id from HrmCity where cityname = '"+COMPANYREGION+"'");
String cityname= "";
while(rs01.next()){
	cityname = rs01.getString("id");
}


%>

<form id="weaver" name="weaver" method="post" action="/cpcompanyinfo/CompanyInfoList.jsp">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		
			<input type="text" class="searchInput" name="flowTitle" value="<%=flowTitle %>" />
			<span id="advancedSearch" class="advancedSearch" style="display:"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("84092",user.getLanguage())%>' attributes="">
		<wea:item type="groupHead">
	     	<%if(maintFlag.equals("true")){ %>
		     	<input class="addbtn" accesskey="A" onclick="newCompany()" title="<%=SystemEnv.getHtmlLabelNames("611",user.getLanguage())%>" type="button">
				<input class="delbtn" accesskey="E" onclick="onBatchDel()" title="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>" type="button">
			<%} %>
	    </wea:item>
	    <wea:item attributes="{'isTableList':'true'}"> 
<%	
	String refFarenParam = "";//法人
	String refDshParam = "";//董事会
	String refZhzhParam = "";//证照
	String refGdParam = "";//股东
	String refZhchParam = "";//章程
	String chzhzh = "";
	String chdsh = "";
	String chgd = "";
	String chzhch = "";
	String chxgs = "";
	
	rs.execute("SELECT * FROM CPCOMPANYTIMEOVER");
	if(rs.next()){
		refFarenParam = rs.getString("tofaren");
		refDshParam = rs.getString("todsh");
		refZhzhParam = rs.getString("tozhzh");
		refGdParam = rs.getString("togd");
		refZhchParam = rs.getString("tozhch");
		
		chzhzh = rs.getString("chzhzh");
		chdsh = rs.getString("chdsh");
		chgd = rs.getString("chgd");
		chzhch = rs.getString("chzhch");
		chxgs = rs.getString("chxgs");
	}
	
	String userManager="";
	CompanyUtil cu=new CompanyUtil();
	 if(!cu.canOperate(user,"2")){
		//得到当前用户管辖那几个公司
		userManager=cu.canOperateCOM(user,"2");
	}else{
		userManager="ALL";
	}
	if("".equals(userManager)){
		//防止报错，如果传个空字符串进去会报错
		userManager="NONE";
	}
	//要查找的列
	JSONObject operatorInfo=new JSONObject();
	String businesstype = Util.null2String(request.getParameter("businesstype"));
	String ischzhzh =  Util.null2String(request.getParameter("o4chzhzh"));
	String ischzhch =  Util.null2String(request.getParameter("o4chzhch"));
	String ischgd =  Util.null2String(request.getParameter("o4chgd"));
	String ischdsh =  Util.null2String(request.getParameter("o4chdsh"));
	String ischxgs =  Util.null2String(request.getParameter("o4chxgs"));
	//System.out.println("businesstype=="+businesstype);
	String issearchTX = Util.null2String(request.getParameter("o4searchTx"));
	String issearchSL = Util.null2String(request.getParameter("o4searchSL"));
	int language=user.getLanguage();
	String checkWhichs = "";
	
	String zrrid="";//得到自然人的id
	String  isShowZrr="NONE";
	if(rs.execute("select id,name from CompanyBusinessService where affixindex=-1")&&rs.next()){
		zrrid=rs.getString("id");
	}
	 if(zrrid.equals(businesstype)){
	 		isShowZrr="HAVE";
	 }
	if("sqlserver".equals(rs.getDBType())){
		if(ischzhzh.equals("on")){
			
			checkWhichs+=" and exists ( select tlv.companyid from CPBUSINESSLICENSEVERSION tlv where t1.companyid = tlv.companyid  and  datediff(day,CONVERT(varchar(100), tlv.createdatetime, 23),CONVERT(varchar(100), getdate(), 23))  "+Util.toHtmlForSplitPage("<") +chzhzh+") ";
		}
		if(ischzhch.equals("on")){
			checkWhichs+=" and exists (  select tcv.companyid from CPCONSTITUTIONVERSION tcv where t1.companyid = tcv.companyid and  datediff(day,CONVERT(varchar(100), tcv.createdatetime, 23),CONVERT(varchar(100), getdate(), 23))  "+Util.toHtmlForSplitPage("<") +chzhch+") ";
		}
		if(ischgd.equals("on")){
			checkWhichs+=" and exists ( select tsv.companyid from CPSHAREHOLDERVERSION tsv where t1.companyid = tsv.companyid and  datediff(day,CONVERT(varchar(100), tsv.createdatetime, 23),CONVERT(varchar(100), getdate(), 23))  "+Util.toHtmlForSplitPage("<") +chgd+") ";
		}
		if(ischdsh.equals("on")){
			checkWhichs+=" and exists ( select tbv.companyid from CPBOARDVERSION tbv where t1.companyid = tbv.companyid and datediff(day,CONVERT(varchar(100), tbv.createdatetime, 23),CONVERT(varchar(100), getdate(), 23)) "+Util.toHtmlForSplitPage("<") +chdsh+") ";
		}
		if(ischxgs.equals("on")){
				//--------------------------datediff 这个函数在oracle中是没有的呀---------------------------------------------------------------------------------------------------
			//checkWhichs+=" and datediff(day,CONVERT(varchar(100), t2.usefulbegindate, 23),CONVERT(varchar(100), getdate(), 23))  " +Util.toHtmlForSplitPage("<") +chxgs;
			
			checkWhichs+=" and  t1.companyid  in(   ";   
			checkWhichs+=" select companyid  from (   ";                                
				checkWhichs+="select  companyid,foundingtime begdata, ";        
				checkWhichs+="CONVERT(varchar(100),DATEADD(day,("+chxgs+"-1),foundingtime),23 )enddata, ";        
				checkWhichs+="CONVERT(varchar(100),getdate(),23)curdata  ";        
				checkWhichs+="from CPCOMPANYINFO  ";        
			checkWhichs+=" ) s where curdata"+Util.toHtmlForSplitPage(">")+"=begdata and curdata "+Util.toHtmlForSplitPage("<")+"=enddata )";        

		}
	
	}else{
		if(ischzhzh.equals("on")){
			checkWhichs+=" and exists (select tlv.companyid from CPBUSINESSLICENSEVERSION tlv where t1.companyid = tlv.companyid and  TO_NUMBER(to_date((select to_char(sysdate,'YYYY-MM-DD') datetime from dual),'YYYY-MM-DD')-to_date(substr(tlv.createdatetime,0,10),'YYYY-MM-DD')) "+Util.toHtmlForSplitPage("<") +chzhzh+") ";
		}
		if(ischzhch.equals("on")){
			checkWhichs+=" and exists (select tcv.companyid from CPCONSTITUTIONVERSION tcv where t1.companyid = tcv.companyid and  TO_NUMBER(to_date((select to_char(sysdate,'YYYY-MM-DD') datetime from dual),'YYYY-MM-DD')-to_date(substr(tcv.createdatetime,0,10),'YYYY-MM-DD')) "+Util.toHtmlForSplitPage("<") +chzhch+") ";
		}
		if(ischgd.equals("on")){
			checkWhichs+=" and exists (select tsv.companyid from CPSHAREHOLDERVERSION tsv where t1.companyid = tsv.companyid and  TO_NUMBER(to_date((select to_char(sysdate,'YYYY-MM-DD') datetime from dual),'YYYY-MM-DD')-to_date(substr(tsv.createdatetime,0,10),'YYYY-MM-DD')) "+Util.toHtmlForSplitPage("<") +chgd+") ";
		}
		if(ischdsh.equals("on")){
			checkWhichs+=" and exists (select tbv.companyid from CPBOARDVERSION tbv where t1.companyid = tbv.companyid and  TO_NUMBER(to_date((select to_char(sysdate,'YYYY-MM-DD') datetime from dual),'YYYY-MM-DD')-to_date(substr(tbv.createdatetime,0,10),'YYYY-MM-DD')) "+Util.toHtmlForSplitPage("<") +chdsh+") ";
		}
		if(ischxgs.equals("on")){
		
			//checkWhichs+=" and TO_NUMBER(to_date((select to_char(sysdate,'YYYY-MM-DD') datetime from dual),'YYYY-MM-DD')-to_date(t2.usefulbegindate,'YYYY-MM-DD'))" +Util.toHtmlForSplitPage("<") +chxgs;
			
			checkWhichs+="and  t1.companyid  in( ";
				checkWhichs+=" select companyid from ( ";
			checkWhichs+=" select companyid,companyname,foundingtime begin ,to_char(trunc(to_date(foundingtime,'yyyy-mm-dd')+("+chxgs+"-1)),'yyyy-mm-dd') enddata, ";
			checkWhichs+="  (  ";
		   	checkWhichs+="  select to_char(sysdate,'YYYY-MM-DD') datetime from dual) cur  ";
		     	checkWhichs+="       from CPCOMPANYINFO    ";
		 	checkWhichs+="  ) where cur "+Util.toHtmlForSplitPage(">")+"=begin and cur "+Util.toHtmlForSplitPage("<")+"=enddata  ";
				checkWhichs+=" ) ";
				} 
	}
	
	if(!issearchTX.equals("")){
		if(!issearchSL.equals("t1.COMPANYREGION")){
			checkWhichs +=" and "+issearchSL+" like '%"+issearchTX+"%'";
		}else{
			checkWhichs += "and exists (select hc.id from hrmcity hc where t1.companyregion = hc.id and hc.cityname like '%"+issearchTX+"%')";
		}
	}
	String backfields="";
	if("sqlserver".equals(rs.getDBType())){
			backfields = " t4.appointenddate, t1.companyid, ISNULL(t1.foundingTime,'') foundingTime,t1.archivenum,t1.companyregion,t1.companyname,t2.usefulbegindate,t2.registercapital,t2.companytype,t2.usefulenddate,t3.stituenddate,t3.effectenddate,(case substring(t1.archivenum,0,1) when 'L' then 1 when 'H' then 2 when 'R' then 3 when 'W' then 4 end ) as abilty , '"+userManager+"' as  userManager,'"+isShowZrr+"' as  isShowZrr,"+language+" as language";
	}else{
		 backfields = " t4.appointenddate,  t1.companyid,t1.foundingTime,t1.archivenum,t1.companyregion,t1.companyname,t2.usefulbegindate,t2.registercapital,t2.companytype,t2.usefulenddate,t3.stituenddate,t3.effectenddate,(case substr(t1.archivenum,0,1) when 'L' then 1 when 'H' then 2 when 'R' then 3 when 'W' then 4 end ) as abilty , '"+userManager+"' as  userManager,'"+isShowZrr+"' as  isShowZrr ,"+language+" as language";
	}
	String fromSql = " CPCOMPANYINFO t1 left join (select tb.* from CPBUSINESSLICENSE tb,CPLMLICENSEAFFIX tl where tb.licenseaffixid=tl.licenseaffixid and tl.licensetype=1 and tb.isdel='T') t2 on t1.companyid = t2.companyid left join CPCONSTITUTION t3 on  t1.companyid=t3.companyid  left join CPBOARDDIRECTORS t4 on t1.companyid=t4.companyid";
	String sqlwhere = " where t1.isdel='T' "+checkWhichs;
	if(!businesstype.equals("")) {sqlwhere += " and t1.businesstype = " + businesstype;
	}else{ 
	sqlwhere += " and t1.businesstype  not in( select id from CompanyBusinessService where affixindex=-1) ";}	//过滤掉自然人
	
	
	
	if(!"".equals(flowTitle)){
		sqlwhere +=" and t1.COMPANYNAME like '%"+flowTitle+"%' ";
	}
	
	if(!"".equals(COMPANYNAME)){
		sqlwhere +=" and t1.COMPANYNAME like '%"+COMPANYNAME+"%' ";
	}
	
	if(!"".equals(COMPANYENAME)){
		sqlwhere +=" and t1.COMPANYENAME like '%"+COMPANYENAME+"%' ";
	}
	if(!"".equals(COMPANYREGION)){
		sqlwhere +=" and t1.COMPANYREGION = '"+cityname+"' ";
	}
	if(!"".equals(CORPORATION)){
		sqlwhere +=" and t2.CORPORATION like '%"+CORPORATION+"%' ";
	}
	if(!"".equals(GENERALMANAGER)){
		sqlwhere +=" and t3.GENERALMANAGER like '%"+GENERALMANAGER+"%' ";
	}
	if(!"".equals(THEBOARD)){
		sqlwhere +=" and t3.THEBOARD like '%"+THEBOARD+"%' ";
	}
	if(!"".equals(BOARDVISITORS)){
		sqlwhere +=" and t3.BOARDVISITORS like '%"+BOARDVISITORS+"%' ";
	}
	if(!"".equals(c_id)){
		sqlwhere += " and t1.BUSINESSTYPE = '" + c_id+"' ";
	}
	
	// href=javascript:window.parent.location.href='/cpcompanyinfo/CompanyManageMain.jsp?companyid="+refCompanyNameParam+"';
	String sqlorderby = " t1.companyid ";
	
	//System.out.println(sqlwhere);
	
	String pageId="cpcompanyinfo_companyinfolist";
	String refCompanyNameParam = "column:companyid+column:userManager+column:isShowZrr";
	String refComlog="column:userManager+column:isShowZrr+column:language";
	StringBuffer tableString = new StringBuffer();
	tableString .append(" <table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID())+"\" width=\"100%\" isfixed=\"true\" isnew= \"true\" _style= \"true\"> ");
	tableString .append(" <checkboxpopedom id=\"checkbox\"   popedompara=\"column:companyid\" showmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getIsShowBox\" />");
	tableString .append(" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+sqlwhere+"\"  sqlorderby=\""+sqlorderby+"\"  sqlprimarykey=\"t1.companyid\" sqlsortway=\"desc\"  />");
	tableString .append(" <head>");         
	 if(zrrid.equals(businesstype)){
	 		tableString.append(" width=\"8%\"   <col   text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage()) +"\"  column=\"archivenum\"   orderkey=\"archivenum\"  align=\"center\" />");
		    tableString.append(" width=\"10%\"  <col   text=\""+SystemEnv.getHtmlLabelName(28100,user.getLanguage()) +"\" column=\"companyregion\"    align=\"center\" transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getCompanyRegion\"/>");
		    tableString.append(" width=\"10%\"  <col   text=\""+SystemEnv.getHtmlLabelName(31445,user.getLanguage()) +"\" column=\"companyname\"   align=\"center\"  	otherpara=\""+refCompanyNameParam+"\"  transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.setCompanyNameRef\" />");
		    tableString.append("</head> ");
		    tableString.append(" <operates>");
		    tableString.append(" <popedom  column=\"companyid\"  otherpara=\""+refComlog+"\" transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getOperating4E8\" ></popedom> ");
		    tableString.append("<operate href=\"javascript:onView()\" text=\""+SystemEnv.getHtmlLabelNames("367",user.getLanguage())+"\" target=\"_self\" index=\"0\"/>");
		    tableString.append("<operate href=\"javascript:onEdit()\" text=\""+SystemEnv.getHtmlLabelNames("93",user.getLanguage())+"\" target=\"_self\" index=\"1\"/>");
		    tableString.append("<operate href=\"javascript:onDel()\" text=\""+SystemEnv.getHtmlLabelNames("91",user.getLanguage())+"\" target=\"_self\" index=\"2\"/>");
		    tableString.append("<operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelNames("83",user.getLanguage())+"\" target=\"_self\" index=\"3\"/>");
		    tableString.append("</operates>");
	 }else{
	 	    tableString.append(" width=\"8%\"   <col   text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage()) +"\"  column=\"archivenum\"   orderkey=\"archivenum\"  align=\"center\"   		  />");
		    tableString.append(" width=\"10%\"  <col   text=\""+SystemEnv.getHtmlLabelName(28100,user.getLanguage()) +"\" column=\"companyregion\"    align=\"center\" transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getCompanyRegion\" 	 />");
		    tableString.append(" width=\"10%\"  <col   text=\""+SystemEnv.getHtmlLabelName(1976,user.getLanguage()) +"\" column=\"companyname\"   align=\"center\"  	otherpara=\""+refCompanyNameParam+"\"  transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.setCompanyNameRef\" />");        
		    tableString.append(" width=\"10%\"  <col   text=\""+SystemEnv.getHtmlLabelName(30975,user.getLanguage()) +"\"   column=\"foundingTime\" orderkey=\"foundingTime\" align=\"center\"   />");
		    tableString.append(" width=\"10%\" 	<col   text=\""+SystemEnv.getHtmlLabelName(30976,user.getLanguage()) +"\" column=\"companytype\"   orderkey=\"companytype\"  align=\"center\"  />");     
		    tableString.append(" width=\"8%\" 	<col   text=\""+SystemEnv.getHtmlLabelName(20668,user.getLanguage()) +"\" column=\"registercapital\"    align=\"center\"  />");           
		    tableString.append(" width=\"5%\" 	<col   text=\""+SystemEnv.getHtmlLabelName(23797,user.getLanguage()) +"\" column=\"usefulenddate\"  	 align=\"center\" otherpara=\""+refFarenParam+"_"+language+"\"  transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getToCompairDate\"  />");    
		    tableString.append(" width=\"5%\" 	<col   text=\""+SystemEnv.getHtmlLabelName(30936,user.getLanguage()) +"\" column=\"appointenddate\"    align=\"center\"   otherpara=\""+refDshParam+"_"+language+"\"  transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getToCompairDate\" />"); 
		    tableString.append(" width=\"8%\" 	<col   text=\""+SystemEnv.getHtmlLabelName(30958,user.getLanguage()) +"\" column=\"companyid\"    align=\"center\"    otherpara=\""+refZhzhParam+"_"+language+"\"  transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getToCompairLicenseDate\" />");
		    tableString.append(" width=\"5%\" 	<col   text=\""+SystemEnv.getHtmlLabelName(28421,user.getLanguage()) +"\" column=\"companyid\"    align=\"center\"   otherpara=\""+language+"\"   transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getToGd\"  />");
		    tableString.append(" width=\"5%\" 	<col   text=\""+SystemEnv.getHtmlLabelName(30941,user.getLanguage()) +"\" column=\"effectenddate\"    align=\"center\"    otherpara=\""+refZhchParam+"_"+language+"\"  transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getToCompairDate\" />");
			
		    
		   
		    tableString.append("</head> ");
		    tableString.append(" <operates>");
		    tableString.append(" <popedom  column=\"companyid\"  otherpara=\""+refComlog+"\" transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getOperating4E8\" ></popedom> ");
		    tableString.append("<operate href=\"javascript:onView()\" text=\""+SystemEnv.getHtmlLabelNames("367",user.getLanguage())+"\" target=\"_self\" index=\"0\"/>");
		    tableString.append("<operate href=\"javascript:onEdit()\" text=\""+SystemEnv.getHtmlLabelNames("93",user.getLanguage())+"\" target=\"_self\" index=\"1\"/>");
		    tableString.append("<operate href=\"javascript:onDel()\" text=\""+SystemEnv.getHtmlLabelNames("91",user.getLanguage())+"\" target=\"_self\" index=\"2\"/>");
		    tableString.append("<operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelNames("83",user.getLanguage())+"\" target=\"_self\" index=\"3\"/>");
		    tableString.append("</operates>");

	   
		 
	 }
    tableString.append("</table>");
%>
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
<wea:SplitPageTag   tableString='<%=tableString.toString()%>'  mode="run"  isShowTopInfo="false" isShowBottomInfo="true"/>	

<% 
if(zrrid.equals(businesstype)){
	%>	
	<input type="hidden" id="businesstype" name="businesstype" value="1"  />
<% 	
}
%>

<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
	    <% 
if(zrrid.equals(businesstype)){
	%>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(31445,user.getLanguage())%></wea:item>
	    	<wea:item><input class=InputStyle type="text" maxlength=60 name="COMPANYNAME" size=30 value='<%=COMPANYNAME%>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(27740,user.getLanguage())%></wea:item>
	    	<wea:item><input class=InputStyle type="text" maxlength=60 name="COMPANYENAME" size=30 value='<%=COMPANYENAME%>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(31077,user.getLanguage())%></wea:item>
	    	<wea:item><input class=InputStyle type="text" maxlength=60 name="COMPANYREGION" size=30 value='<%=COMPANYREGION%>'></wea:item>
	    	<% 
}else{
	%>
	<wea:item><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%></wea:item>
	    	<wea:item><input class=InputStyle type="text" maxlength=60 name="COMPANYNAME" size=30 value='<%=COMPANYNAME%>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(27740,user.getLanguage())%></wea:item>
	    	<wea:item><input class=InputStyle type="text" maxlength=60 name="COMPANYENAME" size=30 value='<%=COMPANYENAME%>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(31077,user.getLanguage())%></wea:item>
	    	<wea:item><input class=InputStyle type="text" maxlength=60 name="COMPANYREGION" size=30 value='<%=COMPANYREGION%>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(23797,user.getLanguage())%></wea:item>
	    	<wea:item><input class=InputStyle type="text" maxlength=60 name="CORPORATION" size=30 value='<%=CORPORATION%>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(20696,user.getLanguage())%></wea:item>
	    	<wea:item><input class=InputStyle type="text" maxlength=60 name="GENERALMANAGER" size=30 value='<%=GENERALMANAGER%>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(30936,user.getLanguage())%></wea:item>
	    	<wea:item><input class=InputStyle type="text" maxlength=60 name="THEBOARD" size=30 value='<%=THEBOARD%>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(31041,user.getLanguage())%></wea:item>
	    	<wea:item><input class=InputStyle type="text" maxlength=60 name="BOARDVISITORS" size=30 value='<%=BOARDVISITORS%>'></wea:item>
	    	<%} %>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="zd_btn_submit" type="submit" name="submit1" onclick="doSubmit();" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>"/>
	    		<input class="zd_btn_cancle" type="reset" name="reset" onclick="resetCondtion();" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
	    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
	    	</wea:item>
	    </wea:group>
	</wea:layout> 
</div>	 
	



<div id="remindtbl" style="width:245px;border:1px solid #DCDCDC;background:#ffffcc;position:absolute;left:780px;top:70px;display:none;">
<table  >
<TBODY>
<TR><TD>
&nbsp;
	<img src="images/O_37_wev8.jpg" align='absMiddle' />&nbsp;<%=SystemEnv.getHtmlLabelName(31074,user.getLanguage())%>&nbsp;&nbsp;
	<img src="images/O_39_wev8.jpg" align='absMiddle' />&nbsp;<%=SystemEnv.getHtmlLabelName(31075,user.getLanguage())%>&nbsp;&nbsp;
	<img src="images/O_38_wev8.jpg" align='absMiddle' />&nbsp;<%=SystemEnv.getHtmlLabelName(31076,user.getLanguage())%>&nbsp;&nbsp;
</TD></TR>
</TBODY>
</table>
</div>

<script type="text/javascript">
function doSubmit() {
	weaver.submit();
}
	function getOperating(id,companyid){
			if(id==1){
				window.parent.beforeEditorView('viewBtn',companyid);
			}else if(id==2){
				window.parent.beforeEditorView('editBtn',companyid);
			}else if(id==3){
				window.parent.delMutiList2Info(companyid);
			}else if(id==4){
				window.parent.openLogView(companyid);
			}
	}
	/*刷新自身页面*/
	function reloadListContent(){
		window.location.reload();
	}
	/*获得公司资料 ID*/
	function getrequestids(){
		var requestids = _xtable_CheckedCheckboxId();
		return requestids;
	}
	function openConter(companyid,showOrUpdate){
			<%
				 if(!zrrid.equals(businesstype)){
			%>
				window.parent.location.href="/cpcompanyinfo/CompanyManageMain.jsp?companyid="+companyid+"&showOrUpdate="+showOrUpdate;
			<%	 
				 }
			%>
			
	}	
	
	//	openDialog(url,title,850,550,false,true);
	
	/*新建公司*/
	function newCompany(){
		diag_vote = new window.top.Dialog();
		diag_vote.currentWindow = window;
		diag_vote.Width = 600;
		diag_vote.Height = 800;
		diag_vote.Modal = true;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelNames("31049",user.getLanguage())%>";
		diag_vote.URL = "/cpcompanyinfo/CompanyInfoMaint.jsp?btnid=newBtn"
		diag_vote.isIframe=false;
		diag_vote.show();
	}
	
	/*查看*/
	function onView(id){
		if(id){
			diag_vote = new window.top.Dialog();
			diag_vote.currentWindow = window;
			diag_vote.Width = 600;
			diag_vote.Height = 800;
			diag_vote.Modal = true;
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelNames("367",user.getLanguage())%>";
			diag_vote.URL = "/cpcompanyinfo/CompanyInfoMaint.jsp?companyid="+id+"&btnid=viewBtn"
			diag_vote.isIframe=false;
			diag_vote.show();
		}
	}
	/*编辑*/
	function onEdit(id){
		if(id){
			diag_vote = new window.top.Dialog();
			diag_vote.currentWindow = window;
			diag_vote.Width = 600;
			diag_vote.Height = 800;
			diag_vote.Modal = true;
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelNames("93",user.getLanguage())%>";
			diag_vote.URL = "/cpcompanyinfo/CompanyInfoMaint.jsp?companyid="+id+"&btnid=editBtn"
			diag_vote.isIframe=false;
			diag_vote.show();
		}
		
	}
	/*删除*/
	function onDel(companyid){
		if(confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>？")){
			var o4params = {
				method:"del",
				companyids:companyid
			};
		
			jQuery.post("/cpcompanyinfo/action/CPInfoOperate.jsp",o4params,function(data){
				reflush2List();
			});
			reloadListContent();
		}
	}
	/*日志*/
	function onLog(companyid){
		diag_vote = new window.top.Dialog();
		diag_vote.currentWindow = window;
		diag_vote.Width = 600;
		diag_vote.Height =430;
		diag_vote.Modal = true;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelNames("83",user.getLanguage())%>";
		diag_vote.URL = "/cpcompanyinfo/CPLog.jsp?companyid="+companyid;
		diag_vote.isIframe=false;
		diag_vote.show();
	}


	/*批量删除*/
	function onBatchDel(){
		var companyids = "";
		$("input[name='chkInTableTag']").each(function(){
		if($(this).attr("checked"))			
			companyids = companyids +$(this).attr("checkboxId")+",";
		});
		
		if(companyids.length==0){
			alert("<%=SystemEnv.getHtmlLabelNames("84093",user.getLanguage())%>");
			return;
		}
		
		
		if(confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>？")){
			var o4params = {
				method:"del",
				companyids:companyids
			};
		
			jQuery.post("/cpcompanyinfo/action/CPInfoOperate.jsp",o4params,function(data){
				reflush2List();
			});
			
			reloadListContent();
		}
	}
	
	function onBtnSearchClick(){
		weaver.submit();
	}	
	
	$(function(){
		$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
		if("<%=openNew%>"=="T"){
			newCompany();
		}
	});
	
	//鼠标悬停效果
	function afterDoWhenLoaded(){
		var remindimg="<a name='remindlink' href='javascript:void(0)' onmouseover='showtip(event)' onmouseout='hidetip(event)' title=''><img src='/images/remind_wev8.png' align='absMiddle'  /></a>";
		$("#_xTable").find("table.ListStyle").find("thead").find("th:eq(11)").append("&nbsp;&nbsp;&nbsp;&nbsp;").append(remindimg);
		
	}
	function showtip(event){
		$("#remindtbl").show();
	}
	function hidetip(event){
		$("#remindtbl").hide();
	}
</script>
	    </wea:item>
	</wea:group>
</wea:layout>
</form>
