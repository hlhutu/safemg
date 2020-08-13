<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script>
	var selectUrl = "${ctx}/biz/sMbglInfo/select.do";
	var insertUrl = "${ctx}/biz/sMbglInfo/insert.do";
	var updateUrl = "${ctx}/biz/sMbglInfo/update.do";
	var deleteUrl = "${ctx}/biz/sMbglInfo/delete.do";

	var modelId = "${param.glid}";//模板id
	var modelName = "${param.mbmc}";//模板名称
	var modelStatus = "${param.modelStatus}";//模板状态
	var table;
	$(window).ready(function() {
		//初始化页面
		$('#modelName').html(modelName);
		$("#glid").val(modelId);
		var dtParam = {
			"keywords": $("#keywords").val()
			, glid: modelId
		};
		$("#datas").wrapAll("<div style='overflow-x:auto'>");
		table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": true,
			"autoWidth": false,
			"processing": true,
			"serverSide": true,
			"stateSave": false,
			"ajax": {
				"dataSrc": "datas",
				"url": selectUrl,
				"data": dtParam,
			},
			"order": [],
			"columns": [ {
				"orderable": false,
				"title":'<input type="checkbox" id="checkAll_" style="margin:0px;">',
				"data":"id",
				"render": function (data, type, row) {
					var s = '<input type="checkbox" ';
					if("1" == row.row_default) {
						s = s + 'disabled="disabled" '; 
					} else {
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				}
			}, {
				"title":"序号",
				"data":"xh"
			}, {
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
					}else if(row["cycle"]=="w"){
						html += "每周";
					}else if(row["cycle"]=="q"){
						html += "每季度";
					}else if(row["cycle"]=="hy"){
						html += "每半年";
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
			},{
				"orderable": false,
				"title":"操作",
				"render": function (data, type, row) {
					return '<a class="info">详情</a>';
				}
			}]
			,"drawCallback": function(s) {
				$("#checkAll_").off("click").on("click", function() {
					$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
				});
				
				$(".info").off("click").on("click", function () {
					var r = table.api().row($(this).parents('tr')).data();
					$("input[type='checkbox']").prop("checked", false);
					$(".ids_[value='"+r.id+"']").prop("checked", true);
				});
			}
		});

		$("#btn-query").on("click", function() {
			var b = $("#selectForm").validationEngine("validate");
			if(b) {
				dtParam.keywords = $("#keywords").val();
				table.api().settings()[0].ajax.data = dtParam;
				table.api().ajax.reload();
			}
		});
		
		$("#editForm .btn-13").on("click", function() {
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#editForm", function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload(null, false);
						$("#myModal").modal("hide");
					}
				});
			}
		});
		
		$("#btn-insert").on("click", function() {
			if("2"==modelStatus){
				layer.msg("责任清单已发布，不可修改");
				return;
			}
			$("*", $("#editForm")).attr("disabled", false);
			editRow = null;
			$("#xh").val(table.api().data().length + 1);
			$("#id").val('');
			$("#attachmentList").html('');
			$("#editForm").attr("action", insertUrl);
			initSelector("其他", null);
			$("#myModal").modal("show");
		});
		
		$("body").on("click", "#btn-update, .info" , function() {
			$("*", $("#editForm")).attr("disabled", false);
			if("详情" ==  $(this).html()) {
				$("*", $("#editForm")).attr("disabled", true);
			}else{
				if("2"==modelStatus){
					layer.msg("责任清单已发布，不可修改");
					return;
				}
			}
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要修改的一行数据！", {icon: 0});
				return;
			}
			$("#editForm").attr("action", updateUrl);
			$("#myModal").modal("show");
			
			var obj = new Object();
			obj.url = selectUrl;
			obj.id = $(".ids_:checkbox:checked").val();
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else if(result.datas && result.datas.length == 1) {
					$("#editForm").fill(result.datas[0]);
					fillSelect("#editForm",result.datas[0]);
					editRow = result.datas[0];
					initSelector(editRow.zysx, editRow.req_model_id);
					$("#attachmentList").html(result.datas[0].attachList);
				} else {
					layer.msg("未找到相关数据！", {icon: 7});
				}
			});
		});
		
		$("#btn-delete").on("click", function() {
			if("2"==modelStatus){
				layer.msg("责任清单已发布，不可修改");
				return;
			}
			var size = $(".ids_:checkbox:checked").length;
			if(size < 1) {
				layer.msg("请选择需要删除的数据！", {icon: 0});
				return;
			}
			layer.confirm("您确定要删除数据吗？", {icon: 3}, function() {
				var ids = [];
				$(".ids_:checkbox:checked").each(function(index, o) {
					ids.push($(this).val());
				});
				var obj = new Object();
				obj.url = deleteUrl;
				obj.id = ids.join(",");
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload(null, false);
					}
				});
			});
		});

		$("input[name=zysx]").click(function () {
			initSelector($(this).val(), editRow? editRow.req_model_id: null);
		});
	});
	var editRow = null;
	function initSelector(val, val1){
		$('#req_model_name').html('');
		$('#req_model_id').html('');
		$('#req_model_name').hide();
		$('#req_model_id').hide();
		if("巡检"==val){
			/*ajax({
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
			});*/
			$("#req_model_id").append("<option value='9527' >默认值</option>");
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
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>
							<i class="fa fa-file-o a-clear"></i> <span id="modelName"> 的责任项</span>
						</h5>
						<div class="ibox-tools">
							<a class="a-reload">
								<i class="fa fa-repeat"></i> 刷新
							</a>
						</div>
					</div>
					
					<div class="ibox-content">
						<!-- search start -->
						<div class="form-horizontal clearfix">
							<div class="col-sm-6 pl0">
								<s:access url="${basePath}/biz/sMbglInfo/insert.do">
									<button class="btn btn-sm btn-success" id="btn-insert" class="status_2_disabled">
										<i class="fa fa-plus"></i> 新增
									</button>
								</s:access>
								<s:access url="${basePath}/biz/sMbglInfo/update.do">
									<button class="btn btn-sm btn-success" id="btn-update" class="status_2_disabled">
										<i class="fa fa-edit"></i> 修改
									</button>
								</s:access>
								<s:access url="${basePath}/biz/sMbglInfo/delete.do">
									<button class="btn btn-sm btn-success" id="btn-delete" class="status_2_disabled">
										<i class="fa fa-trash-o"></i> 删除
									</button>
								</s:access>
							</div>
							
							<div class="col-sm-6 form-inline" style="padding-right: 0; text-align: right">
								<form id="selectForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
									<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="keywords">
									<button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
										<i class="fa fa-search"></i> 查询
									</button>
								</form>
							</div>
						</div>
						<!-- search end -->
						
						<table id="datas" class="table display" style="width: 100%"></table>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- edit start-->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" >
		<div class="modal-dialog" style="width:70%;">
			<div class="modal-content ibox">
				<form id="editForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
					<div class="ibox-title">
						<h5><i class="fa fa-pencil-square-o"></i> 编辑数据</h5>
						<div class="ibox-tools">
							<a class="close-link" data-dismiss="modal">
								<i class="fa fa-times"></i>
							</a>
						</div>
					</div>

					<div class="ibox-content">
						<input type="hidden" id="id" name="id" style="display:none"/>
						<input type="hidden" id="glid" name="glid" style="display:none"/>
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
								<select class="input-sm form-control" id="cycle" name="cycle">
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
									<input type="radio" id="editor_normal" name="zysx" value="其他" checked/> 其他&nbsp;&nbsp;
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
						<button type="button" class="btn btn-sm btn-success btn-13">
							<i class="fa fa-check"></i> 确定
						</button>
						<button type="button" class="btn btn-sm btn-default" data-dismiss="modal">
							<i class="fa fa-ban"></i> 取消
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<!-- edit end-->
</body>
</html>
