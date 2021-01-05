<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<script>

var editorList={};

function getEditor(editorid){
	return editorList[editorid];
}

/*高级编辑器*/
function highEditor(remarkid){
    if(jQuery("#"+remarkid).is(":visible")){
		
	   var editor = UE.getEditor(remarkid,{
	  		 autoFloatEnabled:false,//不保持工具栏位置 
			 allowDivTransToP:false,//不把div自动转为p
			 disabledTableInTable:false,//允许table嵌套
			 //autoHeightEnabled:true,
			 height:120,
       		 toolbars: [[
	            'fullscreen', 'source', '|',
	            'bold', 'italic', 'underline', 'strikethrough','forecolor', 'backcolor', '|', 
	            'justifyleft', 'justifycenter', 'justifyright', '|',
	            'link', 'unlink',
	            'inserttable','insertimage','|',
	            'fontfamily', 'fontsize'
	        ]],
	        theme : "metro", 
		    fontfamily:[{
				    label: '',
				    name: 'songti',
				    val: '宋体,SimSun !important'
				}, {
				    label: '',
				    name: 'kaiti',
				    val: '楷体,楷体_GB2312, SimKai !important'
				}, {
				    label: '',
				    name: 'yahei',
				    val: '微软雅黑,Microsoft YaHei !important'
				}, {
				    label: '',
				    name: 'heiti',
				    val: '黑体, SimHei !important'
				}, {
				    label: '',
				    name: 'lishu',
				    val: '隶书, SimLi !important'
				}],
	        focus:true,
	        textarea:remarkid,
	        initialStyle : "p{font-family:Microsoft YaHei; font-size:12px;}"
	   });
	   
	   editorList[remarkid]=editor;
	}
}

function getRemarkHtml(remarkid){
	var editor=getEditor(remarkid);
	if(!editor) return "";
	var editorbody=$(editor.body);
	//过滤编辑内容中可能包含的input button
    editorbody.find("button").remove();
    editorbody.find("input").remove();
    //获取内容中图片大小
	editorbody.find("img").each(function(){
	   var imgWidth=jQuery(this).width();
	   $(this).attr("imgWidth",imgWidth);
	});
	
	var remark=$("#"+remarkid);
	var remarkValue=editor.getContent();
	
	if(remark.is(":visible")) //如果可见则为文本模式  否则为html模式
        remarkValue = remarkValue.replace(/\n/g,"<br/>");     //替换换行\n
     else{
       remarkValue = remarkValue.replace(/\n/g,"");     //替换换行\n
       remarkValue = remarkValue.replace(/\r/g,"");     //替换单行\r
     }
     
     remarkValue = remarkValue.replace(/\\/g,"\\\\"); //替换斜杠
     remarkValue = remarkValue.replace(/'/g,"\\'");   //转义单引号
     
     return remarkValue;
}

/**
将上传图片转换为邮件可发送图片
*/
function changeImgToEmail(editorid){
	var editor=getEditor(editorid);
	    var editorbody=$(editor.body);
	    editorbody.find("img").each(function(){
		   var $this=$(this);
		   var imgsrc=$this.attr("src");
		   if(imgsrc.indexOf("/weaver/weaver.file.FileDownload?fileid=")!=-1){
		   	  imgsrc=imgsrc.replace("/weaver/weaver.file.FileDownload?fileid=", "docimages_");
		   	  $this.attr("alt",imgsrc);
		   }
	});
}



</script>
