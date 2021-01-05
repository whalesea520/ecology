
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>

<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

 
<%
int ownerid=Util.getIntValue(request.getParameter("ownerid"));
if(ownerid==0) ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
String sname = Util.null2String(request.getParameter("name"));
%>

 

<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray_wev8.css" />
 	<script type="text/javascript">
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(15046,user.getLanguage())%>");
		}catch(e){}
	</script>
 </HEAD>
  <BODY>
  <div class="zDialog_div_content">
  	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" onclick="btnOnSearch()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.submit(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="CatagoryForAddBrowser.jsp" method=post>
		<wea:layout type="2col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
				<wea:item><input class=Inputstyle name=name value='<%=sname%>'></wea:item>
			</wea:group>
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
			</wea:group>
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item attributes="{'isTableList':'true','colspan':'full'}">
					<%
			String tableString = "";
			String sqlWhere = "";
			MultiAclManager am = new MultiAclManager();
			if(user.getType()==0){
				sqlWhere += " id in (select distinct sourceid from DirAccessControlDetail where "+
					"sharelevel="+MultiAclManager.OPERATION_CREATEDOC+" and "+ 
					"((type=1 and content="+user.getUserDepartment()+" and "+
					"seclevel<="+user.getSeclevel()+") or (type=2 and  content in ("+am.getUserAllRoleAndRoleLevel(user.getUID())+") "+ 
					"and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or "+
					"(type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or "+ 
					"(type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+")))";
			}else{
				sqlWhere += "id in (select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode="+MultiAclManager.OPERATION_CREATEDOC+" and "+ 
				"((permissiontype=3 and seclevel<="+user.getSeclevel()+") or (permissiontype=4 and usertype="+user.getType()+" and seclevel<="+user.getSeclevel()+")))";
			}
			
			if(!"".equals(sname)){
			    sqlWhere += " and categoryname like '%"+sname+"%'";
			}
			String pageIdStr = "10";
			tableString ="<table instanceid=\"docseccategory\" name=\"fieldList\" tabletype=\"none\"  pagesize=\"10\" >"+
		    "<sql backfields=\"id,categoryname,secorder\" sqlform=\"DocSecCategory\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\"secorder\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />";
		    tableString += " <head>";
		    tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"id\"/>";
		   	tableString+="<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(67,user.getLanguage())+"\" column=\"categoryname\"  />";
		   	tableString+="<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(19996,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.general.KnowledgeTransMethod.getMSSPath\"  />";
		   	tableString+="</head></table>";
			%>
			<wea:SplitPageTag tableString='<%=tableString%>' mode="run"/>
				</wea:item>
			</wea:group>
		</wea:layout>	
  	</FORM>
  </div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
 </BODY>
 </HTML>
	
   <SCRIPT LANGUAGE="JavaScript">
		
		function afterDoWhenLoaded(){
			jQuery("#_xTable").find("div.table").find("tr[class!='Spacing']").bind("click",function(){
				if(dialog){
					try{
						dialog.callback({id:$(this).find("td:first").next().text(),name:$(this).find("td:first").next().next().text(),other:$(this).find("td:first").next().next().next().text()});
					}catch(e){}
					try{
						dialog.close({id:$(this).find("td:first").next().text(),name:$(this).find("td:first").next().next().text(),other:$(this).find("td:first").next().next().next().text()});
					}catch(e){}
				}else{
					window.parent.returnValue = {id:$(this).find("td:first").next().text(),name:$(this).find("td:first").next().next().text(),other:$(this).find("td:first").next().next().next().text()};
					window.parent.close();
				}
			});
		}
		
		 function btnSubmit(nodeId,nodeText,nodePath){
		 	if(dialog){
				try{
		 		dialog.callback({id:nodeId,name:nodeText,other:nodePath});
				}catch(e){}
				try{
		 		dialog.close({id:nodeId,name:nodeText,other:nodePath});
				}catch(e){}
		 	}else{
		 		window.parent.returnValue = {id:nodeId,name:nodeText,other:nodePath}
		     	window.parent.close()
		 	}
		 }
		 
		 function btnOnSearch(){
		 	SearchForm.submit();
		 }
		 function onClear(){
		 	if(dialog){
				try{
		 		dialog.callback({id:"",name:"",other:""});
				}catch(e){}
				try{
		 		dialog.close({id:"",name:"",other:""});
				}catch(e){}
		 	}else{
		 		window.parent.returnValue = {id:"",name:""};
		     	window.parent.close();
		 	}
	     }
	     
	     function onClose(){
	     	if(dialog){
	     		dialog.close();
	     	}else{
	     		window.parent.close();
	     	}
	     }
	</script>
