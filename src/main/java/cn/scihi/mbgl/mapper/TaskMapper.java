/**
 * 
 */
package cn.scihi.mbgl.mapper;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.Map;

/**
 * @author 岳开
 *
 */
public interface TaskMapper extends IBaseMapper {
    Integer updateForCondition(@Param("updateMap") Map<String, Object> updateMap, @Param("conditionMap") Map<String, Object> conditionMap);
}
