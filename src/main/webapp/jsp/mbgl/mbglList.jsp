<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script>
	var selectUrl = "${ctx}/jsp/mbgl/mbgl/select.do";
	var insertUrl = "${ctx}/jsp/mbgl/mbgl/insert.do";
	var insertMyTaskUrl = "${ctx}/jsp/mbgl/mbgl/insertMyTask.do";
	var updateUrl = "${ctx}/jsp/mbgl/mbgl/update.do";
	var deleteUrl = "${ctx}/jsp/mbgl/mbgl/delete.do";

	var flag = "${param.flag}";
	$(window).ready(function() {
		var userName_="${myUser.user.user_name}";
		var dtParam = {
			"keywords": $("#keywords").val(),
			"status": "1,2"
		};
		if("all"==flag){
			dtParam={
				"status": "1,2"
			}
		}
		var table = $("#datas").dataTable({
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
			"order": [[1, "asc"]],
			"columnDefs": [{
				"targets": [0,2,3,5,6,7],
				"orderable" : false
			}],
			"columns": [ {
				"title":'<input type="checkbox" id="checkAll_" style="margin:0px;">',
				"data":"id",
				"render": function (data, type, row) {
					return '<input type="checkbox" class="ids_" name="ids_" value="'+data+'" style="margin:0px;"/>';
				}
			}, {
				"title":"序号",
				"data":"xh"
			}, {
				"title":"清单名称",
				"data":"mbmc"
			}, {
				"title":"类型 <i class='fa fa-search'></i>",
				"data":"qdlx_desc"
			}, {
				"title":"生效时间",
				"data":"start_date"
			}, {
				"title":"失效时间",
				"data":"end_date"
			}, {
				"title":"修改时间",
				"data":"modified",
				"render": function (data, type, row) {
					return '<span title="'+row.modifierDesc+'">'+data+'</span>';
				}
			}, {
				"title":"状态",
				"data":"status",
				"render": function (data, type, row) {
					if("0" == data) {
						return '<span style="color:#FF0000">禁用</span>';
					}
					return '有效';
				}
			}, {
				"title":"备注",
				"data":"remark"
			}, {
				"title":"操作",
				"data":"id",
				"render": function (data, type, row) {
					if("all"==flag){
						return '<a class="info" value="'+data+'" mbmc="'+row.mbmc+'">查看职责</a><sup>'+row.rwsl+'</sup>';
					}
					return '<a class="info" value="'+data+'" status="'+row.ext1+'" mbmc="'+row.mbmc+'">执行</a><sup>'+row.rwsl+'</sup>';
					//return str += ' <a class="user_" role_id="'+data+'" role_name="'+row.role_name+'">成员</a><sup>'+(row.users||0)+'</sup>'
				}
			}]
			,"drawCallback": function(s) {
				$("#checkAll_").off("click").on("click", function() {
					$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
				});
				
				$(".info").off("click").on("click", function() {
					var id = $(this).attr("value");
					var sfcj = $(this).attr("status");
					var mbmc = $(this).attr("mbmc");
					if("all"==flag){
						var tar = "${basePath}/jsp/mbgl/sMbglInfoList.jsp?glid=" + id+"&mbmc="+mbmc+"&node=-1&token=${param.token}";
						tar = encodeURI(tar);
						var o ={
								"action":"menuItem",
								"target":tar,
								"name":"职责详情"
								}
						doMessage(o);
					}else{
						var tar = "${basePath}/jsp/mbgl/sMbglInfoList.jsp?glid=" + id+"&mbmc="+mbmc+"&node=1&token=${param.token}";
						tar = encodeURI(tar);
						var o ={
								"action":"menuItem",
								"target":tar,
								"name":"职责详情"
								}
						
						var obj = new Object();
						obj.url = insertMyTaskUrl;
						obj.user_name = "${myUser.user.user_name}";
						obj.id = id;
						if(sfcj){//已存在清单直接跳转。
							doMessage(o);
							return;
						}
						ajax(obj, function(result) {
							if ("error" == result.resCode) {
								layer.msg(result.resMsg, {icon: 2});
							} else {
								var glid = result.datas;
								doMessage(o);
							}
						});
					}
		       	});
			}
		});

		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				dtParam.keywords = $("#keywords").val();
				table.api().settings()[0].ajax.data = dtParam;
				table.api().ajax.reload();
			}
       	});
		
		$(".tabs").on("click", function() {
			if(flag=="all"){
				return;
			}
			var data=$(this).data("id");
			if("all"==data){
				dtParam={
						"sfmb":1,
						"my_task":userName_
					}
			}else{
				dtParam={
					"ext2":userName_
				}
			}
			table.api().settings()[0].ajax.data = dtParam;
			table.api().ajax.reload();
       	});
		
		$("#btn-insert").on("click", function() {
			$("*", $("#editForm")).attr("disabled", false);
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");
       	});
		
		$("body").on("click", "#btn-update" , function() {
			$("*", $("#editForm")).attr("disabled", false);
			if("职责" ==  $(this).html()) {
				$("*", $("#editForm")).attr("disabled", true);
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
				} else {
					layer.msg("未找到相关数据，请刷新页面！", {icon: 7});
				}
			});
       	});
          
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
		
		$("#btn-ok").on("click", function() {
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
	});
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>
							<i class="fa fa-file-o a-clear"></i> 履职台账
						</h5>
						<div class="ibox-tools">
							<a class="a-reload"> <i class="fa fa-repeat"></i> 刷新
							</a>
						</div>
					</div>

					<div class="ibox-content">
					<div class="tabs-container">
	                    <ul class="nav nav-tabs" >
	                     	<li class="tabs active" data-id="task">
	                        	<a data-toggle="tab" href="#tab-2" aria-expanded="false" ><i class="fa fa-file-text-o" style="margin-right:3px;"></i>执行中</a>
	                        </li>
	                        <li class="tabs" data-id="all">
	                        	<a data-toggle="tab" href="#tab-1" aria-expanded="true" ><i class="fa fa-list-ul" style="margin-right:3px;"></i>可执行</a>
	                        </li>
	                       
                        </ul>
                       </div>
						<!-- search start -->
						<div class="form-horizontal clearfix">
							<%-- <div class="col-sm-6 pl0">
								<s:access url="${ctx}/jsp/mbgl/mbgl/insert.do">
									<button class="btn btn-sm btn-success" id="btn-insert">
										<i class="fa fa-plus"></i> 新增
									</button>
								</s:access>
								<s:access url="${ctx}/jsp/mbgl/mbgl/update.do">
									<button class="btn btn-sm btn-success" id="btn-update">
										<i class="fa fa-edit"></i> 修改
									</button>
								</s:access>
								<s:access url="${ctx}/jsp/mbgl/mbgl/delete.do">
									<button class="btn btn-sm btn-success" id="btn-delete">
										<i class="fa fa-trash-o"></i> 删除
									</button>
								</s:access>
							</div> --%>

							<div class="col-sm-12 form-inline" style="padding-right: 0;padding-top: 10px; text-align: right">
								<form id="queryForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
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
	                  <input type="text" id="id" name="id" style="display:none"/>
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">清单名称</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="mbmc" id="mbmc" >
					    </div>
					    <label class="col-sm-2 control-label">清单类型</label>
					    <div class="col-sm-4">
					      <s:dict dictType="qdlx" name="qdlx" clazz="input-sm form-control validate[required]"></s:dict>
					    </div>
					  </div>
					  
					  
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">序号</label>
					    <div class="col-sm-4">
					      <input type="number" class="input-sm form-control validate[required]" name="xh" id="xh" >
					    </div>
					  	<label class="col-sm-2 control-label">有效状态</label>
					    <div class="col-sm-4">
					      <label><input type="radio" name="status" value="1" checked="checked">有效</label>
					      <label><input type="radio" name="status" value="0">禁用</label>
					    </div>
					  </div>
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">生效时间</label>
					  	 <div class="col-sm-4">
					  		<input type="text" class="input-sm form-control date_select validate[required]" name="start_date" id="start_date" readonly="readonly" format="yyyy-MM-dd">
				  		</div>
					  	<label class="col-sm-2 control-label">失效时间</label>
					  	 <div class="col-sm-4">
					  		<input type="text" class="input-sm form-control date_select" name="end_date" id="end_date" readonly="readonly" format="yyyy-MM-dd">
				  		</div>
				  		
					  </div>

					  <div class="form-group">
					    <label class="col-sm-2 control-label">备注</label>
					    <div class="col-sm-10">
					      <textarea class="form-control" name="remark" id="remark" ></textarea>
					    </div>
					  </div>
		            </div>
		            
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok">
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
	<!-- edit end-->
</body>
</html>