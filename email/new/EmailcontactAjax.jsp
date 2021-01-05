<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.email.service.ContactManagerService"%>
<%@page import="weaver.email.sequence.MailContacterSequence"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="gms" class="weaver.email.service.GroupManagerService" scope="page" />
<%@ page import="net.sf.json.*" %>
<%
			
			String method = Util.null2String(request.getParameter("method"));
			String srzids = Util.null2String(request.getParameter("srzids")).toLowerCase();
			String srzname=Util.null2String(request.getParameter("srzname"));
			srzname=URLDecoder.decode(srzname, "utf-8");
			String sql="";
			if("haved".equals(method)&&!"".equals(srzname)){
				
				ArrayList arrylist=new ArrayList();
				ArrayList arrylist_id=new ArrayList();
				//记录整个新组的id成员
				ArrayList arrylist_newid=new ArrayList();
				String srzids_sz[]=srzids.split("@;");
				if(null!=srzids_sz&&!"".equals(srzids)){
						sql="select  mailaddress,id from MailUserAddress  where userId='"+user.getUID()+"'";
						rs.execute(sql);
						while(rs.next()){
							arrylist.add((rs.getString("mailaddress")+"").toLowerCase());
							arrylist_id.add(rs.getString("id"));
						}
						//检测这个邮件联系人，在数据库中是否存在
						for(int i=0;i<srzids_sz.length;i++){
							//如果不存在，则创建新的联系人
							if(!arrylist.contains(srzids_sz[i])){
								int ContacterId = MailContacterSequence.getInstance().get();
								//如果这个联系人在当前用户的联系人中不存在，则加入该用户到当前用户的联系人中
								String temp_name=srzids_sz[i];
								String e_name=temp_name.substring(0,temp_name.indexOf("@"));
								sql="insert into MailUserAddress (id,mailaddress,mailuserName,userid)values("+ContacterId+",'"+temp_name+"','"+e_name+"',"+user.getUID()+")";
								rs.execute(sql);
								//记录新的联系人id
								arrylist_newid.add(ContacterId);
							}
						}
						for(int i=0;i<srzids_sz.length;i++){
							for(int j=0;j<arrylist.size();j++){
								String temp_str=arrylist.get(j)+"";
								if(temp_str.equals(srzids_sz[i])){
									//记录旧(以前就存在的)的联系人id
									arrylist_newid.add(arrylist_id.get(j));
									break;
								}
							}
						}
				}
				if(gms.isNameRepeat(srzname, user.getUID())) {
					out.clear();
					out.print(0); //组名重复
				} else {
					int groupId = gms.createGroup(user.getUID(), srzname);
					if(groupId != -1) {
							//创建组成功	
							String newpeople="";
							for(int i=0;i<arrylist_newid.size();i++){
									newpeople+=arrylist_newid.get(i)+",";
							}	
							ContactManagerService sj=new ContactManagerService();
							//将所有成员添加到新组中去
							sj.addContactToGroup(newpeople,groupId);
							out.clear();
							out.println(1); //创建组成功
					}else{
							out.clear();
							out.print(2); //创建组失败
					}
				}
		}
%>