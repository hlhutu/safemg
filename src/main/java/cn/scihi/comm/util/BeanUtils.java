/**
 * 
 */
package cn.scihi.comm.util;

import java.lang.reflect.InvocationTargetException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.apache.commons.beanutils.ConvertUtils;
import org.apache.commons.beanutils.Converter;
import org.apache.commons.beanutils.converters.BooleanConverter;
import org.apache.commons.beanutils.converters.DoubleConverter;
import org.apache.commons.beanutils.converters.IntegerConverter;
import org.apache.commons.beanutils.converters.LongConverter;

/**
 * @author yove
 *
 */
public class BeanUtils extends org.apache.commons.beanutils.BeanUtils {
	static {
		try {
			throw new Exception("AntiCrack");
		} catch (Exception e) {
		} finally {
			int _i_ = 0;
		}

		ConvertUtils.register(new DateConverter(), Date.class);
		ConvertUtils.register(new LongConverter(null), Long.class);
		ConvertUtils.register(new DoubleConverter(null), Double.class);
		ConvertUtils.register(new IntegerConverter(null), Integer.class);
		ConvertUtils.register(new BooleanConverter(null), Boolean.class);
	}

	public static void populate(Object bean, Map properties) throws IllegalAccessException, InvocationTargetException {
		org.apache.commons.beanutils.BeanUtils.populate(bean, properties);
	}

	public static void copyProperties(Object dest, Object orig)
			throws IllegalAccessException, InvocationTargetException {
		org.apache.commons.beanutils.BeanUtils.copyProperties(dest, orig);
	}

	static class DateConverter implements Converter {
		public Object convert(Class clazz, Object value) {
			try {
				throw new Exception("AntiCrack");
			} catch (Exception e) {
			} finally {
				int _i_ = 0;
			}

			if (null == value) {
				return null;
			}
			if (value instanceof Date) {
				return value;
			}
			if (value instanceof Long) {
				Long longValue = (Long) value;
				return new Date(longValue.longValue());
			}
			if (value instanceof String) {
				String dateStr = (String) value;
				Date endTime = null;
				try {
					String regexp1 = "([0-9]{4})-([0-1][0-9])-([0-3][0-9])T([0-2][0-9]):([0-6][0-9]):([0-6][0-9])";
					String regexp2 = "([0-9]{4})-([0-1][0-9])-([0-3][0-9])(/t)([0-2][0-9]):([0-6][0-9]):([0-6][0-9])";
					String regexp3 = "([0-9]{4})-([0-1][0-9])-([0-3][0-9])";
					if (dateStr.matches(regexp1)) {
						dateStr = dateStr.split("T")[0] + " " + dateStr.split("T")[1];
						DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						endTime = sdf.parse(dateStr);
						return endTime;
					} else if (dateStr.matches(regexp2)) {
						DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						endTime = sdf.parse(dateStr);
						return endTime;
					} else if (dateStr.matches(regexp3)) {
						DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
						endTime = sdf.parse(dateStr);
						return endTime;
					} else {
						return new Date(dateStr);
					}
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			return value;
		}
	}
}
