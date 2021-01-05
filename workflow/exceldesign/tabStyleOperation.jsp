<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.util.LinkedHashMap" %>
<%
	String method = Util.null2String(request.getParameter("method"));
	String sql = "";
	if("deleteone".equals(method)){
		int styleid = Util.getIntValue(request.getParameter("styleid"));
		if(styleid>0){
			sql = "delete from workflow_tabstyle where styleid =" + styleid;
			rs.executeSql(sql);
			JSONObject returnjson = new JSONObject();
			returnjson.put("state", "true");
			response.getWriter().write(returnjson.toString());
		}
	}else if("selectone".equals(method)){
		int styleid = Util.getIntValue(request.getParameter("styleid"));
		String returnStr = "none";
		if(styleid >0){
			sql = "select * from workflow_tabstyle where styleid= " + styleid;
			rs.executeSql(sql);
			if(rs.next()){
				JSONObject stylejson = new JSONObject();
				stylejson.put("image_bg", Util.null2String(rs.getString("image_bg")));
				stylejson.put("image_sep", Util.null2String(rs.getString("image_sep")));
				stylejson.put("image_sepwidth", Util.null2String(rs.getString("image_sepwidth")));
				
				stylejson.put("sel_bgleft", Util.null2String(rs.getString("sel_bgleft")));
				stylejson.put("sel_bgleftwidth", Util.null2String(rs.getString("sel_bgleftwidth")));
				stylejson.put("sel_bgmiddle", Util.null2String(rs.getString("sel_bgmiddle")));
				stylejson.put("sel_bgright", Util.null2String(rs.getString("sel_bgright")));
				stylejson.put("sel_bgrightwidth", Util.null2String(rs.getString("sel_bgrightwidth")));
				stylejson.put("sel_color", Util.null2String(rs.getString("sel_color")));
				stylejson.put("sel_fontsize", Util.null2String(rs.getString("sel_fontsize")));
				stylejson.put("sel_family", Util.null2String(rs.getString("sel_family")));
				stylejson.put("sel_bold", Util.null2String(rs.getString("sel_bold")));
				stylejson.put("sel_italic", Util.null2String(rs.getString("sel_italic")));
	
				stylejson.put("unsel_bgleft", Util.null2String(rs.getString("unsel_bgleft")));
				stylejson.put("unsel_bgleftwidth", Util.null2String(rs.getString("unsel_bgleftwidth")));
				stylejson.put("unsel_bgmiddle", Util.null2String(rs.getString("unsel_bgmiddle")));
				stylejson.put("unsel_bgright", Util.null2String(rs.getString("unsel_bgright")));
				stylejson.put("unsel_bgrightwidth", Util.null2String(rs.getString("unsel_bgrightwidth")));
				stylejson.put("unsel_color", Util.null2String(rs.getString("unsel_color")));
				stylejson.put("unsel_fontsize", Util.null2String(rs.getString("unsel_fontsize")));
				stylejson.put("unsel_family", Util.null2String(rs.getString("unsel_family")));
				stylejson.put("unsel_bold", Util.null2String(rs.getString("unsel_bold")));
				stylejson.put("unsel_italic", Util.null2String(rs.getString("unsel_italic")));
				returnStr = stylejson.toString();
			}
		}
		response.getWriter().write(returnStr);
	}else if("selectall".equals(method)){
		sql = "select * from workflow_tabstyle order by styleid ";
		rs.executeSql(sql);
		LinkedHashMap<String,Object> map = new LinkedHashMap<String,Object>();
		while(rs.next()){
			int styleid = Util.getIntValue(rs.getString("styleid"));
			JSONObject stylejson = new JSONObject();
			stylejson.put("opertype", "add");
			stylejson.put("styleid", Util.null2String(rs.getString("styleid")));
			stylejson.put("stylename", Util.null2String(rs.getString("stylename")));
			stylejson.put("image_bg", Util.null2String(rs.getString("image_bg")));
			stylejson.put("image_sep", Util.null2String(rs.getString("image_sep")));
			stylejson.put("image_sepwidth", Util.null2String(rs.getString("image_sepwidth")));
			
			stylejson.put("sel_bgleft", Util.null2String(rs.getString("sel_bgleft")));
			stylejson.put("sel_bgleftwidth", Util.null2String(rs.getString("sel_bgleftwidth")));
			stylejson.put("sel_bgmiddle", Util.null2String(rs.getString("sel_bgmiddle")));
			stylejson.put("sel_bgright", Util.null2String(rs.getString("sel_bgright")));
			stylejson.put("sel_bgrightwidth", Util.null2String(rs.getString("sel_bgrightwidth")));
			stylejson.put("sel_color", Util.null2String(rs.getString("sel_color")));
			stylejson.put("sel_fontsize", Util.null2String(rs.getString("sel_fontsize")));
			stylejson.put("sel_family", Util.null2String(rs.getString("sel_family")));
			stylejson.put("sel_bold", Util.null2String(rs.getString("sel_bold")));
			stylejson.put("sel_italic", Util.null2String(rs.getString("sel_italic")));

			stylejson.put("unsel_bgleft", Util.null2String(rs.getString("unsel_bgleft")));
			stylejson.put("unsel_bgleftwidth", Util.null2String(rs.getString("unsel_bgleftwidth")));
			stylejson.put("unsel_bgmiddle", Util.null2String(rs.getString("unsel_bgmiddle")));
			stylejson.put("unsel_bgright", Util.null2String(rs.getString("unsel_bgright")));
			stylejson.put("unsel_bgrightwidth", Util.null2String(rs.getString("unsel_bgrightwidth")));
			stylejson.put("unsel_color", Util.null2String(rs.getString("unsel_color")));
			stylejson.put("unsel_fontsize", Util.null2String(rs.getString("unsel_fontsize")));
			stylejson.put("unsel_family", Util.null2String(rs.getString("unsel_family")));
			stylejson.put("unsel_bold", Util.null2String(rs.getString("unsel_bold")));
			stylejson.put("unsel_italic", Util.null2String(rs.getString("unsel_italic")));
			map.put("style_"+styleid, stylejson);
		}
		response.getWriter().write(JSONObject.fromObject(map).toString());
	}else if("save".equals(method)){
		String opertype = Util.null2String(request.getParameter("opertype"));
		int styleid = Util.getIntValue(request.getParameter("styleid"), 0);
		String stylename = Util.null2String(request.getParameter("stylename"));
		String image_bg = Util.null2String(request.getParameter("image_bg"));
		String image_sep = Util.null2String(request.getParameter("image_sep"));
		int image_sepwidth = Util.getIntValue(request.getParameter("image_sepwidth"), 0);
		
		String sel_bgleft = Util.null2String(request.getParameter("sel_bgleft"));
		int sel_bgleftwidth = Util.getIntValue(request.getParameter("sel_bgleftwidth"), 0);
		String sel_bgmiddle = Util.null2String(request.getParameter("sel_bgmiddle"));
		String sel_bgright = Util.null2String(request.getParameter("sel_bgright"));
		int sel_bgrightwidth = Util.getIntValue(request.getParameter("sel_bgrightwidth"), 0);
		String sel_color = Util.null2String(request.getParameter("sel_color"));
		int sel_fontsize = Util.getIntValue(request.getParameter("sel_fontsize"), 10);
		String sel_family = Util.null2String(request.getParameter("sel_family"));
		int sel_bold = "on".equals(Util.null2String(request.getParameter("sel_bold")))?1:0;
		int sel_italic = "on".equals(Util.null2String(request.getParameter("sel_italic")))?1:0;
		
		String unsel_bgleft = Util.null2String(request.getParameter("unsel_bgleft"));
		int unsel_bgleftwidth = Util.getIntValue(request.getParameter("unsel_bgleftwidth"), 0);
		String unsel_bgmiddle = Util.null2String(request.getParameter("unsel_bgmiddle"));
		String unsel_bgright = Util.null2String(request.getParameter("unsel_bgright"));
		int unsel_bgrightwidth = Util.getIntValue(request.getParameter("unsel_bgrightwidth"), 0);
		String unsel_color = Util.null2String(request.getParameter("unsel_color"));
		int unsel_fontsize = Util.getIntValue(request.getParameter("unsel_fontsize"), 10);
		String unsel_family = Util.null2String(request.getParameter("unsel_family"));
		int unsel_bold = "on".equals(Util.null2String(request.getParameter("unsel_bold")))?1:0;
		int unsel_italic = "on".equals(Util.null2String(request.getParameter("unsel_italic")))?1:0;
		
		if("add".equals(opertype)){
			sql = " insert into workflow_tabstyle(stylename,image_bg,image_sep,image_sepwidth, "
				+ " sel_bgleft,sel_bgleftwidth,sel_bgmiddle,sel_bgright,sel_bgrightwidth, "
				+ " sel_color,sel_fontsize,sel_family,sel_bold,sel_italic, "
				+ " unsel_bgleft,unsel_bgleftwidth,unsel_bgmiddle,unsel_bgright,unsel_bgrightwidth, "
				+ " unsel_color,unsel_fontsize,unsel_family,unsel_bold,unsel_italic) values( "
				+ " '"+stylename+"','"+image_bg+"','"+image_sep+"',"+image_sepwidth+", "
				+ " '"+sel_bgleft+"',"+sel_bgleftwidth+",'"+sel_bgmiddle+"','"+sel_bgright+"',"+sel_bgrightwidth+", "
				+ " '"+sel_color+"',"+sel_fontsize+",'"+sel_family+"',"+sel_bold+","+sel_italic+", "
				+ " '"+unsel_bgleft+"',"+unsel_bgleftwidth+",'"+unsel_bgmiddle+"','"+unsel_bgright+"',"+unsel_bgrightwidth+", "
				+ " '"+unsel_color+"',"+unsel_fontsize+",'"+unsel_family+"',"+unsel_bold+","+unsel_italic+") ";
			rs.executeSql(sql);
			String maxidsql = " select max(styleid) styleid from workflow_tabstyle ";
			rs.executeSql(maxidsql);
			if(rs.next())
				styleid = Util.getIntValue(rs.getString("styleid"));
		}else if("edit".equals(opertype) && styleid>0){
			sql = " update workflow_tabstyle set stylename='"+stylename+"', "
				+ " image_bg='"+image_bg+"',image_sep='"+image_sep+"',image_sepwidth="+image_sepwidth+", "
				+ " sel_bgleft='"+sel_bgleft+"',sel_bgleftwidth="+sel_bgleftwidth+",sel_bgmiddle='"+sel_bgmiddle+"', "
				+ " sel_bgright='"+sel_bgright+"',sel_bgrightwidth="+sel_bgrightwidth+", "
				+ " sel_color='"+sel_color+"',sel_fontsize="+sel_fontsize+", "
				+ " sel_family='"+sel_family+"',sel_bold="+sel_bold+",sel_italic="+sel_italic+", "
				+ " unsel_bgleft='"+unsel_bgleft+"',unsel_bgleftwidth="+unsel_bgleftwidth+",unsel_bgmiddle='"+unsel_bgmiddle+"', "
				+ " unsel_bgright='"+unsel_bgright+"',unsel_bgrightwidth="+unsel_bgrightwidth+", "
				+ " unsel_color='"+unsel_color+"',unsel_fontsize="+unsel_fontsize+", "
				+ " unsel_family='"+unsel_family+"',unsel_bold="+unsel_bold+",unsel_italic="+unsel_italic+" "
				+ " where styleid="+styleid;
			rs.executeSql(sql);
		}
		//System.err.println("exesql======"+sql);
		response.sendRedirect("/workflow/exceldesign/tabStyleDesign.jsp?isclose=on&opertype="+opertype+"&styleid="+styleid);	
	}
%>