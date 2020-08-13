<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script>
	var selectUrl = "${ctx}/jsp/zskgl/zskgl/select.do";
	var insertUrl = "${ctx}/jsp/zskgl/zskgl/insert.do";
	var updateUrl = "${ctx}/jsp/zskgl/zskgl/update.do";
	var deleteUrl = "${ctx}/jsp/zskgl/zskgl/delete.do"; 
	var k_lx = "${param.k_lx}";

	$(window).ready(function() {
		var html = " 应急预案";
		if(k_lx=="zsklx"){
			html = " 知识库";
		}else if(k_lx=="zyklx"){
			html = " 资源库";
		}else if(k_lx=="yjyalx"){
			html = " 应急预案";
		}
		$(".a-clear").html(html);
		var userName_="${myUser.user.user_name}";
		var dtParam = {
			"keywords": $("#keywords").val(),
			"k_lx": k_lx
		};
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
			"order": [[5, "desc"]],
			"columnDefs": [{
				"targets": [0,1,8],
				"orderable" : false
			}],
			"columns": [ {
				"title":'<input type="checkbox" id="checkAll_" style="margin:0px;">',
				"data":"id",
				"render": function (data, type, row) {
					return '<input type="checkbox" class="ids_" name="ids_" value="'+data+'" style="margin:0px;"/>';
				}
			},{
				"data":"created"
				 ,"bVisible" : false 
			}, {
				"title":"标题  <i class='fa fa-search'></i>",
				"data":"zskgl_title",
				"render": function (data, type, row) {
					if (typeof(data)!='undefined'&&data.length>=20) {
	           		 return  "<span type='button' title='"+data+"'>"+data.substr(0, 20 )+"....."+"</span>";
					}else{
						 return data;
					}
				}
			}, {
				"title":"类型  <i class='fa fa-search'></i>",
				"data":"zskgl_type",
				"render": function (data, type, row) {
					return row.zskgl_type_desc;
				}
			}, {
				"title":"作者  <i class='fa fa-search'></i>",
				"data":"zskgl_author",
				"render": function (data, type, row) {
					return row.zskgl_author_desc;
				}
			}, {
				"title":"发布时间  <i class='fa fa-search'></i>",
				"data":"zskgl_publish_time"
			}, {
				"title":"简述  <i class='fa fa-search'></i>",
				"data":"zskgl_remark",
				"render": function (data, type, row) {
					if (typeof(data)!='undefined'&&data.length>=25) {
                		 return  "<span type='button' title='"+data+"'>"+data.substr(0, 25 )+"....."+"</span>";
					}else{
						 return data;
					}
				}
			}, {
				"title":"状态",
				"data":"status",
				"render": function (data, type, row) {
					if("1" == data) {
						return '<span style="color:#008B00">发布</span>';
					}
					if("2" == data) {
						return '<span style="color:#DAA520">草稿</span>';
					}
					return '过期';
				}
			}, {
				"title":"操作",
				"data":"id",
				"render": function (data, type, row) {
					return '<a class="info" value='+data+'>详情</a>';
				}
			}]
			,"drawCallback": function(s) {
				$("#checkAll_").off("click").on("click", function() {
					$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
				});
				$(".info").off("click").on("click", function() {
					var target = "${basePath}/jsp/zskgl/zskInfo.jsp?node=-1&k_lx="+k_lx+"&orderId="+$(this).attr("value");
					var v = {action:"menuItem", name:"信息查看", target: target};
					doMessage(v);
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
		
		$("#btn-insert").on("click", function() {
			var target = "${basePath}/jsp/zskgl/zskInfo.jsp?node=0&k_lx="+k_lx;
			target = encodeURI(target);
			var v = {action:"menuItem", name:"信息录入", target: target};
			doMessage(v);
       	});

		$("#btn-modify").on("click", function() {
			var ids = [];
			$(".ids_:checkbox:checked").each(function(index, o) {
				ids.push($(this).val());
			});
			if(ids.length != 1) {
				layer.msg("请选择需要修改的一条数据！", {icon: 0});
				return;
			}
			
			var target = "${basePath}/jsp/zskgl/zskInfo.jsp?node=1&k_lx="+k_lx+"&orderId="+ids[0];
			target = encodeURI(target);
			var v = {action:"menuItem", name:"信息修改", target: target};
			doMessage(v);
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
							<i class="fa fa-file-o a-clear"></i> 列表
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
							
								<button class="btn btn-sm btn-success" id="btn-modify">
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
</body>
</html>