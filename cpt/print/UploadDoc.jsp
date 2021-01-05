<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.ConnStatement" %>
<%@ page import="java.io.Writer" %>
<%@ page import="java.io.File" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="weaver.conn.ConnectionPool" %>
<%@ page import="java.sql.SQLException" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<%!
    int id=-1;
    int subcompanyid=0;
    String mouldname="";
    String lastModTime="";
    String mouldtext="";
%>
<%!
    public void EditMouldInfo() throws Exception {
        String sql = "";

        boolean isoracle = (new RecordSet().getDBType()).equals("oracle");
        if (isoracle) {
            Connection conn=null;
            PreparedStatement stat=null;
            ResultSet resultSet=null;
            try {
                sql = "update CPT_PRINT_Mould set  mouldname='"+this.mouldname+"',lastModTime='"+this.lastModTime+"'"+(this.subcompanyid!=0?",subcompanyid='"+this.subcompanyid+"'":"")+",mouldtext=empty_clob() where id='"+this.id+"'";
                new RecordSet().executeSql(sql);

                conn= ConnectionPool.getInstance().getConnection();
                conn.setAutoCommit(false);

                // 3.需要使用for update方法来进行更新，
                // 但是，特别需要注意，如果原来CLOB字段有值，需要使用empty_clob()将其清空。
                // 如果原来是null，也不能更新，必须是empty_clob()返回的结果。
                stat = conn.prepareStatement("select mouldtext from CPT_PRINT_Mould where id='-1' for update");
                resultSet = stat.executeQuery();
                if (resultSet.next()) {
                    oracle.sql.CLOB clob = (oracle.sql.CLOB) resultSet.getClob("mouldtext");
                    Writer outStream = clob.getCharacterOutputStream();
                    char[] c = this.mouldtext.toCharArray();
                    outStream.write(c, 0, c.length);
                    outStream.flush();
                    outStream.close();
                }
                conn.commit();

            } catch (Exception e) {
                new BaseBean().writeLog(e.getMessage());
            } finally {
                if (resultSet!=null) {
                    try {
                        resultSet.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                if (stat!=null) {
                    try {
                        stat.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                if (conn!=null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        } else {// For Sql Server
            ConnStatement statement = new ConnStatement();
            try {
                sql = "update CPT_PRINT_Mould set mouldname=?,mouldtext=?,lastModTime=?"+(this.subcompanyid!=0?",subcompanyid=?":"")+" where id=?";
                statement.setStatementSql(sql);
                statement.setString(1, this.mouldname);
                statement.setString(2, this.mouldtext);
                statement.setString(3, this.lastModTime);
                if(this.subcompanyid!=0){
                    statement.setInt(4, this.subcompanyid);
                    statement.setInt(5, this.id);
                }else{
                    statement.setInt(4, this.id);
                }

                statement.executeUpdate();

            } catch (Exception e) {
                new BaseBean().writeLog(e.getMessage());
            } finally {
                try {
                    statement.close();
                } catch (Exception ex) {
                }
            }
        }
    }
%>
<%
    FileUpload fu=new FileUpload(request);
    String operation = Util.null2String(fu.getParameter("operation"));
    int languageid=user.getLanguage();
    RecordSet rt=new RecordSet();
	if (operation.equals("edit")) {

			this.id = -1;
			this.mouldname = fu.getParameter("mouldname");
			this.mouldtext = Util.fromBaseEncoding(
					fu.getParameter("mouldtext"), languageid);
            int idx=-1;
            if ((idx=this.mouldtext.lastIndexOf("<p><br/></p><p><br/></p><p><br/></p><p><br/></p>"))>-1) {
                this.mouldtext=this.mouldtext.substring(0,idx);
            }
			int tmppos = mouldtext
					.indexOf("/weaver/weaver.file.FileDownload?fileid=");
			while (tmppos != -1) {
				int startpos = mouldtext.lastIndexOf("\"", tmppos);
				String tmpcontent = mouldtext.substring(0, startpos + 1);
				tmpcontent += mouldtext.substring(tmppos);
				mouldtext = tmpcontent;
				tmppos = mouldtext.indexOf(
						"/weaver/weaver.file.FileDownload?fileid=", tmppos + 1);
			}

			int olddocimagesnum = Util.getIntValue(fu
					.getParameter("olddocimagesnum"), 0);
			for (int i = 0; i < olddocimagesnum; i++) {
				String tmpid = Util.null2String(fu.getParameter("olddocimages"
						+ i));
				String tmpid1 = "/weaver/weaver.file.FileDownload?fileid="
						+ tmpid + "\"";
				if (mouldtext.indexOf(tmpid1) == -1) {
					String para =  "" + tmpid;
					rt.executeProc("imagefile_DeleteByDoc", para);
					if (rt.next()) {
						String filerealpath = Util
								.null2String(rt.getString("filerealpath"));
						if (!filerealpath.equals("")) {
							try {
								File file = new File(new String(filerealpath
										.getBytes("ISO8859_1"), "UTF-8"));
								file.delete();
							} catch (Exception e) {
							}
						}
					}
				}
			}

			int docimages_num = Util.getIntValue(fu
					.getParameter("docimages_num"), 0);
			String[] needuploads = new String[docimages_num];

			for (int i = 0; i < docimages_num; i++)
				needuploads[i] = "docimages_" + i;

			String[] filenames;
			String[] fileids;
			fileids = fu.uploadFiles(needuploads);
			filenames = fu.getFileNames();

			for (int i = 0; i < docimages_num; i++) {
				int pos = mouldtext.indexOf(DocManager.getImgAltFlag(i));
				if (pos != -1) {
					String tmpcontent = mouldtext.substring(0, pos);
					tmpcontent += " alt=\"" + filenames[i] + "\" ";
					pos = mouldtext.indexOf("src=\"", pos);
					int endpos = mouldtext.indexOf("\"", pos + 5);
					tmpcontent += "src=\"/weaver/weaver.file.FileDownload?fileid="
							+ Util.getFileidOut(fileids[i]);
					tmpcontent += "\"";
					tmpcontent += mouldtext.substring(endpos + 1);
					mouldtext = tmpcontent;
				} else {
					String para =  "" + fileids[i];
					rt.executeProc("imagefile_DeleteByDoc", para);
					if (rt.next()) {
						String filerealpath = Util
								.null2String(rt.getString("filerealpath"));
						if (!filerealpath.equals("")) {
							try {
								File file = new File(new String(filerealpath
										.getBytes("ISO8859_1"), "UTF-8"));
								file.delete();
							} catch (Exception e) {
							}
						}
					}
				}
			}

			EditMouldInfo();

		}
    response.sendRedirect("moduleedit.jsp?isclose=1");

%>