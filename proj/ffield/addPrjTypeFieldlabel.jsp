<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
	if(!HrmUserVarify.checkUserRight("ProjectFreeFeild:Edit", user)){
		response.sendRedirect("/notice/noright.jsp");	
		return;
	}
%>
<%
int proTypeId = Util.getIntValue (request.getParameter("proTypeId"),0);
    String ajax=Util.null2String(request.getParameter("ajax"));
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

</HEAD>
<%
	int formid=0;
    int subCompanyId= -1;
	formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	
	String qname = Util.null2String(request.getParameter("flowTitle"));
	String fieldname_kwd = Util.null2String(request.getParameter("fieldname_kwd"));
	String fieldlabel_kwd = Util.null2String(request.getParameter("fieldlabel_kwd"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="";
if(!ajax.equals("1"))
{
needfav ="1";
}
String needhelp ="";

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int operatelevel=2;

    
    
    ArrayList fieldids = new ArrayList();
    ArrayList fieldnames = new ArrayList();
    ArrayList fieldlables = new ArrayList();
    ArrayList fieldlablenames = new ArrayList();
    ArrayList fieldlablenamesE = new ArrayList();
    ArrayList fieldlablenamesT = new ArrayList();
    ArrayList viewtypes = new ArrayList();//存scopeid
    
    String sql = "select t1.*,t2.fieldname from cus_formfield t1,cus_formdict t2 where t1.scope='ProjCustomField' and t1.fieldid=t2.id  " ;
    if(proTypeId>0){
    	sql+=" and scopeid='"+proTypeId+"' ";
    }
    
  			if(qname.length()>0){
  				sql +=" and (fieldname like '%"+qname+"%' or fieldlabel like '%"+qname+"%' )";
  			} 
  			
  			if(fieldname_kwd.length()>0){
  				sql +=" and fieldname like '%"+fieldname_kwd+"%' ";
  			} 
  			
  			if(fieldlabel_kwd.length()>0){
  				sql +=" and exists (select * from HtmlLabelInfo where fieldlabel = indexid and labelname like '%"+fieldlabel_kwd+"%' )";
  			} 
  			sql += " order by scopeid,fieldorder";
    RecordSet.executeSql(sql);
  	while(RecordSet.next()){//取得表单的所有字段及字段显示名
    	int tempFieldLableId =Util.getIntValue( RecordSet.getString("prj_fieldlabel"),0);
    	fieldids.add(RecordSet.getString("fieldid")+"_"+RecordSet.getString("scopeid"));
    	//fieldids.add(RecordSet.getString("fieldid"));
    	fieldnames.add(RecordSet.getString("fieldname"));
    	fieldlables.add(""+tempFieldLableId);
    	if(tempFieldLableId!=0){
    		fieldlablenames.add(SystemEnv.getHtmlLabelName(tempFieldLableId,7));
        	fieldlablenamesE.add(SystemEnv.getHtmlLabelName(tempFieldLableId,8));
        	fieldlablenamesT.add(SystemEnv.getHtmlLabelName(tempFieldLableId,9));
    	}else{
    		String oldFieldLabel=Util.null2String(RecordSet.getString("fieldlable"));
    		fieldlablenames.add(oldFieldLabel);
        	fieldlablenamesE.add(oldFieldLabel);
        	fieldlablenamesT.add(oldFieldLabel);
    	}
    	
    	viewtypes.add(RecordSet.getString("scopeid"));
    }
%>


<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:fieldlablesall0(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="fieldlabelfrm" id=fieldlabelfrm method=post action="/proj/ffield/addprjtypeFieldlabel.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="fieldlablesall0();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv"  >
<wea:layout type="4col">
	<wea:group context="搜索条件">
		<wea:item><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
		<wea:item><input type="text" id="fieldname_kwd" name="fieldname_kwd" class="InputStyle" value='<%=fieldname_kwd%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage()) %></wea:item>
		<wea:item><input type="text" id="fieldlabel_kwd" name="fieldlabel_kwd" class="InputStyle" value='<%=fieldlabel_kwd%>'></wea:item>
	</wea:group>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_submit" type="button" name="search" value="搜索" onclick="onBtnSearchClick();"/>
    		<input class="zd_btn_cancle" type="reset" name="reset" value="重置"/>
    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="取消"  />
    	</wea:item>
    </wea:group>
</wea:layout>	
</div>

<input type="hidden" value="editfieldlabel" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name="ajax" value="<%=ajax%>">
<input type="hidden" value="" name="changefieldids">
<input type="hidden" value="" name="checkitems">

<wea:layout type="4col" attributes="">
	<wea:group context="" attributes="{'groupDisplay':'none'}">

<wea:item attributes="{'isTableList':'true'}">

<TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="oTable">
      <colgroup>                           
      <col width="10%">
<%
if(proTypeId<=0){
	%>
      <col width="20%">
	<%
}
%>      
      <col width="20%">
      <col width="20%">
      <col width="20%">
     <TR class="header">                                
		<TD><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TD>
<%
if(proTypeId<=0){
	%>
		<TD><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TD>
	<%
}
%>		
        <TD><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>)</TD>
        <TD><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(English)</TD>     
        <TD><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=LanguageComInfo.getLanguagename("9")%>)</TD>
    </TR>
<%
for(int tmpcount=0; tmpcount< fieldids.size(); tmpcount++){
	String id = (String)fieldids.get(tmpcount);
	String fieldname = (String)fieldnames.get(tmpcount);
	String fieldlablename = (String)fieldlablenames.get(tmpcount);
	String fieldlablenameE = Util.null2String((String)fieldlablenamesE.get(tmpcount));
	String fieldlablenameT = Util.null2String((String)fieldlablenamesT.get(tmpcount));
	String viewtype = (String)viewtypes.get(tmpcount);
	%>
	<tr class="DataLight">
		<td><%=fieldname%></td>
<%
if(proTypeId<=0){
	%>
		<td><%=ProjectTypeComInfo.getProjectTypename(viewtype) %></td>
	<%
}
%>		
		<td>
			<input type="text" class=InputStyle style="width:95%;" name="field_<%=id%>_CN" value="<%=fieldlablename%>" onchange="checkinput('field_<%=id%>_CN','field_<%=id%>_CN_span');setChange('<%=id%>')" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"><span id=field_<%=id%>_CN_span></span>
		</td>
		<td>
			<input type="text" class=InputStyle style="width:95%;" name="field_<%=id%>_En" value="<%=fieldlablenameE%>" onchange="setChange('<%=id%>')" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)">
		</td>
		<td>
			<input type="text" class=InputStyle style="width:95%;" name="field_<%=id%>_TW" value="<%=fieldlablenameT%>" onchange="setChange('<%=id%>')" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)">
		</td>
	</tr>
	<%
	
}
%>	
    
    
</TABLE>

</wea:item>
	</wea:group>
</wea:layout>


</form>

<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#fieldlabelfrm").submit();
}
function setChange(fieldid){
	$G("checkitems").value += "field_"+fieldid+"_CN,"
	var changefieldids = $G("changefieldids").value;
	if(changefieldids.indexOf(fieldid)<0)
		$G("changefieldids").value = changefieldids + fieldid + ",";
}
function fieldlablesall0(){
	fieldlabelfrm.action="/proj/ffield/prjtypeFieldOperation.jsp?proTypeId=<%=proTypeId %>";
	var checks = $G("checkitems").value;
	if(check_form(fieldlabelfrm,checks)){
		fieldlabelfrm.submit();
	}else{
		return;
	}		
}
$(function(){
	$("#topTitle").topMenuTitle({});
});
$(function(){
	var cptgroupname='<%=ProjectTypeComInfo.getProjectTypename(""+proTypeId) %>';
	if(cptgroupname==''){
		cptgroupname='<%=SystemEnv.getHtmlLabelName(18630,user.getLanguage()) %>';
	}
	try{
		parent.setTabObjName(cptgroupname);
	}catch(e){}
});
</script>

</body>
</html>
