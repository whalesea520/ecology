
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<%
	if(!HrmUserVarify.checkUserRight("FormManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>
<%
    String rowcalstr = Util.null2String(request.getParameter("rowcalstr"));
    ArrayList signid = (ArrayList)session.getAttribute("signid");
    ArrayList signlable = (ArrayList)session.getAttribute("signlable");
    ArrayList detailid = (ArrayList)session.getAttribute("detailid");
    ArrayList detaillable = (ArrayList)session.getAttribute("detaillable");
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/templates/default/css/default_wev8.css" type=text/css rel=STYLESHEET>

<!-- add by xhheng @20050204 for TD 1538-->
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/jquery/jquery-1.4.2.min_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js">
</script>
<TABLE id="customFieldTable">
<TBODY>
<table class=ListStyle cols=4  border=0 cellspacing=1>
  <COLGROUP>
		<COL width="20%">
		<COL width="40%">
		<COL width="40%">
	</COLGROUP>
  <thead>    
	    <tr class=header>
            <th>
            	<INPUT type="checkbox" onclick="javascript:var obj = jQuery('input[name=chkInTableTa]');if(jQuery(this).is(':checked')){jQuery(obj).each(function(){changeCheckboxStatus(jQuery(this),true);var rowindex = jQuery(this).parent().parent().parent().parent()[0].rowIndex;rows+=','+rowindex+',';});}else{jQuery(obj).each(function(){changeCheckboxStatus(jQuery(this),false);var rowindex = jQuery(this).parent().parent().parent().parent()[0].rowIndex;rows = rows.replace(','+rowindex+',','');});}" value="ON">
            </th>
            <th colspan="3"><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15636,user.getLanguage())%></th>
        </tr>  
   </thead>
</table>
<TABLE class=ListStyle cols=4  border=0 cellspacing=1 id="allcalexp" >
	<COLGROUP>
		<COL width="20%">
		<COL width="40%">
		<COL width="40%">
	</COLGROUP>
	<TBODY>  
		<%
		String trClass="DataLight";
		int rowsum=0;
		rowcalstr = rowcalstr.replaceAll("_plus_","\\+");
		StringTokenizer stk = new StringTokenizer(rowcalstr,";");
		//System.out.println("公式2:"+rowcalstr);
		while(stk.hasMoreTokens()){
		    String token = stk.nextToken();
		    String token2 = token;
		    //System.out.println("公式3:"+token2);
		    if(!token2.equals("")){
		        for(int i=0; i<signid.size(); i++){
		            token2 = Util.StringReplace(token2,""+signid.get(i),signlable.get(i)+"");
		        }
		        for(int i=0; i<detailid.size(); i++){
		            token2 = Util.StringReplace(token2,"detailfield_"+detailid.get(i),"<span style='color:#000000'>"+detaillable.get(i)+"</span>");
		        }
		    }
		    //System.out.print("token:"+token2);
		%>
			<TR class=<%=trClass%> forsort="ON">
				<td style="height: 40px;">
				<div><input type="checkbox" name="chkInTableTa" onclick="chkCheck(this)"></div></td>
			    <td  style="color:#000000;height: 40px;" colspan="3"><div><%=token2%><input type="hidden" name="calstr" value="<%=token%>">
			    <a href="#" onclick="deleteRowcal(this)" style="float:right;">
			     <%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a></div></td>
	    	</TR>	
			<%
				rowsum++;
			} %>
	</TBODY>
</TABLE>
</TBODY>
</TABLE>
