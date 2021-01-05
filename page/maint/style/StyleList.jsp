
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page"/>
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<jsp:useBean id="su" class="weaver.page.style.StyleUtil" scope="page"/>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
  </head>  
  <%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String type = Util.null2String(request.getParameter("type"));
	ArrayList idList=new ArrayList();
	ArrayList nameList=new ArrayList();
	ArrayList descList=new ArrayList();
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename =  "";
	String pageEdit="";
	if("element".equals(type)){
		titlename = SystemEnv.getHtmlLabelName(22913,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
		pageEdit="ElementStyleEdit.jsp";
		
		esc.setTofirstRow();						
		while(esc.next()){
			idList.add(esc.getId());
			nameList.add(esc.getTitle());
			descList.add(esc.getDesc());
		}		
	} else if("menuh".equals(type)){
		titlename = SystemEnv.getHtmlLabelName(22914,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
		pageEdit="MenuStyleEditH.jsp";
		
		mhsc.setTofirstRow();						
		while(mhsc.next()){
			idList.add(mhsc.getId());
			nameList.add(mhsc.getTitle());
			descList.add(mhsc.getDesc());
		}
	} else if("menuv".equals(type)){
		titlename = SystemEnv.getHtmlLabelName(22915,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
		pageEdit="MenuStyleEditV.jsp";
		try{
		//mvsc.setTofirstRow();						
		while(mvsc.next()){
			idList.add(mvsc.getId());
			nameList.add(mvsc.getTitle());
			descList.add(mvsc.getDesc());
		}
		}catch(Exception e){
			baseBean.writeLog(e.toString());
		}
	}
	String needfav ="1";
	String needhelp ="";
%>


<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(1014,user.getLanguage())+",javascript:onAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>
<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>
<!--For Dialog-->
<script type="text/javascript" src="/js/jquery/ui/ui.core_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/ui/ui.draggable_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/ui/ui.resizable_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/ui/ui.dialog_wev8.js"></script>


<TABLE width=100%  height=100% border="0" cellspacing="0" valign="top">
<colgroup>
<col width="">
<col width="5">
	  <tr>
		<td height="10" colspan="2"></td>
	  </tr>
	  <tr>		
		<td valign="top">  		
		  <TABLE class=Shadow width=100% height="100%" valign="top">
			<tr>
			  <td valign="top">                        
			
														
					<TABLE class="ListStyle" cellspacing=1 valign="top" width="100%">
					<TR class="header">
						<TH><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%><!--名称--></TH>
						<TH><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!--描述--></TH>
					</TR>
				
					<%						
						ArrayList cloneNameList=(ArrayList)nameList.clone();												
						Collections.sort(cloneNameList,new  weaver.general.PinyinComparator());
						
						for(int i=0;i<cloneNameList.size();i++){
							String stylename=(String)cloneNameList.get(i);
							int pos=nameList.indexOf(stylename);
							
							String styleid=(String)idList.get(pos);
							//String stylename=(String)nameList.get(i);
							String styledesc=(String)descList.get(pos);
							
					%>				
					<TR <%if((i+1)%2==0) out.println(" class='DataDark' "); else out.println(" class='DataLight' ");%>>
						<TD  valign="top" width="15%">
						    <a href="/page/maint/style/<%=pageEdit%>?styleid=<%=styleid%>&type=<%=type%>&from=list">					
								<%=Util.toHtml5(stylename)%>
							</a>
						</TD>
						<TD  valign="top" width="40%"><%=Util.toHtml5(styledesc)%></TD>
					</TR>					
					<TR style="height:1px;"><td colspan=3 class=line style="padding:0;"></td></TR>
					<%}%>
					
					</TABLE>
					
			  </td>
			</tr>
		  </TABLE>        
		</td>
		<td></td>
	  </tr>
	  <tr>
		<td height="10" colspan="2"></td>
	  </tr>
	</table>
	<div id="divTemplate" title="<%=SystemEnv.getHtmlLabelName(22993,user.getLanguage())%>">
		<select id="selectTemplate" style="width:90%;height:200px;">
		<%
			String selected="";
			for(int i=0;i<idList.size();i++){
				String styleid=(String)idList.get(i);
				String stylename=(String)nameList.get(i);
				if(styleid.equals("template")){
					selected ="selected";
				}else{
					selected ="";
				}
				out.println("<option value='"+styleid+"' "+selected+" >"+Util.toHtml5(stylename)+"</option>");
			}
		%>
		</select>	
	</div>
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
<!--
	function onAdd(){
		$("#divTemplate").dialog('open');
		var firstButton=$('.ui-dialog-buttonpane button:first');
		firstButton.attr('disabled', '');
		firstButton.removeClass('ui-state-disabled');	
	}
	$(document).ready(function(){
		$("#divTemplate").dialog({
			autoOpen: false,
			resizable:false,
			width:240,
			buttons: {
				"<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>": function() {
					var firstButton=$('.ui-dialog-buttonpane button:first');
					firstButton.attr('disabled', 'disabled');
					firstButton.addClass('ui-state-disabled');
					var value=$("#selectTemplate").val();
					document.location.href="StyleOprate.jsp?method=addFromTemplate&type=<%=type%>&template="+value;
				} 
			} 
		});	
	});
//-->
</SCRIPT>