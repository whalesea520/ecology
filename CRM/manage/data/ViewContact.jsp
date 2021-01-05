
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="RecordSetDemand" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetBase" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />

<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));

RecordSetCT.executeSql("SELECT id,title,fullname,jobtitle,lastname,textfield1,email,phoneoffice,mobilephone,projectrole,attitude,attention FROM CRM_CustomerContacter WHERE (customerid = "+CustomerID+") ORDER BY main DESC,id ASC");
%>
      	<TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="tblTask">
             <colgroup>
             <col width="8%">
             <col width="8%">
             <col width="10%">
             <col width="10%">                       
             <col width="10%">                       
             <col width="10%">                       
             <col width="14%">
             <col width="8%">
             <col width="8%">
             <col width="14%">
             </colgroup>                       
             <TR class="Header">
                 <TH>姓名</TH> 
                 <TH>称呼</TH>  
                 <TH>工作头衔</TH>
                 <TH>部门</TH>
                 <TH>移动电话</TH>
                 <TH>办公室电话</TH>
                 <TH>电子邮件</TH>
                 <TH>项目角色</TH>
                 <TH>意向判断</TH>
                 <TH>关注点</TH>
             </TR>
<%while(RecordSetCT.next()){%>
             <tr class="DataLight">
             	<td>
             		<a href="###" onclick="openFullWindowForXtable('/CRM/data/ViewContacter.jsp?log=n&ContacterID=<%=RecordSetCT.getString(1)%>&frombase=1')" target="_self">
             		<%=Util.toScreen(RecordSetCT.getString("fullname"),user.getLanguage())%>
             		</a> 
             	</td>
             	<td><%=Util.toScreen(ContacterTitleComInfo.getContacterTitlename(RecordSetCT.getString("title")),user.getLanguage())%></td>
              	<td><%=RecordSetCT.getString("jobtitle")%></td>
             	<td><%=RecordSetCT.getString("textfield1")%></td>
             	<td><%=RecordSetCT.getString("mobilephone")%></td>
             	<td><%=RecordSetCT.getString("phoneoffice")%></td>
             	<td><%=RecordSetCT.getString("email")%></td>
             	<td><%=Util.toScreen(RecordSetCT.getString("projectrole"),user.getLanguage())%></td>
             	<td><%=Util.toScreen(RecordSetCT.getString("attitude"),user.getLanguage())%></td>
             	<td><%=Util.toScreen(RecordSetCT.getString("attention"),user.getLanguage())%></td>
             </tr>    
<%}%>
		
			<tr id="addContacter" style="display: none;">
				<form id="quickaddform" name="quickaddform" action="/CRM/data/ContacterOperation.jsp" method=post enctype="multipart/form-data" target="quickaddframe">
				<input type="hidden" name="CustomerID" value="<%=CustomerID %>"/>
				<input type="hidden" name="quickadd" value="1"/>
				<input type="hidden" name="method" value="add"/>
				<input type="hidden" name="Manager" value="<%=user.getUID()+"" %>"/>
				<input type="hidden" name="status" value="1"/>
				<input type="hidden" name="isneedcontact" value="1"/>
				<input type="hidden" name="Language" value="<%=user.getLanguage() %>"/>
				<td><INPUT class=InputStyle maxLength=50 style="width:90%" id="FirstName" name="FirstName" onchange='checkinput("FirstName","FirstNameimage")'><SPAN id=FirstNameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></td>
				<td><INPUT type=hidden class="wuiBrowser" _required="yes" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContacterTitleBrowser.jsp" name=Title></td>
				<td><INPUT class=InputStyle maxLength=100 style="width:90%" id="JobTitle" name="JobTitle" onchange='checkinput("JobTitle","JobTitleimage")'><SPAN id=JobTitleimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></td>
				<td><INPUT class=InputStyle maxLength=100 style="width:95%" id="textfield1" name="textfield1" /></td>
				<td><INPUT class=InputStyle maxLength=20 style="width:95%" id="Mobile" name="Mobile"></td>
				<td><INPUT class=InputStyle maxLength=20 style="width:95%" id="PhoneOffice" name="PhoneOffice"></td>
				<td><INPUT class=InputStyle maxLength=150 style="width:95%" id="CEmail" name="CEmail" onblur="mailValid()"></td>
				<td><INPUT class=InputStyle maxLength=100 style="width:95%" id="projectrole" name="projectrole" /></td>
				<td>
					<select id="attitude" name="attitude">
		          		<option value=""></option>
		          		<option value="支持我方">支持我方</option>
		          		<option value="未表态">未表态</option>
		          		<option value="未反对">未反对</option>
		          		<option value="反对">反对</option>
          			</select>
          		</td>
				<td>
					<INPUT class=InputStyle maxLength=200 style="width:95%" id="attention" name="attention" />
					<div id="div_operate" style="float: right;width: 65px;">
						<div style="float: right;cursor: pointer;color: #1281D6;margin-left: 5px;" onclick="if(confirm('确定取消快速添加联系人?')){cancelSave()}">取消</div>
						<div style="float: right;cursor: pointer;color: #1281D6;" onclick="quickSave()">保存</div>
					</div>
					<button id="quickreset" type="reset" style="display: none"></button>
				</td>
				</form>
			</tr>
			
         </TABLE>
</body>
</html>


