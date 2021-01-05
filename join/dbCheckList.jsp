<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet"></jsp:useBean>
<%
	String clientAddr = request.getRemoteAddr();
	if(!"0:0:0:0:0:0:0:1".equals(clientAddr) && !"127.0.0.1".equals(clientAddr) && !("localhost".equals(clientAddr) || "10.45.49.99".equals(clientAddr))){
		return;
	}
	JSONObject json = new JSONObject();
	json.put("warning","false");
	json.put("dbtype",rs.getDBType());
	//检查当前数据库连接是否正常
	json.put("dbconnect", new Boolean(rs.executeSql("select 1 from license")));
	if("true".equals(json.getString("dbconnect"))){
		if(rs.getDBType().equalsIgnoreCase("oracle")){
			//检查表空间的可扩展情况
			rs.executeSql("select TABLESPACE_NAME,FILE_NAME,AUTOEXTENSIBLE  from dba_data_files where AUTOEXTENSIBLE<>'YES' ");
			if(rs.next()){
				json.put("warning","true");	
				json.put("tableextend",rs.getString("TABLESPACE_NAME"));
			}
			//检查数据库内存设置情况
			rs.executeSql("select name,sumvalue from (select name, (sum(value))/1024/1024/1024 as sumvalue  from v$parameter where name in ('sga_target',  'memory_target') GROUP BY NAME) where sumvalue>0");
			if(rs.next()){
				double sumvalue = rs.getDouble("sumvalue");
				String name = rs.getString("name");
				if(sumvalue<8){
					json.put("warning","true");	
					json.put("sga_memory_target",""+sumvalue);
				}
			}

			//检查数据库连接数是否不小于350
			rs.executeSql("select value from v$parameter where name='processes'");
			if(rs.next()){
				int value = rs.getInt(1);
				if(value<350){
					json.put("warning","true");	
					json.put("process",""+value);
				}
			}

			//检查redo log的尺寸是否设置为512M
			rs.executeSql("select bytes from v$log where bytes>=536870912");
			if(!rs.next()){
					json.put("warning","true");	
					rs.executeSql("select max(bytes)/1024/1024 from v$log");
					if(rs.next()){
						json.put("redo_log_size",""+rs.getInt(1));
					}else{
						json.put("redo_log_size","0");
					}
			}

			//检查归档目录的大小是否不小于20G
			rs.executeSql("select value/1024/1024/1024 from v$parameter where name='db_recovery_file_dest_size'");
			if(rs.next()){
					double size = rs.getDouble(1);
					if(size<20){
						json.put("warning","true");	
						json.put("db_recovery_file_dest_size",""+Math.floor(size));
					}
			}

			//数据库密码过期设置检查
			rs.executeSql("select 1 from dba_profiles where profile='DEFAULT' and resource_name='PASSWORD_LIFE_TIME'  and limit = 'UNLIMITED'");
			if(!rs.next()){
					json.put("warning","true");	
					json.put("PASSWORD_LIFE_TIME","true");
			}

			//数据库密码错误登录锁定设置检查
			rs.executeSql("select 1 from dba_profiles where profile='DEFAULT' and resource_name='FAILED_LOGIN_ATTEMPTS'  and limit = 'UNLIMITED'");
			if(!rs.next()){
					json.put("warning","true");	
					json.put("FAILED_LOGIN_ATTEMPTS","true");
			}

			//session_cached_cursor设置检查
			rs.executeSql(" select value from v$parameter where name='session_cached_cursors' ");
			if(rs.next()){
					int value = rs.getInt(1);
					if(value<300){
						json.put("warning","true");	
						json.put("session_cached_cursor",""+value);
					}
			}

			//open_cursors设置检查
			rs.executeSql(" select value from v$parameter where name='open_cursors'");
			if(rs.next()){
				int value = rs.getInt(1);
				if(value<1000){
					json.put("warning","true");	
					json.put("open_cursors",""+value);
				}
			}


		}else{//sqlserver数据库
			
		}
	}
	out.println(json.toString());
%>
