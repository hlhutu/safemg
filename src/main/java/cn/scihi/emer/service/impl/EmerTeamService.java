package cn.scihi.emer.service.impl;

import cn.scihi.emer.mapper.EmerTeamMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author uplus
 *
 */
@Service
public class EmerTeamService extends ServiceAdapter {

	@Autowired
	private EmerTeamMapper emerTeamMapper;

	public void init() throws Exception {
		super.setBaseMapper(emerTeamMapper);
	}
}
