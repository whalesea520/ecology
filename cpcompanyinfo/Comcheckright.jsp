<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<link href="/cpcompanyinfo/style/Operations_wev8.css" rel="stylesheet"type="text/css" />
<link href="/cpcompanyinfo/style/Public_wev8.css" rel="stylesheet" type="text/css" />
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<html>
<body>
		<% 
			if(!HrmUserVarify.checkUserRight("License:manager", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
			}
			int opertype = 1;//操作类型 
			boolean canEdit=true;	
			String title="";		 
  			String comid=Util.null2String(request.getParameter("comid"));//得到公司的id 
  			String sql="select companyname,companyid,archivenum from CPCOMPANYINFO where companyid='"+comid+"'";
  			if(rs.execute(sql)&&rs.next())
  			{
  				title="["+rs.getString("archivenum")+"]"+rs.getString("companyname")+"_____";
  			}
  			
		%>
		
		<div style="height: 5px"></div>	  
		<!-- 查看文件权限开始 -->
		<FORM name="frmmain2" id="frmmain2" action="" method="post">
		
		<%
		opertype = 2;//操作类型
		%>
	<wea:layout>
		<wea:group context='<%=title+SystemEnv.getHtmlLabelNames("30950",user.getLanguage()) %>' attributes="">
		<wea:item type="groupHead">
			<input class="addbtn" accesskey="A" onclick="resDirAccessRightAdd('<%=opertype %>');" title="<%=SystemEnv.getHtmlLabelNames("611",user.getLanguage())%>" type="button">
			<input class="delbtn" accesskey="E" onclick="javaScript:onPermissionDel('<%=opertype%>','frmmain2','1');" title="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>" type="button">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
	
		<table class="ListStyle" id="company" style="width:100%;font-size: 12px" border="0" cellpadding="0" cellspacing="1" >
		  <colgroup> 
			  <col width="8%">
			  <col width="20%"> 
			  <col width="40%"> 
			  <col width="*">
		  </colgroup> 
		  <tr class="header"> 
				   <th ">  
				       <%if(canEdit){%>
						<input type="checkbox" name="chkDirAccessRightAll<%=opertype%>" onclick="chkDirAccessRightAllClick(this,'<%=opertype%>')">
					    <%}%>
				   </th>		
			   		<th ><%=SystemEnv.getHtmlLabelName(33234,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th>	     
		  </tr>
		
		<%
		 RecordSet.executeSql("select * from  cpcominforight where comid="+comid+" and comallright=0 and comrright="+opertype+" ");
		int i =0;
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
			  <TD></TD>
		    </TR>
		            
		<%} else if(RecordSet.getInt("permType")==6)	{%>
		    <TR class="<%=i%2==0?"DataLight":"DataDark" %>">
		      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkDirAccessRightId<%=opertype%>' <%if(!canEdit) out.print("disabled");%>></TD>
		      <TD class=Field><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
			  <TD class=Field>
			  <%
			   %>
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
		
		
		</div>
		
	
		
</body>

	<script type="text/javascript">
	
		$(document).ready(function(){
		    $(document).bind("contextmenu",function(e){
		        return false;
		    });
		});

	function chkDirAccessRightAllClick(obj,opertype){
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
			
	function resDirAccessRightAdd(opertype){

		var url="/cpcompanyinfo/ComcheckAccessRightAdd.jsp?opertype="+opertype+"&comid=<%=comid%>";
		var title="<%=SystemEnv.getHtmlLabelNames("84070",user.getLanguage())%>";
		openDialog(url,title,500,600,false,false);
		
		
	
	/**
    	var xposition=0; var yposition=0;
		if ((parseInt(navigator.appVersion) >= 4 ))
		{
			xposition = (screen.width - 550) / 2;
			yposition = (screen.height - 650) / 2;
		}
		var msg = window.showModalDialog("/cpcompanyinfo/ComcheckAccessRightAdd.jsp?opertype="+opertype+"&comid=<%=comid%>",window, "dialogWidth:800px; dialogHeight:600px; dialogLeft:"+xposition+"px; dialogTop:"+yposition+"px; status:no;scroll:no;resizable=no;");
   	 	if(msg=='1'){
	  	window.location.reload();
		}
	**/
	
	}


function onPermissionDel(opertype,form,showjsp){
	var ids = "";
	var count = 0;
    var chks = document.getElementsByName("chkDirAccessRightId"+opertype);    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        if(chk.checked){
        	ids += chk.value + ",";
            count ++;
        }
    }    
  // alert(ids);
    if(count==0){
    	alert("<%=SystemEnv.getHtmlLabelName(30951,user.getLanguage())%>");
    	return false;
    }
   
    if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>?")){
    	var formObj = document.getElementById(form);
        formObj.action= "/cpcompanyinfo/ComAccessRightManage.jsp?method=delete&ids="+ids+"&showjsp=0&comid=<%=comid%>"+"&comallright=0";
         formObj.action="/cpcompanyinfo/ComAccessRightManage.jsp?method=delete&ids="+ids+"&showjsp=0&comid=<%=comid%>"+"&comallright=0";
        formObj.submit();
    }
}


	</script>	
</html>
