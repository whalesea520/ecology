<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="AccessItemComInfo" class="weaver.gp.cominfo.AccessItemComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
	String itemname = Util.null2String(request.getParameter("itemname"));
	String itemdesc = Util.null2String(request.getParameter("itemdesc"));
	String itemtype = Util.getIntValue(request.getParameter("itemtype"),1)+"";
	String itemunit = Util.null2String(request.getParameter("itemunit"));
	String isvalid = Util.getIntValue(request.getParameter("isvalid"),0)+"";
	String formula = Util.getIntValue(request.getParameter("formula"),0)+"";
	String kpiformula = Util.null2String(request.getParameter("kpiformula"));
	if(itemtype.equals("1")){
		itemunit = "";
		formula = "0";
	}
	if("13".equals(formula)){
		kpiformula = Util.null2String(request.getParameter("javaclass"));
	}
	int msg = 0;
	if(operation.equals("add")){
		rs.executeSql("select 1 from GP_AccessItem where itemname='"+itemname+"' and itemdesc='"+itemdesc+"'");
		if(!rs.next()){
			rs.executeSql("insert into GP_AccessItem (itemname,itemdesc,itemtype,itemunit,isvalid,formula,formuladetail) values ('"+itemname+"','"+itemdesc+"',"+itemtype+",'"+itemunit+"',"+isvalid+","+formula+",'"+kpiformula+"')");
			String sql = "select max(id) from GP_AccessItem where itemname='"+itemname+"' and itemdesc='"+itemdesc+"'";
			if("oracle".equals(rs.getDBType())){
				if("".equals(itemdesc)){
					sql = "select max(id) from GP_AccessItem where itemname='"+itemname+"' and itemdesc is null ";
				}
			}
			rs.executeSql(sql);
			//rs.executeSql("select max(id) from GP_AccessItem where itemname='"+itemname+"' and itemdesc='"+itemdesc+"'");
			if(rs.next()){
				String id = Util.null2String(rs.getString(1));
				AccessItemComInfo.addComInfo(id);
			}
		}else{
			msg = 1;
		}
	}
	else if(operation.equals("edit")){
	  	String id = Util. null2String(request.getParameter("id"));
	  	rs.executeSql("select 1 from GP_AccessItem where itemname='"+itemname+"' and itemdesc='"+itemdesc+"' and id <>"+id);
	  	if(!rs.next()){
	  		rs.executeSql("update GP_AccessItem set itemname='"+itemname+"',itemdesc='"+itemdesc+"',itemtype="+itemtype+",itemunit='"+itemunit+"',isvalid="+isvalid+",formula="+formula+",formuladetail='"+kpiformula +"' where id="+id);
	  		AccessItemComInfo.updateCache(id);
	  	}else{
	  		msg = 1;
	  	}
	}
	
	response.sendRedirect("AccessItemList.jsp?msg="+msg);
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">