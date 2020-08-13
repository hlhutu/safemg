package cn.scihi.emer.service.impl;

import cn.scihi.emer.mapper.EmerGoodsMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author uplus
 *
 */
@Service
public class EmerGoodsService extends ServiceAdapter {

	@Autowired
	private EmerGoodsMapper emerGoodsMapper;

	public void init() throws Exception {
		super.setBaseMapper(emerGoodsMapper);
	}
}
