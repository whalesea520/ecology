
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
		String[] ids = request.getParameterValues("id");
		String[] url1s= request.getParameterValues("url1");
		String[] url2s = request.getParameterValues("url2");
		String[] url3s = request.getParameterValues("url3");
		String[] titles = request.getParameterValues("title");
		String[] descriptions=request.getParameterValues("description");
		String[] links=request.getParameterValues("link");
		
		Connection conn = null;
		Statement stmt = null;
		ConnectionPool pool = ConnectionPool.getInstance();
		conn = pool.getConnection();
		conn.setAutoCommit(false);
		stmt = conn.createStatement();
		try
		{
			String deleteStr  = "delete from slideElement where  eid="+eid;
			//System.out.println(deleteStr);
			stmt.addBatch(deleteStr);
			String strSettingSql = "select count(*) maxId from slideElement " ;
			rs.execute(strSettingSql);
			int maxid=0;
			if (rs.next())
			{
				maxid = rs.getInt("maxId");
			}
		
			maxid++;
			for (int i = 0; i < url1s.length; i++)
			{
				if (null != url1s[i] && !"".equals(url1s[i]))
				{
					
					String url1=url1s[i];
					String url2=url2s[i];
					String url3=url3s[i];
					String title=titles[i];
					String link=links[i];
					String description=descriptions[i];
					
					//int pictureOrder = Util.getIntValue(pictureOrders[i],0);
					{
						String itemTitle1 ="insert into slideElement(id,title ,description,url1,url2,link,eid,url3) values("+maxid+i+",'"+title+"','"+description+"','"+url1+"','"+url2+"','"+link+"' ,"+eid+",'"+url3+"')";
						stmt.addBatch(itemTitle1);
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
		//response.sendRedirect("/page/element/Picture/SettingBrowser.jsp");
		return;
	}
%>
