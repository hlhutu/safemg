package cn.scihi.mbgl.controller;

import cn.scihi.mbgl.ucc.impl.ReportUcc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * @author uplus
 *
 */
@Controller
@SysLog(module = "报表")
@RequestMapping("/report")
public class ReportController extends BizController {

	@Autowired
	private ReportUcc reportUcc;

	public void init() {
		super.setBaseUcc(reportUcc);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/统计
	 * @title 履职情况1
	 * @description 上方的3个原型图表
	 * @method get
	 * @url /smg/report/lvzhi/1.do
	 * @param year 是 String 年
	 * @param month 否 String 月，形如：06
	 * @param org_id 是 String 机构id
	 * @return {}
	 * @return_param datas List 数据列表
	 * @return_param datas[0].category String 任务类型：巡检，会议，学习，其他
	 * @return_param datas[0].finished Integer 已完成的任务数
	 * @return_param datas[0].total Integer 全部任务数
	 * @return_param datas[0].percent Double 进度百分比
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/lvzhi/1.do", method = RequestMethod.GET)
	@SysLog(module = "统计", method = "履职情况1")
	public String lvzhi1(HttpServletRequest request, Map<String, Object> map, String year, String month, String org_id) throws Exception {
		map = getParameterMap(request, false);
		map.put("datas", reportUcc.lvzhi1(year, month, org_id));
		return toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/统计
	 * @title 履职情况2
	 * @description 将会查询本机构和子机构的履职进度百分比（只查子级，不级联）
	 * @method get
	 * @url /smg/report/lvzhi/2.do
	 * @param year 是 String 年
	 * @param month 否 String 月，形如：06
	 * @param org_id 是 String 机构id
	 * @return {}
	 * @return_param datas List 数据列表
	 * @return_param datas[0].org_id String 机构id
	 * @return_param datas[0].org_name String 机构名称
	 * @return_param datas[0].finished Integer 已完成的任务数
	 * @return_param datas[0].total Integer 全部任务数
	 * @return_param datas[0].percent Double 进度百分比
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/lvzhi/2.do", method = RequestMethod.GET)
	@SysLog(module = "统计", method = "履职情况2")
	public String lvzhi2(HttpServletRequest request, Map<String, Object> map, String year, String month, String org_id) throws Exception {
		map = getParameterMap(request, false);
		map.put("datas", reportUcc.lvzhi2(year, month, org_id));
		return toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/统计
	 * @title 执法次数
	 * @description -
	 * @method get
	 * @url /smg/report/zhifa.do
	 * @param year 是 String 年
	 * @param month 否 String 月，形如：06
	 * @param org_id 是 String 机构id
	 * @return {}
	 * @return_param datas Map 数据列表
	 * @return_param datas.month.finished Integer 已完成的执法数
	 * @return_param datas.month.total Integer 全部执法数
	 * @return_param datas.month.percent Double 进度百分比
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/zhifa.do", method = RequestMethod.GET)
	@SysLog(module = "统计", method = "执法次数")
	public String zhifa(HttpServletRequest request, Map<String, Object> map, String year, String month, String org_id) throws Exception {
		map = getParameterMap(request, false);
		map.put("datas", reportUcc.zhifa(year, month, org_id));
		return toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/统计
	 * @title 灾害等级分布
	 * @description -
	 * @method get
	 * @url /smg/report/zaihailevel.do
	 * @param year 是 String 年
	 * @param month 否 String 月，形如：06
	 * @param org_id 是 String 机构id
	 * @return {}
	 * @return_param zh_jb_1 Integer 一级灾害数
	 * @return_param zh_jb_2 Integer 二级灾害数
	 * @return_param zh_jb_3 Integer 三级灾害数
	 * @return_param zh_jb_4 Integer 四级灾害数
	 * @return_param zh_jb_4.ct Integer 本期灾害数
	 * @return_param zh_jb_4.ctold Integer 去年同期灾害数
	 * @return_param zh_jb_4.tongbi Double 同比
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/zaihailevel.do", method = RequestMethod.GET)
	@SysLog(module = "统计", method = "灾害等级分布")
	public String zaihailevel(HttpServletRequest request, Map<String, Object> map, String year, String month, String org_id) throws Exception {
		map = getParameterMap(request, false);
		try{
			map.put("datas", reportUcc.zaihailevel(year, month, org_id));
		}catch (Exception e){
			e.printStackTrace();
		}

		return toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/统计
	 * @title 灾害发生趋势
	 * @description 将查询指定之间过去6年的统计，时间正序排列
	 * @method get
	 * @url /smg/report/zaihaiqushi.do
	 * @param year 是 String 年
	 * @param month 否 String 月，形如：06
	 * @param org_id 是 String 机构id
	 * @return {}
	 * @return_param datas List 数据列表
	 * @return_param datas[0].year String 年份
	 * @return_param datas[0].total Integer 该年发生的灾害数
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/zaihaiqushi.do", method = RequestMethod.GET)
	@SysLog(module = "统计", method = "灾害发生趋势")
	public String zaihaiqushi(HttpServletRequest request, Map<String, Object> map, String year, String month, String org_id) throws Exception {
		map = getParameterMap(request, false);
		map.put("datas", reportUcc.zaihaiqushi(year, org_id));
		return toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/统计
	 * @title 全部统计
	 * @description 统计所有图表
	 * @method get
	 * @url /smg/report/all.do
	 * @param year 是 String 年
	 * @param month 否 String 月，形如：06
	 * @param org_id 是 String 机构id
	 * @return {}
	 * @return_param lvzhi1 Map 本机构分类履职进度
	 * @return_param lvzhi2 Map 本机构与子机构履职总进度
	 * @return_param zhifa Map 本月和本年度执法数
	 * @return_param zaihailevel Map 灾害等级分布
	 * @return_param zaihaiqushi Map 灾害发生趋势
	 * @remark
	 * @number 0
	 */
	@ResponseBody
	@RequestMapping(value = "/all.do", method = RequestMethod.GET)
	@SysLog(module = "统计", method = "灾害发生趋势")
	public String report(HttpServletRequest request, Map<String, Object> map, String year, String month, String org_id) throws Exception {
		map = getParameterMap(request, false);
		Map<String, Object> report = new HashMap<>();
		report.put("lvzhi1", reportUcc.lvzhi1(year, month, org_id));
		report.put("lvzhi2", reportUcc.lvzhi2(year, month, org_id));
		report.put("zhifa", reportUcc.zhifa(year, month, org_id));
		report.put("zaihailevel", reportUcc.zaihailevel(year, null, org_id));
		report.put("zaihaiqushi", reportUcc.zaihaiqushi(year, org_id));
		map.put("datas", report);
		return toJSONString(map);
	}
}
