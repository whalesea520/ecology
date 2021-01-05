<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="cu" class="weaver.company.CompanyUtil" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />

<HTML><HEAD>
<link href="/cpcompanyinfo/style/Operations_wev8.css" rel="stylesheet"type="text/css" />
<link href="/cpcompanyinfo/style/Public_wev8.css" rel="stylesheet" type="text/css" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<LINK href="/js/ecology8/base/jquery.ui.all_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/js/ecology8/base/jquery.ui.progressbar_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
</HEAD>
<body>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


		<%
			if(!HrmUserVarify.checkUserRight("License:manager", user)){
	    		response.sendRedirect("/notice/noright.jsp");
	    		return;
			}
			int opertype = 1;//操作类型
			boolean canEdit=true;			
  			
		%>
		<div style="height: 5px"></div>
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = ""+SystemEnv.getHtmlLabelName(30945,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>	
		
		<!-- 查看文件权限开始 -->
		<FORM name="frmmain2"  id="frmmain2"  action="" method="post">
		
	<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
	</table>

		<%
		opertype = 2;//操作类型
		%>
	
<wea:layout >
 			
     <wea:group context='<%=SystemEnv.getHtmlLabelName(30950,user.getLanguage())%>' attributes="">
     <wea:item type="groupHead">
     	<input class="addbtn" accesskey="A" onclick="resDirAccessRightAdd('<%=opertype %>');" title="<%=SystemEnv.getHtmlLabelNames("611",user.getLanguage())%>" type="button">
		<input class="delbtn" accesskey="E" onclick="onPermissionDel('<%=opertype%>','frmmain2','1');" title="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>" type="button">
     </wea:item>
    <wea:item attributes="{'isTableList':'true'}">
 	   	
		
		<table id="company" class="ListStyle" style="width:100%;font-size: 12px" border="0" cellpadding="0" cellspacing="1" >
		  <colgroup> 
		  <col width="8%">
		  <col width="20%"> 
		  <col width="40%"> 
		  <col width="*">
		</colgroup> 
		
			<tr class="header">
					<th ><%if(canEdit){%>
						<input type="checkbox" name="chkDirAccessRightAll<%=opertype%>" onclick="chkDirAccessRightAllClick1(this,'<%=opertype%>')">
		   			 <%}%></th>
					<th ><%=SystemEnv.getHtmlLabelName(33234,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th>
			</tr>
		
		<%
		  RecordSet.executeSql("select * from  cpcominforight where comrright=2 and comallright=1");
			int i = 0;
		  while(RecordSet.next()){
			  i++;
		    if(RecordSet.getInt("permType")==1)	{%>
		    <TR class="<%=i%2==0?"DataLight":"DataDark" %>">
		      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkDirAccessRightId<%=opertype%>' <%if(!canEdit) out.print("disabled");%>></TD>
		      <TD class=Field><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("depid")),user.getLanguage())%>
				</TD>
				 <TD class=Field>
				<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
				&nbsp;-&nbsp;
				<%=Util.toScreen(RecordSet.getString("seclevel2"),user.getLanguage())%>
			  </TD>
		    </TR>
		
		<%}else if(RecordSet.getInt("permType")==2)	{%>
		    <TR class="<%=i%2==0?"DataLight":"DataDark" %>">
		      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkDirAccessRightId<%=opertype%>' <%if(!canEdit) out.print("disabled");%>></TD>
		      <TD class=Field><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(RolesComInfo.getRolesRemark(RecordSet.getString("roleid")),user.getLanguage())%>
				/
				<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
				</TD>
				 <TD class=Field> 
				 <%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
				&nbsp;-&nbsp;
				<%=Util.toScreen(RecordSet.getString("seclevel2"),user.getLanguage())%>
			  </TD>
		    </TR>
		            
		<%}else if(RecordSet.getInt("permType")==3)	{%>
		    <TR class="<%=i%2==0?"DataLight":"DataDark" %>">
		      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkDirAccessRightId<%=opertype%>' <%if(!canEdit) out.print("disabled");%>></TD>
		      <TD class=Field><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
			  <TD class=Field>
				</TD>
				 <TD class=Field>
				<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
				&nbsp;-&nbsp;
				<%=Util.toScreen(RecordSet.getString("seclevel2"),user.getLanguage())%>
			  </TD>
		    </TR>
		            
		<%}else if(RecordSet.getInt("permType")==4)	{%>
		    <TR class="<%=i%2==0?"DataLight":"DataDark" %>">
		      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkDirAccessRightId<%=opertype%>' <%if(!canEdit) out.print("disabled");%>></TD>
		      <TD class=Field><%=SystemEnv.getHtmlLabelName(7179,user.getLanguage())%></TD>
			  <TD class=Field>
			    <%=(RecordSet.getInt("usertype")==0)?SystemEnv.getHtmlLabelName(131,user.getLanguage()).trim():CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("usertype"))%>
			   </TD>
				 <TD class=Field>
				<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
				&nbsp;-&nbsp;
				<%=Util.toScreen(RecordSet.getString("seclevel2"),user.getLanguage())%>
			  </TD>
		    </TR>
		            
		<%} else if(RecordSet.getInt("permType")==5)	{%>
		    <TR class="<%=i%2==0?"DataLight":"DataDark" %>">
		      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkDirAccessRightId<%=opertype%>' <%if(!canEdit) out.print("disabled");%>></TD>
		      <TD class=Field><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
			  <TD class=Field>
			    <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%>
			  </TD>
			  <td></td>
		    </TR>
		            
		<%} else if(RecordSet.getInt("permType")==6)	{%>
		    <TR class="<%=i%2==0?"DataLight":"DataDark" %>">
		      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkDirAccessRightId<%=opertype%>' <%if(!canEdit) out.print("disabled");%>></TD>
		      <TD class=Field><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcomid")),user.getLanguage())%>
				</TD>
				 <TD class=Field>
				 <%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
				&nbsp;-&nbsp;
				<%=Util.toScreen(RecordSet.getString("seclevel2"),user.getLanguage())%>
			  </TD>
		    </TR>
		
		<%}
		}%>
		</table>
		   	</wea:item>
     </wea:group>
</wea:layout>	

		</FORM>		
		 
		 
		  <br>
		
		<!-- 查看文件权限开始 -->
		<FORM name="frmmain3"   id="frmmain3"   action="" method="post">
		<%
		opertype = 3;//操作类型
		%>
		
		
<wea:layout >
 			
     <wea:group context='<%=SystemEnv.getHtmlLabelName(30955,user.getLanguage())%>' attributes="">
     <wea:item type="groupHead">
     	<input class="addbtn" accesskey="A" onclick="resDirAccessRightAdd('<%=opertype %>');" title="<%=SystemEnv.getHtmlLabelNames("611",user.getLanguage())%>" type="button">
		<input class="delbtn" accesskey="E" onclick="onPermissionDel('<%=opertype%>','frmmain3','1');" title="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>" type="button">
     </wea:item>
    <wea:item attributes="{'isTableList':'true'}">
		
		<table id="person" class="ListStyle" style="width:100%;font-size: 12px" border="0" cellpadding="0" cellspacing="1" class="stripe OTable">
		  <colgroup> 
		  <col width="8%">
		  <col width="20%"> 
		  <col width="40%"> 
		  <col width="*">
		</colgroup> 
		
		<tr class="header">
						<th > <%if(canEdit){%>
						<input type="checkbox" name="chkDirAccessRightAll<%=opertype%>" onclick="chkDirAccessRightAllClick2(this,'<%=opertype%>')">
					    <%}%></th>
						<th ><%=SystemEnv.getHtmlLabelName(33234,user.getLanguage())%></th>
						<th><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></th>
						<th><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th>
					</tr>
					
		<%
		  RecordSet.executeSql("select * from  cpcominforight where comrright=3 and comallright=1");
			int i = 0;
		  while(RecordSet.next()){
			  i++;
		    if(RecordSet.getInt("permType")==1)	{%>
		    <TR class="<%=i%2==0?"DataLight":"DataDark" %>">
		      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkDirAccessRightId<%=opertype%>' <%if(!canEdit) out.print("disabled");%>></TD>
		      <TD class=Field><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("depid")),user.getLanguage())%>
				</TD>
				<TD> 
				<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
				&nbsp;-&nbsp;
				<%=Util.toScreen(RecordSet.getString("seclevel2"),user.getLanguage())%>
			  </TD>
		    </TR>
		
		<%}else if(RecordSet.getInt("permType")==2)	{%>
		    <TR class="<%=i%2==0?"DataLight":"DataDark" %>">
		      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkDirAccessRightId<%=opertype%>' <%if(!canEdit) out.print("disabled");%>></TD>
		      <TD class=Field><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(RolesComInfo.getRolesRemark(RecordSet.getString("roleid")),user.getLanguage())%>
				/
				<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
				</TD>
				<TD> 
				<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
				&nbsp;-&nbsp;
				<%=Util.toScreen(RecordSet.getString("seclevel2"),user.getLanguage())%>
			  </TD>
		    </TR>
		            
		<%}else if(RecordSet.getInt("permType")==3)	{%>
		    <TR class="<%=i%2==0?"DataLight":"DataDark" %>"> 
		      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkDirAccessRightId<%=opertype%>' <%if(!canEdit) out.print("disabled");%>></TD>
		      <TD class=Field><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
		      
			  <TD class=Field>
			  </TD>
				<TD> 
				<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
				&nbsp;-&nbsp;
				<%=Util.toScreen(RecordSet.getString("seclevel2"),user.getLanguage())%>
			  </TD>
		    </TR>
		            
		<%}else if(RecordSet.getInt("permType")==4)	{%>
		    <TR class="<%=i%2==0?"DataLight":"DataDark" %>">
		      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkDirAccessRightId<%=opertype%>' <%if(!canEdit) out.print("disabled");%>></TD>
		      <TD class=Field><%=SystemEnv.getHtmlLabelName(7179,user.getLanguage())%></TD>
			  <TD class=Field>
			    <%=(RecordSet.getInt("usertype")==0)?SystemEnv.getHtmlLabelName(131,user.getLanguage()).trim():CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("usertype"))%>
			     </TD>
				<TD>
				<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
				&nbsp;-&nbsp;
				<%=Util.toScreen(RecordSet.getString("seclevel2"),user.getLanguage())%>
			  </TD>
		    </TR>
		            
		<%} else if(RecordSet.getInt("permType")==5)	{%>
		    <TR class="<%=i%2==0?"DataLight":"DataDark" %>">
		      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkDirAccessRightId<%=opertype%>' <%if(!canEdit) out.print("disabled");%>></TD>
		      <TD class=Field><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
			  <TD class=Field>
			    <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%>
			  </TD>
			  <td></td>
		    </TR>
		            
		<%} else if(RecordSet.getInt("permType")==6)	{%>
		    <TR class="<%=i%2==0?"DataLight":"DataDark" %>">
		      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkDirAccessRightId<%=opertype%>' <%if(!canEdit) out.print("disabled");%>></TD>
		      <TD class=Field><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcomid")),user.getLanguage())%>
				 </TD>
				<TD>
				<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
				&nbsp;-&nbsp;
				<%=Util.toScreen(RecordSet.getString("seclevel2"),user.getLanguage())%>
			  </TD>
		    </TR>
		
		<%}
		}%>
		</table>
		
		</wea:item>
     </wea:group>
</wea:layout>	

		</FORM>
		
		
		</div>
		 
	<script type="text/javascript">
	
	$(document).ready(function(){
		    $(document).bind("contextmenu",function(e){
		        return false;
		    });
		});
		
		
		function chkDirAccessRightAllClick(obj,opertype){
		    var chks = document.getElementsByName("chkDirAccessRightId"+opertype);  
		    for (var i=0;i<chks.length;i++){
		        var chk = chks[i];
		        chk.checked=obj.checked;
		        
	    }    
}


	function chkDirAccessRightAllClick1(obj,opertype){
		 var allelm = jQuery('#company tr:gt(0)');
				 if(obj.checked==true){
			      	 allelm.each( function(i){
		          		jQuery(this).children("td:eq(0)").find("input").attr("checked",obj.checked);   
		          		jQuery(this).children("td:eq(0)").find("span:eq(1)").attr("class","jNiceCheckbox jNiceChecked"); 
			         });
			       }else{
			       		allelm.each( function(i){
		          		jQuery(this).children("td:eq(0)").find("input").attr("checked",obj.checked);   
		          		jQuery(this).children("td:eq(0)").find("span:eq(1)").attr("class","jNiceCheckbox"); 
			         });
			       }
	}
	
		function chkDirAccessRightAllClick2(obj,opertype){
		 var allelm = jQuery('#person tr:gt(0)');
				 if(obj.checked==true){
			      	 allelm.each( function(i){
		          		jQuery(this).children("td:eq(0)").find("input").attr("checked",obj.checked);   
		          		jQuery(this).children("td:eq(0)").find("span:eq(1)").attr("class","jNiceCheckbox jNiceChecked"); 
			         });
			       }else{
			       		allelm.each( function(i){
		          		jQuery(this).children("td:eq(0)").find("input").attr("checked",obj.checked);   
		          		jQuery(this).children("td:eq(0)").find("span:eq(1)").attr("class","jNiceCheckbox"); 
			         });
			       }
	}
			
	function resDirAccessRightAdd(opertype){
	
		var url="/cpcompanyinfo/ComcheckAccessRightAdd.jsp?opertype="+opertype+"&comallright=1";
		var title="<%=SystemEnv.getHtmlLabelNames("84070",user.getLanguage())%>";
		openDialog(url,title,500,600,false,false);
		
		
	
	}



function onPermissionDel(opertype,form,showjsp){
	var ids = "";
	var count = 0;
    var chks = document.getElementsByName("chkDirAccessRightId"+opertype);    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        if(chk.checked){
        	ids = ids + "," + chk.value;
            count ++;
        }
    }    
    if(count==0){
    	alert("<%=SystemEnv.getHtmlLabelName(30951,user.getLanguage())%>");
    	return false;
    }
   
    if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>?")){
    	var formObj =document.getElementById(form);
        formObj.action= "/cpcompanyinfo/ComAccessRightManage.jsp?method=delete&ids="+ids+"&showjsp="+showjsp;
        formObj.submit();
    }
}

$(function(){
	try{
		window.parent.showLeftTree();
		parent.rebindNavEvent(null,null,null,parent.parent.loadLeftTree,{_window:window,hasLeftTree:true});
		var treeSwitch = jQuery("#e8TreeSwitch",window.parent.document);
		treeSwitch.removeClass("e8_expandOrCollapseDivCol");
	}catch(e){}
	
});

	</script>		 
		
	
	
	
</body>
</html>
