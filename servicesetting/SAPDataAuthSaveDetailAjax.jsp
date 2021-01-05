
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@ page import="weaver.general.BaseBean" %>
<%@page import="java.util.Map"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.net.*"%>
<%@page import="weaver.parseBrowser.SapBrowserComInfo"%>
<%@page import="weaver.parseBrowser.SapBaseBrowser"%> 
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="basebean" class="weaver.general.BaseBean" scope="page" />

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	User user = HrmUserVarify.checkUser(request,response);
	if(user == null){
		return;
	}
	
	if(!HrmUserVarify.checkUserRight("SAPDataAuthSetting:Manage",user)) {
		//response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}



	String json = "";
	
	String operation = Util.null2String(request.getParameter("operation"));
	int settingid = Util.getIntValue(request.getParameter("settingid"),0);
	
	if(operation.equals("savedetail")){
		
		//System.out.println("settingid========" + settingid);
		
		String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));
		String filtertype = Util.null2String(request.getParameter("filtertype"));
		List sapcodeList = (List)session.getAttribute("Temp_SAPDataAuthSetting_SAPCodeList_"+settingid+"_"+sapbrowserid);
		if(sapcodeList == null){
			sapcodeList = new ArrayList();
		}
		String sapcodes = Util.null2String(request.getParameter("sapcodes"));
		sapcodes = URLDecoder.decode(sapcodes,"UTF-8");
		//System.out.println("sapcode=======" + sapcodes);
		String[] sapcodearr = Util.TokenizerString2(sapcodes,",");
		for(int i = 0; i<sapcodearr.length; i++){
			if(!sapcodeList.contains(sapcodearr[i])){
				sapcodeList.add(sapcodearr[i]);	
			}
		}
		rs.execute("delete from SAPData_Auth_setting_detail where settingid='"+settingid + "' and browserid='"+sapbrowserid+"'");
		
		for(int i = 0; i<sapcodeList.size(); i++){
			String tmpsapcode = (String)sapcodeList.get(i);
			String sql = "insert into SAPData_Auth_setting_detail (settingid,filtertype,browserid,sapcode) values ('"+settingid+"','"+filtertype+"','"+sapbrowserid+"','"+tmpsapcode+"')";
			rs.execute(sql);
		}
		session.removeAttribute("Temp_SAPDataAuthSetting_SAPCodeList_"+settingid+"_"+sapbrowserid);
		
		json = "{'saveFlag':'S'}";
		out.println(json);
	}

	if(operation.equals("clear")){
		String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));
		rs.execute("delete from SAPData_Auth_setting_detail where settingid='"+settingid + "' and browserid='"+sapbrowserid+"'");
		session.removeAttribute("Temp_SAPDataAuthSetting_SAPCodeList_"+settingid+"_"+sapbrowserid);
		
		json = "{'saveFlag':'S'}";
		out.println(json);
	}

	if(operation.equals("cancel")){
		String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));
		session.removeAttribute("Temp_SAPDataAuthSetting_SAPCodeList_"+settingid+"_"+sapbrowserid);
	}
	
	if(operation.equals("syncSAPCode")){
		String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));
		String type = Util.null2String(request.getParameter("type"));
		String sapcodes = Util.null2String(request.getParameter("sapcodes"));
		sapcodes = URLDecoder.decode(sapcodes,"UTF-8");
		
		List sapcodeList = (List)session.getAttribute("Temp_SAPDataAuthSetting_SAPCodeList_"+settingid+"_"+sapbrowserid);
		if(sapcodeList == null){
			sapcodeList = new ArrayList();
			rs.execute("select * from SAPData_Auth_setting_detail where settingid='"+settingid+"' and browserid='"+sapbrowserid+"'");
			while(rs.next()){
				String tmpcode = Util.null2String(rs.getString("sapcode"));
				sapcodeList.add(tmpcode);
			}
		}
		
		String[] sapcodearr = Util.TokenizerString2(sapcodes,",");
		if(type.equals("add")){
			for(int i = 0; i<sapcodearr.length; i++){
				String tmpcode = sapcodearr[i];
				if(!sapcodeList.contains(tmpcode)){
					sapcodeList.add(tmpcode);
				}
			}
		}else if(type.equals("delete")){
			for(int i = 0; i<sapcodearr.length; i++){
				String tmpcode = sapcodearr[i];
				if(sapcodeList.contains(tmpcode)){
					sapcodeList.remove(tmpcode);
				}
			}
		}
		//System.out.println("sapcodeList########" + sapcodeList);
		session.setAttribute("Temp_SAPDataAuthSetting_SAPCodeList_"+settingid+"_"+sapbrowserid,sapcodeList);
	}
	
	if(operation.equals("deleteBrowserid")){
		String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));
		rs.execute("delete from SAPData_Auth_setting_detail where settingid='"+settingid+"' and browserid='"+sapbrowserid+"'");
		new BaseBean().writeLog("deleteBrowserid--sapbrowserid=" + sapbrowserid);
	}
	
	if(operation.equals("checksapbrowseridexists")){
		String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));
		SapBrowserComInfo sbc = new SapBrowserComInfo();
		SapBaseBrowser sbb = sbc.getSapBaseBrowser(sapbrowserid);
		if(sbb != null){
			String tmpbrowserid = Util.null2String(sbb.getSapbrowserid());
			if(!tmpbrowserid.equals("") && tmpbrowserid.equals(sapbrowserid)){
				out.println("{'exists':'Y'}");
			}else{
				out.println("{'exists':'N'}");
			}
		}else{
			out.println("{'exists':'N'}");
		}
	}
	
%>