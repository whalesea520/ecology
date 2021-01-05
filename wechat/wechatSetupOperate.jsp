
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String operate=request.getParameter("operate");
	if("save".equals(operate)){//添加	编辑
		String id=request.getParameter("id");
		String prefix=URLDecoder.decode(request.getParameter("prefix"),"UTF-8");
		String suffix=URLDecoder.decode(request.getParameter("suffix"),"UTF-8");
		String prefixConnector=URLDecoder.decode(request.getParameter("prefixConnector"),"UTF-8");
		String suffixConnector=URLDecoder.decode(request.getParameter("suffixConnector"),"UTF-8");
		String type=request.getParameter("type");
		if(!"".equals(id)&&!"0".equals(id)){//更新
			if(rs.executeSql("update wechat_reminder_set set prefix='"+prefix+"', suffix='"+suffix+"',prefixConnector='"+prefixConnector+"',suffixConnector='"+suffixConnector+"' where id="+id)){
				out.print(true);
			}else{
				out.print(false);
			}
		}else{//新增
			String[] types=type.split(",");
			for(int i=0;i<types.length;i++){
				rs.executeSql("insert into wechat_reminder_set(prefix,suffix,prefixConnector,suffixConnector,type,def) values('"+prefix+"','"+suffix+"','"+prefixConnector+"','"+suffixConnector+"','"+types[i]+"','0')");
			}
			out.print(true);
		} 
	}else if("del".equals(operate)){//删除
		String IDS=Util.null2String(request.getParameter("IDS"));//当前节点id
		if(IDS!=null&&!"".equals(IDS)){
			rs.executeSql("delete wechat_reminder_set where def=0 and id in("+IDS+")");
			out.print(true);
		}else{
			out.print(false);
		}
	} 
%>
