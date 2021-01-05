<!--
传入参数：
labels 要显示的提示
user 用户
id 目录id
categoryname 目录名称
categorytype 目录类型
operationcode 操作类型
canEdit 是否可以编辑
am 安全管理器
RecordSet
DepartmentComInfo
ResourceComInfo
CustomerTypeComInfo
RolesComInfo
-->

<%
	sqlWhere = "dirid="+id+" and dirtype="+categorytype+" and operationcode="+operationcode;
	if(canEdit){
		operateString = "<operates width=\"20%\">";
		 	       operateString+=" <popedom></popedom> ";
		 	       operateString+="     <operate isalwaysshow=\"true\" href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"0\"/>";
		 	       operateString+="</operates>";	
	}
	
	 if(canEdit){
	 	tabletype = "checkbox";
	 }
	tableString=""+
	   "<table pageId=\""+pageId+"\" instanceid=\""+intanceid+"\" pagesize=\""+pageSize+"\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"DirAccessControlList\" sqlorderby=\"mainid\"  sqlprimarykey=\"mainid\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			 "<col width=\"30%\" transmethod=\"weaver.general.KnowledgeTransMethod.getPermissionType\" text=\""+SystemEnv.getHtmlLabelName(operationcode==MultiAclManager.OPERATION_TREEFIELDDIR?21956:21956,user.getLanguage())+"\" column=\"permissiontype\" otherpara=\""+user.getLanguage()+"\"  orderkey=\"permissiontype\"/>"+
			 "<col width=\"35%\"  transmethod=\"weaver.general.KnowledgeTransMethod.getPermissionDesc\" column=\"permissiontype\" otherpara=\""+user.getLanguage()+"+column:secLevel+column:departmentid+column:roleid+column:roleLevel+column:usertype+column:userid+column:subcompanyid+column:isolddate+column:includesub+column:joblevel+column:jobdepartment+column:jobsubcompany+column:jobids\"  text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\"/>"+
			 "<col width=\"35%\"  transmethod=\"weaver.general.KnowledgeTransMethod.getPermissionSeclevel\" column=\"secLevel\" otherpara=\""+user.getLanguage()+"+column:secLevelmax+column:isolddate\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\"/>"+
	   "</head>"+
	   "</table>";
	   
%> 
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />

<script language="javascript">
function chkPermissionAllClick<%=operationcode%>(obj){
    var chks = document.getElementsByName("chkPermissionShareId<%=operationcode%>");    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }    
}
function doDel(id){
	 onPermissionDelShare<%=operationcode%>(id);
}
function onPermissionDelShare<%=operationcode%>(mainids){
    if(!mainids){
    	mainids = _xtable_CheckedCheckboxIdForCP();
    }
    //QC61315
    if(!mainids)
    {
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26178,user.getLanguage())%>");  
    	return;
    }
    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){ 
    	window.location = "/docs/category/PermissionOperation.jsp?isdialog=<%=isDialog%>&operationcode=<%=operationcode%>&method=delete&mainids="+mainids+"&categoryid=<%=id%>&categorytype=<%=categorytype%>&";
    });
}
</script>
