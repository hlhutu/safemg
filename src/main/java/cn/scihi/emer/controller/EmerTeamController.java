package cn.scihi.emer.controller;

import cn.scihi.emer.ucc.impl.EmerTeamUcc;
import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author uplus
 *
 */
@Controller
@SysLog(module = "应急-队伍")
@RequestMapping("/emerTeam")
public class EmerTeamController extends BizController {

	@Autowired
	private EmerTeamUcc emerTeamUcc;

	public void init() {
		super.setBaseUcc(emerTeamUcc);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/应急
	 * @title 查询应急队伍列表
	 * @description -
	 * @method get
	 * @url /smg/emerTeam/select.do
	 * @param - - - -
	 * @return {}
	 * @return_param team_no String 队伍编号
	 * @return_param team_name String 队伍名称
	 * @return_param category String 队伍类型
	 * @return_param address String 队伍地址
	 * @return_param org_id String 所属机构
	 * @return_param link_user String 联系人
	 * @return_param link_phone String 联系电话
	 * @return_param lon String 经度
	 * @return_param lat String 维度
	 * @return_param description String 简介
	 * @return_param created Date 创建时间
	 * @remark
	 * @number 0
	 */
}
