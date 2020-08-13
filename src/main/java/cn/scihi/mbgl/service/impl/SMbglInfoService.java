package cn.scihi.mbgl.service.impl;

import cn.scihi.mbgl.mapper.SMbglInfoMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;

/**
 * @author uplus
 *
 */
@Service
public class SMbglInfoService extends ServiceAdapter {

	@Autowired
	private SMbglInfoMapper sMbglInfoMapper;

	public void init() throws Exception {
		super.setBaseMapper(sMbglInfoMapper);
	}
}
