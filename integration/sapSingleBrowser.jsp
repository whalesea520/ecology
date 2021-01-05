<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="com.weaver.integration.entity.Int_BrowserbaseInfoBean"%>
<%@page import="com.weaver.integration.entity.Sap_inParameterBean"%>
<%@page import="com.weaver.integration.entity.Sap_inStructureBean"%>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%> 
<jsp:useBean id="butil" class="com.weaver.integration.util.BaseUtil" scope="page" />
<html>
<head>
	<%
	    String workflowid=Util.null2String(request.getParameter("workflowid"));
		//如果是新建流程，只能从页面取数据
		String frombrowserid = Util.null2String(request.getParameter("frombrowserid"));//触发字段id
		String fromNode = Util.null2String(request.getParameter("fromNode"));//触发字段id
		String fromNodeorReport=Util.getIntValue(request.getParameter("fromNodeorReport"),0)+"";//1表示改浏览按钮的点击来源为报表或节点前或批次条件
		if("1".equals(fromNode)){
			fromNodeorReport="1";
		}
		boolean ismainfield = true;//是主字段
		String detailrow = "";//如果是明字段，代表行号
		String fromfieldid = "";//字段id
		String strs[] = frombrowserid.split("_");
		if(strs.length>=2){
			fromfieldid = strs[0];
			detailrow = strs[1];
			ismainfield = false;
		}else{
			fromfieldid = strs[0];
		}
		String type=Util.null2String(request.getParameter("sapbrowserid"));//集成流程按钮标识
		String nodeid=Util.null2String(request.getParameter("nodeid"));//流程表单的节点id
		Int_BrowserbaseInfoBean nb=butil.getSapBaseInfoById(type);
		List inParameter=nb.getSap_inParameter();//获取输入参数
		List listoafieldin=new ArrayList();//封装oa输入参数字段(有固定值的)
		List listoafieldno=new ArrayList();//封装oa输入参数字段(所有的)
		List intstrufield=nb.getSap_inStructure(); //获取输入结构
		//System.out.println("浏览按钮标识"+type);
		//System.out.println("输入参数的长度"+inParameter.size());
		//System.out.println("输入结构的长度"+intstrufield.size());

		IntegratedSapUtil insaputil=new IntegratedSapUtil();
	%>

</head>
	<body>
	
			<% 

				out.println(" <form action='/integration/sapSingleBrowserDetial.jsp' method='post' name='weaverfield' id='weaverfield'>");

				if(inParameter.size()>0)//说明有输入参数
				{
					for(int i=0;i<inParameter.size();i++)//循环参数
					{
						Sap_inParameterBean sap_inParameterBean=(Sap_inParameterBean)inParameter.get(i);
						String Constant=sap_inParameterBean.getConstant();//输入参数的固定值
						String Oafield=sap_inParameterBean.getOafield();//输入参数来源于OA字段的值
						String sapfield=sap_inParameterBean.getSapfield();//输入参数的sap字段
						String oafieldid=sap_inParameterBean.getFromfieldid();//OA字段的id
						String ismainfieldmy=sap_inParameterBean.getIsmainfield();//是否主表字段
						if("".equals(Constant)&&!"".equals(oafieldid))//如果没有固定值，那么这个值就来源于流程表单界面的字段,并且这个oa字段存在
						{
							if("1".equals(ismainfieldmy))//主表
							{
								listoafieldin.add("field"+oafieldid);
								//out.println("field"+oafieldid+"---<br/>");
							}else//明细表字段
							{
								listoafieldin.add("field"+oafieldid+"_"+detailrow);
							}
						}
						if(!"".equals(oafieldid))
						{
							if("1".equals(ismainfieldmy))//主表
							{
								listoafieldno.add("field"+oafieldid+"@<>@"+Constant);
							}else//明细表字段
							{
								listoafieldno.add("field"+oafieldid+"_"+detailrow+"@<>@"+Constant);
							}
						}
					}
				}
				
				if(intstrufield.size()>0)//说明有输入结构
				{
					
					for(int i=0;i<intstrufield.size();i++)//循环参数
					{
						Sap_inStructureBean sap_inStructureBean=(Sap_inStructureBean)intstrufield.get(i);
						String Constant=sap_inStructureBean.getConstant();//输入参数的固定值
						String Oafield=sap_inStructureBean.getOafield();//输入参数来源于OA字段的值
						String sapfield=sap_inStructureBean.getSapfield();//输入参数的sap字段
						String oafieldid=sap_inStructureBean.getFromfieldid();//OA字段的id
						String ismainfieldmy=sap_inStructureBean.getIsmainfield();//是否主表字段
						if("".equals(Constant)&&!"".equals(oafieldid))//如果没有固定值，那么这个值就来源于流程表单界面的字段,并且这个oa字段存在
						{
							if("1".equals(ismainfieldmy))//主表
							{
								
								listoafieldin.add("field"+oafieldid);
							}else//明细表字段
							{
								
								listoafieldin.add("field"+oafieldid+"_"+detailrow);
							}
						}
						
						if(!"".equals(oafieldid))
						{
							if("1".equals(ismainfieldmy))//主表
							{
								
								listoafieldno.add("field"+oafieldid+"@<>@"+Constant);
							}else//明细表字段
							{
								listoafieldno.add("field"+oafieldid+"_"+detailrow+"@<>@"+Constant);
							}
						}
					}
				}
				listoafieldno=insaputil.removeDuplicateWithOrder(listoafieldno);//去掉重复的字段
				for(int i=0;i<listoafieldno.size();i++)
				{
					String templist[]=(listoafieldno.get(i)+"").split("@<>@");
					if(templist.length>1)
					{
						out.println("<input type='hidden' name='"+templist[0]+"' id='"+templist[0]+"' value='"+templist[1]+"'>");
					}else
					{
						out.println("<input type='hidden' name='"+templist[0]+"' id='"+templist[0]+"' value=''>");
					}
				}
				out.println("<input type='hidden' name='type' id='type' value='"+type+"'>");
				out.println("<input type='hidden' name='detailrow' id='detailrow' value='"+detailrow+"'>");
				out.println("<input type='hidden' name='fromfieldid' id='fromfieldid' value='"+fromfieldid+"'>");
				out.println("<input type='hidden' name='fromNodeorReport' id='fromNodeorReport' value='"+fromNodeorReport+"'>");
				out.println("<input type='hidden' name='nodeid' id='nodeid' value='"+nodeid+"'>");
				out.println("<input type='hidden' name='workflowid' id='workflowid' value='"+workflowid+"'>");
				out.println(" </form>");
			 %>
			<%--<input id="test" type="text" value="1"/>
			<input id="test2" type="text" value="1"/>--%>
	</body>
<script type="text/javascript">
	$(document).ready(function() {

		<%
            for(int j=0;j<listoafieldin.size();j++)
            {
        %>
		//$("#test").val("<%=listoafieldin.get(j)%>");
		try{
			if(navigator.userAgent.indexOf('MSIE') >= 0) {
				//得到输入参数要的字段值
				//var obj = window.parent.parent.document.getElementById("<%=listoafieldin.get(j)%>");
				//修改 zhouhb
				var obj="";
                if(parent.parent.document.getElementById("bodyiframe")==null||parent.parent.document.getElementById("bodyiframe")==""){
					//表单建模中的iframe的id为tabcontentframe
                    var dialog = window.parent.parent.getDialog(parent);
                    obj = dialog.currentWindow.document.getElementById('<%=listoafieldin.get(j)%>');
                }else{
                    obj= parent.parent.document.getElementById("bodyiframe").contentWindow.document.getElementById("<%=listoafieldin.get(j)%>");

                }
                //end
				if(obj.tagName=="SELECT"){
					//下拉框
					document.getElementById("<%=listoafieldin.get(j)%>").value=obj[obj.selectedIndex].text;
					//alert(obj[obj.selectedIndex].text);
				}else{
					document.getElementById("<%=listoafieldin.get(j)%>").value=obj.value;
				}
			}else{
			//修改 zhouhb			   
                if(parent.parent.document.getElementById("bodyiframe")==null||parent.parent.document.getElementById("bodyiframe")==""){
				//表单建模中的iframe的id为tabcontentframe
				<%
				System.out.println("fieldid:"+listoafieldin.get(j));
				%>
				    var dialog = window.parent.parent.getDialog(parent);
                    obj = dialog.currentWindow.document.getElementById('<%=listoafieldin.get(j)%>');
					var v=jQuery("#"+'<%=listoafieldin.get(j)%>').val();
                }else{                  
                    obj= parent.parent.document.getElementById("bodyiframe").contentWindow.document.getElementById('<%=listoafieldin.get(j)%>');					
                }
                //end
				if(obj.tagName=="SELECT"){
					//下拉框
					document.getElementById("<%=listoafieldin.get(j)%>").value=obj[obj.selectedIndex].text;
				}else{
					document.getElementById("<%=listoafieldin.get(j)%>").value=obj.value;
				}
				//$("#test2").val(obj.value);
			}
		}catch(e){
		}
		<%
            }
        %>
		document.getElementById("weaverfield").submit();
	});
</script>
</html>

