package cn.scihi.emer.service.impl;

import cn.scihi.emer.mapper.EmerEventMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author uplus
 *
 */
@Service
public class EmerEventService extends ServiceAdapter {

	@Autowired
	private EmerEventMapper emerEventMapper;

	public void init() throws Exception {
		super.setBaseMapper(emerEventMapper);
	}
}
