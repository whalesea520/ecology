<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<HEAD>
<link type='text/css' rel='stylesheet'  href='/secondwev/tree/js/treeviewAsync/eui.tree.css'/>
<link type='text/css' rel='stylesheet' href='../css/tree.css' />
<script language='javascript' type='text/javascript' src='/secondwev/tree/js/treeviewAsync/jquery.treeview.js'></script>
<script language='javascript' type='text/javascript' src='/secondwev/tree/js/treeviewAsync/jquery.treeview.async.js'></script>

<link href="../css/jquery.jscrollpane.css" rel="stylesheet" />

<script type='text/javascript' src="../js/jquery.jscrollpane.min.js"></script>
<script type='text/javascript' src="../js/jquery.mousewheel.js"></script>
<%@ include file="/secondwev/common/head.jsp" %>
	</head>
<body style="overflow: hidden;">
	<div style="width:100%;;border-top:1px solid  #D6D6D6;line-height:1px"></div>
	<div id="hrmOrgDiv" class="scroll-pane" style="width: 100%;height: 200px;overflow: auto;">
	<p>
					Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec in ligula id sem tristique ultrices
					eget id neque. Duis enim turpis, tempus at accumsan vitae, lobortis id sapien. Pellentesque nec orci
					mi, in pharetra ligula. Nulla facilisi. Nulla facilisi. Mauris convallis venenatis massa, quis
					consectetur felis ornare quis. Sed aliquet nunc ac ante molestie ultricies. Nam pulvinar ultricies
					bibendum. Vivamus diam leo, faucibus et vehicula eu, molestie sit amet dui. Proin nec orci et elit
					semper ultrices. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus
					mus. Sed quis urna mi, ac dignissim mauris. Quisque mollis ornare mauris, sed laoreet diam malesuada
					quis. Proin vel elementum ante. Donec hendrerit arcu ac odio tincidunt posuere. Vestibulum nec risus
					eu lacus semper viverra.
				</p>
				<p>
					Vestibulum dictum consectetur magna eu egestas. Praesent molestie dapibus erat, sit amet sodales
					lectus congue ut. Nam adipiscing, tortor ac blandit egestas, lorem ligula posuere ipsum, nec
					faucibus nisl enim eu purus. Quisque bibendum diam quis nunc eleifend at molestie libero tincidunt.
					Quisque tincidunt sapien a sapien pellentesque consequat. Mauris adipiscing venenatis augue ut
					tempor. Donec auctor mattis quam quis aliquam. Nullam ultrices erat in dolor pharetra bibendum.
					Suspendisse eget odio ut libero imperdiet rhoncus. Curabitur aliquet, ipsum sit amet aliquet varius,
					est urna ullamcorper magna, sed eleifend libero nunc non erat. Vivamus semper turpis ac turpis
					volutpat non cursus velit aliquam. Fusce id tortor id sapien porta egestas. Nulla venenatis luctus
					libero et suscipit. Sed sed purus risus. Donec auctor, leo nec eleifend vehicula, lacus felis
					sollicitudin est, vitae lacinia lectus urna nec libero. Aliquam pellentesque, arcu condimentum
					pharetra vestibulum, lectus felis malesuada felis, vel fringilla dolor dui tempus nisi. In hac
					habitasse platea dictumst. Ut imperdiet mauris vitae eros varius eget accumsan lectus adipiscing.
				</p>
				<p>
					Quisque et massa leo, sit amet adipiscing nisi. Mauris vel condimentum dolor. Duis quis ullamcorper
					eros. Proin metus dui, facilisis id bibendum sed, aliquet non ipsum. Aenean pulvinar risus eu nisi
					dictum eleifend. Maecenas mattis dolor eget lectus pretium eget molestie libero auctor. Praesent sit
					amet tellus sed nibh convallis semper. Curabitur nisl odio, feugiat non dapibus sed, tincidunt ut
					est. Nullam erat velit, suscipit aliquet commodo sit amet, mollis in mauris. Curabitur pharetra
					dictum interdum. In posuere pretium ultricies. Curabitur volutpat eros vehicula quam ultrices
					varius. Proin volutpat enim a massa tempor ornare. Sed ullamcorper fermentum nisl, ac hendrerit sem
					feugiat ac. Donec porttitor ullamcorper quam. Morbi pretium adipiscing quam, quis bibendum diam
					congue eget. Sed at lectus at est malesuada iaculis. Sed fermentum quam dui. Donec eget ipsum dolor,
					id mollis nisi. Donec fermentum vehicula porta.
				</p>
				<p>
					Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.
					Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero
					sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.
					Quisque sit amet est et sapien ullamcorper pharetra. Vestibulum erat wisi, condimentum sed,
					commodo vitae, ornare sit amet, wisi. Aenean fermentum, elit eget tincidunt condimentum, eros
					ipsum rutrum orci, sagittis tempus lacus enim ac dui. Donec non enim in turpis pulvinar facilisis.
					Ut felis. Praesent dapibus, neque id cursus faucibus, tortor neque egestas augue, eu vulputate magna
					eros eu erat. Aliquam erat volutpat. Nam dui mi, tincidunt quis, accumsan porttitor, facilisis
					luctus, metus
				</p>
				<p>
					Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.
					Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit
					amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.
				</p>
	</div>
	<FORM id="orgform" name="orgform" action="BaseSetting.jsp" method="post" target="pageRight">
		<input type="hidden" id="resourceid" name="resourceid"/>
		<input type="hidden" id="resourcetype" name="resourcetype"/>
	</FORM>
	<script>
	var jj = null;
		jQuery(document).ready(function(){
			/**
			jj = jQuery("#hrmOrgDiv").jScrollPane({
		        //autoReinitialise: true  //内容改变后自动计算高度
		    });
			
			jQuery("#hrmOrgDiv .jspPane").html('<ul id="hrmOrgTree" class="hrmOrg" style="width:100%;outline:none;"></ul>');
			jQuery("#hrmOrgTree").treeview({
		       url:"/secondwev/tree/hrmOrgTree.jsp"
		    });*/

		    var val = 3.135;
		    alert(val.toFixed(2));
		});

		Number.prototype.toFixed=function(len)
	    {
	        var tempNum = 0;
	        var s,temp;
	        var s1 = this + "";
	        var start = s1.indexOf(".");
	        
	        //截取小数点后,0之后的数字，判断是否大于5，如果大于5这入为1
	 
	       if(s1.substr(start+len+1,1)>=5)
	        tempNum=1;
	 
	        //计算10的len次方,把原数字扩大它要保留的小数位数的倍数
	      var temp = Math.pow(10,len);
	        //求最接近this * temp的最小数字
	        //floor() 方法执行的是向下取整计算，它返回的是小于或等于函数参数，并且与之最接近的整数
	        s = Math.floor(this * temp) + tempNum;
	        return s/temp;
	 
	    }
			
	</script>
</body>
</html>
