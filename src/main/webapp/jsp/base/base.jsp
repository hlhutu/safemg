<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Cache-Control" content="no-cache" /> 
<meta http-equiv="Pragma" content="no-cache" /> 
<meta http-equiv="Expires" content="0" />
<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" />
<meta name="renderer" content="webkit">
<title>system</title>

<link href="${ctx}/css/font-awesome/css/font-awesome.min.css?v=4.7.0" rel="stylesheet">
<link href="${ctx}/css/animate/animate.css?v=3.5.2" rel="stylesheet">

<script>ctx="${ctx}";portal="${portal}";</script>
<script src="${ctx}/js/jquery.min.js?v=2.1.4"></script>
<script src="${ctx}/js/jquery-ui/jquery-ui.min.js?v=1.12.1"></script>
<script src="${ctx}/js/jquery.form.min.js"></script>
<script src="${ctx}/js/jquery.formautofill.min.js"></script>
<script src="${ctx}/js/plugins/layer/layer.js?v=3.0.3"></script>
<script src="${ctx}/js/base.js"></script>
<script src="${ctx}/js/sdk_web.js"></script>
<%-- <script src="${ctx}/js/auth.js"></script> --%>

<script src="${ctx}/js/plugins/wangEditor/wangEditor.js"></script>
<link href="${ctx}/js/plugins/wangEditor/wangEditor-fullscreen-plugin.css" rel="stylesheet"/>
<script src="${ctx}/js/plugins/wangEditor/wangEditor-fullscreen-plugin.js"></script>

<link href="${ctx}/js/bootstrap/css/bootstrap.min.css?v=3.3.7" rel="stylesheet">
<script src="${ctx}/js/bootstrap/js/bootstrap.min.js?v=3.3.7"></script>
<link href="${ctx}/js/bootstrap/css/bootstrap-table.css" type="text/css" rel="stylesheet">

<link href="${ctx}/js/bootstrap-fileupload/css/fileinput.min.css" rel="stylesheet">
<script src="${ctx}/js/bootstrap-fileupload/js/fileinput.min.js"></script>
<script src="${ctx}/js/bootstrap-fileupload/js/locales/zh.js"></script>
<script type="text/javascript" src="${ctx}/js/bootstrap/js/bootstrap-table.js"></script>
<script type="text/javascript" src="${ctx}/js/bootstrap/js/bootstrap-table-zh-CN.js"></script>

<link href="${ctx}/js/plugins/dataTables/css/jquery.dataTables.css" rel="stylesheet">
<link href="${ctx}/js/plugins/dataTables/css/dataTables.bootstrap.css" rel="stylesheet">
<script src="${ctx}/js/plugins/dataTables/js/jquery.dataTables.min.js?v=1.10.15"></script>
<script src="${ctx}/js/plugins/dataTables/js/dataTables.bootstrap.min.js?v=3"></script>

<link href="${ctx}/js/plugins/validation-engine/validationEngine.jquery.css" rel="stylesheet">
<script src="${ctx}/js/plugins/validation-engine/jquery.validationEngine.js"></script>
<script src="${ctx}/js/plugins/validation-engine/jquery.validationEngine-zh_CN.js"></script>

<link href="${ctx}/js/theme/style.css?v=4.1.0" rel="stylesheet">

<script src="${ctx}/js/plugins/WdatePicker/WdatePicker.js"></script>

<link href="${ctx}/js/plugins/select/bootstrap-select.css" rel="stylesheet"  />
<script src="${ctx}/js/plugins/select/bootstrap-select.js"></script>
<script src="${ctx}/js/plugins/select/defaults-zh_CN.js"></script>

<link href="${ctx}/js/plugins/viewer/viewer.min.css" rel="stylesheet">
<script src="${ctx}/js/plugins/viewer/viewer.min.js"></script>

<style type="text/css">
body {
	font-family: "微软雅黑" !important;
}
.dataTables_wrapper .table th {
	border-bottom: 1px solid #111 !important;
	white-space: nowrap !important;	/* 表头强制不换号 */
 	text-overflow: ellipsis !important;	/* 表头强制不换号 */
}
.dataTables_wrapper .dataTables_info {
	margin-top: 4px !important;
}
.dataTables_wrapper .dataTables_length {
	margin-top: 0 !important;
}
.dataTables_wrapper .dataTables_paginate {
	margin-top: 3px !important;
}
.dataTables_wrapper .dataTables_paginate .paginate_button {
	border: 0 !important;
}
.dataTables_wrapper .dataTables_scrollBody table thead {/* 固定表头，去掉多余表头 */
    display:none;
}
.form-control[readonly] {
	background-color: #f9f9f9;
}
.form-control[disabled], fieldset[disabled] .form-control, button[disabled] {
	background-color: #f9f9f9;
	background-image: none;
}
.btn-white[disabled] {
	color: #000 !important;
}
[class*="validate\[required"],[class*="validate\[groupRequired\["] {
    padding-right:20px;
	background-image: url("${ctx}/images/icon_star.png");
    background-position: calc(100% - 5px);
    background-repeat: no-repeat;
}
select[class*="validate\[required"] {
	appearance:none;
	-moz-appearance:none;
	-webkit-appearance:none;
	line-height:20px;
}
select[class*="validate\[required"]::-ms-expand {
	display:none;
}
.bootstrap-select button {
	border-radius: 0px;
	height: 30px;
}
.textlimit {
	max-width: 150px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}
fieldset {
    border-top: 1px solid #eee;
}
legend {
    padding: 10px;
    border: 0;
    width: auto;
    margin: 0px auto;
    font-size: 14px;
}
#filespan img,.viewer img {
    width: 80px;
    height: 60px;
    cursor: pointer;
}
#filespan span {
    display: inline-block;
    position: relative;
}
#filespan sup {
    color: #ff0000;
    cursor: pointer;
    font-size: 18px;
    position: absolute;
    top: -1px;
    right: -6px;
    z-index: 0;
}
</style>

<script>
try {
	$.fn.dataTable.ext.errMode = "none";
} catch(ex) {
//	console.log(ex);
}

//格式化日期
function formatDate(date, format) {
	var paddNum = function(num) {
		num += "";
		return num.replace(/^(\d)$/, "0$1");
	}
	var cfg = {
		yyyy : date.getFullYear(),
		MM : paddNum(date.getMonth() + 1), // 月 : 如果1位的时候补0
		dd : paddNum(date.getDate()),
		hh : paddNum(date.getHours()),
		mm : paddNum(date.getMinutes()),
		ss : paddNum(date.getSeconds())
	}
	format || (format = "yyyy-MM-dd hh:mm:ss");
	return format.replace(/([a-z])(\1)*/ig, function(m) {
		return cfg[m];
	});
}

$(window).ready(function() {
	$("#keywords").val("${param.keywords}");
	
	$("#checkAll_,.checkAll_").on("click", function() {
		$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
	});
	
 	$(".a-reload").on("click", function() {
	//	location.reload();
		location.href = location.href;
	});

 	$(".a-back").on("click", function() {
 		if(location.href == document.referrer) {
 			history.back();
 		} else {
	 		location.href = document.referrer;
 		}
	});

 	$(".a-go").on("click", function() {
 		history.back();
	});

	try {
		$("button").on("click", function() {
	 		$(this).blur();
		});
		
		$(document).bind("mousedown", function(event) {
			if(3 == event.which) {
				layer.closeAll("loading");
			}
		});

		$(".key-13").bind("keyup", function(event) { //keypress
		    var theEvent = event || window.event;
		    var keyCode = theEvent.keyCode || theEvent.which || theEvent.charCode;
		    if (keyCode == 13 && (!($(":focus").is("textarea")) && !($(":focus").is(".w-e-text")))) {
		      	$(this).find(".btn-13").click();
		      	$("*", this).blur();
		    }
		});
		
		$(document).bind("keyup", function(event) {
			var theEvent = event || window.event;
		    var keyCode = theEvent.keyCode || theEvent.which || theEvent.charCode;
			if(keyCode == 13) {//enter
				$("a.layui-layer-btn0").click();
			} else if(keyCode == 27) {//escap
				$("a.layui-layer-btn1").click();
				layer.closeAll("loading");
			}
		});
	} catch(ex) {
	}
	
 	try {
 		$(".date_select").on("click", function() {
			var format = $(this).attr("format");
			format = isNull(format) ? "yyyy-MM-dd HH:mm:ss" : format;
			var maxDate = $(this).attr("maxDate");
			if("1" == maxDate) {
		 		WdatePicker({el:this,dateFmt:format,minDate:'%y-%M-%d %H:%m:%s',errDealMode:-1});
			} else if("0" == maxDate) {
	 			WdatePicker({el:this,dateFmt:format});
			} else {
	 			WdatePicker({el:this,dateFmt:format,maxDate:'%y-%M-%d %H:%m:%s',errDealMode:-1});
			}
		});
 	} catch(ex) {
	}
 	
	try {
		$(".modal-dialog").draggable({
			handle: ".ibox-title"
		});
	} catch(ex) {
	}
	
	try {
		$(".modal").on("shown.bs.modal", function() {
	 		$(this).find(":text:enabled:visible:first").focus();
	 		$("button[data-dismiss='modal']").attr("disabled", false);
	 		
	 		try {
		 		var selects = $(this).find(".selectpicker");
		 		if(selects){
			 		$(selects).selectpicker("render");
					$(selects).selectpicker("refresh");
				}
	 		} catch(ex) {
	 		}
		});
		
	 	$(".modal").on("hidden.bs.modal", function() {
	 		$(this).find("form").resetForm();
	 		$(this).find("form").validationEngine("hideAll");
	 		
	 		try {
		 		var selects = $(this).find(".selectpicker");
				if(selects && selects.length > 0){
					$.each(selects,function(index, o){
						$(o).selectpicker("val", "");
					});
				}
	 		} catch(ex) {
	 		}
		});
	 	
	 	$.fn.modal.Constructor.prototype.hideModal = function() {
            var that = this;
            this.$element.hide();
            this.backdrop(function() {
                //判断当前页面所有的模态框都已经隐藏了之后body移除.modal-open，即body出现滚动条。
                $('.modal.fade.in').length === 0 && that.$body.removeClass('modal-open');
                that.resetAdjustments();
                that.resetScrollbar();
                that.$element.trigger('hidden.bs.modal');
            });
        }
	} catch(ex) {
	}
	
	try {
		$(".selectpicker").attr("data-live-search","true");
		$(".multiple").attr("multiple","multiple");
		$(".selectpicker").selectpicker({
			noneSelectedText: "请选择",
			actionsBox: true,
			style: "btn-white"
		});
		$(".selectpicker").selectpicker("val", "");
		$(".selectpicker").selectpicker("render");
		$(".selectpicker").selectpicker("refresh");
	} catch(ex) {
	}
});

var fillSelect = function(obj, data) {
	try {
		var selects = $(obj).find(".selectpicker");
		if(selects && selects.length > 0){
			$.each(selects,function(index, o){
				try {
					var name = $(o).attr("name");
					$(o).selectpicker("val", data[name].split(","));
					} catch(ex) {
				}
			});
		}
	} catch(ex) {
	}
}

var doMessage = function(o) {
	try {
		if(window.top == window.self && "menuItem" == o.action && o.target) {
			location.href = o.target;
		} else if(window.top == window.self && "closeItem" == o.action && o.target) {
			history.back();
		} else if(("menuItem" == o.action || "closeItem" == o.action) && o.target) {
			top.postMessage(o, "*");
		} else {
			parent.postMessage(o, "*");
		}
		
		if("menuItem" == o.action) {
			return null;
		}
	} catch (e) {
	}
	
	var m = {action: "click", target: ".a-back", result: "queryTask"};
	try {
		var ws = plus.webview.currentWebview();	//兼容MUI APP
		if(ws.opener()) {
			ws.opener().evalJS("message("+JSON.stringify(m)+")");
		}
	} catch (e) {
		parent.postMessage(m, "*");
	}
	
	return null;
}
</script>