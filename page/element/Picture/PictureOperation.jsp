
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.text.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.ConnStatement,weaver.conn.ConnectionPool"%>
<%@ page import="java.sql.Connection,java.sql.SQLException,java.sql.Statement"%>
<%@ page import="weaver.general.*,weaver.conn.RecordSet"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	request.setCharacterEncoding("UTF-8");
	String operation = Util.null2String(request.getParameter("operation"));
	String ppicturetype = Util.null2String(request.getParameter("picturetype"));
	String eid = Util.null2String(request.getParameter("eid"));
	if ("save".equals(operation))
	{
		String[] pictureids = request.getParameterValues("pictureid");
		String[] pictureUrls = request.getParameterValues("pictureUrl");
		String[] pictureNames = request.getParameterValues("pictureName");
		String[] pictureLinks = request.getParameterValues("pictureLink");
		String[] pictureOrders = request.getParameterValues("pictureOrder");
		
		Connection conn = null;
		Statement stmt = null;
		ConnectionPool pool = ConnectionPool.getInstance();
		conn = pool.getConnection();
		conn.setAutoCommit(false);
		stmt = conn.createStatement();
		try
		{
			String deleteStr  = "delete from picture where eid='"+eid+"'";
			stmt.addBatch(deleteStr);
			for (int i = 0; i < pictureUrls.length; i++)
			{
				
				if (null != pictureUrls[i] && !"".equals(pictureUrls[i]))
				{
					String pictureid = pictureids[i];
					String pictureUrl = pictureUrls[i];
					String pictureName = pictureNames[i];
					pictureName = Util.toHtml2(pictureName);
					String pictureLink = pictureLinks[i];
					int pictureOrder = Util.getIntValue(pictureOrders[i],0);
					{
						String insertsql = "insert into picture(pictureurl,picturename,picturelink,picturetype,pictureOrder,eid) values('"+pictureUrl+"','"+pictureName+"','"+pictureLink+"',"+ppicturetype+","+pictureOrder+",'"+eid+"')";
						stmt.addBatch(insertsql);
					}
				}
			}
			stmt.executeBatch();
			stmt.clearBatch();
			conn.commit();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		finally
		{
			if (null != stmt)
			{
				try
				{
					stmt.close();
				}
				catch (SQLException e)
				{
					// do nothing
				}
			}
			if (null != conn)
			{
				try
				{
					conn.close();
				}
				catch (SQLException e)
				{
					// do nothing
				}
			}
		}
		//response.sendRedirect("/page/element/Picture/SettingBrowser.jsp?picturetype="+request.getParameter("picturetype")+"&eid="+request.getParameter("eid"));
		return;
	}
%>
