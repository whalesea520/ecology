<%@ include file="/page/element/settingCommon.jsp"%>  

<%@ page import="java.lang.reflect.Constructor" %>
<%@ page import="java.lang.reflect.Method" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	/*
	基本信息
	eib
	ebaseid	
	esharelevel
	strsqlwhere
	*/
%>




  <%
	if("2".equals(esharelevel)){
		//得where语句
		//rsWhere.executeSql("select * from hpWhereElement where elementid="+ebaseid);
		String settingshowmethod=Util.null2String(ebc.getSettingMethod(ebaseid));
		String randomValue = Util.null2String(request.getParameter("randomValue"));
		String strSettingWhere ="";
		if (!"".equals(settingshowmethod)){			
			if(!"".equals(settingshowmethod)){
					Class tempClass = Class.forName("weaver.page.element.compatible.PageWhere");
				if(ebaseid.equals("7")||ebaseid.equals("8")||ebaseid.equals("1")||ebaseid.equals("29")){
					Method tempMethod = tempClass.getMethod(settingshowmethod, new Class[] { String.class, String.class, String.class, String.class,String.class,String.class  });
					Constructor ct = tempClass.getConstructor(null);
	
					strSettingWhere=(String)tempMethod.invoke(ct.newInstance(null), new Object[] {eid,ebaseid,strsqlwhere,""+user.getLanguage(),esharelevel,randomValue});
				}else{
					Method tempMethod = tempClass.getMethod(settingshowmethod, new Class[] { String.class, String.class, String.class, String.class,String.class});
					Constructor ct = tempClass.getConstructor(null);

					strSettingWhere=(String)tempMethod.invoke(ct.newInstance(null), new Object[] {eid,ebaseid,strsqlwhere,""+user.getLanguage(),esharelevel});
				}
				out.println("\n"+strSettingWhere+"\n");
				//out.println("<TR valign='top'><TD colspan=2 class=line></TD></TR>\n");
			}

		}
		
	}
	%>


</TABLE>
