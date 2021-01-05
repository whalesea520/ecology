
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.ConnStatement"%>
<%@ page import="oracle.sql.CLOB"%> 
<%@ page import="java.io.*" %>
<jsp:useBean id="rs_DocContent" class="weaver.conn.RecordSet" scope="page" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/swfobject_wev8.js"></script>
<style>
#spanContent A {
	COLOR: blue; TEXT-DECORATION: underline
}
#spanContent A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

#spanContent A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
#spanContent A:visited {
	TEXT-DECORATION: underline}
	
</style>
<table width="100%">
	<tr>
	<td>&nbsp;</td>
	<td>
		<span id="spanContent">
		<%
		int floatid=Util.getIntValue(request.getParameter("docid"),0);
		String strSql_DocContent="";
		String floatContent="";
		 ConnStatement statement = null;
	    try{
	        statement=new ConnStatement();
			if(("oracle").equals(rs_DocContent.getDBType())){
				strSql_DocContent="select doccontent from docdetail d1,docdetailcontent d2 where d1.id=d2.docid and d1.id="+floatid;
				statement.setStatementSql(strSql_DocContent, false);
			    statement.executeQuery();
				if(statement.next()) {
				 CLOB theclob = statement.getClob("doccontent");
				  String readline = "";
			      StringBuffer clobStrBuff = new StringBuffer("");
			      BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
			      while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
			      clobin.close() ;
			      floatContent = clobStrBuff.toString();
				}	
			} else{
				strSql_DocContent="select doccontent from docdetail where id="+floatid;
				statement.setStatementSql(strSql_DocContent, false);
			    statement.executeQuery();
				if(statement.next()) floatContent=statement.getString("doccontent");
			}
			statement.close();
		}catch(Exception e){
	    }finally {
	        statement.close();
	    }

		if(!"".equals(floatContent)){
			String disptmp = "";
			int tmppos = floatContent.indexOf("!@#$%^&*");
			if(tmppos!=-1)	{
				floatContent = floatContent.substring(tmppos+8);
			}		
		}
		if(!"".equals(floatContent)){
			out.println(floatContent);
		}
		%>
		</span>
	</td>
	</tr>
</table>
<script>	

	$(document).ready(function(){
		$("a[target='_self']").attr("target","_blank")
	});

</script>