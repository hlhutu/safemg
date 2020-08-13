<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script src="${ctx}/js/plugins/jquery.jeditable.js"></script>
<script>
var modelId = "${param.glid}";//模板id
var modelName = "${param.mbmc}";//模板名称
var modelStatus = "${param.modelStatus}";//模板状态
var table;
$(function(){
	$('#modelName').html(modelName);
	table = $("#datas").dataTable({
		"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
		"dom": 'rt<"bottom"iflp<"clear">>',
		"pagingType": "full_numbers",
		"searching": false,
		"ordering": false,
		"autoWidth": false,
		"paging": false,
		"scrollX": false,
		"ajax": {
			"dataSrc": "datas",
			"url": "${ctx}/jsp/mbgl/mbglInfo/taskDefs.do",
			"data": {
				glid: modelId
			}
		},
		"columns": [ {
			"title":'<a id="a-plus" title="新增" href="javascript:addRow();"><i class="fa fa-plus"></i></a>',
			"data":"id",
			"render": function (data, type, row) {
				//注意此处必须用onclick，否则无法正确获取tr
				return '<a title="删除" onclick="javascript:removeRow($(this));"><i class="fa fa-remove a-remove"></i></a>';
			}
		}, {
			"title":"序号",
			"data":"xh"
		}, {
			"className":modelStatus==1?"edit":"noEdit",
			"title":"职责",
			"data":"zxxm",
			"render": function (data, type, row) {
				if(data && data.length>60){
					data = "<span title='"+data+"'>"+data.substring(0, 60)+" ...</span>";
				}
				return data;
			}
		},{
			"title":"周期",
			"data":"cycle",
			"render": function (data, type, row) {
				var html="";
				if(row["cycle"]=="y"){
					html += "每年";
				}else if(row["cycle"]=="m"){
					html += "每月";
				}else if(row["cycle"]=="d"){
					html += "每天";
				}
				if(html || row["repeat_"]!=1){
					html += "执行"+row["repeat_"]+"次"
				}
				return html;
			}
		}, {
			"title":"任务要求",
			"data":"zysx",
			"visible":true,
			"render": function (data, type, row) {
				var conf = row["conf"], html = data?data:"", ext="";
				for(var i in conf) {
					if (conf[i] == "editor_remark") {
						ext += ext?"、备注":"上传备注"
					} else if (conf[i] == "editor_file") {
						ext += ext?"、附件":"上传附件"
					}
				}
				return html + (ext?" 需"+ ext:"");
			}
		}, {
			"title":"操作",
			"data":"id",
			"visible":true,
			"render": function (data, type, row) {
				return ' <a title="编辑" onclick="javascript:openEditModel($(this));"><i class="fa"> 详情</i></a>';
			}
		}]
	});
	$("input[name=zysx]").click(function () {
		initSelector($(this).val(), editRow.req_model_id);
	});
});
function initSelector(val, val1){
	$('#req_model_name').html('');
	$('#req_model_id').html('');
	$('#req_model_name').hide();
	$('#req_model_id').hide();
	if("巡检"==val){
		ajax({
			url: "${ctx}/biz/xjmbgl/select.do"
		}, function (data) {
			var datas = data.datas;
			if(!datas){
				layer.msg("没有可用的巡检计划", {icon:1});
				return;
			}
			$.each(datas,function(i,o){
				$("#req_model_id").append("<option value='"+o.id+"' "+(o.id==val1?"selected='selected'":"")+">"+o.xjmc+"</option>");
			});
			$('#req_model_name').html('选择巡检计划');
			$('#req_model_name').show();
			$('#req_model_id').show();
		});
	}else if("学习"==val){
		ajax({
			url: "${ctx}/jsp/xxkgl/select.do"
			,page: 1, pagesize: 5
		}, function (data) {
			var datas = data.datas;
			if(!datas){
				layer.msg("没有可用的学习资料库", {icon:1});
				return;
			}
			$.each(datas,function(i,o){
				$("#req_model_id").append("<option value='"+o.id+"' "+(o.id==val1?"selected='selected'":"")+">"+o.xxkgl_title+"</option>");
			});
			$('#req_model_name').html('选择学习资料');
			$('#req_model_name').show();
			$('#req_model_id').show();
		});
	}
}

function addRow(){
	if(modelStatus!=1){
		layer.msg("当前清单不可编辑", {icon: 0});
		return;
	}
	var length = table.api().data().length + 1;
	var v = {
		"xh":length
		,"zxxm":"职责-"+length
		,"repeat_":1,"zysx":"其他"
	};
	table.fnAddData(v);
}
function removeRow($this){
	if(modelStatus!=1){
		layer.msg("当前清单不可编辑", {icon: 0});
		return;
	}
	table.api().row($this.parents('tr')).remove().draw();
	return;
}
var editRow;
function openEditModel($this){
	editRow = $this;
	var row = table.api().row(editRow.parents('tr')).data();
	initSelector(row.zysx, row.req_model_id);
	$("#editForm2").fill(row);
	$("input[name=conf]").attr("checked", false);
	var conf = row["conf"];
	for(var i in conf){
		$("#"+conf[i]).prop("checked", true);
	}
	if(modelStatus!=1){
		$("*", $("#editForm2 .ibox-content")).attr("disabled", true);
	}
	$("#myModal").modal("show");
}
function doSave(){
	if(modelStatus!=1){
		$("#myModal").modal("hide");
		return;
	}
	var data = table.api().row(editRow.parents('tr')).data();
	var newData = $("#editForm2").serializeObj();
	for(key in newData){
		data[key]=newData[key];
	}
	var conf = new Array();
	$("input[name=conf]:checked").each(function () {
		conf.push($(this).val());
	});
	data["conf"] = conf;
	var index = table.api().row(editRow.parents('tr')).index();//获取下标
	table.api().row(index).data(data);//根据下表，填充数据。
	$("#myModal").modal("hide");
}
function doSubmit(){
	if(modelStatus!=1){
		layer.msg("当前清单不可编辑", {icon: 0});
		return;
	}
	var obj = {};
	if (confirm("您确定要保存吗？")) {
		$("#editForm").attr("action", "${ctx}/jsp/mbgl/mbglInfo/taskDefs.do");
		obj.mbgl_info_list = JSON.stringify(table.api().data());
		ajaxSubmit("#editForm", obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg);
			} else {
				layer.msg("数据处理成功！", {
					shade : [ 0.1, "#fff" ] //独占
				}, function() {
					//table.api().settings()[0].ajax.data = {};
					table.api().ajax.reload();
					//$(".a-reload").click();
				});
			}
		});
	}
}
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<form id="editForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o a-clear">&nbsp;</i><span id="modelName"> 的任务项</span></h5>
	                    <div class="ibox-tools">
							<a id="a-save" style="color:#337ab7" onclick="doSubmit();"><i class="fa fa-save"></i> 保存</a>
							<a class="a-reload"><i class="fa fa-repeat"></i> 刷新</a>
	                    </div>
	                </div>
		            <div class="ibox-content">
	                  <input type="text" id="glid" name="glid" value="${param.glid}" style="display: none;">
	                  <table id="datas" class="table display" style="width: 100%"></table>
		            </div>
				</form>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:70%;">
	        <div class="modal-content ibox">
                <form id="editForm2" class="form-horizontal key-13" role="form" onsubmit="return false;">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i> 配置详情</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
					<div class="ibox-content">
						<input type="hidden" id="id" name="id" style="display:none"/>
						<div class="form-group">
							<label class="col-sm-2 control-label">职责</label>
							<div class="col-sm-10">
								<textarea class="form-control validate[required]" id="zxxm" name="zxxm" rows="3"></textarea>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">序号</label>
							<div class="col-sm-4">
								<input type="number" class="input-sm form-control validate[required]" id="xh" name="xh" />
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">周期</label>
							<div class="col-sm-4">
								<select class="input-sm form-control validate[required]" id="cycle" name="cycle">
									<option value="">不循环</option>
									<option value="d">每天</option>
									<option value="m">每月</option>
									<option value="y">每年</option>
									<option value="w">每周</option>
									<option value="q">每季度</option>
									<option value="hy">每半年</option>
								</select>
							</div>
							<label class="col-sm-2 control-label">执行</label>
							<div class="col-sm-3">
								<input type="number" class="input-sm form-control validate[required]" id="repeat_" name="repeat_" value="1"/>
							</div>
							<label class="col-sm-1 control-label" style="text-align: left;">次</label>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">任务要求</label>
							<div class="col-sm-4">
								<label for="editor_meeting" style="cursor: pointer;">
									<input type="radio" id="editor_meeting" name="zysx" value="会议"/> 会议&nbsp;&nbsp;
								</label>
								<label for="editor_xj" style="cursor: pointer;">
									<input type="radio" id="editor_xj" name="zysx" value="巡检"/> 巡检&nbsp;&nbsp;
								</label>
								<label for="editor_xx" style="cursor: pointer;">
									<input type="radio" id="editor_xx" name="zysx" value="学习"/> 学习&nbsp;&nbsp;
								</label>
								<label for="editor_normal" style="cursor: pointer;">
									<input type="radio" id="editor_normal" name="zysx" value="其他"/> 其他&nbsp;&nbsp;
								</label>
							</div>
							<label class="col-sm-2 control-label" id="req_model_name" style="display: none;">任务要求</label>
							<div class="col-sm-4">
								<select id="req_model_id" name="req_model_id" class="form-control" style="display: none;"></select>
							</div>
						</div>
						<div class="form-group desc">
							<label class="col-sm-2 control-label">附件</label>
							<div class="col-sm-10">
								<div class="col-sm-11" id="attachmentList">
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label"></label>
							<div class="col-sm-10">
								<input type="file" name="file" id="file" multiple />
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label"></label>
							<div class="col-sm-10">
								<h5><i class="fa fa-warning"></i> 温馨提示：</h5>
								<h5>“会议”、“巡检”、“学习”需要在系统中完成“任务要求”对应的工作，才可完成该任务。要求为“其他”则根据文档和职责说明进行履职。</h5>
							</div>
						</div>
					</div>
		            
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" onclick="doSave();">
		                	<i class="fa fa-check"></i> 确定
		                </button>
		                <button type="button" class="btn btn-sm btn-default btn-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
		            </div>
				</form>
	        </div>
	    </div>
	</div>
	
</body>
</html>