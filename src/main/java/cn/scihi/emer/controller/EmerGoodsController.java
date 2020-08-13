package cn.scihi.emer.controller;

import cn.scihi.emer.ucc.impl.EmerGoodsUcc;
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
@SysLog(module = "应急-物资")
@RequestMapping("/emerGoods")
public class EmerGoodsController extends BizController {

	@Autowired
	private EmerGoodsUcc emerGoodsUcc;

	public void init() {
		super.setBaseUcc(emerGoodsUcc);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/应急
	 * @title 查询应急物资列表
	 * @description -
	 * @method get
	 * @url /smg/emerGoods/select.do
	 * @param rep_id 是 String 物资所属的仓库id
	 * @return {}
	 * @return_param goods_no String 物品编号
	 * @return_param goods_name String 物品名
	 * @return_param category String 物品类型
	 * @return_param rep_id String 所属仓库id
	 * @return_param goods_unit String 物品单位
	 * @return_param goods_count String 物品数量
	 * @return_param description String 简介
	 * @return_param created Date 创建时间
	 * @remark
	 * @number 0
	 */
}
