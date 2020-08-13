package cn.scihi.emer.controller;

import cn.scihi.emer.ucc.impl.EmerRepositoryUcc;
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
@SysLog(module = "应急-仓库")
@RequestMapping("/emerRep")
public class EmerRepositoryController extends BizController {

	@Autowired
	private EmerRepositoryUcc emerRepositoryUcc;

	public void init() {
		super.setBaseUcc(emerRepositoryUcc);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/应急
	 * @title 查询应急仓库列表
	 * @description -
	 * @method get
	 * @url /smg/emerRep/select.do
	 * @param - - - -
	 * @return {}
	 * @return_param rep_no String 仓库编号
	 * @return_param rep_name String 仓库名
	 * @return_param category String 类型
	 * @return_param address String 仓库地址
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
