
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.util.LinkedHashMap" %>
<%
	int styleid = Util.getIntValue(request.getParameter("styleid"),0);
	String stylename = Util.null2String(request.getParameter("stylename"));
	int main_row_height = Util.getIntValue(request.getParameter("main_row_height"),0);
	int main_lable_width = Util.getIntValue(request.getParameter("main_lable_width"),0);
	int main_label_width_select = Util.getIntValue(request.getParameter("main_label_width_select"),0);
	int main_field_width = Util.getIntValue(request.getParameter("main_field_width"),0);
	int main_field_width_select = Util.getIntValue(request.getParameter("main_field_width_select"),0);
	String main_border = Util.null2String(request.getParameter("main_border"));
	String main_label_bgcolor = Util.null2String(request.getParameter("main_label_bgcolor"));
	String main_field_bgcolor = Util.null2String(request.getParameter("main_field_bgcolor"));
	int detail_row_height = Util.getIntValue(request.getParameter("detail_row_height"),0);
	int detail_col_width = Util.getIntValue(request.getParameter("detail_col_width"),0);
	int detail_col_width_select = Util.getIntValue(request.getParameter("detail_col_width_select"),0);
	String detail_border = Util.null2String(request.getParameter("detail_border"));
	String detail_label_bgcolor = Util.null2String(request.getParameter("detail_label_bgcolor"));
	String detail_field_bgcolor = Util.null2String(request.getParameter("detail_field_bgcolor"));
	String method = Util.null2String(request.getParameter("method"));
	String sql = "";
	String isadd = "false";
	if(method.equals("operat"))
	{
		if(styleid > 0)
		{
			sql = "update excelStyleDec set stylename='"+stylename+"',mainrowheight="+main_row_height+",mainlblwidth="+main_lable_width+",";
			sql += "mainlblwidthselect="+main_label_width_select+",";
			sql += "mainfieldwidth="+main_field_width+",mainfieldwidthselect="+main_field_width_select+",";
			sql += "mainborder='"+main_border+"',mainlblbgcolor='"+main_label_bgcolor+"',mainfieldbgcolor='"+main_field_bgcolor+"',";
			sql += "detailrowheight="+detail_row_height+",detailcolwidth="+detail_col_width+",detailcolwidthselect="+detail_col_width_select+",";
			sql += "detailborder='"+detail_border+"',detaillblbgcolor='"+detail_label_bgcolor+"',detailfieldbgcolor='"+detail_field_bgcolor+"' where ";
			sql += "id="+styleid;
		}else
		{
			isadd = "true";
			sql = "insert into excelStyleDec(stylename,mainrowheight,mainlblwidth,mainlblwidthselect,mainfieldwidth,mainfieldwidthselect,mainborder,mainlblbgcolor,mainfieldbgcolor,"+
			"detailrowheight,detailcolwidth,detailcolwidthselect,detailborder,detaillblbgcolor,detailfieldbgcolor) values (";
			sql += "'"+stylename+"',"+main_row_height+","+main_lable_width+","+main_label_width_select+","+main_field_width+","+main_field_width_select+",";
			sql += "'"+main_border+"','"+main_label_bgcolor+"','"+main_field_bgcolor+"',"+detail_row_height+","+detail_col_width+","+detail_col_width_select+",";
			sql += "'"+detail_border+"','"+detail_label_bgcolor+"','"+detail_field_bgcolor+"')";
		}
		if(sql.length() > 0)
		{
			RecordSet.executeSql(sql);
			if(styleid > 0);
			else{
				String maxidsql = "select max(id) styleid from excelStyleDec";
				RecordSet.executeSql(maxidsql);
				if(RecordSet.first())
					styleid = Util.getIntValue(RecordSet.getString("styleid"));
			}
		}
			
		response.sendRedirect("/formmode/exceldesign/excelStyleDesign.jsp?isclose=on&isadd="+isadd+"&styleid="+styleid);	
		return;
	}else if(method.equals("searchone"))
	{
		if(styleid > 0)
		{
			sql = " select * from excelStyleDec where id="+styleid;
			//System.out.println("sql:===>"+sql);
			RecordSet.executeSql(sql);
			while(RecordSet.next())
			{
				styleid = Util.getIntValue(RecordSet.getString("id"),0);
				stylename = Util.null2String(RecordSet.getString("stylename"));
				main_row_height = Util.getIntValue(RecordSet.getString("mainrowheight"),0);
				main_lable_width = Util.getIntValue(RecordSet.getString("mainlblwidth"),0);
				main_label_width_select = Util.getIntValue(RecordSet.getString("mainlblwidthselect"),0);
				main_field_width = Util.getIntValue(RecordSet.getString("mainfieldwidth"),0);
				main_field_width_select = Util.getIntValue(RecordSet.getString("mainfieldwidthselect"),0);
				main_border = Util.null2String(RecordSet.getString("mainborder"));
				main_label_bgcolor = Util.null2String(RecordSet.getString("mainlblbgcolor"));
				main_field_bgcolor = Util.null2String(RecordSet.getString("mainfieldbgcolor"));
				detail_row_height = Util.getIntValue(RecordSet.getString("detailrowheight"),0);
				detail_col_width = Util.getIntValue(RecordSet.getString("detailcolwidth"),0);
				detail_col_width_select = Util.getIntValue(RecordSet.getString("detailcolwidthselect"),0);
				detail_border = Util.null2String(RecordSet.getString("detailborder"));
				detail_label_bgcolor = Util.null2String(RecordSet.getString("detaillblbgcolor"));
				detail_field_bgcolor = Util.null2String(RecordSet.getString("detailfieldbgcolor"));
			}
			JSONObject stylejson = new JSONObject();
			stylejson.put("styleid",styleid);
			stylejson.put("stylename",stylename);
			stylejson.put("main_border",main_border);
			stylejson.put("main_label_bgcolor",main_label_bgcolor);
			stylejson.put("main_field_bgcolor",main_field_bgcolor);
			stylejson.put("detail_border",detail_border);
			stylejson.put("detail_label_bgcolor",detail_label_bgcolor);
			stylejson.put("detail_field_bgcolor",detail_field_bgcolor);
			String reval = stylejson.toString();
			//System.out.println(reval);
			response.getWriter().write(reval);
		}
	}else if(method.equals("searchall"))
	{
		sql = " select * from excelStyleDec";
		//System.out.println("sql:===>"+sql);
		RecordSet.executeSql(sql);
		LinkedHashMap map = new LinkedHashMap();
		while(RecordSet.next())
		{
			styleid = Util.getIntValue(RecordSet.getString("id"),0);
			stylename = Util.null2String(RecordSet.getString("stylename"));
			main_row_height = Util.getIntValue(RecordSet.getString("mainrowheight"),0);
			main_lable_width = Util.getIntValue(RecordSet.getString("mainlblwidth"),0);
			main_label_width_select = Util.getIntValue(RecordSet.getString("mainlblwidthselect"),0);
			main_field_width = Util.getIntValue(RecordSet.getString("mainfieldwidth"),0);
			main_field_width_select = Util.getIntValue(RecordSet.getString("mainfieldwidthselect"),0);
			main_border = Util.null2String(RecordSet.getString("mainborder"));
			main_label_bgcolor = Util.null2String(RecordSet.getString("mainlblbgcolor"));
			main_field_bgcolor = Util.null2String(RecordSet.getString("mainfieldbgcolor"));
			detail_row_height = Util.getIntValue(RecordSet.getString("detailrowheight"),0);
			detail_col_width = Util.getIntValue(RecordSet.getString("detailcolwidth"),0);
			detail_col_width_select = Util.getIntValue(RecordSet.getString("detailcolwidthselect"),0);
			detail_border = Util.null2String(RecordSet.getString("detailborder"));
			detail_label_bgcolor = Util.null2String(RecordSet.getString("detaillblbgcolor"));
			detail_field_bgcolor = Util.null2String(RecordSet.getString("detailfieldbgcolor"));
			JSONObject stylejson = new JSONObject();
			stylejson.put("styleid",styleid);
			stylejson.put("stylename",stylename);
			stylejson.put("main_border",main_border);
			stylejson.put("main_label_bgcolor",main_label_bgcolor);
			stylejson.put("main_field_bgcolor",main_field_bgcolor);
			stylejson.put("detail_border",detail_border);
			stylejson.put("detail_label_bgcolor",detail_label_bgcolor);
			stylejson.put("detail_field_bgcolor",detail_field_bgcolor);
			map.put("styleid"+styleid,stylejson);
		}
		JSONObject reval = JSONObject.fromObject(map);
		//System.out.println(reval);
		response.getWriter().write(reval.toString());
		
	}else if(method.equals("deleteone"))
	{
		sql = "delete from excelStyleDec where id="+styleid;
		RecordSet.executeSql(sql);
		response.getWriter().write("true");
	}
		
%>