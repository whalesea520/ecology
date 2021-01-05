<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
  <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 
<%@page import="com.weaver.integration.datesource.SAPInterationOutUtil,com.weaver.integration.params.*"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionParams"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionImportParams"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionExportParams"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionBaseParamBean"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionAllParams"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet02" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<HTML><HEAD><base target="_self">
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>

<%

		
		//Z_OSAP_MATERIAL_GETALL有输入字段的函数
		//BAPI_ROUTING_CREATE有输入结构,有输出结构,有输出参数
		//BAPI_MATERIAL_SAVEDATA多个结构体的
		String servId = Util.null2String(request.getParameter("servId")).trim();
	    String poolid = Util.null2String(request.getParameter("poolid")).trim();
	    String type=Util.null2String(request.getParameter("type")).trim();
	    String paramName = Util.null2String(request.getParameter("paramName")).trim().toUpperCase();
	    String paramDesc = Util.null2String(request.getParameter("paramDesc")).trim().toUpperCase();
	    String disValue = Util.null2String(request.getParameter("disValue")).trim().toUpperCase();
	    String operation=Util.null2String(Util.getIntValue(request.getParameter("operation"),1)+"").trim(); //operation操作类型1表示批量添加,2表示单个添加或修改 
	    String stuortablevalue=Util.null2String(request.getParameter("stuortablevalue")).trim();//如果type=3,表示输入结构的名称,type=6表示输出结构的名称,type=8表示输出表的名称
		
	    String checkvalue=Util.null2String(request.getParameter("checkvalue")).toUpperCase();//选中的一项值
		
		String paramnametitle = "";
		String paramdesctitle = "";
		if("1".equals(type) || "3".equals(type) || "4".equals(type) || "6".equals(type) || "8".equals(type) || "11".equals(type)) {
			paramnametitle = SystemEnv.getHtmlLabelName(23481,user.getLanguage());//23481
			paramdesctitle = SystemEnv.getHtmlLabelName(30667,user.getLanguage());
		}
		if("2".equals(type) || "5".equals(type)) {
			paramnametitle = SystemEnv.getHtmlLabelName(30668,user.getLanguage());
			paramdesctitle = SystemEnv.getHtmlLabelName(30670,user.getLanguage());
		}
		if("10".equals(type) || "7".equals(type)) {
			paramnametitle = SystemEnv.getHtmlLabelName(30671,user.getLanguage());
			paramdesctitle = SystemEnv.getHtmlLabelName(30674,user.getLanguage());
		}
		if("".equals(operation)){operation="1";}
		
	
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="integration"/>
		   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelName(84095,user.getLanguage())%>' /> 
		</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doSearchParamsForm()">						
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onReset(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;

//RCMenu += "{清除,javascript:onClean(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearchParamsForm(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if("1".equals(operation))
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="*">
<col width="10">
</colgroup>
<tr>
	<td></td>
	<td height="35px">
	  <form action="" method="post" id="searchFormParams">
	  		<wea:layout type="4Col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				<wea:item><%=paramnametitle %></wea:item>
				<wea:item><input type="text" name="paramName" value='<%=paramName %>' style="width:200px;"></wea:item>
				<wea:item><%=paramdesctitle %></wea:item>
				<wea:item><input type="text" name="paramDesc" value='<%=paramDesc %>' style="width:200px;"></wea:item>
				</wea:group>
			</wea:layout>
	  		<input type="hidden" name="servId" value="<%=servId%>">
	  		<input type="hidden" name="poolid" value="<%=poolid%>">
	  		<input type="hidden" name="type" value="<%=type%>">
	  		<input type="hidden" name="disValue" value="<%=disValue%>">
	  		<input type="hidden" name="operation" value="<%=operation%>">
	  		<input type="hidden" name="stuortablevalue" value="<%=stuortablevalue%>">
	  		<input id="searchFormParamsBtn" type="submit" style="display: none;width:1px;height:1px; ">
				
	  		
			
			
		</form>
	</td>	
	<td></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top" width="100%">


<!-- 
<table width=100% class="viewform">
<TR>
<TD >SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></TD>
<TD  class=field colspan=3>

</TD>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
<tr>
<TD >参数名称</TD>
<TD  class=field>
		<input type="text">
</TD>
<TD >参数描述</TD>
<TD  class=field>
		<input type="text">
</TD>
</TR>
<TR class="Spacing"  style="height:1px;"><TD class="Line1" colspan=6></TD></TR>
</table>
 -->
<%
	if("1".equals(type)||"3".equals(type)||"4".equals(type)||"6".equals(type)||"8".equals(type)||"11".equals(type)||"12".equals(type))
	{
		if("1".equals(operation))
		{
		
			 out.println("<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' width='100%'>");
			 out.println("<TR class=DataHeader>");
			 out.println("<th width=10% ><input type=checkbox id='check_per_ALL' onclick='javascript:check_per_ALLClick();'>"+SystemEnv.getHtmlLabelName(556,user.getLanguage())+"</th>");
			 out.println("<TH width=40% >"+SystemEnv.getHtmlLabelName(23481,user.getLanguage())+"</TH>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30667,user.getLanguage())+"</TH>");
			 out.println("</tr>");
			 out.println("<TR class=Line  style='height:1px;'><th colspan='3' ></Th></TR> ");
		}else
		{
			 out.println("<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' width='100%'>");
			 out.println("<TR class=DataHeader>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(23481,user.getLanguage())+"</TH>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30667,user.getLanguage())+"</TH>");
			 out.println("</tr>");
			 out.println("<TR class=Line  style='height:1px;'><th colspan='2' ></Th></TR> ");
		}
	}else if("2".equals(type)||"5".equals(type))
	{
		if("1".equals(operation))
		{
			 out.println("<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' width='100%'>");
			 out.println("<TR class=DataHeader>");
			 out.println("<th width=10% ><input type=checkbox id='check_per_ALL' onclick='javascript:check_per_ALLClick();'>"+SystemEnv.getHtmlLabelName(556,user.getLanguage())+"</th>");
			 out.println("<TH width=40% >"+SystemEnv.getHtmlLabelName(30668,user.getLanguage())+"</TH>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30670,user.getLanguage())+"</TH>");
			 out.println("</tr>");
			 out.println("<TR class=Line  style='height:1px;'><th colspan='3' ></Th></TR> ");
		}else
		{
			 out.println("<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' width='100%'>");
			 out.println("<TR class=DataHeader>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30668,user.getLanguage())+"</TH>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30670,user.getLanguage())+"</TH>");
			 out.println("</tr>");
			 out.println("<TR class=Line  style='height:1px;'><th colspan='2' ></Th></TR> ");
		}
	}else if("7".equals(type)||"10".equals(type))
	{
		if("1".equals(operation))
		{
			 out.println("<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' width='100%'>");
			 out.println("<TR class=DataHeader>");
			 out.println("<th width=10% ><input type=checkbox id='check_per_ALL' onclick='javascript:check_per_ALLClick();'>"+SystemEnv.getHtmlLabelName(556,user.getLanguage())+"</th>");
			 out.println("<TH width=40% >"+SystemEnv.getHtmlLabelName(30671,user.getLanguage())+"</TH>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30674,user.getLanguage())+"</TH>");
			 out.println("</tr>");
			 out.println("<TR class=Line  style='height:1px;'><th colspan='3' ></Th></TR> ");
		}else
		{
			 out.println("<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' width='100%'>");
			 out.println("<TR class=DataHeader>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30671,user.getLanguage())+"</TH>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30674,user.getLanguage())+"</TH>");
			 out.println("</tr>");
			 out.println("<TR class=Line  style='height:1px;'><th colspan='2' ></Th></TR> ");
		}
	}
	
	LogInfo li=new LogInfo();
	SAPFunctionAllParams sa  = null;
	SAPFunctionImportParams saimport = null;
	SAPFunctionExportParams saexp = null;
	if("".equals(stuortablevalue)) {
		sa = ServiceParamsUtil.getSAPFunAllParsByServID(servId,paramName,paramDesc,disValue,li);
		if(sa != null) {
			saimport = sa.getSip();//得到所有的输入参数
			saexp = sa.getSep();//得到所有的输出参数
		}
	}
	
	
		if("1".equals(type))//获取输入参数
		{
			List list = null;
			if(saimport != null) {
				list=saimport.getStrList();//得到输入参数里面的所有项
			}
			
			if(null!=list)
			{
				for(int h=0;h<list.size();h++) {
						SAPFunctionBaseParamBean sbpb = (SAPFunctionBaseParamBean)list.get(h);
						if(h%2==0) {
							out.println("<tr class=DataDark>");
						}else {
							out.println("<tr class=DataLight>");
						}
						
							if("1".equals(operation))
							{
								if(checkvalue.equals(sbpb.getParamName().toUpperCase()))
								{
									out.println("<td style='width:50px'><input type=checkbox name='check_per' checked=checked></td>");
								}else
								{
									out.println("<td style='width:50px'><input type=checkbox name='check_per'></td>");
								}
							}
							out.println("<td>"+sbpb.getParamName().toUpperCase()+"</td>");
							out.println("<td>"+sbpb.getParamDesc().toUpperCase()+"</td>");
						out.println("</tr>");
					}
			}
		}else if("3".equals(type))//获取某个输入结构的里面的参数
		{
			if(!"".equals(stuortablevalue))
			{
				List list=ServiceParamsUtil.getCompParamsByServIdAndParamName(servId, stuortablevalue, "import", true,paramName,paramDesc,disValue);
				if(null!=list)
				{
					for(int h=0;h<list.size();h++) {
							SAPFunctionBaseParamBean sbpb = (SAPFunctionBaseParamBean)list.get(h);
							if(h%2==0) {
								out.println("<tr class=DataDark>");
							}else {
								out.println("<tr class=DataLight>");
							}
								if("1".equals(operation))
								{
									if(checkvalue.equals(sbpb.getParamName().toUpperCase()))
									{
										out.println("<td style='width:50px'><input type=checkbox name='check_per' checked=checked></td>");
									}else
									{
										out.println("<td style='width:50px'><input type=checkbox name='check_per'></td>");
									}
								}
								out.println("<td>"+sbpb.getParamName().toUpperCase()+"</td>");
								out.println("<td>"+sbpb.getParamDesc().toUpperCase()+"</td>");
							out.println("</tr>");
					}
				}
			}
		}
		else if("4".equals(type))//获取输出参数
		{
			List list = null;
			if(saexp != null) {
				list=saexp.getStrList();//得到输入参数里面的所有项
			}
			if(null!=list)
			{
				for(int h=0;h<list.size();h++) {
					SAPFunctionBaseParamBean sbpb = (SAPFunctionBaseParamBean)list.get(h);
					if(h%2==0) {
						out.println("<tr class=DataDark>");
					}else {
						out.println("<tr class=DataLight>");
					}
						if("1".equals(operation))
						{
							if(checkvalue.equals(sbpb.getParamName().toUpperCase()))
							{
								out.println("<td style='width:50px'><input type=checkbox name='check_per' checked=checked></td>");
							}else
							{
								out.println("<td style='width:50px'><input type=checkbox name='check_per'></td>");
							}
						}
						out.println("<td>"+sbpb.getParamName().toUpperCase()+"</td>");
						out.println("<td>"+sbpb.getParamDesc().toUpperCase()+"</td>");
					out.println("</tr>");
				}
			}
		}
		else if("6".equals(type))//获取输出结构里面的输出参数
		{
			if(!"".equals(stuortablevalue))
			{
				List list=ServiceParamsUtil.getCompParamsByServIdAndParamName(servId, stuortablevalue, "export", true,paramName,paramDesc,disValue);
				if(null!=list)
				{
					for(int h=0;h<list.size();h++) {
							SAPFunctionBaseParamBean sbpb = (SAPFunctionBaseParamBean)list.get(h);
							if(h%2==0) {
								out.println("<tr class=DataDark>");
							}else {
								out.println("<tr class=DataLight>");
							}
								if("1".equals(operation))
								{
									if(checkvalue.equals(sbpb.getParamName().toUpperCase()))
									{
										out.println("<td style='width:50px'><input type=checkbox name='check_per' checked=checked></td>");
									}else
									{
										out.println("<td style='width:50px'><input type=checkbox name='check_per'></td>");
									}
								}
								out.println("<td>"+sbpb.getParamName().toUpperCase()+"</td>");
								out.println("<td>"+sbpb.getParamDesc().toUpperCase()+"</td>");
							out.println("</tr>");
					}
				}
			}
			
		}
		else if("8".equals(type)||"12".equals(type))//获取输出表里面的输出参数
		{
			if(!"".equals(stuortablevalue))
			{
				List list=ServiceParamsUtil.getCompParamsByServIdAndParamName(servId, stuortablevalue, "export", false,paramName,paramDesc,disValue);
				if(null!=list)
				{
					for(int h=0;h<list.size();h++) {
							SAPFunctionBaseParamBean sbpb = (SAPFunctionBaseParamBean)list.get(h);
							if(h%2==0) {
								out.println("<tr class=DataDark>");
							}else {
								out.println("<tr class=DataLight>");
							}
								if("1".equals(operation))
								{
									if(checkvalue.equals(sbpb.getParamName().toUpperCase()))
									{
										out.println("<td style='width:50px'><input type=checkbox name='check_per' checked=checked></td>");
									}else
									{
										out.println("<td style='width:50px'><input type=checkbox name='check_per'></td>");
									}
								}
								out.println("<td>"+sbpb.getParamName().toUpperCase()+"</td>");
								out.println("<td>"+sbpb.getParamDesc().toUpperCase()+"</td>");
							out.println("</tr>");
					}
				}
			}
		}
		else if("2".equals(type))//获取输入结构的名称集合
		{
			List list = null;
			if(saimport != null)  list=saimport.getStructList();//得到输入参数里面的所有项
			if(null!=list)
			{
				for(int h=0;h<list.size();h++) {
					SAPFunctionBaseParamBean sbpb = (SAPFunctionBaseParamBean)list.get(h);
					if(h%2==0) {
						out.println("<tr class=DataDark>");
					}else {
						out.println("<tr class=DataLight>");
					}
						if("1".equals(operation))
						{
							if(checkvalue.equals(sbpb.getParamName().toUpperCase()))
							{
								out.println("<td style='width:50px'><input type=checkbox name='check_per' checked=checked></td>");
							}else
							{
								out.println("<td style='width:50px'><input type=checkbox name='check_per'></td>");
							}
						}
						out.println("<td>"+sbpb.getParamName().toUpperCase()+"</td>");
						out.println("<td>"+sbpb.getParamDesc().toUpperCase()+"</td>");
					out.println("</tr>");
				}
			}
		}else if("5".equals(type))//获取输出结构结构的名称集合
		{
			List list = null;
			if(saexp != null) list=saexp.getStructList();//得到输入参数里面的所有项
			if(null!=list)
			{
				for(int h=0;h<list.size();h++) {
						SAPFunctionBaseParamBean sbpb = (SAPFunctionBaseParamBean)list.get(h);
						if(h%2==0) {
							out.println("<tr class=DataDark>");
						}else {
							out.println("<tr class=DataLight>");
						}
							if("1".equals(operation))
							{
								if(checkvalue.equals(sbpb.getParamName().toUpperCase()))
								{
									out.println("<td style='width:50px'><input type=checkbox name='check_per' checked=checked></td>");
								}else
								{
									out.println("<td style='width:50px'><input type=checkbox name='check_per'></td>");
								}
							}
							out.println("<td>"+sbpb.getParamName().toUpperCase()+"</td>");
							out.println("<td>"+sbpb.getParamDesc().toUpperCase()+"</td>");
						out.println("</tr>");
					}
			}
		}else if("7".equals(type))//获取输出表的名称集合
		{
			List list = null;
			if(saexp != null) list=saexp.getTableList();//得到输入参数里面的所有项
			if(null!=list)
			{
				for(int h=0;h<list.size();h++) {
						SAPFunctionBaseParamBean sbpb = (SAPFunctionBaseParamBean)list.get(h);
						if(h%2==0) {
							out.println("<tr class=DataDark>");
						}else {
							out.println("<tr class=DataLight>");
						}
							if("1".equals(operation))
							{
								if(checkvalue.equals(sbpb.getParamName().toUpperCase()))
								{
									out.println("<td style='width:50px'><input type=checkbox name='check_per' checked=checked></td>");
								}else
								{
									out.println("<td style='width:50px'><input type=checkbox name='check_per'></td>");
								}
							}
							out.println("<td>"+sbpb.getParamName().toUpperCase()+"</td>");
							out.println("<td>"+sbpb.getParamDesc().toUpperCase()+"</td>");
						out.println("</tr>");
					}
			}
		}else if("10".equals(type))//获取输入表的名称集合
		{
			List list = null;
			if(saimport != null)  list=saimport.getTableList();
			if(null!=list)
			{
				for(int h=0;h<list.size();h++) {
						SAPFunctionBaseParamBean sbpb = (SAPFunctionBaseParamBean)list.get(h);
						if(h%2==0) {
							out.println("<tr class=DataDark>");
						}else {
							out.println("<tr class=DataLight>");
						}
							if("1".equals(operation))
							{
								if(checkvalue.equals(sbpb.getParamName().toUpperCase()))
								{
									out.println("<td style='width:50px'><input type=checkbox name='check_per' checked=checked></td>");
								}else
								{
									out.println("<td style='width:50px'><input type=checkbox name='check_per'></td>");
								}
							}
							out.println("<td>"+sbpb.getParamName().toUpperCase()+"</td>");
							out.println("<td>"+sbpb.getParamDesc().toUpperCase()+"</td>");
						out.println("</tr>");
					}
			}
		}else if("11".equals(type))//获取某个输入表下面的所有的参数
		{
			if(!"".equals(stuortablevalue)) {
				List list=ServiceParamsUtil.getCompParamsByServIdAndParamName(servId, stuortablevalue, "import", false,paramName,paramDesc,disValue);
				if(null!=list)
				{
					for(int h=0;h<list.size();h++) {
							SAPFunctionBaseParamBean sbpb = (SAPFunctionBaseParamBean)list.get(h);
							if(h%2==0) {
								out.println("<tr class=DataDark>");
							}else {
								out.println("<tr class=DataLight>");
							}
								if("1".equals(operation))
								{
									if(checkvalue.equals(sbpb.getParamName().toUpperCase()))
									{
										out.println("<td style='width:50px'><input type=checkbox name='check_per' checked=checked></td>");
									}else
									{
										out.println("<td style='width:50px'><input type=checkbox name='check_per'></td>");
									}
								}
								out.println("<td>"+sbpb.getParamName().toUpperCase()+"</td>");
								out.println("<td>"+sbpb.getParamDesc().toUpperCase()+"</td>");
							out.println("</tr>");
						}
				}
			}
			
		}
	out.println("</TABLE>");
%>
	


</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="50px" colspan="3">
		&nbsp;
	</td>
</tr>
</table>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
		 <input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClear();"/>
		
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </wea:item>
	</wea:group>
	</wea:layout>
</div>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</BODY></HTML>

<SCRIPT LANGUAGE="javascript">
var ids = "";
var names = "";
var dialog = top.getDialog(window);
function btnok_onclick() {
	if(dialog){
		try{
	  	dialog.callback({id: ids, name: names});
	  	}catch(e){alert(e)}
	  	
	  	try{
		     dialog.close({id: ids, name: names});
		
		 }catch(e){alert(e)}
		dialog.callback();
	}else{
		window.parent.returnValue = {id: ids, name: names};//Array(documentids,documentnames)
    	window.parent.close();
	}
}
//多选
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		if($(this)[0].tagName=="TR"&&event.target.tagName!="INPUT"){
			
			<%
				if("1".equals(operation))
				{
			%>
		   		   var $checkboxtemp = $(this).find("input[name=check_per]");
		   		   $checkboxtemp.attr("checked",!$checkboxtemp.attr("checked"));
				   ids= "";
			       names = "";
			       $("input[name=check_per]").each(function() {
			        	if($(this).attr("checked") == true) {
			        		ids += "##" + $(this).parent().parent().find("td:eq(1)").text();
			        		names += "##" + $(this).parent().parent().find("td:eq(2)").text();
			        	}
			        });
		
			  <%
				}else{
			%>		
					ids =   $(this).find("td:eq(0)").text();
			   		names = $(this).find("td:eq(1)").text();
			   		submitData();
			<%		
				}
			%>

		}
		//点击checkbox框
	    if(event.target.tagName=="INPUT"){
	       var obj = $("input[name=check_per]");
	        ids= "";
	        names = "";
	        obj.each(function() {
	        	
	        	if($(this).attr("checked") == true) {
	        		ids += "##" + $(this).parents("tr:first").find("td:eq(1)").text();
	        		names += "##" + $(this).parents("tr:first").find("td:eq(2)").text();
	        	}
	        });
	        
	       
	    }
		
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	})

});
</SCRIPT>
<script language="javascript">
function onSubmit() {
		$G("SearchForm").submit();
}
function onReset() {
		$G("SearchForm").reset()
}
function submitData()
{
	btnok_onclick();
}

function onCancel()
{
	if(dialog){
	  	dialog.close();
    }else{
	    window.parent.close();
    }
}

function onClear()
{
	if(dialog){
		try{
	  	dialog.callback({id: "0",name: ""});
	  	}catch(e){alert(e)}
	  	
	  	try{
		     dialog.close({id: "0",name: ""});
		
		 }catch(e){alert(e)}
    }else{
    	 window.parent.returnValue = {id: "0",name: ""};
     window.parent.close();
    }
	
}
function doSearchParamsForm() {
	$("#searchFormParamsBtn").click();
}
function check_per_ALLClick() {
	var temp = $("#check_per_ALL").attr("checked");
	$("input[name='check_per'][type='checkbox']").attr("checked",temp);
	changeCheckboxStatus($("input[name='check_per'][type='checkbox']"),temp);
	if(temp == false) {
		ids = "";
		names = "";
	} else {
		$("input[name='check_per'][type='checkbox']").each(function(){
			var idtemp = $(this).parents("tr:first").find("td:eq(1)").html();
			var nametemp = $(this).parents("tr:first").find("td:eq(2)").html();
			ids += "##" + idtemp;
			names += "##" + nametemp;
			
		});
	}
	
}
function replaceALL(str,oldstr,newstr) 
{ 
   re=new RegExp(oldstr,"g"); 
   var newstart=str.replace(re,newstr); 
   return newstart;
   // 解释：re=new RegExp("l","g")中的第一个参数是你要替换的字符串，第二个参数指替换所有的，
   //其中，第二参数也可以设置为("i"),表示只替换第一个字符串。 
   //str.replace(re,"t")中第二个参数你要修改的字符串。
} 
</script>
