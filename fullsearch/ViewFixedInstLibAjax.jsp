<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page buffer="8kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.zip.ZipInputStream"%>
<%@page import="weaver.file.AESCoder"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<% 
    User user = HrmUserVarify.getUser (request , response) ;
    //保存后重新显示的固定指令ID
    String showStatus = Util.null2String(request.getParameter("showStatus"));
    //固定指令名称
    String name = Util.null2String(request.getParameter("name"));
    //图片显路径
    String imageIdFromSelect = Util.null2String(request.getParameter("imageIdFromSelect"));
    //固定指令顺序
    String order = Util.null2String(request.getParameter("order"));
    //操作方法
    String method = Util.null2String(request.getParameter("method"));
  	//新加指令时对应的详情
    String addDescLst = Util.null2String(request.getParameter("addDescLst"));
    //固定指令详细排序order
    String fieldOrder = Util.null2String(request.getParameter("fieldorder"));
    //固定指令详细id
    String fieldid = Util.null2String(request.getParameter("fieldid"));
    //用于更新固定指令showExample字段
    String firstDesc = Util.null2String(request.getParameter("firstDesc"));
    //编辑固定指令详细用描述
    String desc = Util.null2String(request.getParameter("desc"));
    //编辑固定指令用删除ID集合
    String delFieldIds = Util.null2String(request.getParameter("delFieldIds"));
    //是否可以编辑固定指令说法
    String canEditFlg = Util.null2String(request.getParameter("canEditFlg"));
    //是否显示checkbox的td
    String checkBoxTd = "";
    //是否显示为readonly
    String readOnlyFlg = "";
    if("true".equals(canEditFlg)){
    	checkBoxTd = "<td style=\"text-align:center\"><input name=\"fieldChk\" type=\"checkbox\" value=\"\" class=\"\"></td>";
    }else{
    	readOnlyFlg = "readonly";
    }
    int incOrd = 0;

    String instructionShow = "";
    if(method.equals("show")){
    	if(!showStatus.equals("0") && !showStatus.equals("add")){
            String instDetailSql = "select id,instructionid,showValue,dsporder from FullSearch_FixedInstShow where instructionId = "+showStatus+" order by dsporder";
            rs.executeSql(instDetailSql);
            while(rs.next()){
            	incOrd ++;
                instructionShow += "<tr class=\"DataLight\" style=\"border-bottom:1px solid #f2f2f2\">"
                +checkBoxTd
                +"<td style=\"text-align:center\"><span><img moveimg style=\"display:none\"/></span></td>"
                +"<td style=\"text-align:left;padding:5px\"><input type=\"text\" style=\"width:70%\" id=\"descLst\" name=\"descLst\" value="+rs.getString("showValue")+" "+readOnlyFlg+"><SPAN></SPAN></td>"
                +"<td><input  type=\"hidden\" id=\"fieldid\" name=\"fieldid\" value="+rs.getString("id")+" ><input name=\"fieldorder\" id=\"fieldorder\" type=\"hidden\" value="+rs.getString("dsporder")+" ></td>"
                +"</tr>";
            }
        }else if(showStatus.equals("add")){
        	if(!addDescLst.equals("")){
        		String addDescLstArr[] = addDescLst.split("\\^");
        		for(int i=0;i<addDescLstArr.length;i++){
        			if(!addDescLstArr[i].equals("")){
        				incOrd ++;
        				instructionShow += "<tr class=\"DataLight\" style=\"border-bottom:1px solid #f2f2f2\">"
        	                +checkBoxTd
        	                +"<td style=\"text-align:center\"><span><img moveimg style=\"display:none\"/></span></td>"
        	                +"<td style=\"text-align:left;padding:5px\"><input type=\"text\" style=\"width:70%\" id=\"descLst\" name=\"descLst\" value="+addDescLstArr[i]+" ><SPAN></SPAN></td>"
        	                +"<td><input  type=\"hidden\" id=\"fieldid\" name=\"fieldid\" value=\"create\" ><input name=\"fieldorder\" id=\"fieldorder\" type=\"hidden\" value="+incOrd+" ></td>"
        	                +"</tr>";
        			}
        		}
        	}
        }
        out.print(instructionShow);
    }else if(method.equals("save")){
    	String iconName="";
    	String insertSql = "";
    	String showStatusTemp = showStatus;
    	if(showStatus.equals("add")){
    		insertSql += "insert into FullSearch_FixedInst (instructionName,showorder,showExample,defaultImgSrc,isCast) values " +
    					"('"+name+"','"+order+"','"+firstDesc+"','/fullsearch/img/fullsearch_defaultInst.png',"+1+")";
    		rs.execute(insertSql);
    		//获得最新的一条数据
    		rs.execute("select max(id) max from FullSearch_FixedInst ");
    		rs.next();
    		showStatus = rs.getString("max");
    	}
    	if(!imageIdFromSelect.equals("")){
    		String uploadPath = GCONST.getRootPath() + "fullsearch"
            + File.separatorChar + "img";
    		//自动创建目录：
    	    if (!new File(uploadPath).isDirectory())
    	        new File(uploadPath).mkdirs();
    		//删除同类型图片
    		File file = new File(uploadPath);
    		File[] array = file.listFiles();
    		for(int i=0;i<array.length;i++){
    			if(array[i].isDirectory()){
                    continue;
                }
    			if(showStatusTemp.equals("1")){
    				if(array[i].exists()){
    					if(array[i].getName().startsWith("fullSearchPhone")){
                            array[i].delete();
                        }
    				}
	    			
    			}else if(showStatusTemp.equals("2")){
                    if(array[i].getName().startsWith("fullSearchShortMessage")){
                        array[i].delete();
                    }
                }else if(showStatusTemp.equals("3")){
                    if(array[i].getName().startsWith("fullSearchInsideInfomation")){
                        array[i].delete();
                    }
                }else if(showStatusTemp.equals("4")){
                    if(array[i].getName().startsWith("fullSearchFlow")){
                        array[i].delete();
                    }
                }else if(showStatusTemp.equals("5")){
                    if(array[i].getName().startsWith("fullSearchRemind")){
                        array[i].delete();
                    }
                }else if(showStatusTemp.equals("6")){
                    if(array[i].getName().startsWith("fullSearChcheckingIn")){
                        array[i].delete();
                    }
                }else if(showStatusTemp.equals("7")){
                    if(array[i].getName().startsWith("fullSearchCheckInReport")){
                        array[i].delete();
                    }
                }else if(showStatusTemp.equals("8")){
                    if(array[i].getName().startsWith("fullSearchHoliday")){
                        array[i].delete();
                    }
                }else if(showStatusTemp.equals("9")){
                    if(array[i].getName().startsWith("fullSearchNavigation")){
                        array[i].delete();
                    }
                }else if(showStatusTemp.equals("10")){
                    if(array[i].getName().startsWith("fullSearchAgencyFlow")){
                        array[i].delete();
                    }
                }else if(showStatusTemp.equals("11")){
                    if(array[i].getName().startsWith("fullSearchUpperLower")){
                        array[i].delete();
                    }
                }else if(showStatusTemp.equals("add")){
                	if(array[i].getName().startsWith("default_cast_"+showStatusTemp+"_")){
                        array[i].delete();
                    }
                }else {
                	if(array[i].getName().startsWith("default_cast_"+showStatusTemp+"_")){
                        array[i].delete();
                    }
                }
    		}
    		
            rs.executeSql("select isaesencrypt,aescode,filerealpath,iszip,imagefilename from imagefile where imagefileid="+imageIdFromSelect);
            rs.next();
            String filerealpath=Util.null2String(rs.getString("filerealpath"));  
            String iszip=Util.null2String(rs.getString("iszip"));
            String isaesencrypt = Util.null2String(rs.getString("isaesencrypt"));
            String aescode = Util.null2String(rs.getString("aescode"));
            String imageFileName = Util.null2String(rs.getString("imagefilename"));
            String suffix = imageFileName.split("\\.")[1];
            
            if(showStatusTemp.equals("1")){
                iconName="fullSearchPhone"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+"."+suffix;
            }else if(showStatus.equals("2")){
                iconName="fullSearchShortMessage"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+"."+suffix;
            }else if(showStatusTemp.equals("3")){
                iconName="fullSearchInsideInfomation"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+"."+suffix;
            }else if(showStatusTemp.equals("4")){
                iconName="fullSearchFlow"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+"."+suffix;
            }else if(showStatusTemp.equals("5")){
                iconName="fullSearchRemind"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+"."+suffix;
            }else if(showStatusTemp.equals("6")){
                iconName="fullSearChcheckingIn"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+"."+suffix;
            }else if(showStatusTemp.equals("7")){
                iconName="fullSearchCheckInReport"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+"."+suffix;
            }else if(showStatusTemp.equals("8")){
                iconName="fullSearchHoliday"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+"."+suffix;
            }else if(showStatusTemp.equals("9")){
                iconName="fullSearchNavigation"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+"."+suffix;
            }else if(showStatusTemp.equals("10")){
                iconName="fullSearchAgencyFlow"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+"."+suffix;
            }else if(showStatusTemp.equals("11")){
                iconName="fullSearchUpperLower"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+"."+suffix;
            }else if(showStatusTemp.equals("add")){
            	iconName="default_cast_"+showStatus+"_"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+"."+suffix;
            }else{
                iconName = "default_cast_"+showStatus+"_"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+"."+suffix;
            }
            String targetUrl = uploadPath+ File.separatorChar +iconName;
            
            
            InputStream imagefile = null;
            File thefile = new File(filerealpath);
            if (iszip.equals("1")) {
                ZipInputStream zin = new ZipInputStream(new FileInputStream(thefile));
                if (zin.getNextEntry() != null) imagefile = new BufferedInputStream(zin);
              } else {
                imagefile = new BufferedInputStream(new FileInputStream(thefile));
              }
              if(isaesencrypt.equals("1")){
                  imagefile = AESCoder.decrypt(imagefile,aescode);
              }
            BufferedOutputStream out2 = new BufferedOutputStream(
                    new FileOutputStream(targetUrl));
            
            byte[] b = new byte[1024];
            int l = -1;
            while ((l = imagefile.read(b)) != -1) {// 读取
            	out2.write(b, 0, l);// 
            }
            out2.flush();
            imagefile.close();
            out2.close();
    	}
    	//删除固定指令详细列表
    	ArrayList delFieldIdArr = Util.TokenizerString(delFieldIds,",");
    	for(int i=0; i<delFieldIdArr.size() ; i++){
    		if(!"create".equals(delFieldIdArr.get(i))){
    			rs.execute("delete FullSearch_FixedInstShow where  id="+delFieldIdArr.get(i)+"");	
    		}
        }
    	//更新固定指令详细的排序
    	String orderArr[] = fieldOrder.split(",");
    	String idArr[] = fieldid.split(",");
    	String descArr[] = desc.split(",");
    	for(int i=0; i<idArr.length ; i++){
    			if(!idArr[i].equals("")){
    				if("create".equals(idArr[i]) && !"".equals(descArr[i])){
        				rs.execute("insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values("+showStatus+",'"+descArr[i]+"',"+orderArr[i]+")");
        			}else if(!"create".equals(idArr[i]) && !"".equals(descArr[i])){
        				rs.execute("update FullSearch_FixedInstShow set dsporder="+orderArr[i]+",showValue = '"+descArr[i]+"' where id="+idArr[i]+"");	
        			}else if(!"create".equals(idArr[i]) && "".equals(descArr[i])){
        				rs.execute("delete FullSearch_FixedInstShow where  id="+idArr[i]+"");
        			}
    			}
        }
    	//更新固定指令列表的详细
    	String updInstDetailSql = "";
    	name = Util.convertInput2DB(name);
        if(!iconName.equals("")){
            updInstDetailSql = "update FullSearch_FixedInst set instructionName = '"+name+"',showorder = '"+order+"',instructionImgSrc = '/fullsearch/img/"+iconName+"',showExample='"+firstDesc+"' where id = "+showStatus+"";         
        }else{
            updInstDetailSql = "update FullSearch_FixedInst set instructionName = '"+name+"',showorder = '"+order+"',showExample='"+firstDesc+"' where id = "+showStatus+"";
        }
    	if(rs.executeSql(updInstDetailSql)){
    		instructionShow =showStatus;
    	};
    	out.print(instructionShow);
    }else if(method.equals("reShow")){
    	String reShowSql = "select * from FullSearch_FixedInst where id = "+showStatus+"";
    	rs.executeSql(reShowSql);
    	rs.next();
    	instructionShow += rs.getInt("id") +",";
    	instructionShow += rs.getInt("instructionName") +",";
    	instructionShow += rs.getInt("instructionImgSrc") +",";
    	instructionShow += rs.getInt("showorder") +",";
    	instructionShow += "show";
    	out.print(instructionShow);
    }else if(method.equals("delete")){
    	String reShowSql = "select * from FullSearch_FixedInst where id = "+showStatus+"";
    	rs.executeSql(reShowSql);
    	rs.next();
    	if(rs.getInt("isCast") == 1){
    		rs1.execute("delete from FullSearch_FixedInstShow where instructionId = "+showStatus);
    		rs1.execute("delete from FullSearch_FixedInst where id = "+showStatus);
    		instructionShow = "success";
    	}
    	out.clearBuffer();
    	out.print(instructionShow);
    }
    




%>