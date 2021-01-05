
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.Writer" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
int isform=Util.getIntValue(request.getParameter("isform"),0);
int formid=Util.getIntValue(request.getParameter("formid"),0);
int nodeid=Util.getIntValue(request.getParameter("nodeid"),0);
int modeid=Util.getIntValue(request.getParameter("modeid"),0);
int isbill=Util.getIntValue(request.getParameter("isbill"),0);
int isprint=Util.getIntValue(request.getParameter("isprint"),0);
int wfid=Util.getIntValue(request.getParameter("wfid"),0);
String ajax=Util.null2String(request.getParameter("ajax"));
// 是否来自流程图形化编辑
String design= Util.null2String(request.getParameter("design")); 
if(isprint==0){
	ArrayList hasfieldList = new ArrayList();
    List fieldIdList=new ArrayList();
    if(isbill==0){
		RecordSet.executeSql("select fieldId from workflow_formfield where formid="+formid);
	}else{
		RecordSet.executeSql("select id as fieldId from workflow_billfield where billid="+formid);
	}
	while(RecordSet.next()){
		fieldIdList.add(Util.null2String(RecordSet.getString("fieldId")));
	}

    String mandatoryfields=Util.null2String(request.getParameter("mandatoryfields"));
    String viewfields=Util.null2String(request.getParameter("viewfields"));
    String editfields=Util.null2String(request.getParameter("editfields"));
    ArrayList mandatorylist=Util.TokenizerString(mandatoryfields,",");
    ArrayList viewlist=Util.TokenizerString(viewfields,",");
    ArrayList editlist=Util.TokenizerString(editfields,",");
    RecordSet.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill);
    for(int i=0;i<mandatorylist.size();i++){
        int fieldid=Util.getIntValue((String)mandatorylist.get(i));
		if((fieldid>0 && fieldIdList.indexOf(""+fieldid)==-1) || hasfieldList.indexOf(""+fieldid)!=-1){
			continue;
		}else{
			hasfieldList.add(""+fieldid);
		}
        RecordSet.executeSql("insert into workflow_modeview(formid,nodeid,isbill,fieldid,isview,isedit,ismandatory) values("+formid+","+nodeid+","+isbill+","+fieldid+",'1','1','1')");
    }
    for(int i=0;i<viewlist.size();i++){
        int fieldid=Util.getIntValue((String)viewlist.get(i));
        if((fieldid>0 && fieldIdList.indexOf(""+fieldid)==-1) || hasfieldList.indexOf(""+fieldid)!=-1){
			continue;
		}else{
			hasfieldList.add(""+fieldid);
		}
        RecordSet.executeSql("insert into workflow_modeview(formid,nodeid,isbill,fieldid,isview,isedit,ismandatory) values("+formid+","+nodeid+","+isbill+","+fieldid+",'1','0','0')");
    }
    for(int i=0;i<editlist.size();i++){
        int fieldid=Util.getIntValue((String)editlist.get(i));
        if((fieldid>0 && fieldIdList.indexOf(""+fieldid)==-1) || hasfieldList.indexOf(""+fieldid)!=-1){
			continue;
		}else{
			hasfieldList.add(""+fieldid);
		}
        RecordSet.executeSql("insert into workflow_modeview(formid,nodeid,isbill,fieldid,isview,isedit,ismandatory) values("+formid+","+nodeid+","+isbill+","+fieldid+",'1','1','0')");
    }
    
    //修改表单的显示模板时，同时要更新所有用到此表单并且显示模板为此表单显示模板的节点模板显示字段信息。
    //MYQ 修改 2008.1.25 开始
    if(nodeid==0){
    	String sql = "select nodeid from workflow_flownode where workflowid in (select id from workflow_base where formid="+formid+") and nodeid not in (select nodeid from workflow_nodemode where formid="+formid+" and isprint!=1) and ismode=1 and showdes=0";
    	rs.executeSql(sql);
    	while(rs.next()){
    		int tempnodeid = rs.getInt("nodeid");
    		hasfieldList.clear();
    		hasfieldList = null;
    		hasfieldList = new ArrayList();
    		rs1.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+tempnodeid+" and isbill="+isbill);
    		for(int i=0;i<mandatorylist.size();i++){
        		int fieldid=Util.getIntValue((String)mandatorylist.get(i));
        		if((fieldid>0 && fieldIdList.indexOf(""+fieldid)==-1) || hasfieldList.indexOf(""+fieldid)!=-1){
        			continue;
        		}else{
        			hasfieldList.add(""+fieldid);
        		}
		        RecordSet.executeSql("insert into workflow_modeview(formid,nodeid,isbill,fieldid,isview,isedit,ismandatory) values("+formid+","+tempnodeid+","+isbill+","+fieldid+",'1','1','1')");
		    }
		    for(int i=0;i<viewlist.size();i++){
		        int fieldid=Util.getIntValue((String)viewlist.get(i));
		        if((fieldid>0 && fieldIdList.indexOf(""+fieldid)==-1) || hasfieldList.indexOf(""+fieldid)!=-1){
        			continue;
        		}else{
        			hasfieldList.add(""+fieldid);
        		}
		        RecordSet.executeSql("insert into workflow_modeview(formid,nodeid,isbill,fieldid,isview,isedit,ismandatory) values("+formid+","+tempnodeid+","+isbill+","+fieldid+",'1','0','0')");
		    }
		    for(int i=0;i<editlist.size();i++){
		        int fieldid=Util.getIntValue((String)editlist.get(i));
		        if((fieldid>0 && fieldIdList.indexOf(""+fieldid)==-1) || hasfieldList.indexOf(""+fieldid)!=-1){
        			continue;
        		}else{
        			hasfieldList.add(""+fieldid);
        		}
		        RecordSet.executeSql("insert into workflow_modeview(formid,nodeid,isbill,fieldid,isview,isedit,ismandatory) values("+formid+","+tempnodeid+","+isbill+","+fieldid+",'1','1','0')");
		    }
    	}
    }
    //MYQ 修改 2008.1.28 结束
    
}
String modestr=Util.null2String(request.getParameter("modestring"));
String sql="";
String nodename="";
int flag=0;
ConnStatement statement=new ConnStatement();
try{
boolean isoracle = (statement.getDBType()).equals("oracle");
if(modeid>0 && isform<1){
    if(nodeid>0){
        RecordSet.executeSql("select nodename from workflow_flownode,workflow_nodebase where (workflow_nodebase.IsFreeNode is null or workflow_nodebase.IsFreeNode!='1') and workflow_nodebase.id=workflow_flownode.nodeid and workflowid="+wfid+" and nodeid="+nodeid);
        if(RecordSet.next()){
            nodename=RecordSet.getString("nodename");
        }
        if(isprint>0){
            nodename+=SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage());
        }else{
            nodename+=SystemEnv.getHtmlLabelName(16450,user.getLanguage());
        }
            RecordSet.executeSql("select id from workflow_nodemode where isprint='"+isprint+"' and nodeid="+nodeid);
            if(RecordSet.next()){
                modeid=RecordSet.getInt(1);
                if(isoracle){
                    sql="update workflow_nodemode set modename=? where isprint='"+isprint+"' and id="+modeid;
                    statement.setStatementSql(sql);
                    statement.setString(1 , nodename);
                    flag=statement.executeUpdate();

                    sql = "select modedesc from workflow_nodemode where id = "+modeid;
                    statement.setStatementSql(sql, false);
                    statement.executeQuery();
                    if(statement.next()){
                        CLOB theclob = statement.getClob(1);
                        char[] contentchar = modestr.toCharArray();
                        Writer contentwrite = theclob.getCharacterOutputStream();
                        contentwrite.write(contentchar);
                        contentwrite.flush();
                        contentwrite.close();
                    }
                }else{
                    sql="update workflow_nodemode set modedesc=?,modename=? where isprint='"+isprint+"' and id="+modeid;
                    statement.setStatementSql(sql);
                    statement.setString(1 , modestr);
                    statement.setString(2 , nodename);
                    flag=statement.executeUpdate();
                }
            }else{
                if(isoracle){
                    sql="insert into workflow_nodemode(formid,nodeid,isprint,modedesc,workflowid,modename) values(?,?,?,empty_clob(),?,?)";
                    statement.setStatementSql(sql);
                    statement.setInt(1 ,formid);
                    statement.setInt(2 ,nodeid);
                    statement.setString(3 ,isprint+"");
                    statement.setInt(4 ,wfid);
                    statement.setString(5 , nodename);
                    flag=statement.executeUpdate();
                    
                    sql = "select modedesc from workflow_nodemode where formid = "+formid+" and nodeid="+nodeid+" and isprint='"+isprint+"' and workflowid="+wfid+" order by id desc";
                    statement.setStatementSql(sql, false);
                    statement.executeQuery();
                    if(statement.next()){
                        CLOB theclob = statement.getClob(1);
                        char[] contentchar = modestr.toCharArray();
                        Writer contentwrite = theclob.getCharacterOutputStream();
                        contentwrite.write(contentchar);
                        contentwrite.flush();
                        contentwrite.close();
                    }
                }else{
                    sql="insert into workflow_nodemode(formid,nodeid,isprint,modedesc,workflowid,modename) values(?,?,?,?,?,?)";
                    statement.setStatementSql(sql);
                    statement.setInt(1 ,formid);
                    statement.setInt(2 ,nodeid);
                    statement.setString(3 ,isprint+"");
                    statement.setString(4 , modestr);
                    statement.setInt(5 ,wfid);
                    statement.setString(6 , nodename);
                    flag=statement.executeUpdate();
                }
            }
    }else{
        if(isprint>0){
            RecordSet.executeSql("select id from workflow_formmode where isprint='"+isprint+"' and id="+modeid);
            if(RecordSet.next()){
                if(isoracle){
                    sql="update workflow_formmode set modename=? where isprint='"+isprint+"' and id="+modeid;
                    statement.setStatementSql(sql);
                    statement.setString(1 , SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage()));
                    flag=statement.executeUpdate();
                    
                    sql = "select modedesc from workflow_formmode where id = "+modeid;
                    statement.setStatementSql(sql, false);
                    statement.executeQuery();
                    if(statement.next()){                          
                        CLOB theclob = statement.getClob(1);                        
                        char[] contentchar = modestr.toCharArray();
                        Writer contentwrite = theclob.getCharacterOutputStream();
                        contentwrite.write(contentchar);
                        contentwrite.flush();
                        contentwrite.close();                        
                    }
                }else{
                    sql="update workflow_formmode set modedesc=?,modename=? where isprint='"+isprint+"' and id="+modeid;
                    statement.setStatementSql(sql);
                    statement.setString(1 , modestr);
                    statement.setString(2 , SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage()));
                    flag=statement.executeUpdate();
                }
            }else{
                if(isoracle){
                    sql="insert into workflow_formmode(formid,isbill,isprint,modedesc,modename) values(?,?,?,empty_clob(),?)";
                    statement.setStatementSql(sql);
                    statement.setInt(1 ,formid);
                    statement.setString(2 ,isbill+"");
                    statement.setString(3 ,isprint+"");
                    statement.setString(4 , SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage()));
                    flag=statement.executeUpdate();

                    sql = "select modedesc from workflow_formmode where formid = "+formid+" and isbill='"+isbill+"' and isprint='"+isprint+"' order by id desc";
                    statement.setStatementSql(sql,false);
                    statement.executeQuery();
                    if(statement.next()){
                        CLOB theclob = statement.getClob(1);
                        char[] contentchar = modestr.toCharArray();
                        Writer contentwrite = theclob.getCharacterOutputStream();
                        contentwrite.write(contentchar);
                        contentwrite.flush();
                        contentwrite.close();
                    }
                }else{
                    sql="insert into workflow_formmode(formid,isbill,isprint,modedesc,modename) values(?,?,?,?,?)";
                    statement.setStatementSql(sql);
                    statement.setInt(1 ,formid);
                    statement.setString(2 ,isbill+"");
                    statement.setString(3 ,isprint+"");
                    statement.setString(4 , modestr);
                    statement.setString(5 , SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage()));
                    flag=statement.executeUpdate();
                }
            }
        }else{
            if(isoracle){
                sql="update workflow_formmode set modename=? where isprint='"+isprint+"' and id="+modeid;
                statement.setStatementSql(sql);
                statement.setString(1 , SystemEnv.getHtmlLabelName(16450,user.getLanguage()));
                flag=statement.executeUpdate();

                sql = "select modedesc from workflow_formmode where id = "+modeid;
                statement.setStatementSql(sql, false);
                statement.executeQuery();
                if(statement.next()){
                    CLOB theclob = statement.getClob(1);
                    char[] contentchar = modestr.toCharArray();
                    Writer contentwrite = theclob.getCharacterOutputStream();
                    contentwrite.write(contentchar);
                    contentwrite.flush();
                    contentwrite.close();
                }
            }else{
                sql="update workflow_formmode set modedesc=?,modename=? where isprint='"+isprint+"' and id="+modeid;
                statement.setStatementSql(sql);
                statement.setString(1 , modestr);
                statement.setString(2 , SystemEnv.getHtmlLabelName(16450,user.getLanguage()));
                flag=statement.executeUpdate();
            }
        }
    }
    
}else{
    if(nodeid>0){
        RecordSet.executeSql("select nodename from workflow_flownode,workflow_nodebase where (workflow_nodebase.IsFreeNode is null or workflow_nodebase.IsFreeNode!='1') and workflow_nodebase.id=workflow_flownode.nodeid and workflowid="+wfid+" and nodeid="+nodeid);
        if(RecordSet.next()){
            nodename=RecordSet.getString("nodename");
        }
        if(isprint>0){
            nodename=nodename+SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage());
        }else{
            nodename=nodename+SystemEnv.getHtmlLabelName(16450,user.getLanguage());
        }
        RecordSet.executeSql("select id from workflow_nodemode where isprint='"+isprint+"' and workflowid="+wfid+" and nodeid="+nodeid);
        if(RecordSet.next()){
            if(isoracle){
                sql="update workflow_nodemode set modename=? where isprint='"+isprint+"' and id="+RecordSet.getInt("id");
                statement.setStatementSql(sql);
                statement.setString(1 , nodename);
                flag=statement.executeUpdate();

                sql = "select modedesc from workflow_nodemode where id = "+RecordSet.getInt("id");
                statement.setStatementSql(sql, false);
                statement.executeQuery();
                if(statement.next()){
                    CLOB theclob = statement.getClob(1);
                    char[] contentchar = modestr.toCharArray();
                    Writer contentwrite = theclob.getCharacterOutputStream();
                    contentwrite.write(contentchar);
                    contentwrite.flush();
                    contentwrite.close();
                }
            }else{
                sql="update workflow_nodemode set modedesc=?,modename=? where isprint='"+isprint+"' and id="+RecordSet.getInt("id");
                statement.setStatementSql(sql);
                statement.setString(1 , modestr);
                statement.setString(2 , nodename);
                flag=statement.executeUpdate();
            }
        }else{
            if(isoracle){
                sql="insert into workflow_nodemode(formid,nodeid,isprint,modedesc,workflowid,modename) values(?,?,?,empty_clob(),?,?)";
                statement.setStatementSql(sql);
                statement.setInt(1 ,formid);
                statement.setInt(2 ,nodeid);
                statement.setString(3 ,isprint+"");
                statement.setInt(4 ,wfid);
                statement.setString(5 , nodename);
                flag=statement.executeUpdate();

                sql = "select modedesc from workflow_nodemode where formid = "+formid+" and nodeid="+nodeid+" and isprint='"+isprint+"' and workflowid="+wfid+" order by id desc";
                statement.setStatementSql(sql, false);
                statement.executeQuery();
                if(statement.next()){
                    CLOB theclob = statement.getClob(1);
                    char[] contentchar = modestr.toCharArray();
                    Writer contentwrite = theclob.getCharacterOutputStream();
                    contentwrite.write(contentchar);
                    contentwrite.flush();
                    contentwrite.close();
                }
            }else{
                sql="insert into workflow_nodemode(formid,nodeid,isprint,modedesc,workflowid,modename) values(?,?,?,?,?,?)";
                statement.setStatementSql(sql);
                statement.setInt(1 ,formid);
                statement.setInt(2 ,nodeid);
                statement.setString(3 ,isprint+"");
                statement.setString(4 , modestr);
                statement.setInt(5 ,wfid);
                statement.setString(6 , nodename);
                flag=statement.executeUpdate();
            }
        }
    }else{
        if(isprint>0){
            nodename=SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage());
        }else{
            nodename=SystemEnv.getHtmlLabelName(16450,user.getLanguage());
        }
        RecordSet.executeSql("select id from workflow_formmode where isprint='"+isprint+"' and formid="+formid+" and isbill="+isbill);
        if(RecordSet.next()){
            if(isoracle){
                sql="update workflow_formmode set modename=? where isprint='"+isprint+"' and id="+RecordSet.getInt("id");
                statement.setStatementSql(sql);
                statement.setString(1 , nodename);
                flag=statement.executeUpdate();

                sql = "select modedesc from workflow_formmode where id = "+RecordSet.getInt("id");
                statement.setStatementSql(sql, false);
                statement.executeQuery();
                if(statement.next()){
                    CLOB theclob = statement.getClob(1);
                    char[] contentchar = modestr.toCharArray();
                    Writer contentwrite = theclob.getCharacterOutputStream();
                    contentwrite.write(contentchar);
                    contentwrite.flush();
                    contentwrite.close();
                }
            }else{
                sql="update workflow_formmode set modedesc=?,modename=? where isprint='"+isprint+"' and id="+RecordSet.getInt("id");
                statement.setStatementSql(sql);
                statement.setString(1 , modestr);
                statement.setString(2 , nodename);
                flag=statement.executeUpdate();
            }
        }else{
            if(isoracle){
                sql="insert into workflow_formmode(formid,isbill,isprint,modedesc,modename) values(?,?,?,empty_clob(),?)";
                statement.setStatementSql(sql);
                statement.setInt(1 ,formid);
                statement.setString(2 ,isbill+"");
                statement.setString(3 ,isprint+"");
                statement.setString(4 , nodename);
                flag=statement.executeUpdate();
                
                sql = "select modedesc from workflow_formmode where formid = "+formid+" and isbill='"+isbill+"' and isprint='"+isprint+"' order by id desc";
                statement.setStatementSql(sql, false);
                statement.executeQuery();
                if(statement.next()){
                    CLOB theclob = statement.getClob(1);
                    char[] contentchar = modestr.toCharArray();
                    Writer contentwrite = theclob.getCharacterOutputStream();
                    contentwrite.write(contentchar);
                    contentwrite.flush();
                    contentwrite.close();
                }
            }else{
                sql="insert into workflow_formmode(formid,isbill,isprint,modedesc,modename) values(?,?,?,?,?)";
                statement.setStatementSql(sql);
                statement.setInt(1 ,formid);
                statement.setString(2 ,isbill+"");
                statement.setString(3 ,isprint+"");
                statement.setString(4 , modestr);
                statement.setString(5 , nodename);
                flag=statement.executeUpdate();
            }
        }
    }   
    
}
    if(isprint==0){
        RecordSet.executeSql("update workflow_flownode set ismode='1' ,showdes='0' where workflowid="+wfid+" and nodeid="+nodeid);
    }else{
        RecordSet.executeSql("update workflow_flownode set ismode='1' ,printdes='0' where workflowid="+wfid+" and nodeid="+nodeid);
    }
}catch(Exception e){
    flag=0;
    e.printStackTrace();    
}finally{
statement.close();
}
if(flag>0){
        if(nodeid>0){
            RecordSet.executeSql("select max(id) as id from workflow_nodemode where isprint='"+isprint+"' and nodeid="+nodeid);
        }else{
            RecordSet.executeSql("select max(id) as id from workflow_formmode where isbill='"+isbill+"' and isprint='"+isprint+"' and formid="+formid);            
        }
        if(RecordSet.next()){
            modeid=RecordSet.getInt("id");
        }
if(!design.equals("1")){        
%>
<SCRIPT language="javascript">
    try{
        <%if(ajax.equals("1")){%>
        var url=parent.opener.location.href;
        if(url.indexOf("&isnodemode")<1){
            url=url.replace("#","")+"&isnodemode=1";
            parent.opener.location=url;
        }else{
			//qyw reload()刷新父页面 如果有数据提交的动作，会提示是否提交的(是和否选项)
           // parent.opener.location.reload();
		   parent.opener.location=parent.opener.location.href; 
        }
        <%}else{%>
        parent.opener.location.reload();
        <%}%>
    }catch(e){}
    //history.go(-1);
    //parent.close();
    //parent.onbeforeunload=null;
    parent.location="/workflow/mode/index.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&isprint=<%=isprint%>&modeid=<%=modeid%>&flag=1&ajax=<%=ajax%>";
    //parent.onbeforeunload="showinfo()";
</SCRIPT>
<%
}
}else{
if(!design.equals("1")){
%>

<SCRIPT language="javascript">

    alert("<%=SystemEnv.getHtmlLabelName(84006 ,user.getLanguage())%>");
    parent.close();

</SCRIPT>
<%}
}
out.println(flag);
%>