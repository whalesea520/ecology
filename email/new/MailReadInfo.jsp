
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%>
<%@page import="weaver.email.MailCommonUtils"%> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" />
<jsp:useBean id="WeavermailUtil" class="weaver.email.WeavermailUtil" />
<HTML>
<head>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>

<%
	String mailid = Util.null2String(request.getParameter("mailid"));//邮件主键信息值
	mrs.setId(mailid+"");
	mrs.setResourceid(""+user.getUID());
	mrs.selectMailResource();
	mrs.next();
	
	String ids=MailCommonUtils.trim(mrs.getToids()+","+mrs.getCcids()+","+mrs.getBccids());
	String pids=MailCommonUtils.trim(mrs.getTodpids()+","+mrs.getCcdpids()+","+mrs.getBccdpids());
	int all=Util.getIntValue(mrs.getToall(),0)+Util.getIntValue(mrs.getCcall(),0)+Util.getIntValue(mrs.getBccall(),0);
	
	String sqlWhere=" t1.status in(0,1,2,3) ";
	
	AppDetachComInfo adci = new AppDetachComInfo();
	boolean isUseAppDetach = adci.isUseAppDetach(); 
	String allids = "";
	if(isUseAppDetach) {
		if(all != 0) {
			allids = adci.getScopeIds(user,"resource");
			if(allids==null||"".equals(allids))isUseAppDetach=false;
		}
	}
	if(all == 0) {
		String orStr = " ";
		if(!"".equals(pids)) {
			orStr = " or ";
			sqlWhere += " and (t1.departmentid in (" + pids + ") ";
			
			String vRresourceids=WeavermailUtil.getVirtualResourceids(pids);
			if(vRresourceids.length()>0){
				ids=ids+vRresourceids;
				ids=MailCommonUtils.trim(ids);
			}
		}
		else {
			sqlWhere += " and (";
		}
		if(!"".equals(ids))
			sqlWhere += orStr + " t1.id in (" + ids + ") ";
		
		sqlWhere += ")";
	}else if(isUseAppDetach){               //如果是分权下的所有人 则获取分权下的所有人
		allids=MailCommonUtils.trim(allids);
		if(!"".equals(allids))
			sqlWhere +=" and t1.id in (" + allids + ") ";
  	}
	
	int pagesize = 10;
	RecordSet recordSet=new RecordSet();
	String backfields = "t1.id,t1.lastname,t4.id as mailid,case when t4.folderId =-3 or t4.id is null then '1' when  t4.readdate is not null then t4.readdate   else '0' end as readdate";
	String fromSql ="HrmResource t1 LEFT JOIN (select * from MailResource where originalMailId="+mailid+") t4 on t1.id=t4.resourceid"; 
	
	String orderby = "readdate";
	String tableString =" <table instanceid=\"readinfo\"  pagesize=\""+pagesize+"\" tabletype=\"none\">"+ 
                "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+sqlWhere+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"/>"+
                "<head>"+
                "<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(2046,user.getLanguage()) +"\" column=\"lastname\"/>"+ 
				"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(31369,user.getLanguage()) +"\" column=\"readdate\" transmethod=\"weaver.splitepage.transform.SptmForMail.getMailReadState\"  otherpara=\""+user.getLanguage()+"\"/>"+ 
				"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(31971,user.getLanguage()) +"\" column=\"readdate\" transmethod=\"weaver.splitepage.transform.SptmForMail.getMailReadDate\"/>"+
				"</head>"+   			
				"</table>";
%>

</head>	  
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="mail"/>
	   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("31970",user.getLanguage())%>'/>
	</jsp:include>
	
	
	<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
	
	
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</html>
                                                              
