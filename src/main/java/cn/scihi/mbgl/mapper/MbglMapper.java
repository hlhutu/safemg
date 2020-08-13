/**
 * 
 */
package cn.scihi.mbgl.mapper;

import java.util.List;
import java.util.Map;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * @author 岳开
 *
 */
public interface MbglMapper extends IBaseMapper {
	List<Map<String, Object>> selectRolesByOrg(Map<String, Object> map);
	
	int softDelete(Map<String, Object> map);

	Integer getLastVersion(String key_);

	Integer updateForCondition(@Param("updateMap") Map<String, Object> update, @Param("conditionMap")Map<String, Object> condition);

    List<Map<String, Object>> selectMyTimeModels(String username);
}
