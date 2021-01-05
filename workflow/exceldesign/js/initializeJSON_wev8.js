var initJSON_moreContent = {
    "tabStripVisible": false,
    "newTabVisible": false,
    "canUserEditFormula": false,
    "allowUndo": false,
    "allowDragDrop": false,
    "allowDragFill": false,
    "highlightInvalidData": true,
    "backgroundImageLayout": 3,
    "grayAreaBackColor": "white",
    "sheets": {
        "Sheet1": {
            "name": "Sheet1",
            "defaults": {
                "rowHeight": 30,
                "colWidth": 40,
                "rowHeaderColWidth": 0,
                "colHeaderRowHeight": 0
            },
            "columns": [
                {
                    "size": 252,
                    "dirty": true
                },
                {
                    "size": 50,
                    "dirty": true
                }
            ],
            "rowCount": 8,
            "columnCount": 2,
            "gridline": {
                "color": "#D0D7E5",
                "showVerticalGridline": true,
                "showHorizontalGridline": true
            },
            "allowDragDrop": false,
            "allowDragFill": false
        }
    }
};

//主面板初始化模板格式
var templteStrModel = {
	'activeSheetIndex':0, 'sheetCount':1, 'tabStripRatio':0.5,
    'tabStripVisible':false, 'tabEditable':true, 'newTabVisible':false, 'referenceStyle':0,
    'useWijmoTheme':false, 'canUserEditFormula':true, 'startSheetIndex':0, 'allowUndo':true,
    'allowUserZoom':true, 'allowUserResize':true, 'allowDragDrop':true, 'allowDragFill':true,
    'highlightInvalidData':true,
    'sheets':{'Sheet1':{
        'name':'Sheet1',
        'defaults':{	//默认的行高列宽
        	'rowHeight':28, 'colWidth':90, 
        	'rowHeaderColWidth':40, 'colHeaderRowHeight':20
        }, 
        'columns':{}, 'rows':{}, //设置行高列宽的数组
        'autoGenerateColumns':true, 'dataSource':null,
        'frozenRowCount':0, //冻结行
        'frozenColCount':0, //冻结列
        'rowCount':20, //表格行数
        'columnCount':10, //表格列数
        'data':{'name':'Sheet1', 'rowCount':20, 'colCount':10,
            'dataTable':{}, //数据填充，包括单元格样式，边框等等
            '_rowDataArray':[], '_columnDataArray':[],
            '_defaultDataNode':{'style':{'foreColor':'black', 'hAlign':3, 'vAlign':0}}
        },
        'spans':{}, //合并单元格
        'selections':{

        },
        'activeRow':0, 'activeCol':0,
        'gridline'://单元格分割线的信息
        {
            'color':'#D0D7E5', 'showVerticalGridline':true, 'showHorizontalGridline':true
        },
        'allowCellOverflow':false, 'referenceStyle':0, '_zoomFactor':1,
        'theme':{
            '_name':'Office', '_themeColor':{
                '_name':'Office',
                '_colorList':[
                    {'a':255, 'r':255, 'g':255, 'b':255},
                    {'a':255, 'r':238, 'g':236, 'b':225},
                    {'a':255, 'r':0, 'g':0, 'b':0},
                    {'a':255, 'r':31, 'g':73, 'b':125},
                    {'a':255, 'r':79, 'g':129, 'b':189},
                    {'a':255, 'r':192, 'g':80, 'b':77},
                    {'a':255, 'r':155, 'g':187, 'b':89},
                    {'a':255, 'r':128, 'g':100, 'b':162},
                    {'a':255, 'r':75, 'g':172, 'b':198},
                    {'a':255, 'r':247, 'g':150, 'b':70},
                    {'a':255, 'r':0, 'g':0, 'b':255},
                    {'a':255, 'r':128, 'g':0, 'b':128}
                ]
            },
            '_headingFont':'Cambria', '_bodyFont':'Calibri'
        },

        'showRowRangeGroup':true, 'showColumnRangeGroup':true,
        'rowRangeGroup':{
            'itemsCount':20, 'itemsData':[], 'direction':1, 'head':null, 'tail':null
        },
        'colRangeGroup':{
            'itemsCount':10, 'itemsData':[], 'direction':1, 'head':null, 'tail':null
        },
        'conditionalFormats':{'rules':[]},
        'sheetTabColor':null, 'frozenlineColor':'black',
        'rowHeaderAutoText':1, 'colHeaderAutoText':2, 'rowHeaderAutoTextIndex':-1,
        'colHeaderAutoTextIndex':-1, 'rowHeaderVisible':true, 'colHeaderVisible':true,
        'rowHeaderColCount':1, 'colHeaderRowCount':1,
        'rowHeaderData':{
            'rowCount':20, 'colCount':1, 'dataTable':{}, '_rowDataArray':[], '_columnDataArray':[],
            '_defaultDataNode':{
                'style':{'foreColor':'black', 'hAlign':1, 'vAlign':1}
            }
        },
        'colHeaderData':{
            'rowCount':1, 'colCount':10, 'dataTable':{}, '_rowDataArray':[], '_columnDataArray':[],
            '_defaultDataNode':{
                'style':{'foreColor':'black', 'hAlign':1, 'vAlign':1}
            }
        },
        'rowHeaderSpan':{}, 'colHeaderSpan':{}, 'rowHeaderColInfos':{}, 'colHeaderRowInfos':{},
        'isProtected':false, 'borderColor':'black', 'borderWidth':0, 'allowDragDrop':true,
        'allowDragFill':true, 'allowUndo':true, 'allowEditorReservedLocations':true
    }
    }, 'names':[]
};