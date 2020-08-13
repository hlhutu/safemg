#ups=http://www.ncjlyj.com:8686/ups
ups=http://36.133.62.50:8686/ups

#----------------------配置信息-----------------------
server.port=8282
server.servlet.contextPath=/smg

spring.mvc.view.prefix=/
spring.mvc.view.suffix=.jsp

spring.http.encoding.force=true
spring.http.encoding.charset=UTF-8
spring.http.encoding.enabled=true
server.tomcat.uri-encoding=UTF-8
server.tomcat.basedir=${java.io.tmpdir}/dev${server.servlet.contextPath}/server

# server.servlet.path=*.do
server.servlet.session.timeout=0
spring.servlet.multipart.max-file-size=100MB
spring.servlet.multipart.max-request-size=100MB

mybatis.config-location=classpath:conf/mybatis/mybatis-config.xml
mybatis.mapper-locations=classpath:conf/mybatis/mapper/**/*Mapper.xml

spring.datasource.driver-class-name=com.mysql.jdbc.Driver
#spring.datasource.url=jdbc:mysql://192.168.0.11:3306/upsdb?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true&useSSL=false
spring.datasource.url=jdbc:mysql://36.133.62.78:3306/upsdb?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true&useSSL=false
spring.datasource.username=root
spring.datasource.password=Root@0817

spring.jmx.enabled=false
spring.datasource.type=com.zaxxer.hikari.HikariDataSource
spring.datasource.hikari.maximum-pool-size=100
spring.datasource.hikari.minimum-idle=10
spring.datasource.hikari.idle-timeout=3000
spring.datasource.hikari.pool-name=SmgHikariCP
spring.datasource.hikari.max-lifetime=1800000
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.connection-test-query=SELECT 1

logging.level.root=ERROR
logging.level.cn.scihi=DEBUG
logging.file=${java.io.tmpdir}/dev${server.servlet.contextPath}/logs/log.log

app.sys_id=6418de47-d1cd-47b8-bc99-70c256f5ba52
app.normal_role=normal
app.root_org_id=-1