<%
int modeid=weaver.general.Util.getIntValue(request.getParameter("modeid"),0);
String modestr="";
String sql="";
int nodeid=weaver.general.Util.getIntValue(request.getParameter("nodeid"),0);
int isform=weaver.general.Util.getIntValue(request.getParameter("isform"),0);
weaver.conn.ConnStatement statement=new weaver.conn.ConnStatement();
boolean isoracle = (statement.getDBType()).equals("oracle");
try{
if(modeid>0){
    //节点模板
    if(nodeid>0 && isform!=1){
        sql="select modedesc from workflow_nodemode where id="+modeid;
    //表单模板
    }else{
        sql="select modedesc from workflow_formmode where id="+modeid;
    }
    statement.setStatementSql(sql);
    statement.executeQuery();
	if(statement.next()){
        if(isoracle){
            oracle.sql.CLOB theclob = statement.getClob(1);
            String readline = "" ;
            StringBuffer clobStrBuff = new StringBuffer("") ; 
            java.io.BufferedReader clobin = new java.io.BufferedReader(theclob.getCharacterStream());
            while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline) ;
            clobin.close() ;
            modestr=clobStrBuff.toString();
        }else{
            modestr=statement.getString("modedesc");
        }
    }
}
}finally{
	statement.close();
}
out.print(modestr);
%>