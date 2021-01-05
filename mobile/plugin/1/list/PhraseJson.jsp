<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.mobile.webservices.workflow.WorkflowServiceUtil"%>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;
	Map result = new HashMap();
	FileUpload fu = new FileUpload(request);
	String type = Util.null2String(fu.getParameter("type"));
	
	if("delete".equalsIgnoreCase(type)){
		String id = Util.null2String(fu.getParameter("id"));
		String sql = "delete from sysPhrase where id ="+id;		
		RecordSet rs = new RecordSet();
		rs.executeSql(sql);
		result.put("flag","true");
	} else if("alter".equalsIgnoreCase(type)){
		String id = Util.null2String(fu.getParameter("id"));
		String phrasedesc = Util.null2String(fu.getParameter("value"));
		String phraseShort = Util.null2String(fu.getParameter("name"));
		if(phrasedesc != null && !"".equals(phrasedesc)){
			phrasedesc = phrasedesc.replace("\n","<br>");
			phrasedesc = phrasedesc;
		} else{
			phrasedesc = "";
		}
		String sql = "update sysPhrase set phrasedesc ='"+phrasedesc+"',phraseShort ='"+phraseShort+"' where id ="+id;		
		RecordSet rs = new RecordSet();
		rs.executeSql(sql);
		result.put("flag","true");
	} else if("insert".equalsIgnoreCase(type)){
		String phrasedesc = Util.null2String(fu.getParameter("value"));
		String phraseShort = Util.null2String(fu.getParameter("name"));
		if(phrasedesc != null && !"".equals(phrasedesc)){
			phrasedesc = phrasedesc.replace("\n","<br>");
			phrasedesc = phrasedesc;
		} else{
			phrasedesc = "";
		}
		String sql = "insert into sysPhrase (hrmId,phraseShort,phrasedesc) values('"+user.getUID()+"','"+phraseShort+"','"+phrasedesc+"')";		
		RecordSet rs = new RecordSet();
		rs.executeSql(sql);
		result.put("flag","true");
	}else if("status".equalsIgnoreCase(type)){
		result.put("flag","true");
	} else{
		List allphrese = new ArrayList();	
	
		RecordSet.executeProc("sysPhrase_selectByHrmId", "" + user.getUID());
    
		while (RecordSet.next()) {
			Map phresesMap = new HashMap();
			phresesMap.put("name", Util.null2String(RecordSet.getString("phraseShort")));
			//phresesMap.put("value", Util.delHtml(Util.null2String(RecordSet.getString("phrasedesc"))).replaceAll("%nbsp;", " "));
			phresesMap.put("id", Util.null2String(RecordSet.getString("id")));


			String phrValue = RecordSet.getString("phrasedesc");
			if(phrValue != null){
					phrValue = WorkflowServiceUtil.splitAndFilterString(phrValue,phrValue.length());
					if(phrValue.endsWith("\n\n"))		//替换后产生两个换行\n\n，去掉一个
					phrValue = phrValue.substring(0, phrValue.length()-2);
					phrValue = phrValue.replace("\r","※").replace("\n","▉").replace("\b","▓").replace("\f","▅").replace("\t","▒");
					phrValue = phrValue.replace("\\","\\\\");
					phrValue = phrValue.replace("※","\r").replace("▉","\n").replace("▓","\b").replace("▅","\f").replace("▒","\t");
					//phrValue=phrValue.replaceAll("\r\n", "").replaceAll("\n", "\\\\\\n").replaceAll("\r", "").replaceAll("\\\\", "\\\\\\\\").replace("\"", "\\\\\\\"").replaceAll("\'", "\\\\\'");
					phrValue = phrValue.replace("\n\n","\n");
					phresesMap.put("value",phrValue);
			 }else{
					phresesMap.put("value","");
			 }
			 phresesMap.put("value",phrValue);
			allphrese.add(phresesMap);
		}
		result.put("phrases", allphrese);
		result.put("flag","true");
	}
	
    JSONObject jo = JSONObject.fromObject(result);
    response.getWriter().write(jo.toString());
%>

