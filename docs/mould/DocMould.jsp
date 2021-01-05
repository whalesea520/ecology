<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(16450,user.getLanguage());
String needfav ="1";
String needhelp ="";
String mouldName = Util.null2String(request.getParameter("flowTitle"));
String subcompanyId = Util.null2String(String.valueOf(session.getAttribute("showMould_subcompanyid")));
String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));

boolean canAdd=HrmUserVarify.checkUserRight("DocMouldAdd:add", user);
boolean canEdit=HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user);
boolean canDelete=HrmUserVarify.checkUserRight("DocMouldEdit:Delete", user);


        int detachable = ManageDetachComInfo.isUseDocManageDetach()?1:0;
	    if(detachable==1){
			 canEdit = false;
	         canAdd = false;
	         canDelete = false;
	    	if( CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocMouldEdit:Edit",Util.getIntValue(subcompanyId,0))>0){
			   canEdit = true;
			}
			if( CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocMouldAdd:add",Util.getIntValue(subcompanyId,0))>0){
			  canAdd = true;
			}
			if( CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocMouldEdit:Delete",Util.getIntValue(subcompanyId,0))>0){
			  canDelete = true;
			}
		
	    }

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#frmmain").submit();
	}
	
	function doSetUserDefaultMould(e){
		e = e || window.event;
		var ele = e.srcElement||e.target;
		var checked=jQuery(ele).attr("checked")
		var checkbox = jQuery(ele).closest("tr").find("input[type=checkbox]:first");
		var jNiceSpan = checkbox.next("span.jNiceCheckbox");
		var id = "";
		if(jNiceSpan.length==0 && checkbox.css("display")=="none"){
			id = checkbox.attr("id");
		}else{
			id = checkbox.attr("checkboxid");
		}
		if(!!checked){
			checked = "1";
		}else{
			checked = "0";
		}
		jQuery.ajax({
				url:"UploadDoc.jsp",
				type:"post",
				data:{
					operation:"setDefault",
					id:id,
					isuserdefault:checked
				},
				complete:function(xhr,status){
					_table.reLoad();
				}
			});
	}
	
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
		var idArr = id.split(",");
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function() {
			var ajaxNum=0;
		   for(var i=0;i<idArr.length;i++){
			   ajaxNum++;
				//以ajax方式提交
				jQuery.ajax({
					url:"UploadDoc.jsp",
					type:"post",
					data:{
						operation:"delete",
						id:idArr[i]
					},
					complete:function(xhr,status){
							ajaxNum--;
						if(ajaxNum==0)
							_table.reLoad();
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
	
	function openDialog(id,doctype){


		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=20&isdialog=1&isWorkflowDoc=<%=isWorkflowDoc%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,16450",user.getLanguage())%>";
		dialog.Width = jQuery(top.window).width()*0.95;
		dialog.Height =jQuery(top.window).height()*0.95;
		if(!!id){
			if(doctype=="0"){
				url = "/docs/tabs/DocCommonTab.jsp?_fromURL=21&isdialog=2&id="+id;
			}else{
				url = "/docs/tabs/DocCommonTab.jsp?_fromURL=22&isdialog=2&id="+id;
			}
			dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,16450",user.getLanguage())%>";
			dialog.Width =jQuery(top.window).width()*0.95;
			dialog.Height = jQuery(top.window).height()*0.95;
		}
		dialog.Drag = true;
		dialog.maxiumnable = true;
		dialog.URL = url;
		dialog.show();
	}
	
	//另存为模板
	function openDialogSaveAs(id,doctype){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;	
		dialog.normalDialog = false;
		if(doctype=="0"){
		url = "/docs/mould/DocMouldEdit.jsp?_fromURL=21&isdialog=2&operation=add&id="+id;
		}else{
		url = "/docs/mould/DocMouldEditExt.jsp?_fromURL=22&isdialog=2&operation=add&id="+id;
		}
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("33144,350",user.getLanguage())+"..."%>";
		dialog.Width =400;
		dialog.Height = 150;
		dialog.URL = url;
		dialog.maxiumnable = false;
		dialog.show();
	}
	
	function onLog(){
		var dialog = new window.top.Dialog();
		dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&sqlwhere=<%=xssUtil.put("where operateitem =5")%>";
		<%if(RecordSet.getDBType().equals("db2")){%>
			dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&sqlwhere=<%=xssUtil.put("where int(operateitem) =5")%>";
		<%}%>
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(17480,user.getLanguage())%>";
		dialog.Width = jQuery(document).width();
		dialog.Height = 610;
		dialog.checkDataChange = false;
		dialog.maxiumnable = true;
		dialog.show();
		
	}
	/*查看模板*/
	function viewDialog(id){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=23&isdialog=2&id="+id;
		<%if(canEdit){%>
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>";
		<%}else{%>
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>";
			<%}%>
		dialog.Width =jQuery(top.window).width()*0.95;
		dialog.Height = jQuery(top.window).height()*0.95;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.checkDataChange = false;
		dialog.maxiumnable = true;
		dialog.show();
	}
	
	/*标签排序*/
	function labelOrderDialog(id){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=47&isdialog=1&isWorkflowDoc=<%=isWorkflowDoc%>&mouldId="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("26364,338",user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 460;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.maxiumnable = true;
		dialog.show();
	}
	
	var userdefaultPlugin = {
		type:"checkbox",
		options:[
			{text:"",value:"1",name:"isView"}
		],
		bind:[
			{type:"click",fn:function(e){
				doSetUserDefaultMould(e);
			}}
		]
	};
	
</script>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<form action="DocMould.jsp" name="frmmain" id="frmmain">
<input type="hidden" name="isWorkflowDoc" id="isWorkflowDoc" value="<%=isWorkflowDoc %>"/>
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
			}if(canDelete){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>" class="e8_btn_top" onclick="onDelete();"/>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" value="<%=mouldName %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>

<%


if(canAdd){

RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

}

if(canDelete){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("DocMould:log", user)){

RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
	if("oracle".equals(RecordSet.getDBType())){
				//显示模板的生成规则，是先生成一篇word文档(因为只有先保存数据后，才能判断该文档是否设置了Contend)，然后再绑定模板的名字
				//如果用户在保存word提示没有设置Contend的时候,并且立马点击返回，那么就会插入空数据
				//所以在此做一次删除动作
				RecordSet.executeSql("delete  DocMould where issysdefault='0'  and  (mouldType=2 or mouldType=4) and mouldname is null");			
	}else{
				RecordSet.executeSql("delete  DocMould where issysdefault='0'  and  (mouldType=2 or mouldType=4) and mouldname=''");
	}
	//String sqlWhere = "issysdefault='0'";
	String sqlWhere = " id!=1";
				if(!mouldName.equals("")){
					sqlWhere += " and mouldName like '%"+mouldName+"%'";
				}
				if(Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0)==1){
					sqlWhere += " and subcompanyid in("+subcompanyId+")";
				}
				
				if(isWorkflowDoc.equals("1")){
					sqlWhere += " and mouldType in (2,4)";
				}	
    
    String  operateString= "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getMouldOperate\"  otherpara=\""+canAdd+"+"+canEdit+"+column:mouldType+"+isIE+"\"   otherpara2=\""+canDelete+"\"></popedom> ";
	 	       operateString+="     <operate otherpara=\"column:mouldType\" href=\"javascript:openDialog()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
			 
	 	       operateString+="     <operate otherpara=\"column:mouldType\" href=\"javascript:openDialogSaveAs()\" text=\""+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"\" index=\"1\"/>";
		
	 	       operateString+="     <operate otherpara=\"column:mouldType\" href=\"javascript:labelOrderDialog()\" text=\""+SystemEnv.getHtmlLabelNames("26364,338",user.getLanguage())+"\" index=\"2\"/>";
	 	       operateString+="     <operate href=\"javascript:onDelete()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"3\"/>";
	 	       operateString+="</operates>";
    
    String tableString=""+
		   "<table pageId=\""+PageIdConst.DOC_VIEWMOULDLIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_VIEWMOULDLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
		   " <checkboxpopedom showmethod=\"weaver.general.KnowledgeTransMethod.getMouldCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlform=\"DocMould\" sqlorderby=\"mouldType\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
		   operateString+
		   "<head>"+							 
				 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"id\"  orderkey=\"id\"  />"+
				 "<col width=\"30%\" transmethod=\"weaver.general.KnowledgeTransMethod.getMouldFileName\" otherpara=\"column:id\" text=\""+SystemEnv.getHtmlLabelName(18151,user.getLanguage())+"\" column=\"mouldName\" orderkey=\"mouldName\"/>"+
				 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(20622,user.getLanguage())+"\" column=\"mouldType\" transmethod=\"weaver.general.KnowledgeTransMethod.getModuleType2\" otherpara=\""+user.getLanguage()+"\"/>"+
				 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(149,user.getLanguage())+SystemEnv.getHtmlLabelName(16450 ,user.getLanguage())+"\" column=\"isuserdefault\" editPlugin=\"userdefaultPlugin\"   editEnableMethod=\"weaver.splitepage.transform.SptmForDoc.chkUserdefaultPlugin\" editpara=\""+canEdit+"\"/>"+
				 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(19521 ,user.getLanguage())+"\" column=\"lastModTime\" transmethod=\"weaver.general.KnowledgeTransMethod.getMouldModDate\" />"+						
		   "</head>"+
		   "</table>"; 
	%>
	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_VIEWMOULDLIST %>"/>
    <wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 


 </BODY></HTML>
