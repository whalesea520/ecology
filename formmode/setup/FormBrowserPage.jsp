
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.workflow.form.FormManager"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	int pageNo = NumberHelper.string2Int(request.getParameter("pageNo"),1);
	int pageSize = NumberHelper.string2Int(request.getParameter("pageSize"),12);
	String formname = StringHelper.null2String(request.getParameter("formname"));
	String formtype = StringHelper.null2String(request.getParameter("formtype"));
	StringBuffer bodyBuffer = new StringBuffer();
	String sqlwhere = "";
	if(!StringHelper.isEmpty(formname))
		sqlwhere += " and d.labelname like '%"+formname+"%'";
    if(formtype.equals("1"))
    	sqlwhere += " and isvirtualform = 1";
    else if(formtype.equals("2")) 
    	sqlwhere += " and (isvirtualform is null or isvirtualform != 1)";
	
	 String sql = "select top("+pageSize+") d.labelname,a.*,c.isvirtualform from workflow_bill a " + 
     "left join ModeFormExtend c on a.id=c.formid left join HtmlLabelInfo d on a.namelabel=d.indexid and d.languageid=7 " +  
     "where id<0 and invalid is null "+sqlwhere;
	 sql += " and a.id not in(select top("+pageNo*pageSize+") a.id from workflow_bill a left join ModeFormExtend c on a.id=c.formid "+
	 "left join HtmlLabelInfo d on a.namelabel=d.indexid and d.languageid=7 where id<0 and invalid is null "+sqlwhere+" order by id desc)  ";
	 sql += " order by id desc";

	 RecordSet.executeSql(sql);
	 int idx = 0;
	 FormManager fManager = new FormManager();
	 while(RecordSet.next()){
		int tmpid = RecordSet.getInt("id");
    	String formtypestr = RecordSet.getInt("isvirtualform") == 1 ? SystemEnv.getHtmlLabelName(33885,user.getLanguage()) : SystemEnv.getHtmlLabelName(33886,user.getLanguage());//虚拟表单:实际表单
    	String tmplable = RecordSet.getString("labelname");
     	String checktmp = "";
     	String tablename = RecordSet.getString("tablename");
     	String formtable_main = fManager.getTablename(tmpid);//主表名
     	if(tablename.equals(formtable_main) || VirtualFormHandler.isVirtualForm(tmpid)){
     		idx++;
     		if(idx%2==0){
     			bodyBuffer.append("<TR class=DataLight>");	
     		}else{
     			bodyBuffer.append("<TR class=DataDark>");	
     		}
     		bodyBuffer.append("<TD style=\"display:none\"><A HREF=#>"+tmpid+"</A></TD>");
     		bodyBuffer.append("<td>"+tmplable+"</TD>");
		 	bodyBuffer.append("<td>"+formtypestr+"</TD>");
		 	bodyBuffer.append("</TR>");
     	}
	 }
	
	 out.print(bodyBuffer);
%>
