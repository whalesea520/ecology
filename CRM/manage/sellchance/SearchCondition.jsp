
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String listType=Util.null2String(request.getParameter("listType"));
	if(listType.equals("1")){
%>
	<div class="listitem" onclick="doSearch(this,'creater','<%=user.getUID() %>')">我的商机</div>
	<div class="listitem" onclick="doSearch(this,'attention','1')">关注商机</div>
	<div class="listitem" onclick="doSearch(this,'subcompanyId','<%=user.getUserSubCompany1() %>')">所在分部</div>
	<div class="listitem" onclick="doSearch(this,'deptId','<%=user.getUserDepartment() %>')">所在部门</div>
<%	}else if(listType.equals("2")){ 
		rs.executeSql("select id,lastname from hrmresource where (status =0 or status = 1 or status = 2 or status = 3) and managerid=" + user.getUID() + " order by dsporder");
		if(rs.getCounts()==0){
%>
	<div style="width:100%;line-height: 40px;text-align: left;font-size: 12px;color: #808080;padding-left:15px;" >暂无下属人员！</div>
<%			
		}
		while(rs.next()){
%>
	<div class="listitem" onclick="doSearch(this,'creater','<%=rs.getString("id") %>')"><%=rs.getString("lastname") %></div>
<%
		} 
	}else if(listType.equals("3")){
%>
	<script>
	 jQuery(document).ready(function(){
	       $("#hrmOrgTree").addClass("hrmOrg"); 
	       $("#hrmOrgTree").treeview({
	          url:"/tree/hrmOrgTree.jsp"
	       });
	 });
	 function doClick(orgId,type,obj){
			var parm = "";
			if(type==2){
				parm = "subcompanyId";
			}else if(type==3){
				parm = "deptId";
			}else if(type==4){
				parm = "creater";
			}
			doSearch(null,parm,orgId);
			if(obj){
				jQuery(obj).css("font-weight","normal");
				jQuery(obj).parent().parent().find(".selected").removeClass("selected");
				jQuery(obj).parent().addClass("selected");
			}
	 }
    </script> 
    <div style="width:100%;;border-top:1px solid  #c8ebfd;line-height:1px"></div>
    <ul id="hrmOrgTree" style="width: 100%"></ul>
<%
	}else{
		SellstatusComInfo.setTofirstRow();
		while(SellstatusComInfo.next()){
%>
		<div class="listitem" onclick="doSearch(this,'sellstatusid','<%=SellstatusComInfo.getSellStatusid() %>')"><%=SellstatusComInfo.getSellStatusname() %></div>
<%
		}
	}
%>		