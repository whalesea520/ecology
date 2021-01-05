
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	String wfid=Util.null2String(request.getParameter("wfid"));
	String formid = Util.null2String(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
%>


<script type="text/javascript">
var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;

String.prototype.length2 = function() {
    var cArr = this.match(/[^\x00-\xff]/ig);
    return this.length + (cArr == null ? 0 : cArr.length);
}
function setSelIndex(selindex, selectvalue) {
    //alert("selindex:"+selindex+"   selectvalue:"+selectvalue);
    document.addopform.selectindex.value = selindex ;
    document.addopform.selectvalue.value = selectvalue ;
    if($GetEle("tmptype_42").checked){
        var signorderval= $("input[name='signorder']:checked").val();
        if(signorderval==3 || signorderval==4){
           $GetEle("Tab_Coadjutant").style.display='none';
        }else{
           $GetEle("Tab_Coadjutant").style.display='';
        }
    }else {
    $GetEle("Tab_Coadjutant").style.display='none';
    }
}

function changelevel(tmpindex) {
    tmpindex.checked = true;
    changeRadioStatus(tmpindex, true);
    tmpid = tmpindex.id;
    //document.addopform.selectindex.value = Mid(tmpid, 9, len(tmpid));
    document.addopform.selectindex.value = tmpid.substring(8);// Mid(tmpid, 9, len(tmpid));
    document.addopform.selectvalue.value = tmpindex.value;
    if($GetEle("tmptype_42").checked){
        var signorderval= $("input[name='signorder']:checked").val();
        if(signorderval==3 || signorderval==4){
           $GetEle("Tab_Coadjutant").style.display='none';
        }else{
           $GetEle("Tab_Coadjutant").style.display='';
        }
    }else {
    $GetEle("Tab_Coadjutant").style.display='none';
    }
    //alert("selindex:"+Mid(tmpid,9,len(tmpid)))+"   selectvalue:"+tmpindex.value;
}

function onShowBrowser4opM1(url,index,tmpindex){
	var tempid = "id_"+index;
	var url1 = url+"?selectedids="+document.all(tempid).value;
	onShowBrowser4opM(url1,index,tmpindex);
}

function onShowBrowser4opM(url,index,tmpindex){
	tmpid = "id_"+index;
	tmpname = "id_"+index+"span";
	datas = window.showModalDialog(url + "?resourceids=," + $G(tmpid).value, "","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
        if (datas.id!= ""){
			$("#"+tmpname).html("<a href='#"+datas.id.substr(1)+"'>"+datas.name.substr(1))+"</a>";			
			$("input[name="+tmpid+"]").val(datas.id.substr(1));
			tmpindex.checked = true
	        tmpid = $(tmpindex).attr("id");
	        document.addopform.selectindex.value = tmpid.substr(8);
	        document.addopform.selectvalue.value = tmpindex.value;
		}else{
			$("#"+tmpname).html("");
			$("input[name="+tmpid+"]").val("");
		}
	}
}

function callbackMeth(event,data,name,paras){
	var obj;
	if(name=="id_0"){
		obj = $("#tmptype_0");
	}else if(name=="id_1"){
		obj = $("#tmptype_1");
	}else if(name=="id_2"){
		obj = $("#tmptype_2");
	}else if(name=="id_3"){
		obj = $("#tmptype_3");
	}else if(name=="level_50"){
		obj = $("#tmptype_50");
	}else if(name=="id_28"){
		obj = $("#tmptype_28");
	}else if(name=="id_29"){
		obj = $("#tmptype_29");
	}
	
	if(obj){
		obj.attr("checked",true);
		//alert(tmpid);
		changeRadioStatus(obj,true);
		document.addopform.selectindex.value = obj.attr("id").substr(8);
	    document.addopform.selectvalue.value = obj.val();
	}
}

function onShowBrowser4op(url,index,tmpindex){
	tmpid = "id_"+index;
	tmpname = "id_"+index+"span";
	url=url+"?selectedids=" + $G(tmpid).value;
	datas = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
        if (datas.id!= ""){
			$("#"+tmpname).html("<a href='#"+datas.id.substr(0)+"'>"+datas.name.substr(0)+"</a>");
			$("input[name="+tmpid+"]").val(datas.id.substr(0));
			tmpindex.checked = true;
	        tmpid = $(tmpindex).attr("id");
	        document.addopform.selectindex.value = tmpid.substr(8);
	        document.addopform.selectvalue.value = tmpindex.value;
		}else{
			$("#"+tmpname).html("");
			$("input[name="+tmpid+"]").val("");
		}
	}
}

function onShowBrowserLevel(url,index,tmpindex){
	tmpid = "level_"+index;
	tmpname = "level_"+index+"span";
	datas = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
	    if (datas.id!= ""){
			$("#"+tmpname).html("<a href='#"+datas.id+"'>"+datas.name+"</a>");
			$("input[name="+tmpid+"]").val(datas.id);
			tmpindex.checked = true
	        tmpid = $(tmpindex).attr("id");
	        document.addopform.selectindex.value = index;
	        document.addopform.selectvalue.value = tmpindex.value;
		}else{
			$("#"+tmpname).html("");
			$("input[name="+tmpid+"]").val("");
		}
	}
}

function onShowBrowser4opLevel(url,index,tmpindex){
	tmpid = "level_"+index;
	tmpname = "level_"+index+"span";
	datas = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
	    if (datas.id!= ""){
			$("#"+tmpname).html("<a href='#"+datas.id+"'>"+datas.name+"</a>");
			$("input[name="+tmpid+"]").val(datas.id);
			tmpindex.checked = true
	        tmpid = $(tmpindex).attr("id");
	        document.addopform.selectindex.value = index;
	        document.addopform.selectvalue.value = tmpindex.value;
		}else{
			$("#"+tmpname).html("");
			$("input[name="+tmpid+"]").val("");
		}
	}
}

function addRow4op(){
    var rowindex4op = 0;
    var rows=document.getElementsByName('check_node');
    var len = document.addopform.elements.length;
    var rowsum1 = 0;
    var obj;
    for(i=0; i < len;i++) {
		if (document.addopform.elements[i].name=='check_node'){
			rowsum1 += 1;
            obj=document.addopform.elements[i];
            }
    }

    if(rowsum1>0) {
    	rowindex4op=parseInt(obj.getAttribute("rowIndex"))+1;
    }

    for(i=0;i<100;i++){
    	var belongtype ="0";
        if(document.addopform.selectindex.value == i){
			switch (i) {
            case 0:
			case 1:
            case 2:
			case 7:
			case 8:
			case 9:
			case 11:
			case 12:
			case 14:
			case 15:
			case 16:
			case 18:
			case 19:
			case 27:
			case 28:
			case 29:
			case 30:
            case 38:
            case 45:
            case 46:
			case 50:
				
				//如果安全级别最大值不为空且最小值为空, 则最小值默认为0 。
				if($G("level_"+i).value ==''  &&  $G("level2_"+i).value != '')     $G("level_"+i).value = '0';
				if($GetEle("id_"+i).value ==0 || $GetEle("level_"+i).value =="" || ($GetEle("level_"+i).value =="0"&&i==50)){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 3:
			case 5:
			case 49:
			case 6:
			case 10:
			case 13:
			case 17:
			case 20:
			case 21:
			case 31:
			case 40:
			case 41:
			case 42:
			case 43:
			case 44:
			case 47:
			case 48:
			case 51:
			
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;

			case 52:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 53:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 54:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 55:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 4:   //所有人
            case 24:  //创建人下属
			case 25:  //创建人本分部
			case 26:  //创建人本部门 
			case 39:  //创建人上级部门
			case 32:  //创建客户

				//如果安全级别最大值不为空且最小值为空, 则最小值默认为0 。
				if($G("level_"+i).value ==''  &&  $G("level2_"+i).value != '')    $G("level_"+i).value = '0';
				if($G("level_"+i).value ==''){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 99:
				if (!checkMatrix()) {
					Dialog.alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			}
            var hrmids,hrmnames; 
			var k=1;
			var subcompanyids,subcompanynames; 
			var belongtypeStr = "";
			var singerorder_flag = 0;
			try{
				singerorder_flag = parseInt(document.getElementById("singerorder_flag").value);
			}catch(e){
				singerorder_flag = 0;
			}
			var singerorder_type = document.getElementById("singerorder_type").value;
      if (i==0){//多分部
			var stmps = $G("id_"+i).value;
			var sHtmls = "";
			if($("#id_"+i+"span").children().length>0){
				$("#id_"+i+"span").find("a").each(function(index){
					if(index==0){
						sHtmls =$(this).html();
					}else{
						sHtmls +=","+$(this).html();
					}					
				});	
			}else{
				sHtmls = $G("id_"+i+"span").innerHTML;
			}
			
			if($G("signorder_"+i)) belongtype = $G("signorder_"+i).value;
			if(stmps.indexOf(",") >= 0)
			{
				stmps = stmps.substr(1,stmps.length);
				sHtmls = sHtmls.substr(1,sHtmls.length);
			}
			if(belongtype=="1"){
                subcompanyids=stmps.split(",");
                subcompanynames=sHtmls.split(",");
                k=subcompanyids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%>)";
			}else if(belongtype=="2"){
                if(singerorder_flag>0 && singerorder_type!="30"){
                    alert("<%=SystemEnv.getHtmlLabelName(24767,user.getLanguage())%>");
                    return;
                }
                subcompanyids=stmps.split(",");
                subcompanynames=sHtmls.split(",");
                k=subcompanyids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%>)";
                document.getElementById("singerorder_flag").value = ""+k;
                document.getElementById("singerorder_type").value = "30";
			}else{
                subcompanyids=stmps.split(",");
                subcompanynames=sHtmls.split(",");
                k=subcompanyids.length;
            }
			}
			var departmentids,departmentnames; 
      if (i==1){//多部门
			var stmps = $G("id_"+i).value;
			var sHtmls = "";
			if($("#id_"+i+"span").children().length>0){
				$("#id_"+i+"span").find("a").each(function(index){
					if(index==0){
						sHtmls =$(this).html();
					}else{
						sHtmls +=","+$(this).html();
					}					
				});	
			}else{
				sHtmls = $G("id_"+i+"span").innerHTML;
			}
			if($G("signorder_"+i)) belongtype = $G("signorder_"+i).value;
			if(stmps.indexOf(",") >= 0)
			{
				stmps = stmps.substr(1,stmps.length);
				sHtmls = sHtmls.substr(1,sHtmls.length);
			}
			if(belongtype=="1"){
                departmentids=stmps.split(",");
                departmentnames=sHtmls.split(",");
                k=departmentids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%>)";
			}else if(belongtype=="2"){
                if(singerorder_flag>0 && singerorder_type!="1"){
                    alert("<%=SystemEnv.getHtmlLabelName(24767,user.getLanguage())%>");
                    return;
                }
                departmentids=stmps.split(",");
                departmentnames=sHtmls.split(",");
                k=departmentids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%>)";
                document.getElementById("singerorder_flag").value = ""+k;
                document.getElementById("singerorder_type").value = "1";
			}else{
                departmentids=stmps.split(",");
                departmentnames=sHtmls.split(",");
                k=departmentids.length;
            }
			}
		if(i==2){//角色
			if($G("signorder_"+i)) belongtype = $G("signorder_"+i).value;
			if(belongtype=="1"){
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>)";
			}else if(belongtype=="2"){
                if(singerorder_flag > 0){
                    alert("<%=SystemEnv.getHtmlLabelName(24767,user.getLanguage())%>");
                    return;
                }
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%>)";
                document.getElementById("singerorder_flag").value = "1";
                document.getElementById("singerorder_type").value = "2";
			}
		}
            if (i==3)  //多人力资源
			{
			var stmps = $G("id_"+i).value;
			hrmids=stmps.split(",");
			var sHtmls = "";
			if($("#id_"+i+"span").children().length>0){
				$("#id_"+i+"span").find("a").each(function(index){
					if(index==0){
						sHtmls =$(this).html();
					}else{
						sHtmls +=","+$(this).html();
					}					
				});	
			}else{
				sHtmls = $G("id_"+i+"span").innerHTML;
			}
			hrmnames=sHtmls.split(",");
			k=hrmids.length;
			}
			for (m=0;m<k;m++)
			{ rowColor = getRowBg();
//			ncol = oTable4op.cols;
			ncol = oTable4op.rows[0].cells.length
			oRow = oTable4op.insertRow(-1);
			oRow.className="DataLight";
			for(j=0; j<ncol; j++) {
				oCell = oRow.insertCell(-1);
				oCell.style.height=24;
				oCell.style.background= "#fff";
				switch(j) {
					case 0:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' name='check_node' value='0' rowindex="+rowindex4op+" belongtype="+belongtype+">";
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
					case 1:
						var oDiv = document.createElement("div");
						var sHtml="";

						if(i==0)
							sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>"+belongtypeStr;
						if(i== 1 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>"+belongtypeStr;
						if(i== 2 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>"+belongtypeStr;
						if(i== 3 )
							sHtml="<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>";
						if(i== 4 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>";
						if(i== 5 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%>";
						if(i== 6 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%>";
						if(i== 7 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%>";
						if(i== 8 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%>";
						if(i== 9 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%>";
						if(i== 10 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%>";
						if(i== 11 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%>";
						if(i== 12 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%>";
						if(i== 13 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%>";
						if(i== 14 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%>";
						if(i== 15 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%>";
						if(i== 16 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%>";
						if(i== 17 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%>";
						if(i== 18 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%>";
						if(i== 19 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%>";
						if(i== 20 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%>";
						if(i== 21 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%>";
						if(i== 22 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%>";
						if(i== 23 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%>";
						if(i== 24 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%>";
						if(i== 25 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%>";
						if(i== 26 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%>";
						if(i== 27 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%>";
						if(i== 28 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%>";
						if(i== 29 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%>";
						if(i== 30 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%>";
						if(i== 31 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%>";
						if(i== 32 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%>";
						if(i== 38 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%>";
                        if(i== 39 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())%>";
                        if(i== 40 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%>";
                        if(i== 41 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%>";
                        if(i== 42 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
                        if(i== 43 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>";
                        if(i== 44 )
							sHtml="<%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%>";
                        if(i== 45 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18678,user.getLanguage())%>";
                        if(i== 46 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18679,user.getLanguage())%>";
                        if(i== 47 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18680,user.getLanguage())%>";
                        if(i== 48 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18681,user.getLanguage())%>";
                        if(i== 49 )
							sHtml="<%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%>";
						if(i== 50 )
							sHtml="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>";
						if(i== 51 )
							sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
						if(i== 52 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27107,user.getLanguage())%>";
						if(i== 53 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27108,user.getLanguage())%>";
						if(i== 54 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27109,user.getLanguage())%>";
						if(i== 55 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27110,user.getLanguage())%>";
						if(i== 99 )
							sHtml="<%=SystemEnv.getHtmlLabelName(84494, user.getLanguage())%>";
                        oDiv.innerHTML = sHtml;

						jQuery(oCell).append(oDiv);

                        var rowtypevalue = document.addopform.selectvalue.value ;
						
						var oDiv1 = document.createElement("div");
						var sHtml1 = "<input type='hidden' name='group_"+rowindex4op+"_type'  value='"+rowtypevalue+"'>";
						oDiv1.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv1);
						break;
				case 2:
					{
						var stmp="";
					if(i==0){
					  	stmp=""+subcompanyids[m];
					  }else if(i==1){
					  	stmp=""+departmentids[m];
					  } else if(i == 99) {
					  	stmp = getMatrixValue();
					  } else{ 
						if (i==3)
					    {
						stmp=""+hrmids[m];
						}
					    else
					    {
						 stmp = $G("id_"+i).value;
					    }
            		}
						var oDiv = document.createElement("div");
						var sHtml = "";
						if((i>= 5 && i <= 21) || i == 27 || i == 31 || i == 30 || i==38  || i== 40 || i == 41|| i == 42|| i == 43|| i == 44|| i == 45|| i == 46|| i == 47|| i == 48|| i == 49|| i == 50|| i == 51|| i == 52 || i == 53 || i == 54 || i == 55){
							var srcList = $G("id_"+i);
							for (var count = srcList.options.length - 1; count >= 0; count--) {
								if(srcList.options[count].value==stmp)
									sHtml = srcList.options[count].text;
							}
						} else if (i == 99) {
							sHtml = getMatrixDisplayName();
						} else if(i== 4 || i== 22 || i== 23 || i==24 || i== 25 || i== 26  || i== 32 || i == 39){
							sHtml = stmp;
						}
						else
					      {
						    if(i==0){ sHtml=subcompanynames[m];}
						    else if(i==1){ sHtml=departmentnames[m];}
					    else{
							if (i==3)
							sHtml=hrmnames[m];
							else
								if(i==2){
									if($("#id_"+i+"span").children().length>0){
										$("#id_"+i+"span").find("a").each(function(index){			
											if(index==0){
												sHtml =$(this).html();
											}else{
												sHtml +=","+$(this).html();
											}				
										});	
									}else{
										sHtml = $G("id_"+i+"span").innerHTML;
									}
								}else{
									sHtml = $G("name_"+i).innerHTML;
								}								
							}
						  }
						  if (i==50)  sHtml =sHtml+"/"+jQuery('#level_50span span a').text();
						oDiv.innerHTML = sHtml;

						jQuery(oCell).append(oDiv);

						var oDiv2= document.createElement("div");
                       
						var stemp=stmp;
						
                        var sHtml1;
                        if(i==0 || i==1){
                        	sHtml1="<input type='hidden'  name='group_"+rowindex4op+"_subcompanyids' value='"+stemp+"'>";
                        	sHtml1 += "<input type='hidden'  name='group_"+rowindex4op+"_id' value='"+stemp+"'>";
                        }else{
							sHtml1="<input type='hidden'  name='group_"+rowindex4op+"_id' value='"+stemp+"'>";
                        }
						oDiv2.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv2);
						break;
					}
					case 3:
						var oDiv = document.createElement("div");
						var sval = "";
						var sval2 = "";
						var sHtml="";
					
						if(i == 0 || i == 1 || i == 4 || i == 7 || i == 8 || i == 9 || i == 11 || i == 12 || i== 14 || i == 15 || i == 16 || i == 18 || i == 19 || i == 24 || i == 25 || i == 26 || i == 27 || i == 28 || i == 29 || i == 30 || i == 32 || i == 38 || i == 39 || i == 45 || i == 46){
                            sval = $G("level_"+i).value;
                            sval2 = $G("level2_"+i).value;
							
                            if(sval2!=""){
							    sHtml = sval+" - " + sval2;
                            }else{
                                sHtml = ">= "+sval;
                            }

						}
						
						if (i==42){
						   var tmpval = $GetEle("id_42_dept").value;
	                       if(tmpval=='0'){
                            sval = $G("level_"+i).value;
                            sval2 = $G("level2_"+i).value;
							
                            if(sval2!=""){
							    sHtml = sval+" - " + sval2;
                            }else{
                                sHtml = ">= "+sval;
                            }
	   
	                       }else{
	                          var obj=document.getElementById('id_42_dept'); 
                              var text=obj.options[obj.selectedIndex].text;//获取文本
                              sHtml=text;
	                       }
						}
						
						if (i==51){
						   var tmpval = $GetEle("id_51_sub").value;
	                       if(tmpval=='0'){
                            sval = $G("level_"+i).value;
                            sval2 = $G("level2_"+i).value;
							
                            if(sval2!=""){
							    sHtml = sval+" - " + sval2;
                            }else{
                                sHtml = ">= "+sval;
                            }
	   
	                       }else{
	                          var obj=document.getElementById('id_51_sub'); 
                              var text=obj.options[obj.selectedIndex].text;//获取文本
                              sHtml=text;
	                       }
						}

						if (i==50){

                            sval = $G("level_"+i).value;
							sval2 = $G("level2_"+i).value;
							if(sval2=="1"){
								sHtml = "<%=SystemEnv.getHtmlLabelName(22689,user.getLanguage())%>";
							}else if(sval2=="2"){
								sHtml = "<%=SystemEnv.getHtmlLabelName(22690,user.getLanguage())%>";
							}else if(sval2=="3"){
								sHtml = "<%=SystemEnv.getHtmlLabelName(22667,user.getLanguage())%>";
							}else{
								sHtml = "<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
							}
						}
						if(i == 2 ){
							sval = $G("level_"+i).value;
							if(sval==0)
								sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
							if(sval==1)
								sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
							if(sval==2)
								sHtml="<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
							if(sval==3)
								sHtml="<%=SystemEnv.getHtmlLabelName(22753,user.getLanguage())%>";
						}
					
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);

						var oDiv3= document.createElement("div");
                        var sHtml1 = "<input type='hidden' size='32' name='group_"+rowindex4op+"_level'  value='"+sval+"'>";
                        
                        if(sval2!=""){
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_level2'  value='"+sval2+"'>";
                        }else{
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_level2'  value='-1'>";
                        }
                        
                       if (i==42){
						   var tmpval = $GetEle("id_42_dept").value;
	                       if(tmpval!='0'){
	                          sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_deptField'  value='"+tmpval+"'>";
	                       }else{
	                          sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_deptField'  value=''>";
	                       }
	                   }
                        
                       if (i==51){
						   var tmpval = $GetEle("id_51_sub").value;
	                       if(tmpval!='0'){
	                          sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_subcompanyField'  value='"+tmpval+"'>";
	                       }else{
	                          sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_subcompanyField'  value=''>";
	                       }
	                   }                        
                        
						
						oDiv3.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv3);
						break;

					case 4:
						var oDiv = document.createElement("div");
						var sval = "";
						var sHtml="";
					
						if((document.getElementById("signordertr")&&document.getElementById("signordertr").style.display!="none"
							&&(i == 99 || i == 5||i == 6||i == 7||i == 8||i == 9||i == 38||i == 42||i == 52||i == 53||i == 54||i == 55||i == 51||i == 43
							||i == 49||i == 50||i == 22||i == 23||i == 24||i == 25||i == 26||i == 39||i == 40||i == 41|| i==48))
							||i == 31||((i == 2||i == 3)&&document.all("signorder_"+i))){
							if(i==31||i==2||i==3)
							{
								sval = document.all("signorder_"+i);
							}
							else
							{
								sval = document.all("signorder");
							}
							if(sval)
							{
								if(sval[0]&&sval[0].checked){
	                                sHtml="<%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>";
									sval = "0";
	                            }else if(sval[1]&&sval[1].checked){
									sHtml="<%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>";
									sval = "1";
								}else if(sval[2]&&sval[2].checked){
									sHtml="<%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>";
									sval = "2";
								}else if(sval[3]&&sval[3].checked){
									sHtml="<%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>";
									sval = "3";
								}else if(sval[4]&&sval[4].checked){
									sHtml="<%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>";
									sval = "4";
								}
							}
						}
						if(i==0 || i==1 || i==2){
							sval = $G("signorder_"+i).value;
						}
                        sHtml += "<input type='hidden' size='32' name='group_"+rowindex4op+"_signorder'  value='"+sval+"'>";

						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
					case 5:
						var oDiv = document.createElement("div");
						var sval = $G("conditionss").value;
						var sval1 = $G("conditioncn").value;
						var sval3 = $G("rulemaplistids").value;
                        var sval2 = $G("Coadjutantconditions").value;
						/*var temp = document.all("signorder_5");
						if(document.all("tmptype_5").checked&&(temp[3].checked||temp[4].checked)){
							sval="";
							sval1="";
						}*/
                        if(!$G("tmptype_42").checked){
                            sval2="";
                        }
						while (sval.indexOf("'")>0)
						{
							sval=sval.replace("'","&#39");
						}
						while (sval1.indexOf("'")>0)
						{
							sval1=sval1.replace("'","&#39");
						}						
						if($G("Tab_Coadjutant") && $G("Tab_Coadjutant").style.display=="none"){
							sval2="";
							$G("IsCoadjutant").value="";
							$G("issyscoadjutant").value="";
							$G("signtype").value="";
							$G("coadjutants").value="";
							$G("issubmitdesc").value="";
							$G("ispending").value="";
							$G("isforward").value="";
							$G("ismodify").value="";
						}
						var hashead=0;
						var sHtml="<input type='hidden' name='group_"+rowindex4op+"_condition' value='"+sval+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex4op+"_conditioncn' value='"+sval1+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex4op+"_rulemaplistids' value='"+sval3+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex4op+"_Coadjutantconditions' value='"+sval2+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_IsCoadjutant' value='"+$G("IsCoadjutant").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_signtype' value='"+$G("signtype").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_issyscoadjutant' value='"+$G("issyscoadjutant").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_coadjutants' value='"+$G("coadjutants").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_issubmitdesc' value='"+$G("issubmitdesc").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_ispending' value='"+$G("ispending").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_isforward' value='"+$G("isforward").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_ismodify' value='"+$G("ismodify").value+"'>";
                        if(sval1!=""){
						    sHtml+="<%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>:"+sval1;
                            hashead=1;
                        }
                        if(sval2!=""){
                            if(hashead==1) sHtml+="<br>";
                            sHtml+="<%=SystemEnv.getHtmlLabelName(22675,user.getLanguage())%>:"+sval2;
                        }
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
						case 6:
							var sval = "";
							if(($G("signordertr")&&$G("signordertr").style.display!="none"
								&&(i == 5||i == 6||i == 7||i == 8||i == 9||i == 38||i == 42||i == 52||i == 53||i == 54||i == 55||i == 51||i == 43
								||i == 49||i == 50||i == 22||i == 23||i == 24||i == 25||i == 26||i == 39||i == 40||i == 41))
								||i == 31||((i == 2||i == 3)&&$G("signorder_"+i))){
								if(i==31||i==2||i==3)
								{
									sval = document.all("signorder_"+i);
								}
								else
								{
									sval = document.all("signorder");
								}
								if(sval)
								{
									
									if(sval[0]&&sval[0].checked){ 
										sval = "0";
		                            }else if(sval[1]&&sval[1].checked){ 
										sval = "1";
									}else if(sval[2]&&sval[2].checked){ 
										sval = "2";
									}else if(sval[3]&&sval[3].checked){ 
										sval = "3";
									}else if(sval[4]&&sval[4].checked){ 
										sval = "4";
									} 
								}
							} 
							
						var oDiv = document.createElement("div");

						//var sval1 = document.getElementById("orders").value;
						var sval1 = $G("orders").value;

						var temp = document.all("signorder");
						var f_check = true;
						if(temp)
						{
							if(document.getElementById("signordertr")&&document.getElementById("signordertr").style.display!="none"&&(temp[3].checked||temp[4].checked)){
								sval1="";
								f_check = false;
							}
						}
						if (sval1==null || sval1 == ''){
							sval1=0;
						}
						//alert(sval1);
						var sHtml="<input type='hidden' name='group_"+rowindex4op+"_orderold' value='"+sval1+"'>";
						var nodetype_operatorgroup = $GetEle("nodetype_operatorgroup").value;
						//如果是会签抄送不显示批次
						if(sval=='3'||sval=='4'){
							sHtml += '';
						} 
						else{
							if(nodetype_operatorgroup == 1 || nodetype_operatorgroup == 2 || nodetype_operatorgroup == 3){
								sHtml+="<input type='text' class='Inputstyle' name='group_"+rowindex4op+"_order' value='"+sval1+"' onchange=\"check_number('group_"+rowindex4op+"_order');checkDigit(this,5,2)\"  maxlength=\"5\" style=\"width:80%\">";
							}else{
								sHtml += sval1;
							}
						}
						if(f_check == false){
							sHtml = "";
						}
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
				}
			}
			rowindex4op = rowindex4op*1 +1;
			}
			$G("fromsrc").value="1";
			$G("conditionss").value="";
			$G("conditioncn").value="";
			$G("conditions").innerHTML="";
			$G("IsCoadjutant").value="";
			$G("signtype").value="";
			$G("issyscoadjutant").value="";
			$G("coadjutants").value="";
			$G("issubmitdesc").value="";
			$G("ispending").value="";
			$G("isforward").value="";
			$G("ismodify").value="";
            $G("Coadjutantconditions").value="";
			$G("Coadjutantconditionspan").innerHTML="";
			//for(itmp = 0;itmp < 32;itmp++)
				//document.form1.tmptype(itmp).checked = false;
			jQuery("body").jNice();	
			return;
		}
	}
	alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");

}

function nodeopaddsave(obj){
    var sss=document.addopform.groupname.value;
    if(sss.length2()>60){
    alert("<%=SystemEnv.getHtmlLabelName(18686, user.getLanguage())%>");
    }else{
	    if (check_form(addopform, 'groupname')) {
	        var rowindex4op = 0;
	        var len = document.addopform.elements.length;
	        var rowsum1 = 0;
	        var obj_tmp;
	        for (i = 0; i < len; i++) {
	            if (document.addopform.elements[i].name == 'check_node') {
	                rowsum1 += 1;
	                obj_tmp = document.addopform.elements[i];
	            }
	        }
	
	        if (rowsum1 > 0) {
	            rowindex4op = parseInt(obj_tmp.getAttribute("rowIndex")) + 1;
	        }
	
	        addopform.groupnum.value = rowindex4op;
			
	        obj.disabled = true;
	        addopform.submit();
	    }
   	}
}

function deleteRow4op()
{
	var flag = false;
	var ids = document.getElementsByName('check_node');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}

	}
    if(flag) {
    	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
    	top.Dialog.confirm(str, function () {
			len = document.addopform.elements.length;
			var i=0;
			var rows = jQuery('#oTable4op tr');
			var rowsum1 = rows.length;//包含横线行
			for(i=len-1; i >= 0;i--) {
				if (document.addopform.elements[i].name=='check_node') {
					rowsum1 -= 1;
					if (jQuery(rows[rowsum1]).is('.Spacing')) {
						rowsum1 -= 1;//如果是横线行继续递减
	                }
					if(document.addopform.elements[i].checked==true) {
		                if(document.addopform.elements[i].belongtype=="2"){
		        			var singerorder_flag = 0;
		        			try{
		        				singerorder_flag = parseInt($G("singerorder_flag").value);
		        			}catch(e){
		        				singerorder_flag = 0;
		        			}
		        			if(singerorder_flag > 0){
		        				singerorder_flag = singerorder_flag - 1;
		        			}
		                    $GetEle("singerorder_flag").value = ""+singerorder_flag;
		                    if(singerorder_flag == 0){
		                    	$G("singerorder_type").value = "";
		                    }
		                }
		                if ((rowsum1 + 1) < rows.length && jQuery(rows[rowsum1 + 1]).is('.Spacing')) {
							oTable4op.deleteRow(rowsum1 + 1);//横线单独占一行，随行删除
		                }
						oTable4op.deleteRow(rowsum1);
					}
				}
			}
    	}, function () {}, 320, 90,true);
    }else{
    	top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}

function cancelEditNode(){
	window.location = "/workflow/workflow/Editwfnode.jsp?ajax=1&wfid=<%=wfid%>";
}

function nodeopdelete(obj){
	if (isdel()) {
    obj.disabled=true;
    addopform.src.value="delgroups";
    addopform.submit() ;
  }
}

function onChangetype(objval) {

	if ( objval==1 ) {
		$G("odiv_1").style.display="";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
        $G("odiv_10").style.display="none";
	    //$G("signordertrline").style.display="none";
		$G("signordertr").style.display="none";
}
if ( objval==2 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
        $G("odiv_10").style.display="none";
	    //$G("signordertrline").style.display="";
		$G("signordertr").style.display="";
}
if ( objval==3 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
        $G("odiv_10").style.display="none";
	    //$G("signordertrline").style.display="none";
		$G("signordertr").style.display="none";
		}
if ( objval==4 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
        $G("odiv_10").style.display="none";
	    //$G("signordertrline").style.display="none";
		$G("signordertr").style.display="none";
		}
if ( objval==5 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
        $G("odiv_10").style.display="none";
	    //$G("signordertrline").style.display="none";
		$G("signordertr").style.display="none";
		}
if ( objval==6 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
        $G("odiv_10").style.display="none";
	    //$G("signordertrline").style.display="none";
		$G("signordertr").style.display="none";
		}
if ( objval==7 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
        $G("odiv_10").style.display="none";
	   	//$G("signordertrline").style.display="";
		$G("signordertr").style.display="";
		}
if ( objval==8 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="";
        $G("odiv_9").style.display="none";
        $G("odiv_10").style.display="none";
	    //$G("signordertrline").style.display="none";
		$G("signordertr").style.display="none";
}
	if (objval == 9 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="";
        $G("odiv_10").style.display="none";
		//$G("signordertrline").style.display="";
		$G("signordertr").style.display="";
	}
	if (objval == 10 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
        $G("odiv_10").style.display="";
		$G("signordertr").style.display="";
		changeRadioStatus('#matrixTmpType', true);
		jQuery('#matrixTmpType').click();
	}
}

function onShowBrowsers(obj,rid,rnodeid,rformid,risbill,rwfid){
	var url = "/formmode/interfaces/showconditionContent.jsp?rulesrc=2&nodeid="+rnodeid+"&formid="+rformid+"&isbill="+risbill+"&linkid="+rnodeid+"&isnew=1&wfid="+rwfid;
	var rownum = 0;
	if(jQuery("#oTable4op").find("tr").length >0){
		rownum = jQuery("#oTable4op").find("tr").not("[class=Spacing]").eq(jQuery("#oTable4op").find("tr").not("[class=Spacing]").length-1).find("[name=check_node]").attr("rowindex");
		rownum = (parseInt(rownum)+1);

	}
	url+="&rownum="+rownum;
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(81951, user.getLanguage())%>";
	dialog.Width = 850;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function onShowCoadjutantBrowser() {
   
    var url = encode("/workflow/workflow/showCoadjutantOperate.jsp?iscoadjutant=" + $GetEle("IsCoadjutant").value + "+signtype=" + $GetEle("signtype").value + "+issyscoadjutant=" + $GetEle("issyscoadjutant").value + "+coadjutants=" + $GetEle("coadjutants").value + "+coadjutantnames=" + $GetEle("coadjutantnames").value + "+issubmitdesc=" + $GetEle("issubmitdesc").value + "+ispending=" + $GetEle("ispending").value + "+isforward=" + $GetEle("isforward").value + "+ismodify=" + $GetEle("ismodify").value);
    var data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
    if (data) {
        if (wuiUtil.getJsonValueByIndex(data, 0) != "") {
            
            $GetEle("IsCoadjutant").value = wuiUtil.getJsonValueByIndex(data, 0);
            $GetEle("signtype").value = wuiUtil.getJsonValueByIndex(data, 1);
            $GetEle("issyscoadjutant").value = wuiUtil.getJsonValueByIndex(data, 2);
            $GetEle("coadjutants").value = wuiUtil.getJsonValueByIndex(data, 3);
            $GetEle("coadjutantnames").value = wuiUtil.getJsonValueByIndex(data, 4);
            $GetEle("issubmitdesc").value = wuiUtil.getJsonValueByIndex(data, 5);
            $GetEle("ispending").value = wuiUtil.getJsonValueByIndex(data, 6);
            $GetEle("isforward").value = wuiUtil.getJsonValueByIndex(data, 7);
            $GetEle("ismodify").value = wuiUtil.getJsonValueByIndex(data, 8);
            $GetEle("Coadjutantconditions").value = wuiUtil.getJsonValueByIndex(data, 9);
            $GetEle("Coadjutantconditionspan").innerHTML = wuiUtil.getJsonValueByIndex(data,9);
        } else {
            $GetEle("IsCoadjutant").value = "";
            $GetEle("signtype").value = "";
            $GetEle("issyscoadjutant").value = "";
            $GetEle("coadjutants").value = "";
            $GetEle("coadjutantnames").value = "";
            $GetEle("issubmitdesc").value = "";
            $GetEle("ispending").value = "";
            $GetEle("isforward").value = "";
            $GetEle("ismodify").value = "";
            $GetEle("Coadjutantconditions").value = "";
            $GetEle("Coadjutantconditionspan").innerHTML = "";
        }
    }
}

function checkAllChkBox(){
	len = document.addopform.elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.addopform.elements[i].name=='check_node' && jQuery("input[name=checkall]").attr("checked")==true){
			document.addopform.elements[i].checked=true;
			changeCheckboxStatus(document.addopform.elements[i],true);
		}else if(document.addopform.elements[i].name=='check_node' && jQuery("input[name=checkall]").attr("checked")==false){
			document.addopform.elements[i].checked=false;
			changeCheckboxStatus(document.addopform.elements[i],false);
		}
	}
}

function encode(str){
    return escape(str);
}

//matrix start
function selectAllMatrixRow(checked) {
	changeCheckboxStatus('#matrixTable tr.data td input:checkbox', checked);
}

function changeSelectAllMatrixRowStatus(checked) {
	changeCheckboxStatus('#matrixTable tr.header td input:checkbox', checked);
}

function checkMatrix() {
	var matrix = jQuery('#matrix').val();
	var vf = jQuery('#vf').val();
	if (matrix == '' || vf == '') {
		return false;
	}
	var ret = true;
	var matrixTableRows = jQuery('#matrixTable tr.data');
	matrixTableRows.each(function() {
		var cf = jQuery(this).find('input[name="cf"]').val();
		var wf = jQuery(this).find('input[name="wf"]').val();
		if (cf == '' || wf == '') {
			ret = false;
		}
	});
	return ret;
}

function getMatrixBrowserUrl(fieldtype) {
	var matrix = jQuery('#matrix').val();
	if (matrix) {
		return '/systeminfo/BrowserMain.jsp?url=/matrixmanage/pages/matrixfieldbrowser.jsp?matrixid=' + matrix + '&fieldtype=' + fieldtype;
	} else {
		Dialog.alert('<%=SystemEnv.getHtmlLabelName(129434, user.getLanguage())%>');
		return '';
	}
}

function addMatrixRow() {
	var lastRow = jQuery('<tr class="data"><td><input type="checkbox" /></td><td><div class="cf"><span></span></div></td><td><div class="wf"><span></span></div></td><td></td></tr>');
	var matrixTable = jQuery('#matrixTable');
	matrixTable.append(lastRow);
	lastRow.jNice();
	lastRow.find('div.cf span').e8Browser({
	   name: 'cf',
	   viewType:"0",
	   hasInput:true,
	   isSingle:true,
	   hasBrowser:true, 
	   isMustInput:2,
	   completeUrl:"javascript:getMatrixDataUrl(0);",
	   width:"130px",
	   getBrowserUrlFn: "getMatrixBrowserUrl",
	   getBrowserUrlFnParams: "0"
	});
	lastRow.find('div.wf span').e8Browser({
	   name: 'wf',
	   viewType:"0",
	   hasInput:false,
	   isSingle:true,
	   hasBrowser:true, 
	   isMustInput:2,
	   completeUrl:"/data.jsp",
	   width:"130px",
	   getBrowserUrlFn: "getFieldUrl"
	});
	changeSelectAllMatrixRowStatus(false);
}

function removeMatrixRow() {
	var removeRows = jQuery('#matrixTable tr.data input:checked').closest('tr.data');
	removeRows.remove();
	changeSelectAllMatrixRowStatus(false);
}

function getMatrixValue() {
	var matrixTableRows = jQuery('#matrixTable tr.data');
	//去除重复值
	var matrixTableValueObj = {};
	matrixTableRows.each(function() {
		var cf = jQuery(this).find('input[name="cf"]').val();
		var wf = jQuery(this).find('input[name="wf"]').val();
		matrixTableValueObj[cf] = wf;
	});
	var matrix = jQuery('#matrix').val();
	var vf = jQuery('#vf').val();
	var matrixTableValue = matrix + ',' + vf;
	for (var p in matrixTableValueObj) {
		matrixTableValue += ',' + p + ':' + matrixTableValueObj[p];
	}
	return matrixTableValue;
}

function getFieldUrl() {
	return "/systeminfo/BrowserMain.jsp?url=/workflow/ruleDesign/showFieldBrowser.jsp?formid=<%=formid%>&isbill=<%=isbill%>";
}

function getMatrixDisplayName() {
	var matrixDisplayName = jQuery('#matrixspan span a').text();
	var vfDisplayName = jQuery('#vfspan span a').text();
	return matrixDisplayName + '(' + vfDisplayName + ')';
}

function matrixChanged() {
	_writeBackData('vf', 2, {id:'',name:''});
	jQuery('#matrixTable tr.data #cf').val('');
	jQuery('#matrixTable tr.data #cfspan').html('');
	jQuery('#matrixTable tr.data #cfspanimg').html('<img align="absmiddle" src="/images/BacoError_wev8.gif">');
}

function getMatrixDataUrl(fieldtype) {
	var matrix = jQuery('#matrix').val();
	if (matrix) {
		return '/data.jsp?type=matrixfield&matrixid=' + matrix + '&fieldtype=' + fieldtype;
	} else {
		Dialog.alert('<%=SystemEnv.getHtmlLabelName(129434, user.getLanguage())%>');
		return '';
	}
}
//matrix end
</script>