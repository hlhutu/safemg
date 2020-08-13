/**
 * 
 */
package cn.scihi.zskgl.ucc.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.ucc.UccAdapter;
import cn.scihi.zskgl.service.impl.ZskglService;

/**
 * @author wyc
 *
 */
@Service
public class ZskglUcc extends UccAdapter {

	@Resource
	private ZskglService zskglService;

	public void init() {
		super.baseService = zskglService;
	}

}
