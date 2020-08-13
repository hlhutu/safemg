/**
 * 
 */
package cn.scihi.mbgl.controller;

import cn.scihi.mbgl.ucc.impl.TaskUcc;
import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import jdk.nashorn.internal.runtime.logging.Logger;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * @author 岳开
 *
 */
@Controller
@SysLog(module = "任务管理")
@RequestMapping(value = "/jsp/task/task")
@Logger
public class TaskController extends BizController {

	@Resource
	private TaskUcc taskUcc;

	public void init() {
		super.baseUcc = taskUcc;
	}

	/**
	 * showdoc
	 * @catalog 南充应急/任务
	 * @title 查询任务
	 * @description 用于查询指定模板，指定任务项下的所有任务。需指定执行人
	 * @method get
	 * @url /jsp/task/task/select.do
	 * @param zxr 是 string 任务执行人
	 * @param mbid 是 string 模板id
	 * @param infoid 是 string 任务项id
	 * @return {}
	 * @return_param datas Object 返回数据
	 * @remark
	 * @number 0
	 */
	/**
	 * showdoc
	 * @catalog 南充应急/任务
	 * @title 生成任务
	 * @description 每天凌晨00:30扫描所有激活的模板，并根据任务项配置生成任务实例。
	 * @method post
	 * @url /jsp/task/task/generator.do
	 * @param - - - -
	 * @return {}
	 * @return_param datas Object 返回数据
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = {"/generator"}, method = RequestMethod.POST)
	@SysLog(module = "任务", method = "自动生成任务")
	@Transactional(rollbackFor = Exception.class)
	@Scheduled(cron = "0 30 0 1/1 * ? ")
	//@Scheduled(cron = "0 0/1 * * * ? ")
	public synchronized String generator() throws Exception {
		Map<String, Object> map = new HashMap<>();
		taskUcc.generatorForAll();
		return this.toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/任务
	 * @title 改变任务状态
	 * @description
	 * @method post
	 * @url /jsp/task/task/status/{taskId}.do
	 * @param taskId 路径参数 String 任务id
	 * @param status 否 String 完成备注
	 * @return {}
	 * @return_param datas Object 返回数据
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = {"/status/{taskId}.do"}, method = RequestMethod.POST)
	@SysLog(module = "任务", method = "改变任务状态")
	@Transactional(rollbackFor = Exception.class)
	public String status(HttpServletRequest request, Map<String, Object> map, @PathVariable String taskId, Integer status) throws Exception {
		map = getParameterMap(request, false);
		map.put("status", status);
		map.put("id", taskId);
		map.put("datas", taskUcc.status(taskId, status));
		return this.toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/任务
	 * @title 完成任务
	 * @description
	 * @method post
	 * @url /smg/jsp/task/task/complete/{taskId}.do
	 * @param taskId 路径参数 String 任务id
	 * @param remark 否 String 完成备注
	 * @param files 否 binary 附件
	 * @return {}
	 * @return_param datas Object 返回数据
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = {"/complete/{taskId}.do"}, method = RequestMethod.POST)
	@SysLog(module = "任务", method = "完成任务")
	@Transactional(rollbackFor = Exception.class)
	public String complete(HttpServletRequest request, Map<String, Object> map, @PathVariable String taskId) throws Exception {
		map = getParameterMap(request, false);
		map.put("datas", taskUcc.complete(request, taskId, map));
		return this.toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/任务
	 * @title 关联任务的具体项目
	 * @description 关联之后，任务的状态变为3：进行中。1：未开始。2：已结束。
	 * @method post
	 * @url /jsp/task/task/instance/{taskId}.do
	 * @param taskId 路径参数 String 任务id
	 * @param task_req 是 String 任务要求：会议，巡检，学习
	 * @param req_id 是 String 任务要求对应的id
	 * @return {}
	 * @return_param datas Object 返回数据
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = {"/instance/{taskId}.do"}, method = RequestMethod.POST)
	@SysLog(module = "任务", method = "关联任务的具体项目")
	@Transactional(rollbackFor = Exception.class)
	public String instance(HttpServletRequest request, Map<String, Object> map, @PathVariable String taskId) throws Exception {
		map = getParameterMap(request, false);
		map.put("datas", taskUcc.instance(taskId, map));
		return this.toJSONString(map);
	}
}
