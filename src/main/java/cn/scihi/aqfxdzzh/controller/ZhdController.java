/**
 * 
 */
package cn.scihi.aqfxdzzh.controller;


import cn.scihi.aqfxdzzh.ucc.impl.ZhdUcc;
import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * @author wyc
 *
 */
@RestController
@SysLog(module = "灾害点管理")
@RequestMapping(value = "/jsp/aqfxdzzh/zhd")
public class ZhdController extends BizController {

	@Resource
	private ZhdUcc zhdUcc;

	public void init() {
		super.baseUcc = zhdUcc;
	}

	/**
	 * showdoc
	 * @catalog 南充应急/应急
	 * @title 查询灾害记录
	 * @description -
	 * @method get
	 * @url /smg/jsp/aqfxdzzh/zhd/select.do
	 * @param year 否 String 年
	 * @param month 否 String 月，形如：06
	 * @param month_long 否 Integer 查询x个月的数据，默认1，若传次参数，则必须传year和month
	 * @return {}
	 * @return_param datas List 数据列表
	 * @return_param id String id
	 * @return_param sys_id String 系统id
	 * @return_param jdddz String 风险点位地址
	 * @return_param jddjd String 风险点位经度
	 * @return_param jddwd String 风险点位维度
	 * @return_param jddmc String 风险点位名称
	 * @return_param zhd_parent_id String 风险点位id
	 * @return_param zh_jb_desc String 灾害级别
	 * @return_param zhd_fssj String 灾害发生时间
	 * @return_param zhd_ms String 灾害描述
	 * @return_param zhd_result String 灾害处置结果
	 * @return_param attachList List 附件列表
	 * @remark
	 * @number 0
	 */

	/**
	 * showdoc
	 * @catalog 南充应急/应急
	 * @title 根据灾害等级查询灾害数
	 * @description -
	 * @method get
	 * @url /smg/jsp/aqfxdzzh/zhd/countByStatus.do
	 * @param year 否 String 年
	 * @param month 否 String 月
	 * @return {}
	 * @return_param zh_jb String 灾害级别
	 * @return_param total String 个数
	 * @remark
	 * @number 0
	 */
	@RequestMapping({"/countByStatus.do"})
	@SysLog(module = "应急", method = "根据灾害等级查询灾害数")
	public String countByStatus(HttpServletRequest request, Map<String, Object> map, String year, String month) throws Exception {
		try{
			map.put("datas",zhdUcc.countByStatus(year, month));
		}catch (Exception e){
			e.printStackTrace();
		}
		return this.toJSONString(map);
	}
}
