
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.cpcompanyinfo.JspUtil"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs02" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%

		int temp_n=Util.getIntValue(request.getParameter("temp_n"),0);
		String temp_type=Util.null2String(request.getParameter("temp_type"));
		String countryid_str="";
		String[]countryid_count=request.getParameterValues("countryid_count");
		String sql="";
		if("CompanyBusinessService".equals(temp_type)){
				String _message="";
					try{
							//业务类型的开发
							if(null!=countryid_count){
								for(int i=0;i<countryid_count.length;i++){
										if(!"".equals(countryid_count[i])){
												countryid_str+=countryid_count[i]+",";
										}
								}
							}
							String delete_n=Util.null2String(request.getParameter("delete_n"));
							if(!"".equals(delete_n)){
								sql="delete  CompanyBusinessService where id  in("+JspUtil.Strim(delete_n)+")";
								sql+=" and id not in( ";
							    sql+=" select businesstype  from CPCOMPANYINFO where   isdel='T' ";
							    sql+="group by  businesstype ";
							    sql+="having count(businesstype)>0 ) ";
								rs.execute(sql);	
							}
							for(int i=0;i<temp_n;i++){	
									String affixindexdesc_=Util.null2String(request.getParameter("affixindexdesc_"+i));
									String tempjie01=Util.null2String(request.getParameter("countryid_"+i));
									String tempjie02=Util.null2String(request.getParameter("affname_"+i));
									String tempjie=Util.null2String(request.getParameter("affdesc_"+i));
									if("".equals(tempjie02)){
										continue;
									}else if(!"".equals(tempjie01)){
											rs.execute("select count(*) s from CompanyBusinessService where (affixindex='"+affixindexdesc_+"'  or name='"+tempjie02+"')  and id !='"+tempjie01+"'");
											if(rs.next()&&rs.getInt("s")<=0){
												//修改操作
												sql="update CompanyBusinessService set name='"+tempjie02+"',affixindex='"+affixindexdesc_+"',affdesc='"+tempjie+"'   where id='"+tempjie01+"'";
												 rs.execute(sql);
											}else{
												_message+="--"+SystemEnv.getHtmlLabelName(26329 ,user.getLanguage())+"["+affixindexdesc_+"]"+tempjie+""+SystemEnv.getHtmlLabelName(31436 ,user.getLanguage())+"!";
											}
									}else{
											rs.execute("select count(*) s from CompanyBusinessService where (affixindex='"+affixindexdesc_+"'  or name='"+tempjie02+"')   ");
											if(rs.next()&&rs.getInt("s")<=0){
												sql="insert into CompanyBusinessService (affixindex,name,affdesc) values('";
												sql+=affixindexdesc_+"','";
												sql+=tempjie02+"','";
												sql+=tempjie+"'";
												sql+=")";	
												rs.execute(sql);
											}else{
												_message+="--"+SystemEnv.getHtmlLabelName(26329 ,user.getLanguage())+"["+affixindexdesc_+"]"+tempjie+""+SystemEnv.getHtmlLabelName(26772 ,user.getLanguage())+"!";
											}
									}
							}	
							if("".equals(_message)){
								//全部操作成功，没有错误
								_message=SystemEnv.getHtmlLabelName(30700 ,user.getLanguage())+_message;
							}else{
								//操作已完成，有错误
								_message=SystemEnv.getHtmlLabelName(31437 ,user.getLanguage())+_message;
							}
							
					}catch(Exception e){
							e.printStackTrace();
							_message=SystemEnv.getHtmlLabelName(30651 ,user.getLanguage())+"!";
					}
				%>
						<script type="text/javascript">
							window.parent.alert("<%=_message%>");
							window.parent.location.href="/cpcompanyinfo/CompanyService.jsp";
						</script>
					<%
					return;
					//response.sendRedirect("/cpcompanyinfo/CompanyService.jsp?flag=cg");
		}else  if("Companyattributable".equals(temp_type)){
					//公司归属
					String _message="";
					try{
							if(null!=countryid_count){
									for(int i=0;i<countryid_count.length;i++){
											if(!"".equals(countryid_count[i])){
													countryid_str+=countryid_count[i]+",";
											}
									}
								}
								String delete_n=Util.null2String(request.getParameter("delete_n"));
									if(!"".equals(delete_n)){
										sql="delete  Companyattributable where id  in("+JspUtil.Strim(delete_n)+")";
										sql+=" and id not in( ";
									    sql+=" select companyvestin  from CPCOMPANYINFO where   isdel='T' ";
										sql+="group by  companyvestin   ";
										sql+="having count(companyvestin)>0 )  ";
										rs.execute(sql);	
									}
								for(int i=0;i<temp_n;i++){	
									String affixindexdesc_=Util.null2String(request.getParameter("affixindexdesc_"+i));
									String tempjie01=Util.null2String(request.getParameter("countryid_"+i));
									String tempjie02=Util.null2String(request.getParameter("affname_"+i));
									String tempjie=Util.null2String(request.getParameter("affdesc_"+i));
										if("".equals(tempjie02)){
											continue;
										}else if(!"".equals(tempjie01)){
											rs.execute("select count(*) s from Companyattributable where (affixindex='"+affixindexdesc_+"'  or name='"+tempjie02+"')  and id !='"+tempjie01+"'");
											if(rs.next()&&rs.getInt("s")<=0){
												//修改操作
												sql="update Companyattributable set name='"+tempjie02+"',affixindex='"+affixindexdesc_+"',affdesc='"+tempjie+"'   where id='"+tempjie01+"'";
												rs.execute(sql);
											}else{
												_message+="--"+SystemEnv.getHtmlLabelName(30987 ,user.getLanguage())+"["+affixindexdesc_+"]"+tempjie+""+SystemEnv.getHtmlLabelName(31436 ,user.getLanguage())+"!";
											}
										}else{
											rs.execute("select count(*) s from Companyattributable where (affixindex='"+affixindexdesc_+"'  or name='"+tempjie02+"')   ");
											if(rs.next()&&rs.getInt("s")<=0){
												sql="insert into Companyattributable (affixindex,name,affdesc) values('";
												sql+=affixindexdesc_+"','";
												sql+=tempjie02+"','";
												sql+=tempjie+"'";
												sql+=")";	
												rs.execute(sql);
											}else{
												_message+="--"+SystemEnv.getHtmlLabelName(30987 ,user.getLanguage())+"["+affixindexdesc_+"]"+tempjie+""+SystemEnv.getHtmlLabelName(26772 ,user.getLanguage())+"!";
											}
										}
								}	
							if("".equals(_message)){
								//全部操作成功，没有错误
								_message=SystemEnv.getHtmlLabelName(30700 ,user.getLanguage())+_message;
							}else{
								//操作已完成，有错误
								_message=SystemEnv.getHtmlLabelName(31437 ,user.getLanguage())+_message;
							}
					}catch(Exception e){
							e.printStackTrace();
							_message=SystemEnv.getHtmlLabelName(30651 ,user.getLanguage())+"!";
					}
					%>
					<script type="text/javascript">
						window.parent.alert("<%=_message%>");
						window.parent.location.href="/cpcompanyinfo/Companyattributable.jsp";
					</script>
			<%
					return;
					//response.sendRedirect("/cpcompanyinfo/Companyattributable.jsp?flag=cg");
		}else  if("CompanyLicenseMaintain".equals(temp_type)){
				//公司证照处理界面的逻辑
					String _message="";
					try{
						//证照名称
						String now = Util.date(2);
						if(null!=countryid_count){
							for(int i=0;i<countryid_count.length;i++){
									if(!"".equals(countryid_count[i])){
											countryid_str+=countryid_count[i]+",";
									}
							}
						}
						String delete_n=Util.null2String(request.getParameter("delete_n"));
						if(!"".equals(delete_n)){
							sql="delete  CPLMLICENSEAFFIX where licenseaffixid  in("+JspUtil.Strim(delete_n)+")";
							sql+=" and licenseaffixid not in(";
							sql+="select licenseaffixid  from CPBUSINESSLICENSE where   isdel='T' ";
							sql+="group by  licenseaffixid ";
							sql+="having count(licenseaffixid)>0 )";
							rs.execute(sql);	
						}
						 for(int i=0;i<temp_n;i++){	
								String affixindexdesc_=Util.null2String(request.getParameter("affixindexdesc_"+i));
								String ismulti_=Util.getIntValue(Util.null2String(request.getParameter("ismulti_"+i)), 0)+"";
								String tempjie01=Util.null2String(request.getParameter("countryid_"+i));
								String tempjie02=Util.null2String(request.getParameter("affname_"+i));
								//判断该affixindexdesc_是否在数据库中存在
								if("".equals(tempjie02)){
									continue;
								}else if(!"".equals(tempjie01)){
											rs.execute("select count(*) s from CPLMLICENSEAFFIX where (affixindex='"+affixindexdesc_+"'  or licensename='"+tempjie02+"')  and licenseaffixid !='"+tempjie01+"'");
											if(rs.next()&&rs.getInt("s")<=0){
											   //修改操作
												sql = "update CPLMLICENSEAFFIX set affixindex='"+affixindexdesc_+"',licensename = '"+tempjie02+"',uploaddatetime='"+now+"',ismulti='"+ismulti_+"' where licenseaffixid="+tempjie01;
												rs.execute(sql);
											}else{
												_message+="--"+SystemEnv.getHtmlLabelName(31435 ,user.getLanguage())+"["+affixindexdesc_+"]"+tempjie02+""+SystemEnv.getHtmlLabelName(31436 ,user.getLanguage())+"!";
											}
								}else{
									
									rs.execute("select count(*) s from CPLMLICENSEAFFIX where (affixindex='"+affixindexdesc_+"'  or licensename='"+tempjie02+"')   ");
									if(rs.next()&&rs.getInt("s")<=0){
										sql="insert into CPLMLICENSEAFFIX (affixindex,licensename,licensetype,uploaddatetime,ismulti) values ("+affixindexdesc_+",'"+tempjie02+"',0,'"+now+"','"+ismulti_+"')";
										rs.execute(sql);
									}else{
										_message+="--"+SystemEnv.getHtmlLabelName(31435 ,user.getLanguage())+"["+affixindexdesc_+"]"+tempjie02+""+SystemEnv.getHtmlLabelName(26772 ,user.getLanguage())+"!";
									}
								}
								
						}	
						if("".equals(_message)){
								//全部操作成功，没有错误
								_message=SystemEnv.getHtmlLabelName(30700 ,user.getLanguage())+_message;
							}else{
								//操作已完成，有错误
								_message=SystemEnv.getHtmlLabelName(31437 ,user.getLanguage())+_message;
							}
					}catch(Exception e){
							e.printStackTrace();
							_message=SystemEnv.getHtmlLabelName(30651 ,user.getLanguage())+"!";
					}
					%>
					<script type="text/javascript">
						window.parent.alert("<%=_message%>");
						window.parent.location.href="/cpcompanyinfo/CompanyLicenseMaintain.jsp";
					</script>
			<%
					return;
		
		}else  if("CompanyAttach".equals(temp_type)){
					String message="";
					try{
							String lmdirectors[]=Util.null2String(request.getParameter("lmdirectors")).split(";");
							String lmlicense[]=Util.null2String(request.getParameter("lmlicense")).split(";");
							String lmconstitution[]=Util.null2String(request.getParameter("lmconstitution")).split(";");
							String lmshare[]=Util.null2String(request.getParameter("lmshare")).split(";");
							sql="update mytrainaccessoriestype set mainid="+lmdirectors[0]+",subid="+lmdirectors[1]+",secid="+lmdirectors[2]+" where accessoriesname='lmdirectors'";
							rs.execute(sql);
							sql="update mytrainaccessoriestype set mainid="+lmlicense[0]+",subid="+lmlicense[1]+",secid="+lmlicense[2]+" where accessoriesname='lmlicense'";
							rs.execute(sql);
							sql="update mytrainaccessoriestype set mainid="+lmconstitution[0]+",subid="+lmconstitution[1]+",secid="+lmconstitution[2]+" where accessoriesname='lmconstitution'";
							rs.execute(sql);
							sql="update mytrainaccessoriestype set mainid="+lmshare[0]+",subid="+lmshare[1]+",secid="+lmshare[2]+" where accessoriesname='lmshare'";
							rs.execute(sql);
							message=""+SystemEnv.getHtmlLabelName(30700,user.getLanguage());
					}catch(Exception e){
							message=""+SystemEnv.getHtmlLabelName(30651,user.getLanguage());
					}
					out.clear();
					out.println(message+"!");		
		}
%>