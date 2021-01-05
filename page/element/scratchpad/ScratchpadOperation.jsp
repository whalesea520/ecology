
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.text.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.ConnStatement"%>
<%@ page import="weaver.general.*,weaver.conn.RecordSet"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	request.setCharacterEncoding("UTF-8");
	int paduserid = Util.getIntValue(request.getParameter("userid"));
	String padcontent = Util.null2String(request.getParameter("padcontent"));
	String operation = Util.null2String(request.getParameter("operation"));
	String eid = Util.null2String(request.getParameter("eid"));
	ConnStatement statement = new ConnStatement();
	try
	{
		if ("save".equals(operation))
		{
			boolean isexist = checkScratchpad(rs, paduserid,eid);
			String sql = "";

			if (!isexist)
			{
				if(!"".equals(padcontent))
				{
					sql = "insert into scratchpad(userid,padcontent,eid) values(?,?,?)";
					statement.setStatementSql(sql);
					statement.setInt(1, paduserid);
					statement.setString(2, padcontent);
					statement.setString(3, eid);
					statement.executeUpdate();

				}
			}
			else
			{
				sql = "update scratchpad set padcontent=? where userid=? and eid=?";
				statement.setStatementSql(sql);
				statement.setString(3, eid);
				statement.setInt(2, paduserid);
				statement.setString(1, padcontent);
				statement.executeUpdate();
			}
			
		}
		else
		{
			String sql = "select padcontent "+
						 " from scratchpad "+
						 " where userid = "+paduserid +" and eid='"+eid+"'";
			rs.executeSql(sql);
			while(rs.next())
			{
				padcontent = rs.getString("padcontent");	
			}
		}
	}
	catch (Exception e)
	{
		e.printStackTrace();
	}
	finally
	{
		try
		{
			statement.close();
		}
		catch (Exception ex)
		{
			
		}
	}
	out.print(padcontent);
%>
<%!boolean checkScratchpad(RecordSet rs, int userid, String eid)
	{
		String sql = "select padcontent from scratchpad where userid = " + userid +" and eid='"+eid+"'";
		rs.executeSql(sql);
		if (rs.next())
		{
			return true;
		}
		else
		{
			return false;
		}
	}%>