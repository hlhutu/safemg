<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<style type="text/css">
.ztree li span.button.add {margin-left:2px; margin-right: -1px; background-position:-144px 0; vertical-align:top; *vertical-align:middle}
</style>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>

<link href="${ctx}/js/zTree_v3/css/zTreeStyle/zTreeStyle.css" rel="stylesheet">
<script src="${ctx}/js/zTree_v3/js/jquery.ztree.all.min.js"></script>

<script>
	var selectScaleUrl = "${ctx}/jsp/danger/template/scale/select.do";
	var insertScaleUrl = "${ctx}/jsp/danger/template/scale/insert.do";
	var updateScaleUrl = "${ctx}/jsp/danger/template/scale/update.do";
	var deleteScaleUrl = "${ctx}/jsp/danger/template/scale/delete.do";

	var selectContentUrl = "${ctx}/jsp/danger/template/content/select.do";
	var insertContentUrl = "${ctx}/jsp/danger/template/content/insert.do";
	var updateContentUrl = "${ctx}/jsp/danger/template/content/update.do";
	var deleteContentUrl = "${ctx}/jsp/danger/template/content/delete.do";

	var dtParam = {
		"scale_id": "0",
		"keywords": ""
	};
	var table = null;
	$(window).ready(function() {
		dtParam["keywords"] = $("#keywords").val();
		var userName_="${myUser.user.user_name}";
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
				"url": selectContentUrl,
				"data": dtParam,
			},
			"order": [[3, "desc"]],
			"columnDefs": [{
				"targets": [0,2,3],
				"orderable" : false
			}],
			"columns": [ {
				"title":'<input type="checkbox" id="checkAll_" style="margin:0px;">',
				"data":"id",
				"render": function (data, type, row) {
					return '<input type="checkbox" class="ids_" name="ids_" value="'+data+'" style="margin:0px;"/>';
				},
				"width":25
			}, {
				"title":"清单项具体描述  <i class='fa fa-search'></i>",
				"data":"description",
				"width":450
			}, {
				"title":"清单依据",
				"data":"basis",
				"width":150
			}, {
				"title":"创建时间",
				"data":"created",
				"width":150
			}]
			,"drawCallback": function(s) {
				$("#checkAll_").off("click").on("click", function() {
					$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
				});
			}
		});
		//查询
		$("#btn-query").on("click", function() {
			dtParam.keywords = $("#keywords").val();
			table.api().settings()[0].ajax.data = dtParam;
			table.api().ajax.reload();
       	});
		//新增
		$("#btn-insert").on("click", function() {
			$("*", $("#contentEditForm")).attr("disabled", false);
			$("#contentEditForm").attr("action", insertContentUrl);
			$("#contentModal").modal("show");

			$("#scale_id").val(dtParam.scale_id);
       	});
		$("#btn-content-save").on("click", function() {
			var b = $("#contentEditForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#contentEditForm", function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload(null, false);
						$("#contentModal").modal("hide");
					}
				});
			}
		});
		//修改
		$("body").on("click", "#btn-update" , function() {
			var ids = [];
			$(".ids_:checkbox:checked").each(function(index, o) {
				ids.push($(this).val());
			});
			if(ids.length != 1) {
				layer.msg("请选择需要修改的一条数据！", {icon: 0});
				return;
			}
			
			$("#contentEditForm").attr("action", updateContentUrl);
			$("#contentModal").modal("show");

			var obj = new Object();
			obj.url = selectContentUrl;
			obj.id = $(".ids_:checkbox:checked").val();
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else if(result.datas && result.datas.length == 1) {
					$("#contentEditForm").fill(result.datas[0]);
				} else {
					layer.msg("未找到相关数据，请刷新页面！", {icon: 7});
				}
			});
       	});
        //删除
		$("#btn-delete").on("click", function() {
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
				obj.url = deleteContentUrl;
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
        
		//刷新ztree
		refreshTree();

		//新增清单行业类别
		$("#btn-save").on("click", function() {
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				var obj = new Object();
				obj.url = insertScaleUrl;
				obj.parent_id = nowTreeNode.id;
				obj.scale_name = $("#tree_name").val();
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						$("#treeModal").modal("hide");
						$.fn.zTree.getZTreeObj("treeDemo").addNodes(nowTreeNode, {id:result.id, pId:result.parent_id, name:result.scale_name});
					}
				});
			}
		});
	});

	function refreshTree(){
		var zNodes =[
			{id:1, pId:0, name:"行业类别", open:true}
		];
		var obj = new Object();
		obj.url = selectScaleUrl;
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				$.each(result.datas,function(index,row){
					zNodes.push({id:row.id, pId:row.parent_id, name:row.scale_name, open:false});
				});
				
				$.fn.zTree.init($("#treeDemo"), setting, zNodes);
				$("#selectAll").bind("click", selectAll);
			}
		});
	}

	var setting = {
		view: {
			addHoverDom: addHoverDom,
			removeHoverDom: removeHoverDom,
			selectedMulti: false
		},
		edit: {
			enable: true,
			editNameSelectAll: true,
			showRemoveBtn: showRemoveBtn,
			showRenameBtn: showRenameBtn
		},
		data: {
			simpleData: {
				enable: true
			}
		},
		callback: {
			beforeDrag: beforeDrag,
			beforeEditName: beforeEditName,
			beforeRemove: beforeRemove,
			beforeRename: beforeRename,
			onRemove: onRemove,
			onRename: onRename,
			onClick: zTreeOnClick
		}
	};

	function zTreeOnClick(event, treeId, treeNode) {
		dtParam.keywords = $("#keywords").val();
		dtParam.scale_id = treeNode.id;
		table.api().settings()[0].ajax.data = dtParam;
		table.api().ajax.reload();
	};

	var log, className = "dark";
	function beforeDrag(treeId, treeNodes) {
		return false;
	}
	function beforeEditName(treeId, treeNode) {
		className = (className === "dark" ? "":"dark");
		var zTree = $.fn.zTree.getZTreeObj("treeDemo");
		zTree.selectNode(treeNode);
		setTimeout(function() {
			if (confirm("你要修改 [" + treeNode.name + "] 吗?")) {
				setTimeout(function() {
					zTree.editName(treeNode);
				}, 0);
			}
		}, 0);
		return false;
	}
	function beforeRemove(treeId, treeNode) {
		className = (className === "dark" ? "":"dark");
		var zTree = $.fn.zTree.getZTreeObj("treeDemo");
		zTree.selectNode(treeNode);
		return confirm("你确定要删除 [" + treeNode.name + "] 吗?");
	}
	function onRemove(e, treeId, treeNode) {
		var obj = new Object();
		obj.url = deleteScaleUrl;
		obj.id = treeNode.id;
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				layer.msg("数据删除成功！", {icon: 1});
			}
		});
	}
	function beforeRename(treeId, treeNode, newName, isCancel) {
		className = (className === "dark" ? "":"dark");
		if (newName.length == 0) {
			setTimeout(function() {
				var zTree = $.fn.zTree.getZTreeObj("treeDemo");
				zTree.cancelEditName();
				alert("Node name can not be empty.");
			}, 0);
			return false;
		}
		return true;
	}
	function onRename(e, treeId, treeNode, isCancel) {
		var obj = new Object();
		obj.url = updateScaleUrl;
		obj.id = treeNode.id;
		obj.scale_name = treeNode.name;
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				layer.msg("数据处理成功！", {icon: 1});
			}
		});
	}
	function showRemoveBtn(treeId, treeNode) {
		return treeNode.id!=1;
	}
	function showRenameBtn(treeId, treeNode) {
		return treeNode.id!=1;
	}
	function getTime() {
		var now= new Date(),
		h=now.getHours(),
		m=now.getMinutes(),
		s=now.getSeconds(),
		ms=now.getMilliseconds();
		return (h+":"+m+":"+s+ " " +ms);
	}

	var nowTreeNode = null;
	function addHoverDom(treeId, treeNode) {
		var sObj = $("#" + treeNode.tId + "_span");
		if (treeNode.editNameFlag || $("#addBtn_"+treeNode.tId).length>0) return;
		var addStr = "<span class='button add' id='addBtn_" + treeNode.tId
			+ "' title='add node' onfocus='this.blur();'></span>";
		sObj.after(addStr);
		var btn = $("#addBtn_"+treeNode.tId);
		if (btn) btn.bind("click", function(){
			$("#treeModal").modal("show");
			nowTreeNode = treeNode;
			return false;
		});
	};
	function removeHoverDom(treeId, treeNode) {
		$("#addBtn_"+treeNode.tId).unbind().remove();
	};
	function selectAll() {
		var zTree = $.fn.zTree.getZTreeObj("treeDemo");
		zTree.setting.edit.editNameSelectAll =  $("#selectAll").attr("checked");
	}
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-4">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>
							<class="fa fa-file-o a-clear"></i> 行业清单类别
						</h5>
					</div>
					
					<div class="ibox-content">
						<div class="form-horizontal clearfix">
							<div class="col-sm-6 pl0">
								<div class="content_wrap">
									<div class="zTreeDemoBackground left">
										<ul id="treeDemo" class="ztree"></ul>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-sm-8">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>
							<class="fa fa-file-o a-clear"></i> 清单项列表
						</h5>
						<div class="ibox-tools">
							<a class="a-reload"> <i class="fa fa-repeat"></i> 刷新
							</a>
						</div>
					</div>

					<div class="ibox-content">
						<div class="form-horizontal clearfix">
							<div class="col-sm-6 pl0">
								<button class="btn btn-sm btn-success" id="btn-insert">
									<i class="fa fa-plus"></i> 新增
								</button>
							
								<button class="btn btn-sm btn-success" id="btn-update">
									<i class="fa fa-edit"></i> 修改
								</button>
							
								<button class="btn btn-sm btn-success" id="btn-delete">
									<i class="fa fa-trash-o"></i> 删除
								</button>
							</div>

							<div class="col-sm-6 form-inline" style="padding-right: 0; text-align: right">
								<form id="selectForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
									<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="keywords" value="">
									<button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
										<i class="fa fa-search"></i> 查询
									</button>
								</form>
							</div>
						</div>

						<table id="datas" class="table display" style="width: 100%"></table>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- start-->
	<div class="modal fade" id="treeModal" tabindex="-1" role="dialog" >
		<div class="modal-dialog" style="width:70%;">
			<div class="modal-content ibox">
                <form id="editForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i> 添加行业类别</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
	            
		            <div class="ibox-content">
	                  <div class="form-group">
					    <label class="col-sm-2 control-label">名称</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="tree_name" id="tree_name" >
					    </div>
					  </div>
					</div>
		            
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13 btn-ok" id="btn-save">
		                	<i class="fa fa-save"></i> 保存
		                </button>
		                <button type="button" class="btn btn-sm btn-default btn-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
		            </div>
				</form>
	        </div>
	    </div>
	</div>
	<!-- end-->
	<div class="modal fade" id="contentModal" tabindex="-1" role="dialog" >
		<div class="modal-dialog" style="width:70%;">
			<div class="modal-content ibox">
                <form id="contentEditForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i> 添加清单项</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
	            
		            <div class="ibox-content">
		              <input type="text" id="id" name="id" style="display:none"/>
		              <input type="text" id="scale_id" name="scale_id" style="display:none"/>
	                  <div class="form-group">
					    <label class="col-sm-2 control-label">清单项具体描述</label>
					    <div class="col-sm-10">
					      <textarea class="form-control validate[required]" name="description" id="description" ></textarea>
					    </div>
					  </div>
					  <div class="form-group">
					    <label class="col-sm-2 control-label">清单依据</label>
					    <div class="col-sm-10">
					      <textarea class="form-control" name="basis" id="basis" ></textarea>
					    </div>
					  </div>
					</div>
		            
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13 btn-ok" id="btn-content-save">
		                	<i class="fa fa-save"></i> 保存
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