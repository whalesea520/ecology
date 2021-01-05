<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<%
	String to = Util.null2String(request.getParameter("to"));
	int id = Util.getIntValue(request.getParameter("id"),0);
 %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#frmmain").submit();
	}
	
	jQuery(document).ready(function(){
		if("<%=to%>"=="1"){
			openDialog(<%=id%>);
		}
	});
	
	function onDelete(id){
		if(!id){
			id = _xtable_CheckedCheckboxId();
		}
		if(!id){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
			return;
		}
		if(id.match(/,$/)){
			id = id.substring(0,id.length-1);
		}
		var ids = id.split(",");
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			var ajaxNum=0;
			for(var i=0;i<ids.length;i++){
				ajaxNum++;
				jQuery.ajax({
					url:"NewsOperation.jsp?operation=delete&isdialog=2&id="+ids[i],
					method:"post",
					dataType:"text",
					complete:function(xhr,ts){
						ajaxNum--;
						if(ajaxNum==0){
							_table.reLoad();
						}
					},
					error:function(xhr,msg,e){
						
					}
				});
			}
		});
	}
	
	var dialog = null;
	function closeDialog(){
		if(dialog)
			dialog.close();
	}
	
	function openDialog(id){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=14&isdialog=1";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,70",user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 321;
		if(!!id){
			url = "/docs/tabs/DocCommonTab.jsp?_fromURL=15&isdialog=1&id="+id;
			dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,70",user.getLanguage())%>";
			dialog.Width = 800;
			dialog.Height = 427;
		}
		
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	
	//另存为新闻页
	function openDialogSaveAs(id){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=15&isdialog=1&operation=add&id="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("70,350",user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 427;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	
	function onLog(){
		var dialog = new window.top.Dialog();
		dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&sqlwhere=<%=xssUtil.put("where operateitem =6")%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(17480,user.getLanguage())%>";
		dialog.Width = jQuery(document).width();
		dialog.Height = 610;
		dialog.checkDataChange = false;
		dialog.maxiumnable = true;
		dialog.show();
		
	}
	
	function onPreview(id){
		/*var dialog = new window.top.Dialog();
		dialog.URL = "/docs/news/NewsDsp.jsp?id="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>";
		dialog.Width = jQuery(document).width();
		dialog.Height = jQuery(document).height();
		dialog.maxiumnable = true;
		dialog.checkDataChange = false;
		dialog.DefaultMax=true;
		dialog.show();*/
		window.open("/docs/news/NewsDsp.jsp?id="+id);
	}
	
	
</script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(70,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(68,user.getLanguage());
String needfav ="1";
String needhelp ="";
String frontpagename = Util.null2String(request.getParameter("frontpagename"));
String publishtype = Util.null2String(request.getParameter("publishtype"));
String newstypeid = Util.null2String(request.getParameter("newstypeid"));
String isactive = Util.null2String(request.getParameter("isactive"));
String depid = Util.null2String(request.getParameter("depid"));
String subcompanyId = Util.null2String(String.valueOf(session.getAttribute("docNews_subcompanyid")));

int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% boolean canEdit=  HrmUserVarify.checkUserRight("DocFrontpageEdit:Edit", user);
   boolean canlog=  HrmUserVarify.checkUserRight("DocFrontpage:log", user);
   boolean canAdd= HrmUserVarify.checkUserRight("DocFrontpageAdd:add", user);
   boolean canDelete= HrmUserVarify.checkUserRight("DocFrontpageEdit:Delete", user);
 int detachable = ManageDetachComInfo.isUseDocManageDetach()?1:0;
	    if(detachable==1){
			 canlog = false;
	         canAdd = false;
	         canDelete = false;
			 canEdit=false;
	    	if( CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocFrontpage:log",Util.getIntValue(subcompanyId,0))>0){
			   canlog = true;
			}
			if( CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocFrontpageAdd:add",Util.getIntValue(subcompanyId,0))>0){
			  canAdd = true;
			}
			if( CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocFrontpageEdit:Delete",Util.getIntValue(subcompanyId,0))>0){
			  canDelete = true;
			}
			if( CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocFrontpageEdit:Edit",Util.getIntValue(subcompanyId,0))>0){
			  canEdit = true;
			}
			
		
	    }
if(canAdd){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog()',_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(canDelete){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(canlog){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

 
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			
			<%
			if(canAdd){
			%>
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" onclick="javascript:openDialog()"/>
			<%
			}
			%>
			
			<%if(canDelete){ %>
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:onDelete()"/>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" id="flowTitle" onchange="setKeyword('flowTitle','frontpagename','frmmain')" value="<%= frontpagename %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<form action="DocNews.jsp" name="frmmain" id="frmmain">
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
				<wea:item><INPUT class=InputStyle id="frontpagename" name=frontpagename value='<%=frontpagename %>' ></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(1993,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=InputStyle  name=publishtype size=1>
						<option value=""></option>
						<option <%=publishtype.equals("1")?"selected":"" %> value="1"><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%></option>
						<option <%=publishtype.equals("0")?"selected":"" %> value="0"><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%></option>
						<%if(isgoveproj==0){%>
							<%if(isPortalOK){%><!--portal begin-->
								   <%while(CustomerTypeComInfo.next()){
										String curid=CustomerTypeComInfo.getCustomerTypeid();
										String curname=CustomerTypeComInfo.getCustomerTypename();
										String value="-"+curid;
								   %>
										<option <%=publishtype.equals(value)?"selected":"" %>  value="<%=value%>"><%=Util.toScreen(curname,user.getLanguage())%></option>
								   <%
								   }%>
							<%}%><!--portal end-->
						<%}%>
					</select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(19789,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=InputStyle  name=newstypeid>
						<option value=""></option>
						<%
							rs.executeSql("select id,typename from newstype order by dspnum");
							while(rs.next()){
								String value = rs.getString("typename");
						%>	
							<option <%=newstypeid.equals(value)?"selected":"" %> value="<%=value%>"><%=rs.getString("typename")%></option>
						<%}%>
					 </select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></wea:item>
				<wea:item><INPUT class=InputStyle name=isactive value=1 type=checkbox <%=isactive.equals("1")?"checked":"" %>></wea:item>
			</wea:group>
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</form>
</div>


			<%
				//设置好搜索条件				
				String sqlWhere = "1=1";
				if(!frontpagename.equals("")){
					sqlWhere += " and frontpagename like '%"+frontpagename+"%'";
				}
				if(!publishtype.equals("")){
					sqlWhere += " and publishtype = '"+publishtype+"'";
				}
				if(!newstypeid.equals("")){
					sqlWhere += " and newstypeid = "+newstypeid;
				}
				if(!isactive.equals("")){
					sqlWhere += " and isactive = '"+isactive+"'";
				}
				if(!depid.equals("")){
					sqlWhere += " and departmentid = "+depid;
				}
				if(Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0)==1){
					sqlWhere += " and subcompanyid in("+subcompanyId+")";
				}	
				
			String operateString= "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getNewsOperate\" otherpara=\"column:isactive\" otherpara2=\""+canEdit+"\"></popedom> ";
	 	       operateString+="     <operate href=\"javascript:onPreview();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:openDialog();\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"2\"/>";
	 	       operateString+="     <operate href=\"javascript:openDialogSaveAs();\"  text=\""+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"\" index=\"3\"/>";
	 	       operateString+="     <operate href=\"javascript:onDelete()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="</operates>";
				
				String tableString=""+
					   "<table pageId=\""+PageIdConst.DOC_NEWSLIST+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_NEWSLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
					   " <checkboxpopedom  showmethod=\"weaver.general.KnowledgeTransMethod.getNewsCheckbox\" id=\"checkbox\"  popedompara=\"column:id\" />"+
					   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlform=\"DocFrontpage\" sqlorderby=\"typeordernum\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
					   operateString+
					   "<head>";
					   	tableString += "<col width=\"10%\"  text=\"ID\" column=\"id\" orderkey=\"id\"/>";
					   		tableString+=	 "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"frontpagename\"  orderkey=\"frontpagename\" />";
					   		tableString += "<col width=\"15%\" transmethod=\"weaver.general.KnowledgeTransMethod.getNewsTypeName\"  text=\""+SystemEnv.getHtmlLabelName(19789,user.getLanguage())+"\" column=\"newstypeid\" orderkey=\"newstypeid\"/>";
					   		tableString += "<col width=\"15%\" transmethod=\"weaver.general.KnowledgeTransMethod.getNewsPublishTypeName\" otherpara=\""+user.getLanguage()+"\"  text=\""+SystemEnv.getHtmlLabelName(1993,user.getLanguage())+"\" column=\"publishtype\" orderkey=\"publishtype\"/>";
							tableString += "<col width=\"10%\" transmethod=\"weaver.general.KnowledgeTransMethod.getIsActiveDesc\" otherpara=\""+user.getLanguage()+"\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"isactive\" orderkey=\"isactive\"/>";
							tableString +=	 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"typeordernum\"  orderkey=\"typeordernum\" />"+
					   "</head>"+
					   "</table>";      
			  %>
			  <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_NEWSLIST %>"/>
							<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/> 
 
 </BODY></HTML>
