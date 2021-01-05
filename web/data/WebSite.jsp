
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>

<%
boolean canedit=false;
if(HrmUserVarify.checkUserRight("WebSiteView:View",user)) {
	canedit=true;
   }
ArrayList newsIdS=new ArrayList();
ArrayList newsNameS=new ArrayList();
RecordSet.executeSql("select id,frontpagename from DocFrontpage" );
while (RecordSet.next())
{
	newsIdS.add(RecordSet.getString("id"));
	newsNameS.add(RecordSet.getString("frontpagename"));
}
ArrayList researchIdS=new ArrayList();
ArrayList researchNameS=new ArrayList();
RecordSet.executeSql("select inprepid,inprepname from T_SurveyItem" );
while (RecordSet.next())
{
	researchIdS.add(RecordSet.getString("inprepid"));
	researchNameS.add(RecordSet.getString("inprepname"));
}
String name="";
String linkKey="";
String newsId="";
String type="";
String id=Util.null2String(request.getParameter("id"));
if(!id.equals("")){
	RecordSet.executeSql("select * from webSite where id = " + id);
	if(RecordSet.next()){
	 name=Util.null2String(RecordSet.getString("name"));
	 linkKey=Util.null2String(RecordSet.getString("linkKey"));
	 newsId=Util.null2String(RecordSet.getString("newsId"));
	 type=Util.null2String(RecordSet.getString("type"));
	}
}
String errorStr = "" ;
int error = Util.getIntValue(request.getParameter("error"),0);
int changeType = Util.getIntValue(request.getParameter("changeType"),0);
if (error == 1) 
	{
	  errorStr = Util.toScreen("填入的访问关键字已被引用！",user.getLanguage(),"0") ;
	  name = Util.toScreen(request.getParameter("name"),user.getLanguage(),"0");
	  linkKey = Util.toScreen(request.getParameter("linkKey"),user.getLanguage(),"0");
	  newsId=Util.null2String(request.getParameter("newsId"));
	  type=Util.null2String(request.getParameter("type"));
	}
if (changeType == 1) 
	{
	  name = Util.toScreen(request.getParameter("name"),user.getLanguage(),"1");
	  linkKey = Util.toScreen(request.getParameter("linkKey"),user.getLanguage(),"1");
	  newsId=Util.null2String(request.getParameter("newsId"));
	  type=Util.null2String(request.getParameter("type"));
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = Util.toScreen("网站管理",user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){
    if(id.equals("")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<%if(canedit){%>
<FORM id=weaverA name="weaverA" action="WebSiteOperation.jsp" method=post >
<input type="hidden" name="changeType" value="1">
<%if(id.equals("")){%>
	<input type="hidden" name="method" value="add">
<%}else{%>
	<input type="hidden" name="method" value="edit">
	<input type="hidden" name="id" value="<%=id%>">
<%}%>
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width=85%>
  <TBODY>

		<TR>
			<TD colSpan=4>
			<%if( error!=0 ) out.print("<BR><font color=FF0000>"+errorStr+"</font>");%>
			</TD>
		</TR>
		<TR>
          <TD>网站栏目名称</TD>
          <TD class=Field>			  
              <input name=name class=inputstyle  onchange='checkinput("name","nameimage");onChangeName();checkinput("linkKey","linkKeySpan")' value="<%if(!name.equals("")){%><%=name%><%}%>"><SPAN id=nameimage><%if(name.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
		  </TD>
        </TR>
		<tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD>访问关键字</TD>
          <TD class=Field>
              <input name=linkKey class=inputstyle  value="<%if(!linkKey.equals("")){%><%=linkKey%><%}%>" onchange='checkinput("linkKey","linkKeySpan")'><SPAN id="linkKeySpan"><%if(linkKey.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%>
		  </TD>
        </TR>
		<tr><td class=Line colspan=2></td></tr>
		<TR>
          <TD>类型</TD>
          <TD class=Field>
			  <select name="type" onchange="changeTypeSubmit()">
				<option value="1" <%if (type.equals("1")) {%>selected<%}%>>单文档</option>
				<option value="2" <%if (type.equals("2") || type.equals("")) {%>selected<%}%>>列表显示一</option>

				<option value="8" <%if (type.equals("8")) {%>selected<%}%>>列表显示二</option>
				
			    <option value="3" <%if (type.equals("3")) {%>selected<%}%>>摘要显示</option>
				<!--option value="4" <%if (type.equals("4")) {%>selected<%}%>>论坛显示</option-->
				<option value="5" <%if (type.equals("5")) {%>selected<%}%>>电子刊物显示</option>
				<option value="6" <%if (type.equals("6")) {%>selected<%}%>>工作流程</option>
				<!--option value="7" <%if (type.equals("7")) {%>selected<%}%>>网站调查</option-->
			  </select>
		  </TD>
        </TR>		
		<%if(type.compareTo("6")<0 || type.equals("8")) {%>
		<tr><td class=Line colspan=2></td></tr>
		<TR>
          <TD>新闻组</TD>
          <TD class=Field>
			  <BUTTON class=Browser id=SelectNewsID onclick="onNewsID()"></BUTTON>
               <SPAN id=newsSpan>
				  <% if(!newsId.equals(""))
				   { 
						int indexTemp = newsIdS.indexOf(newsId);
						String newsNameTemp = (String)newsNameS.get(indexTemp);
						out.print(newsNameTemp);
				    } else {%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
				  <% } %>
			   </SPAN>
              <INPUT id=newsId type=hidden name=newsId value="<%if(!newsId.equals("")){%><%=newsId%><%}%>">
		  </TD>
        </TR>
		<%}else if (type.equals("6")) {%>
		<tr><td class=Line colspan=2></td></tr>
		<TR>
          <TD>工作流</TD>
          <TD class=Field>
			  <BUTTON class=Browser id=SelectNewsID onclick="onShowWorkflow()"></BUTTON>
               <SPAN id=newsSpan>
				  <% if(!newsId.equals(""))
				   { 
						String newsNameTemp = WorkflowComInfo.getWorkflowname(newsId);
						out.print(newsNameTemp);
				    } else {%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
				  <% } %>
			   </SPAN>
              <INPUT id=newsId type=hidden name=newsId value="<%if(!newsId.equals("")){%><%=newsId%><%}%>">
		  </TD>
        </TR>
		<%}else if (type.equals("7")) {%>
		<tr><td class=Line colspan=2></td></tr>
		<TR>
          <TD>调查模版</TD>
          <TD class=Field>
			  <BUTTON class=Browser id=SelectNewsID onclick="showInprepId()"></BUTTON>
               <SPAN id=newsSpan>
				  <% if(!newsId.equals(""))
				   { 
						int indexTemp = researchIdS.indexOf(newsId);
						String newsNameTemp = (String)researchNameS.get(indexTemp);
						out.print(newsNameTemp);
				    } else {%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
				  <% } %>
			   </SPAN>
              <INPUT id=newsId type=hidden name=newsId value="<%if(!newsId.equals("")){%><%=newsId%><%}%>">
		  </TD>
        </TR>
		<%}%>
  </TBODY>
</TABLE>
</FORM>

<FORM id=weaverD action="WebSiteOperation.jsp" method=post>
<input type="hidden" name="method" value="delete">

<TABLE class=form>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
  <TR class=separator>
          <TD class=Sep1 colSpan=2></TD></TR>
           <TR>
          <TD colSpan=2>
		  <BUTTON class=btnDelete accessKey=D type=submit onclick="return isdel()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
	  
		  </TD>
        </TR>
  </TBODY>
</TABLE>
<%}%>
	 <TABLE class=ListStyle cellspacing=1>
        <TBODY>
	    <TR class=Header>
			<th width=10>&nbsp;</th>
			<th>网站栏目名称</th>
			<th>访问关键字</th>
			<th>新闻组</th>
			<th>类型</th>
	    </TR>
		<TR class=Line><TD colSpan=5></TD></TR>

<%
RecordSet.executeSql("select * from webSite order by id desc");
boolean isLight = false;
while(RecordSet.next())
{
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>

			<th width=10><%if(canedit){%><input type=checkbox name=webIDs value="<%=RecordSet.getString("id")%>"><%}%></th>
			<td>
			<A href='WebSite.jsp?id=<%=RecordSet.getString("id")%>'>
			<%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>
			</A>
			</td>
			<td><%=Util.toScreen(RecordSet.getString("linkKey"),user.getLanguage())%></td>	
			<td><%
				String newsIdTemp=RecordSet.getString("newsId");
				int indexTemp = newsIdS.indexOf(newsIdTemp);
				String newsNameTemp = (String)newsNameS.get(indexTemp);
				out.print(newsNameTemp);
				%>
			</td>
			<td>
				<%int typeTemp = Util.getIntValue(RecordSet.getString("type"),0);
				switch (typeTemp)
				{
					case 1 : out.print(Util.toScreen("单文档",user.getLanguage(),"0"));break;
					case 2 : out.print(Util.toScreen("列表显示一",user.getLanguage(),"0"));break;
					case 3 : out.print(Util.toScreen("摘要显示",user.getLanguage(),"0"));break;
					case 4 : out.print(Util.toScreen("论坛显示",user.getLanguage(),"0"));break;
					case 5 : out.print(Util.toScreen("电子刊物显示",user.getLanguage(),"0"));break;
					case 6 : out.print(Util.toScreen("工作流程",user.getLanguage(),"0"));break;
					case 7 : out.print(Util.toScreen("网站调查",user.getLanguage(),"0"));break;
					case 8 : out.print(Util.toScreen("列表显示二",user.getLanguage(),"0"));break;
					default: break;
				}
				%>
			</td>
    </tr> 
<%	
	isLight = !isLight;
}%>
	  </TBODY>
	  </TABLE>
</FORM>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

<script language=vbs>
sub onNewsID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/news/NewsBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	newsSpan.innerHtml = id(1)
	weaverA.newsId.value=id(0)
	else 
    newsSpan.innerHtml = "<IMG src=/images/BacoError_wev8.gif align=absMiddle>"
	weaverA.newsId.value=""
	end if
	end if
end sub
sub onChangeName()
	weaverA.linkKey.value = weaverA.name.value
end sub
sub onShowWorkflow()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		newsSpan.innerHtml = id(1)
		weaverA.newsId.value=id(0)
		else
		newsSpan.innerHtml = empty
		weaverA.newsId.value=""
		end if
	end if
end sub
sub showInprepId()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/sendmail/SendMailBrowser.jsp")
	if (Not IsEmpty(id)) then
        if id(0)<> "" then
            newsSpan.innerHtml = id(1)
            weaverA.newsId.value=id(0)
        else 
            newsSpan.innerHtml = ""
            weaverA.newsId.value=""
        end if
	end if
end sub
</script>
<script language="javascript">
function changeTypeSubmit()
{
	document.all("weaverA").action="WebSite.jsp";
	document.all("weaverA").submit();
}

function submitData() {
	if(check_form(weaverA,"name,linkKey,newsId")){
	weaverA.submit();
	}
}
</script>
</body>
</html>


