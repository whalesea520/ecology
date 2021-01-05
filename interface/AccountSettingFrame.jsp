
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
</head>
<%

//qc296829  [80]集成登录-集成登录账号设置页面优化   ----START
String  sysid=Util.null2String(request.getParameter("sysid"));
String sql="select * from outter_sys where 1=1";
if(!"".equals(sysid)){
	sql+=" and sysid='"+sysid+"'";
}
RecordSet.executeSql(sql);
// RecordSet.executeSql("select * from outter_sys");
//qc296829  [80]集成登录-集成登录账号设置页面优化   ----END

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String systemid = Util.null2String(request.getParameter("systemid"));
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="AccountOperation.jsp">
<input type=hidden name=operate value="insert">
<input type=hidden name=sysid value="<%=sysid %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit()"/>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"></span>
</div>

<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<wea:layout>
                <%
                while(RecordSet.next()){
              	 String autologin = Util.null2String(RecordSet.getString("autologin"));
                 String account ="";
                 String password="";
                 String logintype="1";
                 %>
                 <wea:group context='<%=RecordSet.getString("name")%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
				<%
				RecordSet1.executeSql("select * from outter_sys where sysid='"+RecordSet.getString("sysid")+"'");
				if(RecordSet1.next()){
                    int basetype1=Util.getIntValue(RecordSet1.getString("basetype1"),0);
					int basetype2=Util.getIntValue(RecordSet1.getString("basetype2"),0);
					String baseparam1 = Util.null2String(RecordSet1.getString("baseparam1"));
					String baseparam2 = Util.null2String(RecordSet1.getString("baseparam2"));
					
				 %>
                  <%  
                      RecordSet1.executeSql("select * from outter_account where sysid='"+RecordSet.getString("sysid")+"' and userid="+user.getUID());                    
                      if(RecordSet1.next()){                    
                              account=RecordSet1.getString("account");
                              password=RecordSet1.getString("password");
                             
                            //解密
                  			String password_new="";
                          if(!password.equals("")){
                          	password_new=SecurityHelper.decryptSimple(password);
                          }
                          if(!password_new.equals("")){
                          	password=password_new;
                          } 
                              logintype=RecordSet1.getString("logintype");
                      }
                  %>

				<%if(!"".equals(baseparam1)){ %>
					<wea:item>
			<%=SystemEnv.getHtmlLabelName(83594,user.getLanguage())%>
					</wea:item>
					<wea:item>
					<%if(basetype1==0){%>
					<input  name=account_999_<%=RecordSet.getString("sysid")%>  value="<%=account%>" maxlength="50" style="width :50%" class="InputStyle" _noMultiLang="true" >
			      <%}else{%>
				    <span><%=SystemEnv.getHtmlLabelName(20974,user.getLanguage())%><span>
				    <input  type=hidden name=account_999_<%=RecordSet.getString("sysid")%>  value="<%=account%>" maxlength="50" style="width :50%" class="InputStyle" _noMultiLang="true">
					<%}%>
					</wea:item>
			
				<%} %>
				
				<%if(!"".equals(baseparam2)){ %>
				
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%>
					</wea:item>
					<wea:item>
					 <%if(basetype2==0){%>
					<input name=password_999_<%=RecordSet.getString("sysid")%> type=password value="<%=password%>" maxlength="50" style="width :50%" class="InputStyle" _noMultiLang="true">
					<%}else{%>
                    <span><%=SystemEnv.getHtmlLabelName(20975,user.getLanguage())%><span>
				    <input type=hidden name=password_999_<%=RecordSet.getString("sysid")%> type=password value="<%=password%>" maxlength="50" style="width :50%" class="InputStyle" _noMultiLang="true">
					<%}%>
					</wea:item>
               
				<%} %>

				<%}%>
				  <%
				RecordSet1.executeSql("select * from outter_sysparam where paramtype=1 and  sysid='"+RecordSet.getString("sysid")+"'");
				while(RecordSet1.next()){
                    String labelname=RecordSet1.getString("labelname");
					String paramname=RecordSet1.getString("paramname");
					String paramvalue="";
                    RecordSet2.executeSql("select * from outter_params where sysid='"+RecordSet.getString("sysid")+"'"+" and userid="+user.getUID()+" and paramname='"+paramname+"'");
					if(RecordSet2.next()) paramvalue=RecordSet2.getString("paramvalue");
				 %> 
				 <wea:item>
					<%=labelname%>
				</wea:item>
					<wea:item>
					<input name=<%=paramname+"_"+RecordSet.getString("sysid")%>  value="<%=paramvalue%>" maxlength="50" style="width :50%" class="InputStyle" _noMultiLang="true">
					</wea:item>
                           
				<%}%>
				<%if(!autologin.equals("1")){%>
				 <wea:item>
					<%=SystemEnv.getHtmlLabelName(20971,user.getLanguage())%>
				</wea:item>
					<wea:item>
					<select name=logintype_999_<%=RecordSet.getString("sysid")%> >
                          <option value="1" <%if(logintype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20972,user.getLanguage())%></option>
                          <option value="2" <%if(logintype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20973,user.getLanguage())%></option>
                      </select>     
					</wea:item>
			  <%}%>                    
				</wea:group>  
        <%}%> 

	
</wea:layout>
  </FORM>
</BODY>

<script language="javascript">
function onSubmit()
{
	frmMain.submit();
}

</script>
</HTML>
