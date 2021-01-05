
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<%@ page import=" com.weaver.integration.datesource.*" %>
<%@ page import=" com.weaver.integration.params.*" %>
<%@ page import=" com.weaver.integration.log.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<%
		
		String flag="0";//0保存失败,1保存成功
		boolean parseFlag = false;
		//save--保存,update--修改,delete-删除
		String opera=Util.null2String(request.getParameter("opera"));
		String id=Util.null2String(request.getParameter("ids"));
		if(!"".equals(id)&&(id.length()==(id.lastIndexOf(",")+1)))
		{
			id=id.substring(0,(id.length()-1));
		}
		String hpid=Util.null2String(request.getParameter("hpid"));
		String poolid=Util.null2String(request.getParameter("poolid"));
		String funname=Util.null2String(request.getParameter("funname"));
		String fundesc=Util.null2String(request.getParameter("fundesc"));
		String serdesc=Util.null2String(request.getParameter("serdesc"));
		String regname=Util.null2String(request.getParameter("regname"));
		String loadmb=Util.getIntValue(request.getParameter("loadmb")+"",0)+"";
		String loadDate=Util.getIntValue(request.getParameter("loadDate")+"",0)+"";
		String isParseParams = Util.null2String(request.getParameter("isParseParams"));
		String sql="";
		String tempid =" ";
		
	 
		if("save".equals(opera))
		{
			sql=" insert into sap_service (poolid,funname,fundesc,serdesc,regname,hpid,loadmb,loadDate)";
			sql+=" values ('"+poolid+"','"+funname+"','"+fundesc+"','"+serdesc+"','"+regname+"','"+hpid+"','"+loadmb+"','"+loadDate+"')";
			if(rs.execute(sql))
			{
				flag="1";
				tempid = (SAPInterationDateSourceUtil.getMaxSapServiceNum(hpid)-1)+"";
			}
			 SAPInterationOutUtil sou = new SAPInterationOutUtil();
				LogInfo li = new LogInfo();
				if("yes".equals(isParseParams)) {
					//从sap获取所有的参数列表
					List list = ServiceParamsUtil.changeTypeBySAPAllBean(sou.getALLParamsByFunctionName(poolid, funname, li));
					//更新int_serviceParams表里面的数据
					parseFlag = ServiceParamsUtil.insertServiceParams(list, tempid);
					//更新int_servicecompparamslist表里面的数据
					ServiceParamsUtil.insertServiceCompParms(poolid, funname, tempid, li);
			   }
			response.sendRedirect("/integration/serviceReg/serviceReg_3New.jsp?closeDialog=close&isNew=1&id="+hpid);
			return;
		}else if("update".equals(opera))
		{
			sql=" update sap_service set poolid='"+poolid+"',funname='"+funname+"',fundesc='"+fundesc+"',serdesc='"+serdesc+"',regname='"+regname+"',loadmb='"+loadmb+"',loadDate='"+loadDate+"'";
			sql+=" where id='"+id+"'";
			if(rs.execute(sql))
			{
				flag="1";
				tempid = id;
				ServiceParamsUtil.delParamsByServId(tempid);
			}
			 SAPInterationOutUtil sou = new SAPInterationOutUtil();
				LogInfo li = new LogInfo();
				if("yes".equals(isParseParams)) {
					//从sap获取所有的参数列表
					List list = ServiceParamsUtil.changeTypeBySAPAllBean(sou.getALLParamsByFunctionName(poolid, funname, li));
					//更新int_serviceParams表里面的数据
					parseFlag = ServiceParamsUtil.insertServiceParams(list, tempid);
					//更新int_servicecompparamslist表里面的数据
					ServiceParamsUtil.insertServiceCompParms(poolid, funname, tempid, li);
			   }
			response.sendRedirect("/integration/serviceReg/serviceReg_3New.jsp?closeDialog=close&isNew=1&id="+id);
			return;
		}else if("delete".equals(opera))
		{
				sql=" delete sap_service where id in("+id+")";
				if(rs.execute(sql))
				{
					flag="1";
					tempid = id;
					ServiceParamsUtil.delParamsByServId(tempid);
				}
			String isDialog=Util.null2String(request.getParameter("isDialog"));
			if("1".equals(isDialog)){
				response.sendRedirect("/integration/serviceReg/serviceReg_3New.jsp?closeDialog=close&isNew=1&id="+id);
				return;
			}
		}else if("updatedesc".equals(opera))
		{
			sql=" update sap_service set serdesc='"+serdesc+"',loadmb='"+loadmb+"',loadDate='"+loadDate+"',regname='"+regname+"'";
			sql+=" where id='"+id+"'";
			if(rs.execute(sql))
			{
				flag="1";
				tempid = id;
				
			}
			 SAPInterationOutUtil sou = new SAPInterationOutUtil();
				LogInfo li = new LogInfo();
				if("yes".equals(isParseParams)) {
					//从sap获取所有的参数列表
					List list = ServiceParamsUtil.changeTypeBySAPAllBean(sou.getALLParamsByFunctionName(poolid, funname, li));
					//更新int_serviceParams表里面的数据
					parseFlag = ServiceParamsUtil.insertServiceParams(list, tempid);
					//更新int_servicecompparamslist表里面的数据
					ServiceParamsUtil.insertServiceCompParms(poolid, funname, tempid, li);
			   }
			response.sendRedirect("/integration/serviceReg/serviceReg_3New.jsp?closeDialog=close&isNew=1&id="+id);
			return;
		}else if("refresh".equals(opera))
		{
			//删除int_serviceParams,int_serviceCompParamsList表里面的数据
			flag="1";
			tempid = id;
			rs.execute("delete int_servParamModeDis where servid in("+tempid+")");
			ServiceParamsUtil.delParamsByServId(tempid);
		}
	SAPInterationOutUtil sou = new SAPInterationOutUtil();
	LogInfo li = new LogInfo();
	if("yes".equals(isParseParams)) {
		//从sap获取所有的参数列表
		List list = ServiceParamsUtil.changeTypeBySAPAllBean(sou.getALLParamsByFunctionName(poolid, funname, li));
		//更新int_serviceParams表里面的数据
		parseFlag = ServiceParamsUtil.insertServiceParams(list, tempid);
		//更新int_servicecompparamslist表里面的数据
		ServiceParamsUtil.insertServiceCompParms(poolid, funname, tempid, li);
	}
		
      
%>

<script type="text/javascript">
	<!--
		if(<%=flag%>==1)
		{
			alert("<%=SystemEnv.getHtmlLabelName(30700,user.getLanguage())%>!");
		}else
		{
			alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>!");
		}
		<%if("delete".equals(opera)) {%>
			window.location.href="/integration/serviceReg/serviceReg_3list.jsp?hpid="+<%=hpid%>;
		<%}else {%>
			window.location.href="/integration/serviceReg/serviceReg_3New.jsp?isNew=1&id="+<%=tempid%>;
		<%}%>	
//-->
</script>
