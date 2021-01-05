
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*,weaver.file.Prop" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="java.net.URLDecoder"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="dci" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rsc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="adci" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page" />
<%@ include file="/page/element/viewCommon.jsp"%>
<%
String key = Util.null2String(request.getParameter("key"));
key = URLDecoder.decode(key);
String whereSql = "";
String maxLimit = " 100 ";
String sql = null;
if("sqlserver".equals(rs.getDBType())){	//  oracle
	sql =" SELECT top "+maxLimit+" id,lastname,telephone,mobile,departmentid,email FROM HrmResource";
}else{
	sql =" SELECT id,lastname,telephone,mobile,departmentid,email FROM HrmResource";
}

if(adci.isUseAppDetach()){
	String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"");
	String tempstr= (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
	whereSql+=tempstr;
}

if(!"".equals(key)){
	whereSql += " and status in (0,1,2,3)  and (lastname like '%"+key+"%' or pinyinlastname like '%"+key+"%' or mobile like '%"+key+"%')";
	if(!whereSql.equals("")){
		sql+=" where "+whereSql.replaceFirst("and","");
	}
	if("oracle".equals(rs.getDBType())){
		sql+= " and rownum<"+maxLimit;
	}
	sql+=" order by dsporder asc, lastname asc";
	
}else{
	String hrm = Util.null2String(request.getParameter("hrm"));
	if(hrm.equals("1")){
		whereSql += " and status in (0,1,2,3) and id in (select selectid from HrmResourceSelectRecord WHERE resourceid = "+user.getUID()+")";
	}else if(hrm.equals("2")){
		whereSql +=" and status in (0,1,2,3) and departmentid='"+user.getUserDepartment()+"'";
	}else if(hrm.equals("3")){
		String queryShow ="select value from hpElementSetting where eid="+eid+" and name='showsub'";
		rs.execute(queryShow);
		boolean showSub = true;
		if(rs.next()){
			showSub = "1".equals(rs.getString("value"));
		}
		whereSql += " and status in (0,1,2,3) ";
		if(showSub){
			whereSql +=" and managerstr like '%,"+user.getUID()+",%'";
		}else{
			whereSql +=" and managerid = '"+user.getUID()+"'";
		}
	}
	
	if(!whereSql.equals("")){
		sql+=" where "+whereSql.replaceFirst("and","");
	}
	if("oracle".equals(rs.getDBType())){
		sql+= " and rownum<"+maxLimit;
	}
	sql+=" order by dsporder, lastname ";
	
	if(hrm.equals("1")){
		String limitTopStr = "sqlserver".equals(rs.getDBType()) ? (" top "+maxLimit) :"" ;
		String limitWhereStr = "oracle".equals(rs.getDBType()) ? (" and rownum<"+maxLimit) :"" ;
		sql = " select "+limitTopStr+" hr.id as id, hrsd.id dsporder0,lastname, telephone,mobile,departmentid,email, dsporder "
			+ " from hrmresource hr, HrmResourceSelectRecord  hrsd " 
			+ " where hr.id = selectid and resourceid ="+user.getUID()+" and hr.status in (0,1,2,3)" + limitWhereStr
			+ " order by dsporder0 desc, dsporder ";
	}
	
}

String imgSymbol="";
if (!"".equals(esc.getIconEsymbol(hpec.getStyleid(eid)))) imgSymbol="<img name='esymbol' src='"+esc.getIconEsymbol(hpec.getStyleid(eid))+"'>";



//out.println("select id,lastname,departmentid  from Hrmresource where id ='"+userid+"' or   belongto = '"+userid+"' order by id ");
//out.println(sql);

rs.execute(sql);

%>

<table id="_contenttable_<%=eid%>" class="Econtent elementdatatable"  style="table-layout:auto;margin:0;" width=100%>
<%
while(rs.next()){
	int size=1;
	%>
		<tr>
			<TD width="8"><%=imgSymbol%></TD>
			
			<%
			int fsize = fieldIdList.size();
			for (int j = 0; j < fsize; j++) {
			String fieldId = (String) fieldIdList.get(j);
			String columnName = (String) fieldColumnList.get(j);
			String fieldwidth = (String) fieldWidthList.get(j);
				if(columnName.equals("name")){
					%>
					<td style="min-width:90px" _order="<%=size-1 %>">
						<font class=font style="cursor: pointer;" onclick="window.open('/hrm/HrmTab.jsp?_fromURL=HrmResource&id=<%=rs.getString("id") %>')"><%=rs.getString("lastname") %></font>
					</td>
					<%
					
				}
				if(columnName.equals("tel")){
					%>
					<td width="<%=fieldwidth %>"  _order="<%=size-1 %>" align="right">
						<font class=font><%=rs.getString("telephone") %></font>
					</td>
					<%
					
				}
				if(columnName.equals("mobile")){
					%>
					<td width="<%=fieldwidth %>"  _order="<%=size-1 %>" align="right">
						<font class=font><%=rsc.getMobileShow(rs.getString("id"),user) %></font>
					</td>
					<%
					
				}
				if(columnName.equals("email")){
					%>
					<td width="<%=fieldwidth %>"  _order="<%=size-1 %>" align="right">
						<font class=font><%=rs.getString("email") %></font>
					</td>
					<%
					
				}
				if(columnName.equals("department")){
					%>
					<td width="*"  _order="<%=size-1 %>" align="right">
						<font class=font><%=dci.getDepartmentname(rs.getString("departmentid")) %></font>
					</td>
					<%
					
				}
				size++;
			}
			%>
				
			
			
		</tr>
		 <TR class='sparator' style='height:1px' height=1px><td style='padding:0px' colspan=<%=size%>></td></TR>
	<%
}
//out.println(key);
%>
</table>		
<script>
$(document).ready(function(){
	var wArr = new Array(0,0,0,0,0);
	$("#_contenttable_<%=eid%> tr[class!='sparator']").each(function(i,o){
		$(o).find('font').each(function(j,obj){
			if(wArr[j] < $(obj).width()){
				wArr[j] = $(obj).width();
			}
		})
	})
	for(var i=0;i<wArr.length; i++){
		$("#_contenttable_<%=eid%> td[_order="+i+"][width][width!='*']").width((wArr[i] > 0? wArr[i]+10 : wArr[i]));
		if(wArr[i] > 0){
			$("#_contenttable_<%=eid%> td[_order="+i+"] font").css("margin-right","10px");
		}
	}
})
</script>