<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script src="${ctx}/js/plugins/jquery.jeditable.js"></script>

<script>
	var selectUrl = "${ctx}/biz/xjglInfo/select.do";
	var insertUrl = "${ctx}/biz/xjglInfo/insert.do";
	var updateUrl = "${ctx}/biz/xjglInfo/update.do";
	var deleteUrl = "${ctx}/biz/xjglInfo/delete.do";
	
	
	var callbackUrl = "${ctx}/sdk/callback.do";
	
	var back = { action : "click", target : ".a-back", result : "" };
	var closeItem = { action : "closeItem", target : document.location.toString() };
	var xj_id = "${param.xj_id}";
	var xjmc = "${param.xjmc}";
	var table;
	
	
	$(window).ready(function() {
		$("#xjmc").html("（${param.xjmc}）");
		
		$("#datas").wrapAll("<div style='overflow-x:auto'>");
		table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": false,
			"autoWidth": false,
			"paging": false,
			"scrollX": false,
			 //表头固定
            /* "scrollY": "500px",
            "scrollCollapse": "true", */
			"ajax": {
				"dataSrc": "datas",
				"url": selectUrl,
				"data": function() {
					if(xj_id) {
						return {"xj_id": xj_id};
					}
					return {"xj_id": "------------"};
				} 
			},
			"columns": [ {
				"title":'<input type="checkbox" id="checkAll_" style="margin:0px;">',
				"data":"id",
				"render": function (data, type, row) {
					if(row.zxzt!="0"){
						return '<input type="checkbox" disabled="disabled" class="ids_" name="ids_" value="'+data+'" style="margin:0px;"/>';
					}
					return '<input type="checkbox" class="ids_" name="ids_" value="'+data+'" style="margin:0px;"/>';
				}
			},{
				"title":"序号",
				"data":"xh"
			}, {
				"title":"巡检任务项",
				"data":"rwx"
			}, {
				"title":"巡检地点",
				"data":"rwdd"
			}, {
				"title":"执行人",
				"data":"zxr_desc"
			}, {
				"title":"执行时间",
				"data":"zxsj"
			}, {
				"title":"执行结果",
				"data":"zxjg",
				"render": function (data, type, row) {
					if("1"==data){
						return "<span style='color: #008B00'>正常</span>";
					}else if("0"==data){
						return "<span style='color: #f00'>异常</span>";
					}
					return "<span style='color: #abab2a'>未执行</span>";
				}
			}, {
				"title":"操作",
				"data":"id",
				"render": function (data, type, row) {
					return '<a class="info" value="'+data+'">任务详情</a>';
				}
			}]
			,"drawCallback": function(s) {
				$(".info").on("click", function () {
					$("input[type='checkbox']").prop("checked", false);
					$(".ids_[value='"+$(this).attr("value")+"']").prop("checked", true);
					$(".upload").addClass("hide");
					$(".fileList").removeClass("hide");
					var o = {
							action:"menuItem",
							name:"任务详情",
							target:"${basePath}/jsp/xjgl/xjglInfoHisDetail.jsp?id="+$(this).attr("value")
					}
					doMessage(o);
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
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");
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
		
		
		/* document.getElementById("map").contentDocument.getElementById("mapRef").οnclick=function(){
			var rs ={};
			rs.lat=	$('iframe').contents().find("#latY").val();
			rs.lng=$('iframe').contents().find("#lngX").val();
			rs.address=$('iframe').contents().find("#keyword").val();
			console.log(rs);
		}; */
		
	});
	
	

</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i>巡检任务详情<span id="xjmc"></span></h5>
	                    <div class="ibox-tools">
	                       <a class="a-reload">
	                          <i class="fa fa-repeat"></i> 刷新
	                       </a>
	                    </div>
	                </div>
	            
		            <div class="ibox-content">

	                  <input type="text" id="xj_id" name="xj_id" value="${param.xj_id}" style="display: none;">
	                  <input type="text" id="zxr" name="zxr" value="${param.zxr}" style="display: none;">
	                  <table id="datas" class="table display" style="width: 100%"></table>
		            </div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>