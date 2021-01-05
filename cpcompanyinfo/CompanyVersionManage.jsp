<%@page import="weaver.general.Util"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@page import="weaver.docs.docs.DocComInfo"%>
<%
	String licenseid = Util.null2String(request.getParameter("licenseid"));
	String contitutionid = Util.null2String(request.getParameter("constitutionid"));
	String shareid = Util.null2String(request.getParameter("shareid"));
	String directorsid =  Util.null2String(request.getParameter("directorsid"));
	String oneMoudel = Util.null2String(request.getParameter("oneMoudel"));
	
	//很关键的一个变量，用于判断后续页面是否开发编辑权限
	//0--只有这个公司的查看权限，没有维护权限
	//1--拥有这个公司查看和维护全县
	String showOrUpdate = Util.null2String(request.getParameter("showOrUpdate"));
 %>
<link rel="stylesheet" type="text/css" href="/cpcompanyinfo/style/wbox_wev8.css" />
<LINK href="/CRM/css/Contact_wev8.css" type=text/css rel=STYLESHEET>
<!--<LINK href="/CRM/css/Base_wev8.css" type=text/css rel=STYLESHEET>-->

<!--表头浮动层 start-->
<div  class="Bgfff">
	<div class="FL">
		<div class="border17 FL PTop5" style="width:490px">
			<select id="selectdate02" onchange="javascript:searchVersiondate(this);" class="OSelect MT3 MLeft8">
					</select>
					
					
 
    <div id="" class="_box" style="float:right!important;margin-right:20px!important;margin-top:5px!important;">
      <input type="button" value="<%=SystemEnv.getHtmlLabelName(367,user.getLanguage()) %>" class="e8_btn_top_first" onclick="viewVersion()" /> 
<%
if(!"0".equals(showOrUpdate)){
	%>
      <input type="button" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>" class="e8_btn_top" onclick="getVersion()" /> 
      <input type="button" value="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage()) %>" class="e8_btn_top" onclick="dodel_gd()" /> 
	<%
}
%>      
    </div>
 
 			
			<div class="clear" style="height:5px;"></div>

		</div>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("19587",user.getLanguage())%>' attributes="{'groupDisplay':''}">
		<wea:item attributes="{'isTableList':'true'}">
		<div class="OContRightScroll FL" style="height:193px;width:490px;">
		<table id="webTable2version" width="490" border="1" cellpadding="0" cellspacing="1" class="ListStyle" bordercolor="#F0F0F0">
			
			<tr id="OTable2" class="header">
				<td width="5%" height="25" align="center">
					<input type="checkbox" id="fileid" onclick="selectall_chk(this)"/>
				</td>
				<td width="10%" align="center">
					<%=SystemEnv.getHtmlLabelName(22186,user.getLanguage()) %>
				</td>
				<td width="20%" align="center">
					<%=SystemEnv.getHtmlLabelName(31126,user.getLanguage()) %>
				</td>
				<td width="15%" align="center">
					<%=SystemEnv.getHtmlLabelName(722,user.getLanguage()) %>
				</td>
				<td width="20%" align="center">
					<%=SystemEnv.getHtmlLabelName(31128,user.getLanguage()) %>
				</td>
			</tr>
			
			<% 
				int tempOr=1;
				if("sqlserver".equals(rs.getDBType())){
						tempOr=2;
				}
		
				String sql = "";
				if(oneMoudel.equals("license")){
					if(tempOr==1){
						sql = "select * from CPBUSINESSLICENSEVERSION where licenseid = '"+licenseid +"' order by  to_number(versionnum)  desc";
					}else{
						sql = "select * from CPBUSINESSLICENSEVERSION where licenseid = '"+licenseid +"'  order by  CONVERT(float,versionnum)  desc";
					}
				}
				if(oneMoudel.equals("constitution")){
					if(tempOr==1){
						sql = "select * from CPCONSTITUTIONVERSION where constitutionid = '"+contitutionid +"'   order by to_number(versionnum)  desc";
					}else{
							sql = "select * from CPCONSTITUTIONVERSION where constitutionid = '"+contitutionid +"' order by CONVERT(float,versionnum)  desc";
					}
					//System.out.println(sql);
				}
				if(oneMoudel.equals("share")){
					if(tempOr==1){
						sql = "select * from CPSHAREHOLDERVERSION where shareid = '"+shareid +"'   order by to_number(versionnum)  desc";
					}else{
						sql = "select * from CPSHAREHOLDERVERSION where shareid = '"+shareid +"'   order by CONVERT(float,versionnum)  desc";
					}
				}
				if(oneMoudel.equals("director")){
					if(tempOr==1){
						sql = "select * from CPBOARDVERSION where directorsid = '"+directorsid +"'   order by to_number(versionnum)  desc";
					}else{
						sql = "select * from CPBOARDVERSION where directorsid = '"+directorsid +"'   order by CONVERT(float,versionnum)  desc";
					}
				}
				//System.out.println("版本查询"+sql);
				rs.execute(sql);
				while(rs.next()){
			 %>
			<tr versionid=<%=rs.getString("versionid") %>   _versionnum="<%=rs.getString("VERSIONNUM") %>"    dbvalue="<%=Util.null2String(rs.getString("CREATEDATETIME")).substring(0,4) %>">
				<td width="5%" height="25" align="center">
					<input type="checkbox" name="checkbox" inWhichPage="zhzhVersion" onclick="selectone_chk()"/>
				</td>
				<td width="10%" align="center">
				<%=rs.getString("VERSIONNUM") %>
				</td>
				<td width="20%" align="center">
				<%=rs.getString("VERSIONNAME") %>
				</td>
				<td width="15%" align="center">
				<%=rs.getString("CREATEDATETIME").substring(0,10) %>
				</td>
				<td width="20%" align="center">
				<%=rs.getString("VERSIONMEMO") %>
				</td>
			</tr>
			<%} %>
		</table>
		
	</div>
			</wea:item>
	</wea:group>	
</wea:layout>
</div>
</div>
<!--表头浮动层 end-->
		
		
<script type="text/javascript">
	jQuery(document).ready(function(){
		var now = new Date();
		var currentYear = now.getFullYear();
		var selectdateoptions = '';
		for(xx=0;xx<=currentYear-1990;xx++){
			selectdateoptions+= "<option value='"+(currentYear-xx)+"'>"+(currentYear-xx)+"</option>";
		}
		jQuery("#selectdate02").html(selectdateoptions);
	});
	
	function searchVersiondate(o4this){
		var obj = jQuery("#webTable2version").find("tr");
		for(i=1;i<obj.size();i++){
			
			if(jQuery(o4this).val()==jQuery(obj[i]).attr("dbvalue"))
				jQuery(obj[i]).show();
			else
				jQuery(obj[i]).hide();
		}
	}
	
	//全部选择操作，复选框
	function selectall_chk(Tcheck){
	   if(Tcheck.checked==true){
	      $("input[type=checkbox][inWhichPage='zhzhVersion']").each(function(){
				 $(this).attr("checked",true);
		  });
	   }else{
		  $("input[type=checkbox][inWhichPage='zhzhVersion']").each(function(){
				 $(this).attr("checked",false);
		  });
	   }
	}
	 
	//选中其中的一个
	function selectone_chk(){
	    jQuery("#fileid").attr("checked",false); 
	}
</script>
