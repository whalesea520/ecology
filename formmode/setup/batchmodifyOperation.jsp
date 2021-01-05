<%@page import="weaver.formmode.setup.ModeSetUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.general.GCONST" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="modeSetUtil" class="weaver.formmode.setup.ModeSetUtil" scope="page" />

<%
	String modeid = Util.null2String(request.getParameter("modeid"));
	String id = Util.null2String(request.getParameter("id"));
	String formid = Util.null2String(request.getParameter("formid"));
	String name = Util.null2String(request.getParameter("name"));
	String remark = Util.null2String(request.getParameter("remark"));
	String saveflag = Util.null2String(request.getParameter("saveflag"));
	String deleteflag = Util.null2String(request.getParameter("deleteflag"));
	String[] feildids = request.getParameterValues("feildid");
	String[] changetypes = request.getParameterValues("changetype");
	String[] defaultvalues = request.getParameterValues("defaultvalue");
	if("".equals(id)){//创建
		RecordSetTrans rst = new RecordSetTrans();
		try{
			rst.setAutoCommit(false);
			String sqlmain="insert into mode_batchmodify(name,remark,modeid,formid)values('"+name+"','"+remark+"',"+modeid+","+formid+")";
			rst.executeSql(sqlmain);
			rst.executeSql("select max(id) as id from mode_batchmodify");
			int mainid = 0;
			if(rst.next()){
				mainid=rst.getInt(1);
			}
			id=mainid+"";
			String sqldetail="";
			for(int i=0;i<feildids.length;i++){
				if(feildids[i]==null||"".equals(feildids[i])){
					continue;
				}
				sqldetail = "insert into mode_batchmodifydetail(mainid,feildid,changetype,feildvalue)values("
								+mainid+","+feildids[i]+","+changetypes[i]+",'"+defaultvalues[i]+"')";
				rst.executeSql(sqldetail);
			}
			rst.commit();
		}catch(Exception e){
			e.printStackTrace();
			rst.rollback();
		}
	}else{//修改或删除
		if(deleteflag.equals("0")){
			//修改操作
			RecordSetTrans rst = new RecordSetTrans();
			try{
				rst.setAutoCommit(false);
				String sqlmain="update mode_batchmodify set name='"+name+"',remark='"+remark+"',modeid="+modeid+",formid="+formid+" where id="+id;
				rst.executeSql(sqlmain);
				String deldetailsql="delete from mode_batchmodifydetail where mainid ="+id;
				rst.executeSql(deldetailsql);
				String sqldetail="";
				for(int i=0;i<feildids.length;i++){
					if(feildids[i]==null||"".equals(feildids[i])){
						continue;
					}
					sqldetail = "insert into mode_batchmodifydetail(mainid,feildid,changetype,feildvalue)values("
									+id+","+feildids[i]+","+changetypes[i]+",'"+defaultvalues[i]+"')";
					rst.executeSql(sqldetail);
				}
				rst.commit();
			}catch(Exception e){
				e.printStackTrace();
				rst.rollback();
			}
		}else if(deleteflag.equals("1")){
			//删除操作zwbo
			RecordSetTrans rst = new RecordSetTrans();
			try{
				rst.setAutoCommit(false);
				String sqlmain="delete mode_batchmodify  where id= ? ";
				rst.executeUpdate(sqlmain,id);
				String deldetailsql="delete from mode_batchmodifydetail where mainid =?";
				rst.executeUpdate(deldetailsql,id);
				rst.commit();
			}catch(Exception e){
				e.printStackTrace();
				rst.rollback();
			}
		}


	}
	
%>
<script>
	//var parentWin = parent.parent.getParentWindow(parent);
	//var dialog = parent.parent.getDialog(parent);
	<%
	if(deleteflag.equals("1")){//删除操作zwbo
	%>
		strname=" ";
		var returnjson = {id:'',name:strname};
	 	parent.closeWinAFrsh(returnjson);
	
	<%
	}
	else if(saveflag.equals("1")){//保存并使用
	%>
		var strname = '<%=name%>';
		strname="<a href=\""+"javascript:modifyfeild(<%=id%>)\">"+strname+"</a>";
		var returnjson = {id:'<%=id%>',name:strname};
	 	parent.closeWinAFrsh(returnjson);
	<%
	}else{//保存并关闭
	%>
		parent.closeWinAFrsh();
	<%	
	}
	%>
</script>