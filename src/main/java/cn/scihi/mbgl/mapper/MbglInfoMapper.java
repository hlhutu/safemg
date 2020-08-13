/**
 * 
 */
package cn.scihi.mbgl.mapper;

import java.util.Map;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * @author 岳开
 *
 */
public interface MbglInfoMapper extends IBaseMapper {
	int updateRowHist(Map<String, Object> map);

	Integer updateForCondition(@Param("updateMap") Map<String, Object> updateMap, @Param("conditionMap") Map<String, Object> conditionMap);
}
