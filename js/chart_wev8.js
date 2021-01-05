// JavaScript Document
var WeaverChart=null;

(function(){

if(WeaverChart!=null)return;//表示已定义
   
WeaverChart={
	changeSeiesType:_changeSeiesType,
	debugChart:_debugChart,
	resetChart:_resetChart
};

function _changeSeiesType(o,chartId){
	var iType=(typeof(o)=='object')?parseInt(o.getAttribute('_value')):o;
	var chart0=$(''+chartId);
	var sizes=chart0.SeriesCount;
	if(iType==5 && sizes>1){//当seriesSize大于零时，不能切换到饼图
		if(typeof(o)=='object')o.disabled=true;
		return;
	}

	var isMarked=(iType==5)?_resetChart(chart0):false;
	for(var i=0;i<sizes;i++){
		chart0.ChangeSeriesType(i,iType);
		chart0.Series(i).Marks.Style=(iType==5 && !isMarked)?3:0;//如果柱状图等转换标签的显示方式
		if(iType==5 && !isMarked){
			chart0.Series(i).Marks.Style=3;
		}else chart0.Series(i).Marks.Style=0;//如果柱状图等转换标签的显示方式
		//chart0.Series(i).RefreshSeries();
	}
	if(!chart0.Aspect.View3D)chart0.Aspect.View3D=true;
	if(iType!=5){
		chart0.Aspect.Orthogonal=true;
		chart0.Aspect.Chart3DPercent=20;
	}
	
	chart0.Repaint();
}

function _resetChart(chart0){
	var isMarked=false;
	var sizes=chart0.SeriesCount;
	for(var i=0;i<sizes;i++){
		var oSeries=chart0.Series(i);
		var len=oSeries.VisibleCount();
		for(var n=0;n<len;n++){
			var label=oSeries.PointLabel(n);
			if(label.length>6){
				isMarked=true;
				break;
			}
		}//end for.
		if(isMarked)break;
	}//end for.
	return isMarked;
}

function _debugChart(id){
	eval($("chartDebug_"+id).value);
}

var str=new Array('<style type="text/css">\n',
		'.btns{text-align:center;width:100%;height:100%;}\n',
		'.btns button{width:33%;height:30px;border-width:1px;}\n',
		'</style>').join('');
document.writeln(str);

}());

if(typeof($)=='undefined'){
	function $(id){
		return (typeof(id)=='string')?document.getElementById(id):id;
	}
}//end if.
